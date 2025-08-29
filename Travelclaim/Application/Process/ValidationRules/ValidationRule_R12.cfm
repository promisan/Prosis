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
Validation Rule :  R12
Name			:  Verify HZA, MSA or special rate indicator
Steps			:  Determine if any HAZARD payment was selected
Date			:  20 Feb 2007
--->

<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT * FROM ClaimEventTripIndicator
    WHERE     ClaimTripId IN
                  (SELECT  Tr.ClaimTripId
                   FROM    ClaimEvent Ev INNER JOIN
                           ClaimEventTrip Tr ON Ev.ClaimEventId = Tr.ClaimEventId
                   WHERE   Ev.ClaimId = '#URL.ClaimId#')
	AND       IndicatorCode IN (SELECT Code 
	          	    	        FROM Ref_Indicator 
								WHERE Category = 'Rate')  
</cfquery>

<cfset cde = code>
<cfset des = description>

<cfloop query="Check">

	<cfquery name="Indicator" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM Ref_Indicator 
	 WHERE Code = '#IndicatorCode#'
	</cfquery>

	 <cf_ValidationInsert
    	ClaimId        = "#URL.ClaimId#"
		ClaimLineNo    = ""
		CalculationId  = "#rowguid#"
		ValidationCode = "#cde#"
		ValidationMemo = "#Des#"
		Mission        = "#ClaimRequest.Mission#">
		
</cfloop>