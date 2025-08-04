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
<cfoutput>
<cfquery name="System" 
datasource="AppsSystem">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemModule   = 'Portal'
	AND    FunctionClass  = 'SelfService'
	AND    FunctionName   = '#URL.ID#' 
</cfquery>

<cfparam name="URL.PersonNo" default="#client.PersonNo#">

<link href="#SESSION.root#/print.css" rel="stylesheet" type="text/css" media="print">

<link rel="stylesheet" 
      type="text/css" 
	  href="#SESSION.root#/<cfoutput>#client.style#</cfoutput>">
	  

<cfif Client.googlemap eq "1">
   <cfajaximport tags="cfmap" params="#{googlemapkey='#client.googlemapid#'}#">
</cfif>	  	  
	  
<cfajaximport tags="cfform,cftree,cfmenu,cftextarea,cfinput-datefield,cfinput-autosuggest">

<cfinclude template="ClaimDetailScript.cfm">	

<cf_dialogLedger>

<cf_ActionListingScript>
<cf_FileLibraryScript>
<cf_DetailsScript>

<cfset header1 = "002350">
<cfset header1Size = "2">

<cf_LoginTop FunctionName = "Insurance" graphic="No">

<table width="97%" align="center" height="94%" border="0" cellspacing="0" cellpadding="0">

<tr><td><cfinclude template="../CaseView/ClaimViewBanner.cfm"></td></tr>

<tr><td><cfinclude template="../../Claim/ControlOrganization/ClaimDetail.cfm"></td></tr>

<tr><td align="center"><table><tr><td align="center">
    <a href="javascript:ColdFusion.navigate('ClaimDetailPDF.cfm?claimid=#claimid#','pdf')"><cf_tl id="PDF version"></a>
		<img src="#Client.VirtualDir#/Images/pdf_button.png"
	     alt="PDF"
	     border="0"
	     align="absmiddle"
	     style="cursor: pointer;"
	     onClick="ColdFusion.navigate('ClaimDetailPDF.cfm?claimid=#claimid#','pdf')">
	</td>
	<td><cfdiv id="pdf"></td>
	</tr></table>
</td>
</tr>

