
<cfquery name="Claim" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Claim
	WHERE   ClaimId = '#URL.ClaimId#'	
</cfquery>

<!--- dependents pass tru --->

<table width="100%" height="100%"><tr><td>

  <cfoutput>
	<iframe src="../../../../Staffing/Application/Employee/Dependents/EmployeeDependent.cfm?action=claim&id=#claim.personno#" width="98%" height="98%" marginwidth="0" marginheight="0" scrolling="no" frameborder="0"></iframe>
  </cfoutput>	
</td></tr></table>