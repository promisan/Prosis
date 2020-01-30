
<!--- from workflow --->
<cfparam name="Object.ObjectKeyValue4" default="">

<cfparam name="attributes.EntitlementId" default="#Object.ObjectKeyValue4#">

<cfquery name="ActionSource" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">   
      SELECT * 		  
	  FROM   Employee.dbo.EmployeeActionSource
	  WHERE  ActionDocumentNo IN (SELECT ActionDocumentNo 
		                          FROM   Employee.dbo.EmployeeAction 
								  WHERE  ActionSourceId = '#attributes.EntitlementId#')		
</cfquery>	

<cfset PANo = ActionSource.ActionDocumentNo>

<cfif ActionSource.recordcount gt "0">

	<cfquery name="getAction" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT * 
		   FROM   Employee.dbo.EmployeeAction     
		   WHERE  ActionDocumentNo  = '#actionsource.ActionDocumentNo#'  
	</cfquery>
			
	<cfloop query="ActionSource">
				 
			<cfif ActionStatus eq "9">
			    <cfset contractstatus = "9">
			<cfelse>
			    <cfset contractstatus = "2">
			</cfif>
	
			<cfquery name="RevokeContract" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
		    	  UPDATE Payroll.dbo.PersonEntitlement
			      SET    Status    = '#contractstatus#'
			      WHERE  EntitlementId   = '#ActionSourceId#'  								  				  
			</cfquery>
			
	</cfloop>		

</cfif>