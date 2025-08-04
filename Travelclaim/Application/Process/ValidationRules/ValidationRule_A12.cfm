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
		 <proDes>Template for validation Rule A12 </proDes>
		 <proCom>New File For Validation A12 </proCom>
</cfsilent>

<!--- 
Check whether  Claims submitted are not automatically matched For NON -DSA .
--->

<cfquery name ="CheckNONDSAmatching" datasource="appsTravelClaim" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT D.ClaimRequestId, D.ClaimRequestLine as ClaimRequestLineNo, R.ClaimCategory,
 		D.ClaimObligated      
	FROM ClaimEventIndicatorCost C INNER JOIN Ref_Indicator R ON 
		C.IndicatorCode = R.Code 
		INNER JOIN ClaimEventIndicatorCostLine D ON C.ClaimEventID = D.ClaimEventID
								AND  	D.IndicatorCode = R.Code
								AND  	D.IndicatorCode = C.IndicatorCode
						        AND		D.CostLineNo = C.CostLineNo
        WHERE 	C.ClaimEventId IN 
							(SELECT ClaimEventId 
							 FROM ClaimEvent 
							 WHERE ClaimId = '#URL.ClaimId#')
	 	AND 	ClaimAutoMatching = 0
		AND 	MatchingAction    = 0 		

</cfquery>

<!--- if such is the case then check whether somebody in the EO has already submitted it by making the necessary 
     action actionstatus of 3 if only other than submitted we display this error or insert a record into 
	 claimvalidation table
--->

<cfif CheckNONDSAmatching.recordcount gt 0> 
			
				<cf_ValidationInsert
					ClaimId        = "#URL.ClaimId#"
					ClaimLineNo    = ""
					CalculationId  = "#rowguid#"
					ValidationCode = "A12"
					ValidationMemo = "Unable to automatically Associate NON-DSA claim lines to TVRQ. Perform manual association"
					Mission        = "#ClaimRequest.Mission#">
			

</cfif>
