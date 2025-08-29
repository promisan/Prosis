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
Validation Rule 	:  R04
Name				:  Validate different DSA location code
Desc				:  Verify to check the DSA location code and flag for EO review if the location code is not in the travel request
Date				:  15 August2006

---------------------Modification-----------------------------

Last Modified 	:  24/08/2008
Last Modfied By :  Huda Seid
Change Made 	: Made changes below to exclude the DSA days when annual leave is taken --->



<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">

	SELECT  *
    FROM    ClaimLineDSA
    WHERE   ClaimId = '#URL.ClaimId#'
    AND calendardate NOT IN (select calendardate 
			 				from dbo.ClaimLineDateIndicator 
			 				where indicatorcode='P01' and claimid='#URL.ClaimId#')
    AND LocationCode NOT IN (SELECT ServiceLocation 
	                         FROM ClaimRequestDSA
							 WHERE ClaimRequestId = '#ClaimRequest.ClaimRequestId#') 
	 <!---- Previous code was as below not taking into account annual leave days
	 
	SELECT  *
    FROM    ClaimLineDSA
    WHERE   ClaimId = '#URL.ClaimId#'
    AND LocationCode NOT IN (SELECT ServiceLocation 
	                         FROM ClaimRequestDSA
							 WHERE ClaimRequestId = '#ClaimRequest.ClaimRequestId#') 
							 
	---->
	
</cfquery>		

<cfif Check.recordcount gte "1">

	 <cf_ValidationInsert
    	ClaimId        = "#URL.ClaimId#"
		ClaimLineNo    = ""
		CalculationId  = "#rowguid#"
		ValidationCode = "#code#"
		ValidationMemo = "#Description#"
		Mission        = "#ClaimRequest.Mission#">
		
</cfif>	 		
		


