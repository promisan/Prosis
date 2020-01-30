
<cfquery name="Check" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Claim
	WHERE ClaimId = '#URL.ClaimId#' 
</cfquery>

<cflocation url="..\ClaimView\ClaimView.cfm?time=#now()#&personNo=#URL.personNo#" addtoken="No">