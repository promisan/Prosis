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
Validation Rule :  R14
Name			:  Flag for accounts review if Days DSA claimed > Days DSA Obligated excluding annual leave days
Creation Date	:  29 October 2008
Created         : Huda Seid
---->

<cfquery name="DSARequest" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
     SELECT    SUM(RequestDays) AS Requested
     FROM      ClaimRequestDSA
     WHERE     ClaimRequestId = '#Claim.ClaimRequestId#' 
</cfquery>	

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

<cfif DSARequest.Requested gte "1">

	<cfif DSAClaim.Claimed gt DSARequest.Requested >

		 <cf_ValidationInsert
	    	ClaimId        = "#URL.ClaimId#"
			ClaimLineNo    = ""
			CalculationId  = "#rowguid#"
			ValidationCode = "#code#"
			ValidationMemo = "#Description#"
			Mission        = "#ClaimRequest.Mission#">
		
	</cfif>	 	

</cfif>	
		

		