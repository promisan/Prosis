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
<!--- this template is to be used in the workflow to allow for attachment to be recorded as part of a workflow step --->
<!--- the topic of the workflow is determined and then used to define which topics need to be show here, 
      only topics defined as attachments are allowed -------------------------------------------------------------- --->
<!--- ------------------------------------------------------------------------------------------------------------- --->

<cfquery name="Context" 
	datasource="AppsCaseFile">
	SELECT   *
	FROM     stQuestionaireContent T 
	WHERE    T.TopicId = '#Object.ObjectKeyValue4#'	
</cfquery>

<cfquery name="qClaim" datasource="AppsCaseFile">
	SELECT     *
	FROM  stQuestionaireContent
	WHERE TopicId = '#Object.ObjectKeyValue4#' 
</cfquery>

<cfquery name="claimDetails" datasource = "AppsCaseFile">
	SELECT *
	FROM   Claim
	WHERE  ClaimId = '#qClaim.ClaimId#'
</cfquery>

<cfquery name="first" datasource="AppsCaseFile">
	SELECT * 
	FROM   stQuestionaire
	WHERE  TopicParent = '#Context.topiccode#'
	AND    TopicScope  = 'Workflow'
	AND    ClaimTypeClass = '#claimDetails.ClaimTypeClass#'
</cfquery>

<input type="hidden" name="SaveCustom" value="CaseFile/Application/Case/Questionaire/SupportingWorkflowDialogSubmit.cfm">


<table width="98%" align="center">

<cfset vExisting=0>

<cfset itemNo = 0>

<cfoutput query="first">

		<cfquery name="second" datasource="AppsCaseFile">
			SELECT  *
			FROM    stQuestionaireTopic
			WHERE   TopicCode = '#TopicCode#'
			AND     UserInput = 'Attach'
		</cfquery>
		
		<!--- show attachments for this tab --->

		<cfif second.recordcount neq 0>		
		
				<cfset claimId="#qClaim.ClaimId#">
				<cfset itemNo = itemNo + 1>
				<tr>
					 <td width="70">&nbsp;&nbsp;&nbsp;#itemNo#.</td>
		    	     <td><font face="Verdana" size="2" color="6688aa"><b>#Second.FormLabel#</td>
				</tr>
	         
				<cfif Second.FormNote neq "">
					<tr><td height="4"></td></tr>
				    <tr><td></td>
				 		<td width="95%"><font size="1" face="Verdana">#Second.FormNote#</td>
					</tr>
				</cfif>   
		
				<tr><td height="5"></td></tr>
											 				
				<tr>
				    
					<td width="200"></td>
					<td>	
																						
							<cfset box = "d_#currentrow#">
							
								<cf_filelibraryN
								DocumentPath  = "InsuranceClaim"
								SubDirectory  = "#claimid#" 
								Filter        = "#Second.TopicCode#"						
								LoadScript    = "0"		
								Width         = "98%"
								Box           = "#box#"
								Insert        = "yes"
								Remove        = "yes">												
										
					</td>
					
				</tr>
				 
				<tr><td height="5"></td></tr>

				<cfset vExisting=1>
			
		</cfif>

</cfoutput>


<cfif vExisting eq 0>
		<tr><td height="250" align="center">
			 	<font color="808080">There are no specific documents required for this entitlement to be attached in this step.
		</td></tr>
</cfif>
		
	
</table>	
