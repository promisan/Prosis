
<cfquery name="Claim" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Claim
	WHERE   ClaimId = '#URL.ClaimId#'	
</cfquery>

<table width="98%" height="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td height="10"></td></tr>

<tr>
	<td valign="top" align="center">

	<cfoutput>
	
	<iframe src="../../../../Staffing/Application/Employee/Dependents/EmployeeDependent.cfm?action=claim&id=#claim.personno#" width="98%" height="98%" scrolling="no" frameborder="0"></iframe>
	</cfoutput> 

	</td>
</tr>

</table>