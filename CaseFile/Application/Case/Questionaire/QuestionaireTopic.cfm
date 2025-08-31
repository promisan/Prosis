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
<cfquery name="Claim" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Claim
		WHERE ClaimId = '#URL.claimid#'	
</cfquery>	
			
<cfquery name="List" 
	datasource="AppsCaseFile">
	SELECT   *
	FROM     stQuestionaire Q INNER JOIN
	         stQuestionaireTopic T ON Q.TopicCode = T.TopicCode INNER JOIN
			 stQuestionaireSection S ON S.Code=Q.TabLabel
	WHERE    Q.ClaimTypeClass = '#Claim.ClaimTypeClass#'
	AND      S.Description    = '#url.Tab#'
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

<!--- main level access --->	

<cfquery name="Object" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   OrganizationObject
		WHERE  ObjectKeyValue4 = '#URL.claimid#'	
</cfquery>

<!--- ------------------------------------ --->
<!--- pointer to hide/show tab, see bottom --->
<cfset tabshow = "0">
<!--- ------------------------------------ --->
<!--- ------------------------------------ --->

<table width="96%" cellspacing="0" cellpadding="0" align="center">

	<tr><td height="5" colspan="3"></td></tr>
	
	<cfoutput>
	
		<tr><td height="7"></td></tr>
		<tr><td colspan="3" height="30" class="labellarge">#Tab# Actions</td></tr>
		<tr><td colspan="3" class="linedotted"></td></tr>
		<tr><td height="8"></td></tr>
	
	</cfoutput>

	<cfoutput query="List">

    <!--- ----------------------------- --->
	<!--- define if topic will be shown --->
	<!--- ----------------------------- --->
	
	<cfif accessgranted gte accesslevelread and accessgranted neq "">	
					
		<!--- capture the id of the content record --->   
		
		<cfquery name="check" datasource="AppsCaseFile">
			SELECT *
			FROM   stQuestionaireContent
			WHERE  ClaimId    = '#url.claimId#'
			AND    TopicCode  = '#topiccode#'
		</cfquery>
									
		<cfif check.recordcount eq "0">				
		
		    <cf_assignId>
			
			<!--- create an instance for this topic and claim to directly store information --->
			
			<cfquery name="insert" datasource="AppsCaseFile">
				INSERT INTO stQuestionaireContent 
							(Claimid,
					         TopicCode,
							 TopicId,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
				VALUES 		('#URL.Claimid#',
				        	'#topicCode#',
							'#rowguid#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#')
			</cfquery>
			
			<cfquery name="check" datasource="AppsCaseFile">
				SELECT *
				FROM   stQuestionaireContent
				WHERE  ClaimId    = '#url.claimId#'
				AND    TopicCode  = '#topiccode#'
			</cfquery>
			
			<cfset url.ajaxid = rowguid>
			
		<cfelse>
		
		   <cfset url.ajaxid = check.topicid>	
		
		</cfif>		
				
		<tr>
		
		 <td width="70" class="labelit">&nbsp;&nbsp;&nbsp;#ListingOrder#.</td>		 
		 <cfif UserInput eq "CheckBox">
		 <td>
		 <table cellspacing="0" cellpadding="0" class="formpadding">
				<tr>
				<td class="labelmedium"><input class="radiol" name="input#url.ajaxid#" type="radio" value="0" <cfif check.TopicValue neq "1">checked</cfif> onclick="_cf_loadingtexthtml='';ColdFusion.navigate('../Questionaire/QuestionaireTopicSubmitCheckbox.cfm?topicid=#url.ajaxid#&value=0','save#url.ajaxid#')"></td><td class="labelmedium">No</td>
				<td class="labelmedium"><input class="radiol" name="input#url.ajaxid#" type="radio" value="1" <cfif check.TopicValue eq "1">checked</cfif> onclick="_cf_loadingtexthtml='';ColdFusion.navigate('../Questionaire/QuestionaireTopicSubmitCheckbox.cfm?topicid=#url.ajaxid#&value=1','save#url.ajaxid#')"></td><td class="labelmedium">Yes</td>						
				<td>&nbsp;&nbsp;</td>
				</tr>
		 </table>		
		 </td>
		 <cfelse>
		 <td></td>
		 </cfif>
		 
         <td class="labelmedium" style="color:##6688AA"><b>#FormLabel#</b></td>
		 
		</tr>
		         
		<cfif FormNote neq "">		  
		    <tr><td></td>
			    <td></td>
		 		<td width="95%" class="labelit">#FormNote#</td>
			</tr>
		</cfif> 
		
		<tr><td colspan="3" id="save#url.ajaxid#"></td></tr>
		
		<!--- show content --->
		
		<cfif UserInput eq "None">
		
			<tr><td colspan="3" class="labelmedium"><b>#FormLabel#</b></td></tr>
					
		<cfelseif UserInput eq "Workflow">
			
		    <tr id="#TopicCode#TR">
			
			<td></td>							
			<td></td>
			<td>
			
				<table width="98%" cellspacing="0" cellpadding="0" class="formpadding">	
										
					<cfset wflink = "#SESSION.root#/CaseFile/Application/Case/Questionaire/QuestionaireTopicWorkflow.cfm">  
					 
					<input type="hidden" 
					   name="workflowlink_#ajaxid#" 
					   id="workflowlink_#ajaxid#" 
					   value="#wflink#">		
					   
					    <cfquery name="DeathPending" datasource="appsQuery">
							SELECT *
							FROM   #SESSION.acc#deathPending
							WHERE  ObjectKeyValue4 = '#url.ajaxid#'
						</cfquery>
						
						 <cfquery name="DeathStatus" datasource="appsQuery">
							SELECT *
							FROM   #SESSION.acc#deathstatus
							WHERE  ObjectKeyValue4 = '#url.ajaxid#'
						</cfquery>
					   
				    <tr>
					<td height="20" id="#url.ajaxid#" class="labelit">		
						<a href="javascript:ColdFusion.navigate('../Questionaire/QuestionaireTopicWorkflow.cfm?ajaxId=#ajaxid#','#url.ajaxid#')">
						<font color="53A9FF">
						<cfif DeathStatus.recordcount eq "0">
							<font color="6688aa">[Press here to process]</font>
						<cfelse>
						    Status: #DeathStatus.ActionDescriptionDue# 
						    <cfif DeathPending.recordcount gte "0">
								<font color="FF0000">&nbsp;For action: #DeathPending.ActionDescriptionDue#</font> 	
								(click to process)									
							<cfelse>
								(click to see more details)		
							</cfif>
							
						</cfif>
						</a>	
					</td>	
					</tr>
				</table>
				
			  </td>
		    </tr>	
							
		<cfelseif UserInput eq "Attach">	
						
			<tr><td height="3" colspan="3"></td></tr>
												 				
				<tr>
					    
						<td></td>
						<td></td>
						<td>	
																							
								<cfset box = "#tabid#_#currentrow#">
								
								<cf_filelibraryN
									DocumentPath  = "InsuranceClaim"
									SubDirectory  = "#claimid#" 
									Filter        = "#TopicCode#"						
									LoadScript    = "0"		
									Width         = "98%"
									Box           = "#box#"
									Insert        = "yes"
									Remove        = "yes">												
											
						</td>
						
			 </tr>
					 
			 <tr><td height="3" colspan="3"></td></tr>
				
					 										
		</cfif>		
		
	</cfif>	
			
	<tr><td height="3" colspan="3"></td></tr>	
	<!--- -------------------------------------------------- --->
	<!--- hide tab if not access exists at all for any topic --->
	<!--- -------------------------------------------------- --->
	
	
</cfoutput>		

<!--- custom provision to show forms --->

<cfoutput>

<cfif tab neq "Insurances" and tab neq "Pension Fund">

	<tr><td height="6"></td></tr>
	<tr><td colspan="3" class="linedotted"></td></tr>
	<tr><td colspan="3" height="30">
	<a href="javascript:ColdFusion.navigate('#SESSION.root#/CaseFile/application/Case/Questionaire/SupportingForms.cfm?tab=#tab#','#tab#forms')" title="Supporting Template Forms">
	<font size="2" color="0080C0"><u>Show Supporting Templates and Forms</u></font>
	</a></td></tr>
	<tr><td colspan="3" class="linedotted"></td></tr>
	<tr><td height="8"></td></tr>
	<tr><td colspan="3" id="#tab#forms"></td></tr>
 
</cfif> 
</cfoutput>
	
</table>		
