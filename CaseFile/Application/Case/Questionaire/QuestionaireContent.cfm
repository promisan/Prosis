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
<cf_actionlistingscript>
<cf_filelibraryscript>
<cf_menuscript>

<cf_screentop height="100%" scroll="no" html="No" jquery="Yes">

<!--- --------------------------------------------------------------------------------------------- --->
<!--- This template was originally developed for FPD NY to assist in the Haiti disaster ----------- --->
<!--- --------------------------------------------------------------------------------------------- --->

<cf_wfPending entityCode="ClmNoticasDocument" table="#SESSION.acc#deathpending">
<cf_wfCurrent entityCode="ClmNoticasDocument" table="#SESSION.acc#deathstatus">

<cfajaximport tags="cfdiv">

<table width="94%" height="100%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr class="hide"><td id="result"></td></tr>	
	
	<cfset claimId = replace(URL.claimid,' ','','ALL')>
	
	<cfquery name="Document" 
	   datasource="AppsCaseFile"
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">	
			SELECT  *
			FROM    Claim
			WHERE   ClaimId = '#claimid#' 						
	</cfquery>
		
	<cfquery name="Object" 
	   datasource="AppsOrganization"
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">	
			SELECT  *
			FROM    OrganizationObject
			WHERE   ObjectKeyValue4 = '#claimid#' 			
			AND     EntityCode='Clm#Document.ClaimType#'
	</cfquery>
		
	<cfquery name="Claim" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  Claim
			WHERE ClaimId = '#URL.claimid#'	
	</cfquery>	
		
	<cfinvoke component = "Service.Access"  
		 method         = "CaseFileManager" 
		 mission        = "#Claim.Mission#" 	
		 claimtype      = "#Claim.claimtype#"   
		 returnvariable = "accessLevel">		
	
	<cfif accesslevel eq "NONE">
					
			<cfif Object.ObjectId neq "">
		
				<cfinvoke component = "Service.Access"  
			    method           = "AccessEntityFly" 	   
				ObjectId         = "#Object.Objectid#"
			    returnvariable   = "accessgranted">	
			
				<!--- return NULL, 0 (collaborator), 1 (processor) --->
		
			</cfif>
		
	<cfelse>
		
			<cfset accessgranted = "2">
		
	</cfif>
	
	<tr><td align="center">
	
	<table width="100%" cellspacing="0" cellpadding="0">
	
	<tr>	
	
	<cfif Object.recordcount eq "1">
			
			<cfquery name="Claim" 
			datasource="AppsCaseFile">
				SELECT    *
				FROM     Claim
				WHERE    ClaimId IN (SELECT ObjectKeyValue4 
				FROM     Organization.dbo.OrganizationObject
				WHERE    ObjectId = '#Object.ObjectId#') 
			</cfquery>			
		  						
			    <!--- ---------------------------- --->
			    <!--- --custom code for UNHQ only- --->
				<!--- ---------------------------- --->
				
				<cfset ht = "40">
				<cfset wd = "40">
				
				<cfset itm = 0>
						
				<!--- show for collaborator and up --->
				<!--- REMOVED BY dev ON AUGUST 2011 
			    <cfif accessGranted gte "0">		
				
						<cfset itm = itm+1>

						<!--- dfields --->
						
						<cf_menutab base="death" item       = "#itm#" 
					            iconsrc    = "Logos/CaseFile/Death.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								padding    = "1"
								class      = "highlight1"
								name       = "Arrangements">								
				
				</cfif>
				--->
				
				
				<!--- --------------------------------------------------- --->
				<!--- ----------generate stQuenstionare tabs------------- --->
				<!--- --------------------------------------------------- --->		
				<!--- Note : label = free text so this needs improvement- --->
								
				<cfquery name="ListMain" 
				datasource="AppsCaseFile">
					SELECT Description as Tab 
					FROM   stQuestionaireSection 
					ORDER BY ListingOrder									
				</cfquery>				
								
				<!--- if not access at all, hide/disable the tab --->
				 				
				<cfoutput query="ListMain">
																		
						<!--- precheck access --->										
														
						<cfquery name="List" 
							datasource="AppsCaseFile">
							SELECT   *
							FROM     stQuestionaire Q INNER JOIN
							         stQuestionaireTopic T ON Q.TopicCode = T.TopicCode INNER JOIN
									 stQuestionaireSection S ON S.Code=Q.TabLabel
							WHERE    Q.ClaimTypeClass = '#Claim.ClaimTypeClass#'
							AND      S.Description       = '#Tab#'
							AND      Q.TopicScope     = 'Main' <!--- exclude the workflow show only --->
							ORDER BY Q.ListingOrder 
						</cfquery>						
						 
						<cfinvoke component = "Service.Access"  
							 method         = "CaseFileManager" 
							 mission        = "#Claim.Mission#" 	
							 claimtype      = "#Claim.claimtype#"   
							 returnvariable = "accessLevel">		
						
						<cfif accesslevel eq "NONE">
										
								<cfif Object.ObjectId neq "">
							
									<cfinvoke component = "Service.Access"  
								    method           = "AccessEntityFly" 	   
									ObjectId         = "#Object.Objectid#"
								    returnvariable   = "accessgranted">	
								
									<!--- return NULL, 0 (collaborator), 1 (processor) --->
							
								</cfif>
							
						<cfelse>
							
								<cfset accessgranted = "2">
							
						</cfif>
						
						<cfset show = 0>
						
						<cfloop query="List">

   							<cfif accessgranted gte accesslevelread and accessgranted neq "">	
							    <!--- we have access to at least one topic so we show the tab --->							
								<cfset show = 1>							
							</cfif>
							
						</cfloop>		
						
						<cfif show eq "1">
						
							<cfset itm = itm+1>
						
							<cf_menutab base="death" item       = "#itm#" 
					            iconsrc    = "Logos/System/Document.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								targetitem = "2"
								padding="1"
								name       = "#Tab#"
								source     = "../Questionaire/QuestionaireTopic.cfm?claimid=#url.claimid#&tab=#tab#&tabid=death#currentrow#">		
						
													  
						</cfif>	  
							
														
				</cfoutput>	
										
						
		</cfif>	
		
		<td width="10%"></td>
		
		</tr>
	</table>
	
	</td>	 
	</tr>
	
	<tr><td class="linedotted"></td></tr>
	
	<tr>
		<td height="100%">
		
		    <cf_divscroll height="100%">
			
			<table width="100%" height="100%">
			
			 
			
			<cf_menucontainer item="1" class="regular">
				  <!--- Removed as per OHRM (Jasmin) request on November 18th - dev
					<cfset url.objectId = Object.Objectid>
					<cfinclude template="../Additional/Additional.cfm">
					--->
			</cf_menucontainer>
			<cf_menucontainer item="2" class="hide">
		
			<!--- added as per OHRM (Jasmin) request on November 18th - dev --->
			<script>
				document.getElementById("death1").click();
			</script>
			
			</cf_divscroll>
		
			</table>	
		</td>
	</tr>
	
</table>



