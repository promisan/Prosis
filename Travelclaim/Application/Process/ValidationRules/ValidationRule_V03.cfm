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
Validation Rule :  V03
Name			:  Recovery on an advance
Steps			:  Determine of claim line amount < Advance amount
Issues			:  Comparison based on converted amount = USD
Date			:  05 June 2006
--->

<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT sum(ClaimAmountBase) as Claimed
	FROM   ClaimLine
	WHERE  ClaimId = '#URL.ClaimId#' 
</cfquery>	

<cfquery name="Advance" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT sum(cnvrt_bal) as Advance
	FROM   IMP_ClaimAdvance
	WHERE  Doc_No = '#ClaimRequest.DocumentNo#'
	AND db_mdst_source = '#ClaimRequest.Mission#'
</cfquery>

<cfif Check.Claimed lt Advance.advance>		 

 <cf_ValidationInsert
   	ClaimId        = "#URL.ClaimId#"
	ClaimLineNo    = ""
	CalculationId  = "#rowguid#"
	ValidationCode = "#code#"
	ValidationMemo = "#Description#"
	Mission        = "#ClaimRequest.Mission#">
	
</cfif>	

