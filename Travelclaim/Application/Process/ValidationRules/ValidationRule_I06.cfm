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
Validation Rule :  I06
Name			:  Verify If the TVRQ has only a NOC line or only an ITN line, and no other line types, then the TVRQ should|
                   not be available for claiming in the portal,  neither as an Express Claim, nor as a Detailed   
                   Claim.
Steps			:  Claim Request Itin should have three or more records
Date			:  17 September 2007
--->

<!--- header home leave with different line --->

<cfquery name="CheckITN" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM     ClaimRequestLine
 WHERE    ClaimRequestId = '#Claim.ClaimRequestId#'
 AND ClaimCategory IN ('NOC','ITIN')
</cfquery>

<cfquery name="CheckAll" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM     ClaimRequestLine
 WHERE    ClaimRequestId = '#Claim.ClaimRequestId#'
</cfquery>

<cfif CheckITN.recordcount eq "1" and CheckAll.recordcount eq "1">

		<cfquery name="Insert" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ClaimValidation
		       (ClaimId,
			    CalculationId,
				ValidationCode, 
				ValidationMemo) 
		VALUES ('#Claim.ClaimId#',
		        '#rowguid#',
		        '#Code#',
				'#Description#')
		</cfquery>

</cfif>
