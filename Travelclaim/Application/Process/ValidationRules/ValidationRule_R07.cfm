<!--
    Copyright © 2025 Promisan

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
Validation Rule :  R07
Name			:  Verify different DSA code
Steps			:  Claimant has indicated one or more personal days
Date			:  15 November 2007
--->

<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#"> 
   SELECT   *
   FROM     ClaimLineDateIndicator
   WHERE    IndicatorCode = 'P01'
   AND      ClaimId = '#URL.ClaimId#'
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
		


