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
<!--- this template serves specific validations, 
each template must have the following name
ValidationRule_#validationcode# as stored in table Ref_Validation

only validations enabled for a dutystation will be performed
--->

	<cfquery name="Calculation" 
		  datasource="appsTravelClaim">
		  SELECT TOP 1 CalculationId 
		  FROM  ClaimCalculation
		  WHERE ClaimId = '#URL.ClaimId#'
		  AND   ActionId = '{00000000-0000-0000-0000-000000000000}'
	</cfquery>
	
	<cfif Calculation.recordcount eq "1">
	
	    <cfset rowguid = calculation.calculationId>
		
	<cfelse>
		
		<cf_assignId>
	
		<cfquery name="Insert" 
		datasource="appsTravelClaim">
		INSERT ClaimCalculation 
		       ( ClaimId,
			     CalculationStamp, 
				 CalculationId,
				 ActionId,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		VALUES ('#URL.ClaimId#',
		         getDate(),
				 '#rowguid#',
				 '{00000000-0000-0000-0000-000000000000}',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
	    </cfquery> 	
		
	</cfif>	

	<cfquery name="Rules" 
	    datasource="appsTravelClaim"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM ClaimValidation
		WHERE ClaimId = '#Claim.ClaimId#'		
		AND ValidationCode IN (SELECT Code
								FROM      Ref_Validation
								WHERE     ValidationClass = 'Initial') 
	</cfquery>	

	<cfquery name="Rules" 
	    datasource="appsTravelClaim"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM      Ref_Validation
		WHERE     ValidationClass = 'Initial' 
		AND       Operational = 1
	</cfquery>
	
	<cfloop query="Rules">
	
	    <cfinclude template="ValidationRule_#Code#.cfm">
	   	
	</cfloop>

