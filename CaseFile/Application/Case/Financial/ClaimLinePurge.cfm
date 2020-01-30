
<cfquery name="Delete" 
    datasource="AppsCaseFile" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM ClaimLine
	 WHERE ClaimId     = '#URL.ClaimId#'
	 AND   ClaimLineId = '#URL.ID2#'
</cfquery>

<cfinclude template="ClaimLine.cfm">
