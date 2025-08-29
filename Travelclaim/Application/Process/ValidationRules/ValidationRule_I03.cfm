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
Validation Rule :  I03
Name			:  Verify if Home leave travel request has Official Business component
Steps			:  Search for overlapping periods for the traveller
Date			:  05 April 2006
Last date		:  05 June 2006 (review)
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

<cfquery name="Line" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM     ClaimRequestLine
 WHERE    ClaimRequestId = '#URL.RequestId#'
 AND      ActionPurpose != '9'
</cfquery>

<cfif Header.recordcount eq "1" and Line.Recordcount gt "0">

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

<!--- line home leave with different header --->

<cfquery name="Header" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM     ClaimRequest
 WHERE    ClaimRequestId = '#URL.RequestId#'
 AND      ActionPurpose != '9'
</cfquery>

<cfquery name="Line" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM     ClaimRequestLine
 WHERE    ClaimRequestId = '#URL.RequestId#'
 AND      ActionPurpose = '9'
</cfquery>

<cfif Header.recordcount eq "1" and Line.Recordcount gt "0">

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

