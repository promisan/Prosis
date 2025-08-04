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
Validation Rule :  I04
Name			:  Verify if Home leave travel component
Steps			:  Verify for code '9'
Date			:  05 July 2006
Last date		:  05 July 2006 (review)
--->

<!--- header home leave with different line --->

<cfquery name="Header" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM     ClaimRequest
 WHERE    ClaimRequestId = '#URL.RequestId#'
 AND      ActionPurpose = '9'
</cfquery>

<cfif Header.recordcount eq "1">

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
