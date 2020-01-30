
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