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
Validation Rule :  R09
Name			:  TRM calculated by the Portal but not obligated in TVRQ
Steps			:  Check if TRM exist but not in Obligation
Date			:  15 January 2008
--->

<cfquery name="Check1" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#"> 
 	SELECT   *
	FROM     ClaimEventIndicatorCost CI INNER JOIN
             ClaimEvent C ON CI.ClaimEventId = C.ClaimEventId
	WHERE    CI.IndicatorCode = 'TRM'
	AND      C.ClaimId = '#URL.ClaimId#'
</cfquery>	
 
<cfquery name="Check2" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#"> 
 	SELECT   *
    FROM     ClaimRequestLine
    WHERE    ClaimRequestid = '#ClaimRequest.ClaimRequestId#'
	AND      ClaimCategory = 'TRM'	
</cfquery>							

<cfif Check1.recordcount gte "1" and Check2.recordcount eq "0">

	 <cf_ValidationInsert
    	ClaimId        = "#URL.ClaimId#"
		ClaimLineNo    = ""
		CalculationId  = "#rowguid#"
		ValidationCode = "#code#"
		ValidationMemo = "#Description#"
		Mission        = "#ClaimRequest.Mission#">
				
</cfif>	 		
		


