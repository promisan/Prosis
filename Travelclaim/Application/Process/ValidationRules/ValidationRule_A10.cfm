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
<cfsilent>
		  <proUsr>Joseph George</proUsr>
		  <proOwn>Joseph George</proOwn>
		 <proDes>Template for validation Rule A10 </proDes>
		 <proCom>New File For Validation A10 </proCom>
</cfsilent>
<!-- 
Check whether  Claims submitted are not automatically matched.
 -->
<cfquery name ="Check" 
      datasource="appsTravelClaim" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT  	ClaimRequestId, 
					ClaimRequestLineNo 
		FROM     	ClaimLineDSA 
		WHERE       ClaimId = '#URL.ClaimId#' 
		AND         ClaimAutoMatching = 0
		AND         MatchingAction = 0 
		AND         Amount >0 
</cfquery>
<!-- if such is the case then check whether somebody in the EO has already submitted it by making the necessary 
     action actionstatus of 3 if only other than submitted we display this error or insert a record into 
	 claimvalidation table
-->


<cfif Check.recordcount gt 0> 

			<!---
			<cfquery name ="ClaimActionStatus" 
			      datasource="appsTravelClaim" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					SELECT *
					FROM   Claim 
					WHERE  ActionStatus < '3' 
					AND    ClaimId = '#URL.ClaimId#'
			</cfquery>
			 
			<cfif ClaimActionStatus.recordcount eq 1>
			
			--->
						
				<cf_ValidationInsert
					ClaimId        = "#URL.ClaimId#"
					ClaimLineNo    = ""
					CalculationId  = "#rowguid#"
					ValidationCode = "#code#"
					ValidationMemo = "#Description#"
					Mission        = "#ClaimRequest.Mission#">
			
			<!---
			</cfif>
			--->
</cfif>
			
		 