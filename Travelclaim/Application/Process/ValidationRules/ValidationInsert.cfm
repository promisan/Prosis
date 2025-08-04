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

<cfparam name="Attributes.EventCode"       default="">
<cfparam name="Attributes.ClaimCategory"   default="">
<cfparam name="Attributes.IndicatorCode"   default="">
<cfparam name="Attributes.ValidationMemo"  default="">
<cfparam name="Attributes.RowGuid"         default="">

<cfquery name="Validation" 
datasource="appsTravelClaim">
	SELECT *
	FROM   Ref_Validation
	WHERE  Code = '#Attributes.ValidationCode#'
</cfquery>

<cfquery name="Claim" 
datasource="appsTravelClaim">
	SELECT *
	FROM   Claim
	WHERE  ClaimId = '#Attributes.ClaimId#'
</cfquery>

<cfquery name="ClaimRequest" 
	  datasource="appsTravelClaim">
	  SELECT *
	  FROM ClaimRequest
	  WHERE ClaimRequestId = '#Claim.ClaimRequestId#'
</cfquery>

<!--- check role --->

<cfquery name="Actor" 
  datasource="appsTravelClaim"
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT  '#Attributes.ValidationCode#' as Code, 
	        '#Attributes.ValidationMemo#' as Description, 
			ClearanceActor
	FROM    Ref_DutyStationValidation
	WHERE   Mission        = '#ClaimRequest.Mission#'
	AND     ValidationCode = '#Attributes.ValidationCode#' 
	<cfif #Attributes.EventCode# neq "">
	AND     EventCode = '#Attributes.EventCode#'
	</cfif>
</cfquery>
			
<cfloop query="Actor">

	<cfquery name="Check" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   ClaimValidation
	WHERE  ClaimId        = '#Attributes.ClaimId#'
	AND    CalculationId  = '#Attributes.CalculationId#'
	<cfif Attributes.ClaimCategory neq "">
	AND    ClaimCategory   = '#Attributes.ClaimCategory#'
	</cfif>
	<cfif Attributes.EventCode neq "">
	AND    EventCode       = '#Attributes.EventCode#'
	</cfif>
	AND    ValidationCode = '#Attributes.ValidationCode#'
	AND    ClearanceActor = '#ClearanceActor#'
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	
		<cfquery name="Insert" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ClaimValidation   
		       	   (ClaimId, 
				    CalculationId,
				    ClaimCategory, 
					ValidationCode, 
					ValidationMemo,
					ClearanceActor) 
		VALUES ('#Attributes.ClaimId#',
		        '#Attributes.CalculationId#',
		        '#Attributes.ClaimCategory#',
				'#Attributes.ValidationCode#',
				<cfif Attributes.ValidationMemo neq "">
				'#Attributes.ValidationMemo# - #Attributes.EventCode#',
				<cfelse>
				'#Validation.MessagePerson#',
				</cfif>
				'#ClearanceActor#')
		</cfquery>
		
	</cfif>

</cfloop>
