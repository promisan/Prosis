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
<cfif url.claimcategory neq "DSA">
	
	<cfquery name="Update" 
	 	datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE  ClaimEventIndicatorCostLine
		<cfif url.val eq "True">
		SET     MatchingAction = '1'
		<cfelse>
		SET     MatchingAction = '0'
		</cfif>
		WHERE   ClaimEventid IN (SELECT ClaimEventid 
		                         FROM   ClaimEvent 
								 WHERE  ClaimId = '#URL.ClaimId#')
		AND     IndicatorCode IN (SELECT Code 
		                          FROM Ref_Indicator 
		                          WHERE ClaimCategory = '#URL.ClaimCategory#')	
	</cfquery>	

<cfelse>

	<cfquery name="Update" 
	 	datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE ClaimLineDSA
		<cfif url.val eq "True">
			SET     MatchingAction = '1'
			<cfelse>
			SET     MatchingAction = '0'
			</cfif>
		WHERE ClaimId = '#URL.ClaimId#'	
	</cfquery>

</cfif>