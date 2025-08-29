<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
	