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
Validation Rule :  R01
Name			:  Travel with overnight stop requires review
Steps			:  Determine if an overnight stop was checked/reported
Date			:  05 April 2006
Last date		:  15 June 2006
--->

<!--- query trip info for status 1 --->

<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT     *
	FROM    ClaimEventTrip
	WHERE   OverNightStay = '1' 
	AND (ClaimEventId IN
            (SELECT    ClaimEventid
             FROM      ClaimEvent
             WHERE     ClaimId = '#URL.ClaimId#')) 
</cfquery>	

<cfif Check.recordcount neq "0">		 

 <cf_ValidationInsert
   	ClaimId        = "#URL.ClaimId#"
	ClaimLineNo    = ""
	CalculationId  = "#rowguid#"
	ValidationCode = "#code#"
	ValidationMemo = "#Description#"
	Mission        = "#ClaimRequest.Mission#">
	
</cfif>	


