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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html><head><title>Validate and Calculate</title></head><body>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>"> 

<cfset line = 0>

<cfparam name="URL.ClaimId"    default="{00000000-0000-0000-0000-000000000000}">
<cfparam name="URL.Mode"       default="event">
<cfparam name="URL.Validation" default="1">
<cfparam name="URL.Class"      default="regular">
<cfparam name="URL.reload"     default="Yes">
<cfparam name="URL.enforce"    default="0">
<cfparam name="Progress"       default="1">
<cfparam name="URL.express"    default="0">

<!--- check if calcuation is needed --->

<cfquery name="Claim" 
  datasource="appsTravelClaim">
	SELECT *
	FROM   Claim
	WHERE  ClaimId = '#URL.ClaimId#'
</cfquery>

<!--- 18/12/2007 exported claims will not be recalculated --->

<cfif claim.exportNo eq "" or url.validation eq "0" or SESSION.isAdministrator eq "Yes">
	
	<cfif Claim.ClaimAsIs eq "1">
		<cfset url.express = 1>
		<cfset url.class = "Express">
	</cfif>
	
	<cfif claim.claimrequestid eq "">
		<cf_message message="An internal error occurred. Please come back later.">
		<cfabort>
	</cfif>
	
	<cfquery name="ClaimRequest" 
		datasource="appsTravelClaim">
		SELECT * 
		FROM   ClaimRequest
		WHERE  ClaimRequestId = '#Claim.ClaimRequestId#'
	</cfquery>
	
	<cfquery name="Prior" 
	datasource="appsTravelClaim">
		SELECT   TOP 1 * 
		FROM     ClaimCalculation
		WHERE    ClaimId = '#URL.ClaimId#'
		ORDER BY CalculationStamp DESC
	</cfquery>
	
	<cfif Prior.calculationStamp neq "">
			<cfset diff = DateDiff("h", Prior.CalculationStamp,now())>
	<cfelse>
			<cfset diff = 99>
	</cfif>			
	
	<cfif Prior.recordcount eq "0">
	      <cfset chg = 99>
	<cfelseif Claim.PointerClaimUpdated neq "">
		  <cfset chg = DateDiff("s", Claim.PointerClaimUpdated,Prior.CalculationStamp)>
	<cfelse>
	      <cfset chg = 0>
	</cfif>		
		
	<cfif URL.Enforce is "0" and 
	      Prior.recordcount eq "1" and 
		  URL.Validation eq "1" and
		  URL.Express neq "1" and
		  Diff lte 12>
		 	  	  	
		  <!--- do nothing this time --->
		  
		  <cfif reload eq "Yes">	
				<cfoutput>
					<script language="JavaScript">
					    window.location = "#SESSION.root#/#Parameter.TemplateRoot#/ClaimEntry/ClaimEntry.cfm?ClaimId=#URL.ClaimId#&RequestId=#ClaimRequest.ClaimRequestId#&PersonNo=#ClaimRequest.PersonNo#&Mode=1"
					</script>
				</cfoutput>
		  </cfif>
		  
	<!--- by pass calculation --->
	
	<cfelseif URL.Validation eq "0" and chg gt "0">
	
		<!--- do not calculate as this is already calculated --->
	
	<cfelse>
	
		<!--- check if action exists --->
		<!--- calculation script consist of 3 sections DSA, TRM, Ticket, Toll etc --->
		<!--- PENDING-2 : verify if claim dates of prior claim does not overlap --->
		
		<cfparam name="URL.Express" default="#Claim.ClaimAsIs#">
				
		<cfquery name="DELETE" 
		  datasource="appsTravelClaim">
		  DELETE FROM ClaimLine
		  WHERE ClaimId = '#URL.ClaimId#' 
		</cfquery>
		
		<!--- record the calculation action --->
		
		<cfset line = 0>
		
		<cfquery name="Current" 
			datasource="appsOrganization">
				SELECT  TOP 1 OA.ActionId 
				FROM    OrganizationObject O INNER JOIN
		                OrganizationObjectAction OA ON O.ObjectId = OA.ObjectId
				WHERE   O.ObjectKeyValue4 = '#URL.ClaimId#'
				 AND    OA.ActionStatus = '0'
				ORDER BY OA.ActionFlowOrder
		</cfquery> 
		
		<cfif current.recordcount eq "0">
			<cfset act = "{00000000-0000-0000-0000-000000000000}">
		<cfelse>
			 <cfset act = "#Current.ActionId#">
		</cfif>	
			
		<cfquery name="Clean" 
			  datasource="appsTravelClaim">
			  DELETE FROM ClaimCalculation
			  WHERE ClaimId = '#URL.ClaimId#'
			  AND   ActionId = '#act#'
		</cfquery>
			
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
					 '#act#',
					 '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#')
	    </cfquery> 		
		
		<cftry>
			
		    <cfif Progress eq "1">			
				<cf_wait1 icon="circle" text="Terminal Expenses" flush="force">
			</cfif>		
						
			<cfinclude template="CalculateTRM.cfm">
			
			<cfif Progress eq "1">
				<cf_waitEnd>
				<cf_wait1 icon="circle" text="Calculation - Other" flush="force">
			</cfif>
			
			<cfinclude template="CalculateOTH.cfm">
			
			<cfif Progress eq "1">
				<cf_waitEnd>	
				<cf_wait1 icon="circle" text="Calculation - DSA" flush="force">
			</cfif>	
					
			<cfinclude template="CalculateDSA.cfm">
			
			<cfif Progress eq "1">
				<cf_waitEnd>
				<cf_wait1 icon="circle" text="Validation - Matching" flush="force">	
			</cfif>	
			<cfinclude template="../ValidationRules/ValidationMatching.cfm">	
			
			<cfcatch>
			
				<cfquery name="Clean" 
					  datasource="appsTravelClaim">
					  DELETE FROM ClaimCalculation
					  WHERE ClaimId = '#URL.ClaimId#'
					  AND   ActionId = '#act#'
				</cfquery>
				
				<cf_message message="Problem, claim amounts have not been determined. Please contact your administrator">
				<cfabort>
			
			</cfcatch>
		
		</cftry>	
				
		<cfif url.validation eq "1">	
		
			<!--- remove validation messages --->								
			
			<cfif Progress eq "1">
				<cf_waitEnd> 				
				<cf_wait1 icon="circle" text="Validation - Threshold" flush="force">
			</cfif>	
			
				<cfquery name="ValCheck" 
				    datasource="appsTravelClaim">
					SELECT *
					FROM   ClaimCalculation
					WHERE  ClaimId       = '#URL.ClaimID#'
					AND    CalculationId = '#rowguid#'
				</cfquery>	
		
				<cfif ValCheck.recordcount eq "1">
									
					<cfquery name="Record" 
					    datasource="appsTravelClaim">
						INSERT INTO ClaimValidationLog
						(CalculationId, ClaimId, ValidationCode, ValidationStart)
						VALUES
						('#rowguid#','#Claim.ClaimId#','E01',getDate())
					</cfquery>
						
					<cfinclude template="../ValidationRules/ValidationThreshold.cfm">	
							
					<cfquery name="Record" 
					    datasource="appsTravelClaim">
						UPDATE ClaimValidationLog
						SET    ValidationEnd = getDate(), 
						       ValidationStatus = 1
						WHERE  CalculationId = '#rowguid#'			
						AND    ClaimId = '#Claim.ClaimId#'		
					</cfquery>
					
				<cfelse>
				
					<cfinclude template="../ValidationRules/ValidationThreshold.cfm">
				
				</cfif>	
				
			<cfif Progress eq "1">					
				<cf_waitEnd>		
				<cf_wait1 icon="circle" text="Validation - Advance, DSA, Funding" flush="force">
			</cfif>	
			
			<cfsilent>							
				<cfinclude template="../ValidationRules/ValidationRule.cfm">
			</cfsilent>
			
			<!--- goes to subdirectory --->
				
							
			<cfif Progress eq "1">	
				<cf_waitEnd>
			</cfif>	
									 
			<cfquery name="ResetClaim" 
				     datasource="appsTravelClaim" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     UPDATE Claim
					 SET    ActionStatus = '1'
					 WHERE  ClaimId = '#URL.ClaimID#'
					 AND    ActionStatus = '0'
			</cfquery>
			
			<!--- claim excpetion --->
			
			<cfquery name="Exception" 
				     datasource="appsTravelClaim" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">	
					 SELECT  *
					 FROM    ClaimValidation CV INNER JOIN
		                     Claim C ON CV.ClaimId = C.ClaimId INNER JOIN
		                     Ref_DutyStationActor R ON CV.ClearanceActor = R.ClearanceActor
					 WHERE   (R.Mission = '#ClaimRequest.Mission#')  
					 AND     (R.ClaimException = 1)
					 AND     CV.CalculationId = '#rowguid#' 
					 AND     C.ClaimId = '#URL.ClaimID#'
			</cfquery>		 
			
			<cfif exception.recordcount eq "0">
					 	
				<cfquery name="ResetClaim" 
					     datasource="appsTravelClaim" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     UPDATE Claim
						 SET    ClaimException = '0' 
						 WHERE  ClaimId = '#URL.ClaimID#'
						 AND (ClaimExceptionActor is NULL or ClaimExceptionActor = '')		
				</cfquery>
				
			<cfelse>
			
				<cfquery name="ResetClaim" 
					     datasource="appsTravelClaim" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     UPDATE Claim
						 SET    ClaimException = '1' 
						 WHERE  ClaimId = '#URL.ClaimID#'					
				</cfquery>
			
			</cfif>	
			
			<!--- Hanno 9/4/2008
			reset a claim to express only through the workflow sendback 
			
			<cfif URL.Express neq "">
			
				<cfquery name="ResetClaim" 
					     datasource="appsTravelClaim" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     UPDATE Claim
						 SET    ClaimAsIs = '#URL.Express#'		
						 WHERE  ClaimId = '#URL.ClaimID#' 				 
				</cfquery>
			
			</cfif>
			
			--->

			<cfquery name="Current" 
				datasource="appsTravelClaim">
					SELECT   * 
					FROM     ClaimSection C,
					         Ref_ClaimSection R
					WHERE    ClaimId = '#URL.ClaimId#'
					AND      C.ClaimSection = R.Code
					AND      C.ProcessStatus = 0
					ORDER BY ListingOrder DESC
			</cfquery> 
			
			<cfquery name="Next" 
			datasource="appsTravelClaim">
				UPDATE ClaimSection 
				SET    ProcessStatus    = 1, 
				       ProcessDate      = getDate(),
					   OfficerUserId    = '#SESSION.acc#',
					   OfficerLastName  = '#SESSION.last#',
					   OfficerFirstName = '#SESSION.first#'
				WHERE  ClaimId          = '#URL.ClaimId#' 
				AND    ClaimSection = '#Current.ClaimSection#'
			</cfquery> 	
			
			<!--- determine the step that is active at this moment --->		
					
			<cfif reload eq "Yes">	
				<cfoutput>
					<script language="JavaScript">
						window.location = "#SESSION.root#/#Parameter.TemplateRoot#/ClaimEntry/ClaimEntry.cfm?ClaimId=#URL.ClaimId#&RequestId=#ClaimRequest.ClaimRequestId#&PersonNo=#ClaimRequest.PersonNo#&Mode=1"
					</script>
				</cfoutput>
			</cfif>
			
			<cf_waitEnd>
			
		</cfif>	
	
	</cfif>	
	
<cfelse>

	<script>	
		alert("You may not validate this claim anymore.")
		history.back()
	</script>	
</cfif>	

</body>
</html>