<tr><td>

		<table width="97%" cellspacing="0" cellpadding="0" class="formpadding" align="center">
		
		<!--- --------------- --->
		<!--- memo            --->
		<!--- --------------- --->
							
		<cfif details.claimMemo neq "">
		
		    <cf_tl id="Briefs" var="1">
			<cfset tBriefs = "#Lt_text#">			
		
			<cf_ProcessActionTopic name="att0" 
	                       title="#tBriefs#"
						   click="maximize('att0')">
			
			<tr id="att0" class="hide">
			<td colspan="2">
							
					<table width="100%" bordercolor="silver" border="0" cellspacing="0" cellpadding="0" class="formpadding">
					<tr><td>#Details.ClaimMemo#</td></tr>
					</table>
			</td>
			</tr>	
				
		</cfif>	
		
		<!--- --------------- --->
		<!--- workflow        --->
		<!--- --------------- --->
		
		<cfif url.userclass eq "Actor">
		
		    <cf_tl id="Claim Status Workflow" var="1">
			<cfset tClaim = "#Lt_text#">		
		
			<cf_ProcessActionTopic name="action#Details.CaseNo#" 
	                       title="#tClaim#"
						   click="drill('action#Details.CaseNo#','#url.claimId#','action')">
						
			<!--- <tr><td height="1" colspan="2" bgcolor="silver">111</td></tr> --->
			<tr id="r#url.claimid#" class="hide" >
			<td colspan="2">
		
				<table width="100%" cellspacing="0" cellpadding="0" align="center">
				<tr><td>
				   				  				
					<cfdiv id="#url.claimid#"/>
					
					<input type="hidden" 
			  	   name="workflowlink_#url.claimid#" 
			  	   id="workflowlink_#url.claimid#" 				   
				   value="#SESSION.root#/CaseFile/Application/Claim/CaseView/DetailWorkflow.cfm">		
				
				</td></tr>
				</table>	
			
			</td></tr>	
			
		</cfif>
		
		<!--- --------------- --->
		<!--- attactments     --->
		<!--- --------------- --->
				
		
		<cfquery name="Object" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    OrganizationObject
				WHERE   ObjectKeyValue4 = '#URL.claimid#' 
				AND     Operational = 1 
			</cfquery>			
		
		<cfif url.userclass eq "Actor" or url.userclass eq "Underwriter">	
											
			<cfif Object.Recordcount eq "1">
	
			<cfquery name="External" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT   R.*			
		    FROM     Ref_EntityDocument R
		    WHERE    R.DocumentType  = 'Attach'
			AND      R.Operational   = 1
			AND      R.DocumentId IN (SELECT DocumentId 
			                          FROM OrganizationObjectDocument
									  WHERE ObjectId = '#Object.Objectid#'
									  AND Operational = 1) 
			ORDER BY DocumentOrder 
			</cfquery>			
				
			<cfloop query="External">	
			
			 <cf_filelibraryCheck
		    	DocumentURL   = "#EntityCode#"
				DocumentPath  = "#EntityCode#"
				SubDirectory  = "#Object.ObjectId#" 
				Filter        = "#DocumentCode#">	
				
				<cfif files gte "1">
				
					<cf_ProcessActionTopic name="att#currentrow#" 
		                 title="#DocumentDescription#"
						 click="attopen('att#currentrow#','#EntityCode#','#Object.ObjectId#','#DocumentCode#','att#currentrow#')">
										
					   <tr id="att#currentrow#" class="hide">
						<td></td>
						<td colspan="1" id="att#currentrow#_content"></td>
						</TR>
					
				</cfif>		
					
			</cfloop>
					
		</cfif>		
			
	</cfif>
	
	
	<!--- --------------- --->
	<!--- questionaire    --->
	<!--- --------------- --->
	
	<cfif url.userclass eq "Actor">	
	
	<cfquery name="Check" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     stQuestionaireContent
		WHERE    ClaimId = '#URL.ClaimId#'
	</cfquery>	
	
	<cfif check.recordcount gte "1">
	
	    <cf_tl id="Questionnaire" var="1">
		<cfset tQuest = "#Lt_text#">	
	
		<cf_ProcessActionTopic name="ilq0" 
	                title="#tQuest#"
				   click="maximize('ilq0')">
	
		
		<tr id="ilq0" class="hide">
		<td colspan="2">	
		<cfset url.mode = "read">
		<cfinclude template="../../../../Custom/Insight/Questionaire/Form.cfm">		
		</td></tr>	
		
		</cfif>
		
	</cfif>	
	
	<!---
	
	<!--- --------------- --->
	<!--- activity report --->
	<!--- --------------- --->
	
	<cfif url.userclass eq "Actor" or url.userclass eq "Underwriter">	
							
		<tr><td width="20">
								
			 <img src="#SESSION.root#/Images/expand5.gif" alt="Expand" 
		onMouseOver="document.act#Details.CaseNo#Exp.src='#SESSION.root#/Images/expand-over.gif'" 
		onMouseOut="document.act#Details.CaseNo#Exp.src='#SESSION.root#/Images/expand5.gif'"
		name="act#Details.CaseNo#Exp" border="0" class="regular" 
		align="absmiddle" style="cursor: pointer;"
		onClick="drill('act#Details.CaseNo#','#Object.ObjectId#','act','#url.userclass#')">
		
			<img src="#SESSION.root#/Images/collapse5.gif" 
		onMouseOver="document.act#Details.CaseNo#Min.src='#SESSION.root#/Images/collapse-over.gif'" 
		onMouseOut="document.act#Details.CaseNo#Min.src='#SESSION.root#/Images/collapse5.gif'"
		name="act#Details.CaseNo#Min" alt="Collapse" border="0" 
		align="absmiddle" class="hide" style="cursor: pointer;"
		onClick="drill('act#Details.CaseNo#','#Object.ObjectId#','act','#url.userclass#')">	
	
		</td>		
		<td width="90%">	
		<b><b><a href="javascript:drill('act#Details.CaseNo#','#Object.ObjectId#','activity','#url.userclass#')">
		Claim Status Report			
		</td>
		
		</tr>
		<tr><td height="1" colspan="2" bgcolor="silver"></td></tr>
		
		<tr id="ract#Object.ObjectId#" class="hide">
		<td colspan="2">				
		<cfdiv id="act#Object.ObjectId#"/>
		</td></tr>	
		
	</cfif>
	
	--->
	
	
	<!--- --------------- --->
	<!--- internal notes  --->
	<!--- --------------- --->
	
	
	<cfif url.userclass eq "Actor">	
		
	    <cf_tl id="Case file Notes" var="1">
		<cfset tCase = "#Lt_text#">			
		
		<cf_ProcessActionTopic name="note#Details.CaseNo#" 
	                title="#tCase#"
				   click="drill('note#Details.CaseNo#','#Object.ObjectId#','note','#url.userclass#')">
						
		<tr id="rnote#Object.ObjectId#" class="hide">
		<td colspan="2">				
		<cfdiv id="note#Object.ObjectId#"/>
		</td></tr>	
		
	</cfif>
	
	<!--- --------------- --->
	<!--- expenses        --->
	<!--- --------------- --->
	
	<cfif url.userclass eq "Actor" or url.userclass eq "Underwriter" or url.userclass eq "Broker">		
			
	    <cf_tl id="Claim Status and Handling Activities and Costs" var="1" class="Message">
 	    <cfset tHandling = "#Lt_text#">
		
		<cf_ProcessActionTopic name="expense#Details.CaseNo#" 
	       title="#tHandling#"
		   click="drill('expense#Details.CaseNo#','#Object.ObjectId#','expense','#url.userclass#')">
							
		<tr id="rexpense#Object.ObjectId#" class="hide">		
		<td colspan="2">				
		<cfdiv id="expense#Object.ObjectId#"/>					
		</td></tr>	
				
	</cfif>		
	
	<!--- --------------- --->
	<!--- invoice status  --->
	<!--- --------------- --->
	
	<cfif url.userclass eq "Actor" or url.userclass eq "Underwriter" or url.userclass eq "Broker">	

		   <cf_tl id="Payment Tracking" var="1">
		   <cfset tPayment = "#Lt_text#">	
		   					
			<cf_ProcessActionTopic name="fin0" 
	       title="#tPayment#"
		   click="maximize('fin0')">
												
			<tr id="fin0" class="hide">
			<td></td>
			<td>
												
			<cfif url.userclass eq "Actor">	
							
					<cf_LedgerObject
					Edit="0"
	    			ObjectId   = "#Object.ObjectId#">	
					
			<cfelse>
			
					<cf_LedgerObject
					Journal = "60001" 
					Edit="0"
	    			ObjectId   = "#Object.ObjectId#">	
			
			</cfif>				
									
			</td>
			</tr>			
										
	</cfif>		
	
	<!--- --------------- --->
	<!--- embedded docs   --->
	<!--- --------------- --->
			
	<cfif url.userclass eq "Actor" or url.userclass eq "Underwriter" or url.userclass eq "Broker">	
			 
		<cfquery name="Embedded" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT    P.ActionId, 
		             P.Created as Issued, 
					 R.*
	       FROM      OrganizationObjectActionReport P INNER JOIN
	                 Ref_EntityDocument R ON P.DocumentId = R.DocumentId
	       WHERE     P.ActionId IN
	                       (SELECT  ActionId
	                        FROM    OrganizationObjectAction
					    	WHERE   ObjectId = '#Object.ObjectId#')  
		   AND      R.PortalShow = 1					
		   ORDER BY DocumentOrder, P.Created DESC					
		</cfquery>
		
		<cfset ord = "0">
		
		
		<cfloop query="Embedded">	
			
			<!--- added provision to show only the last prelim invoice --->
		
			<cfif ord neq DocumentOrder>
			
				<cfset ord = DocumentOrder>			
				
				<cf_ProcessActionTopic name="doc#currentrow#" 
			       title="#DocumentDescription#</b> (dd: #dateformat(issued,CLIENT.DateFormatShow)#)"
				   click="maximize('doc#currentrow#')">		
						
					<tr id="doc#currentrow#" class="hide"><td colspan="2">
					<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
					<tr><td colspan="2" height="300">
					
			   			 <iframe src="EmbedDocument.cfm?objectid=#object.ObjectId#&documentid=#documentid#&actionid=#actionid#"
			   			         width="100%"
			   			         height="100%"
			   			         scrolling="no"
			   			         frameborder="0">
						 </iframe>
				
						
						</td></tr>
					</table>
					</td>
					</TR>
					
			 </cfif>	
				
		</cfloop>
	
	    </table>	
									
	</td></tr>
	
	</cfif>
		
</table>

<cf_LoginBottom FunctionName = "Insurance">	
</cfoutput>	 
