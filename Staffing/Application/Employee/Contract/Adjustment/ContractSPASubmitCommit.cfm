
<!--- from workflow --->
<cfparam name="Object.ObjectKeyValue4" default="">

<cfparam name="attributes.PostAdjustmentId" default="#Object.ObjectKeyValue4#">

<cfquery name="SPA" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
    SELECT   * 		  
	FROM     PersonContractAdjustment
	WHERE    PostAdjustmentId = '#attributes.PostAdjustmentId#'		
</cfquery>	

<cfif SPA.recordcount eq "1">
	
	<cfquery name="Confirm" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	 	UPDATE   Employee.dbo.PersonContractAdjustment
		SET      ActionStatus = '1'
		WHERE    PersonNo           = '#SPA.PersonNo#'
		AND       PostAdjustmentId  = '#SPA.PostAdjustmentId#'
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
					           WHERE  PersonNo     = '#SPA.PersonNo#'
							   AND    ActionStatus = '1'
	                           AND    ActionDocumentNo IN (SELECT ActionDocumentNo 
				                                           FROM   EmployeeAction 
										                   WHERE  ActionSourceId = '#SPA.PostAdjustmentId#')
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
					           WHERE  PersonNo     = '#SPA.PersonNo#'
							   AND    ActionStatus = '1'
	                           AND    ActionDocumentNo IN (SELECT ActionDocumentNo 
				                                           FROM   EmployeeAction 
										                   WHERE  ActionSourceId = '#SPA.PostAdjustmentId#')
	                            )
	</cfquery>

</cfif>	