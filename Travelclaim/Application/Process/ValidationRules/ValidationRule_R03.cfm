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
<!--- 
Validation Rule :  R03
Name			:  Flag for EO review if Days DSA claimed <> Days DSA Obligated excluding annual leave days
Date			:  20 Feb 2007
---------------------Modification-----------------------------

Last Modified 	:  24/08/2008
Last Modfied By :  Huda Seid
Change Made 	:  	Made changes to flag claims for only for EO Review instead of EO and accounts(done online in NOVA). 
					Excluded annual leave days.
--->


<!--- We calculate the total number of days for which DSA was obligated in the TVRQ --->
<cfquery name="DSARequest" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
     SELECT    SUM(RequestDays) AS Requested
     FROM      ClaimRequestDSA
     WHERE     ClaimRequestId = '#Claim.ClaimRequestId#' 
</cfquery>	

<!--- We calculate the total number of days for which DSA is claimed 
We exclude days marked as Personal days [with a record in ClaimLineDateIndicator with a P01 indicatorcode.
For detailed claims, ClaimLineDSA (built based on the detailed itinerary) contains 1 record by date / line in the subsistence screen.
 --->
<cfquery name="DSAClaim" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 	SELECT count(*) as Claimed
		FROM    ClaimLineDSA
		WHERE    ClaimId = '#URL.claimid#'
		AND calendardate not in (select calendardate 
								 from dbo.ClaimLineDateIndicator 
								 where indicatorcode='P01'
								 And ClaimId = '#URL.claimid#') 
	 
	 
</cfquery> 
<!----
<cfquery name="DSAClaim" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT  COUNT(*) AS Claimed
	 FROM    ClaimLineDSA
	 WHERE   ClaimId = '#URL.ClaimId#'
	 AND     Percentage > 0	
</cfquery> 
------------------------------>
<!----If the number of dsa days claimed is different from the dsa days in the claim excluding annual leave days then flag for validation--->

<cfif DSARequest.Requested gte "1">

	<cfif DSAClaim.Claimed neq DSARequest.Requested >

		 <cf_ValidationInsert
	    	ClaimId        = "#URL.ClaimId#"
			ClaimLineNo    = ""
			CalculationId  = "#rowguid#"
			ValidationCode = "#code#"
			ValidationMemo = "#Description#"
			Mission        = "#ClaimRequest.Mission#">
		
	</cfif>	 	

</cfif>	
		


