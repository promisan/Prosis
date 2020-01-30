<cf_SystemScript>

<cfquery name="Delete" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	PersonEntitlement
		WHERE	PersonNo = '#URL.ID#'
		AND		EntitlementId = '#URL.ID1#'
		AND		Status = '0'
</cfquery>
	    
<cfoutput>
	<script>	 
		ptoken.location("EmployeeEntitlement.cfm?ID=#URL.ID#&Status=#URL.Status#");
	</script>	
</cfoutput>	