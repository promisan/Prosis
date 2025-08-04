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
Validation Rule :  R31
Name			:  Verify mode of travel (claimevents)
Steps			:  Determine if the selected travel mode would require additional review
Date			:  05 April 2006
Last date		:  05 June 2006
--->

<cfquery name="Verify" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    DISTINCT eventcode
	FROM      ClaimEventTrip Trip, 
	          ClaimEvent Ev
	WHERE     Ev.ClaimId         = '#URL.ClaimId#' 
	AND       Trip.ClaimEventId  = Ev.ClaimEventId
	AND       Trip.EventCode IN (SELECT EventCode 
	                             FROM   Ref_DutyStationValidation
								 WHERE  Mission = '#ClaimRequest.Mission#' 
								 AND    ValidationCode = '#Code#'
								 AND    Operational = 1) 
</cfquery>	

<cfset valcode = "#Code#">
<cfset valdesc = "#Description#">

<cfloop query="Verify">

	 <cf_ValidationInsert
    	ClaimId        = "#URL.ClaimId#"
		ClaimLineNo    = ""
		ValidationCode = "#valcode#"
		ValidationMemo = "#valdesc#"
		Mission        = "#ClaimRequest.Mission#"
		EventCode      = "#EventCode#"
		CalculationId  = "#rowguid#">
		
</cfloop>