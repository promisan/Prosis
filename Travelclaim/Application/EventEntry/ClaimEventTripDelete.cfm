
<cfquery name="Delete" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM ClaimEventTrip 
	WHERE ClaimEventId = '#URL.ClaimEventId#'
	AND ClaimTripStop = '#URL.Stop#'
</cfquery>

<cflocation url="ClaimEventEntry.cfm?section=#url.section#&leg=0&Status=Edit&claimId=#URL.claimId#&ID1=#URL.ID1#&Topic=#URL.Topic#" addtoken="No">
