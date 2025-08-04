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
Validation Rule :  R16
Name			:  Verify whether the Peace keeping mission radio /Indicator is switched on 
Steps			:  Determine if any subsistence exception was selected
Date			:  16/09/2009 JG

--->

<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT IndicatorCode as Indcode_ind  FROM ClaimEventTripIndicator
    WHERE     ClaimTripId IN
                  (SELECT  Tr.ClaimTripId
                   FROM    ClaimEvent Ev INNER JOIN
                           ClaimEventTrip Tr ON Ev.ClaimEventId = Tr.ClaimEventId
                   WHERE   Ev.ClaimId = '#URL.ClaimId#')
	AND       IndicatorCode IN (SELECT Code 
	          	    	        FROM Ref_Indicator 
								WHERE Category IN (SELECT Code 
					                               FROM Ref_IndicatorCategory 
												   WHERE ClaimSection = 'Subsistence'))  
	AND IndicatorCode ='R02'
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
	 WHERE Code = '#Indcode_ind#'
	</cfquery>

	 <cf_ValidationInsert
    	ClaimId        = "#URL.ClaimId#"
		ClaimLineNo    = ""
		CalculationId  = "#rowguid#"
		ValidationCode = "#cde#"
		ValidationMemo = "#des#"
		Mission        = "#ClaimRequest.Mission#">
		
</cfloop>