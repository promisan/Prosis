<cfquery name="Delete" 
	     datasource="AppsTravelClaim" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM ClaimEventIndicatorCost
		 WHERE  ClaimEventId   IN (SELECT ClaimEventId 
		                           FROM ClaimEvent
								   WHERE ClaimId= '#URL.ClaimId#')
		 AND  IndicatorCode = '#URL.IndicatorCode#'
		 AND  CostLineNo = '#URL.id2#'
</cfquery>

<cfquery name="Updated"
	datasource="appsTravelClaim"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Claim
		SET   PointerClaimUpdated = getDate()
		WHERE ClaimId = '#URL.ClaimId#'				
</cfquery>	

<cf_NavigationReset
     Alias          = "AppsTravelClaim"
	 Object         = "Claim" 
	 Group          = "TravelClaim" 
	 Reset          = "Default"
	 Id             = "#URL.ClaimId#">

<cfoutput> 
<SCRIPT LANGUAGE = "JavaScript">
	     ColdFusion.navigate('#SESSION.root#/travelclaim/application/evententry/ClaimEventEntryIndicatorEntryCostRecord.cfm?editclaim=#url.editclaim#&claimid=#URL.ClaimID#&personNo=#URL.PersonNo#&indicatorcode=#URL.IndicatorCode#','b#URL.PersonNo#_#URL.IndicatorCode#') 
</script>	
</cfoutput>	
	