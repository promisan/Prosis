
<!--- from workflow --->
<cfparam name="Object.ObjectKeyValue4" default="">

<cfparam name="attributes.contractid" default="#Object.ObjectKeyValue4#">

<cfquery name="Contract" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
    SELECT   * 		  
	FROM     PersonContract
	WHERE    ContractId = '#attributes.contractid#'		
</cfquery>	

<cfquery name="SetAction" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">   
      UPDATE  Employee.dbo.EmployeeAction
	  SET    ActionStatus = '1'	  
	  WHERE  ActionDocumentNo IN (SELECT ActionDocumentNo 
		                          FROM   Employee.dbo.EmployeeAction 
								  WHERE  ActionSourceId = '#attributes.contractid#'
								  
								  <!--- added based on STL observation run removing the created portion --->
								  UNION
								  SELECT ActionDocumentNo 
		                          FROM   Employee.dbo.EmployeeActionSource 
								  WHERE  ActionSourceId = '#attributes.contractid#'
								  )		
								  
</cfquery>	

<cfif contract.recordcount eq "1">
	
	<cfquery name="Confirm" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	 	UPDATE   Employee.dbo.PersonContract
		SET      ActionStatus = '1'
		WHERE    PersonNo     = '#Contract.PersonNo#'
		AND      ContractId   = '#Contract.ContractId#'
	</cfquery>
	
	<cfquery name="ConfirmEntitlement" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    UPDATE   Payroll.dbo.PersonEntitlement
		SET      Status     = '2'
		FROM     Payroll.dbo.PersonEntitlement
		WHERE    PersonNo   = '#Contract.PersonNo#'
	    AND      Contractid = '#Contract.ContractId#'
	</cfquery>
	
	<cfquery name="Confirm" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		UPDATE   Employee.dbo.PersonAssignment
		SET      AssignmentStatus = '1'
		WHERE    PersonNo         = '#Contract.PersonNo#'
		AND      ContractId       = '#Contract.ContractId#'
	</cfquery>
	
	<!--- these are contract releated dependent record to prevent double workflow --->
	
	<cfquery name="ConfirmDependents" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    UPDATE   PersonDependent
		SET      ActionStatus = '2'
	    FROM     PersonDependent
	    WHERE    DependentId IN (
		
		                       SELECT ActionSourceId 
		                       FROM   EmployeeActionSource
					           WHERE  ActionStatus = '1'
	                           AND    PersonNo     = '#Contract.PersonNo#'
	                           AND    ActionDocumentNo IN (SELECT ActionDocumentNo 
				                                           FROM   EmployeeAction 
										                   WHERE  ActionSourceId = '#Contract.ContractId#')
	                            )
	</cfquery>
	
	<cfquery name="ConfirmDependentsEntitlement" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    UPDATE   Payroll.dbo.PersonDependentEntitlement
		SET      Status = '2'
		FROM     Payroll.dbo.PersonDependentEntitlement
	    WHERE    DependentId IN (
		                       SELECT ActionSourceId 
		                       FROM   EmployeeActionSource
					           WHERE  ActionStatus = '1'
	                           AND    PersonNo     = '#Contract.PersonNo#'
	                           AND    ActionDocumentNo IN (SELECT ActionDocumentNo 
				                                           FROM   EmployeeAction 
										                   WHERE  ActionSourceId = '#Contract.ContractId#')
	                            )
	</cfquery>

</cfif>	