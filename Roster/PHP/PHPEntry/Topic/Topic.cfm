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
<cfparam name="url.animationDelay"   	default="600">  <!--- Kristhian --->
<cfparam name="url.TextAreaType" 		default="CK">

<cf_screentop html="No" jquery="yes">

<cf_TextAreaScript>
<cf_PresentationScript>
<cf_dialogstaffing>
<cf_filelibraryscript mode="standard">
	
<cfajaximport>

<style>
	.clear { clear:both; }
	html, body {  <!--- Kristhian --->
		margin:0 !important;
		padding:0 !important;
	}
</style>


<cfparam name="URL.EntryScope"   default="Profile">
<cfparam name="URL.ApplicantNo"  default="">
<cfparam name="URL.ID"           default="">
<cfparam name="URL.Section"      default="">  <!--- section of the navigation framework --->
<cfparam name="URL.Mission"      default="">

<cfif trim(url.ApplicantNo) eq "" AND isDefined("client.ApplicantNo")>
	<cfset url.ApplicantNo = client.ApplicantNo>
</cfif>

<cfquery name="Section" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ApplicantSection
	WHERE    Code = '#URL.Section#' 
</cfquery>

<cfquery name="getAssignedCandidacy" <!--- Kristhian --->
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  AF.*, F.FunctionDescription, R.Meaning AS StatusDescription
		FROM    ApplicantFunction AF 
				INNER JOIN FunctionOrganization FO ON AF.FunctionId = FO.FunctionId 
				INNER JOIN FunctionTitle F ON FO.FunctionNo = F.FunctionNo
				INNER JOIN Ref_StatusCode R ON AF.Status = R.Status 
				INNER JOIN Ref_SubmissionEdition S ON FO.SubmissionEdition = S.SubmissionEdition AND R.Owner = S.Owner
		WHERE   R.Id = 'FUN'
		AND		AF.Source = 'Assignment'
		AND     AF.ApplicantNo = '#client.applicantNo#'
</cfquery>

<cfparam name="URL.Code"      	       default="">
<cfparam name="URL.Source"    	       default="">  <!--- PHP source to filter on the topics like we do for the parent --->
<cfparam name="URL.Parent"    	       default="#section.TemplateCondition#">  <!--- parent of the topics to be shown --->
<cfparam name="URL.Owner"     	       default="Sysadmin">  <!--- owner to filter on topics based on the context of this portal --->
<cfparam name="URL.SubmissionEdition"  default=""> 

<cfif url.entryscope eq "Profile">

	<cfset vHelpImage = "Images/info1_green.png">
	<cfinclude template="../NavigationCheck.cfm">
	
</cfif>	

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Parameter
</cfquery>

<cfif url.applicantNo eq "">

	<cfquery name="Check"
	   datasource="AppsSelection"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
         SELECT   * 
         FROM     ApplicantSubmission 
	  	 WHERE    PersonNo = '#URL.Id#'
		 <cfif url.source neq "">
		 AND      Source = '#url.source#' 
		 </cfif>
		 <cfif url.submissionedition neq "">
		 AND      SubmissionEdition = '#url.submissionedition#' 
		 </cfif>
		 ORDER BY Created
	</cfquery>	
			
	<cfset url.applicantno = check.applicantNo>
	<cfset source          = check.source>

<cfelse>
	
	<cfquery name="Check"
	   datasource="AppsSelection"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
         SELECT * 
         FROM   ApplicantSubmission 
	  	 WHERE  ApplicantNo = '#URL.ApplicantNo#'
	</cfquery>	
		
	<cfset source = check.source>
	
</cfif>

<cfif source eq "">
	 <cfset source = Parameter.PHPSource>
</cfif>

<cfif check.actionStatus eq "0">
	<cfset edit = "edit">
<cfelse>
	<cfset edit = "view">	
</cfif>

<cfoutput>
	
	<script language="JavaScript">			
   
			function toggle(parent,entry) {
				ptoken.navigate("#SESSION.root#/tools/process/roster/topic/TopicEntry.cfm?ApplicantNo=#URL.ApplicantNo#"+"&Mode=embedded"+"&Topic="+entry,parent);
			}
			
			function showtopiccode(topic,initial,selected) {  <!--- kristhian --->
			
			    if (document.getElementById('codebox')) {
					_cf_loadingtexthtml='';		
					$('##tiptopiccode').hide();			
					window['_topicCB'] = function(){
						$('##tiptopiccode').fadeIn(#url.animationDelay#);
					};						
					if (selected) {
				        ptoken.navigate('#SESSION.root#/tools/process/roster/topic/TopicExplanation.cfm?code='+topic+'&listcode='+selected,'tiptopiccode', '_topicCB', null, null, null);
					} else {		
					    ptoken.navigate('#SESSION.root#/tools/process/roster/topic/TopicExplanation.cfm?code='+topic+'&listcode='+initial,'tiptopiccode', '_topicCB', null, null, null);
					}				
				}
			} 
							
			function showtopic(topic,listcode) {					    
				setProsisHelp('#SESSION.root#/tools/process/roster/topic/TopicHelp.cfm?code='+topic+'&listCode='+listcode, function() {showProsisHelp()} )				
			}
			
			function toggleTopicHelp(t) {
				$('.topicHelp_' + t).toggle();
			}
			
			function toggleTopicHelpGroup(selector) {
				if ($(selector).first().is(':visible')) {
					$(selector).hide();
				} else {
					$(selector).show();
				}
			}
			
			function showTopicHelp(t) {
				$('.topicHelp_' + t).show();
			}	

			function formvalidate() {  
				parent.Prosis.busy('yes');
				document.frmtopic.onsubmit();
				if (_CF_error_messages.length == 0 ) { 
					ColdFusion.navigate('#session.root#/Roster/PHP/PHPEntry/Topic/TopicSubmit.cfm?ts=#getTickCount()#&Mission=#URL.Mission#&entryscope=#url.entryscope#&Code=#URL.Code#&Section=#URL.Section#&ApplicantNo=#URL.ApplicantNo#&parent=#url.parent#&Source=#source#&owner=#url.owner#&TextAreaType=#url.TextAreaType#','topicprocess', function(){
						parent.Prosis.busy('no');
					}, null, 'POST', 'frmtopic');
					return true;
				 } 	 	 
				 return false;  
			}
			
									 
	</script>
	
</cfoutput>		

<cf_LayoutScript>

<div id="topicprocess" style="display:none;"></div>
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cfif url.entryscope eq "Profile">
	<cfset onsubmit = "parent.Prosis.busy('yes');">
<cfelse>
	<cfset onsubmit = "Prosis.busy('yes');">
</cfif>

<cfform style="height:100%; width:100%;" onsubmit="#onsubmit# return false" id="frmtopic" name="frmtopic">			

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea position="center" name="box">	
	   
						
				<table width="100%" height="100%" align="center">
					
					<tr><td valign="top" colspan="2" height="100%"> 
																		    
						<cf_divscroll>					
										
						<table width="100%" height="100%" align="center">
						
						<cfif url.entryscope eq "Profile">															
						
							<tr><td colspan="2"><cf_navigation_header1 toggle="Yes"></td></tr>									
						
						</cfif>						
						
						<cfquery name="getApplicableSkills" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  DISTINCT FRT.Topic
							FROM    FunctionRequirementLineTopic FRT INNER JOIN
							        FunctionRequirement FR ON FRT.RequirementId = FR.RequirementId INNER JOIN
							        FunctionOrganization FO ON FR.FunctionNo = FO.FunctionNo AND FR.GradeDeployment = FO.GradeDeployment INNER JOIN
							        ApplicantFunction AF ON FO.FunctionId = AF.FunctionId 
							WHERE   AF.ApplicantNo = '#url.ApplicantNo#'
							AND     FRT.Topic IN (SELECT Topic 
							                      FROM   Ref_Topic R INNER JOIN Ref_ExperienceParent S ON R.Parent = S.Parent 
												  WHERE  Area = 'Skills' 
												  AND    R.Parent = '#url.parent#')
						</cfquery>		
									
												
						<cfquery name="Master" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
												
						     SELECT *
							 FROM (
							 
						 	  SELECT   C.ListingOrder as ClassOrder,
							           C.Description as ClassDescription,
									   C.Tooltip as ClassTooltip,
									   C.ListingMode,
									   (
									   SELECT ListCode
									   FROM   ApplicantSubmissionTopic
									   WHERE  ApplicantNo = '#url.ApplicantNo#'
									   AND    Topic       = R.Topic ) as ListCode,
									   <cfif getAssignedCandidacy.recordcount neq 0>
									   (
									   	SELECT	RTx.Topic
										FROM	FunctionRequirementLineTopic RTx
												INNER JOIN FunctionRequirement Rx
													ON RTx.RequirementId = Rx.RequirementId
												INNER JOIN FunctionOrganization Ox
													ON Rx.FunctionNo = Ox.FunctionNo
										WHERE	Ox.FunctionId = '#getAssignedCandidacy.functionid#'
										AND 	RTx.Topic = R.Topic
									   ) 
									   <cfelse>
									   		''
									   </cfif> 
									   as isAssignmentTopic,
									   
									   R.*
									   
							  FROM     #CLIENT.LanPrefix#Ref_Topic R LEFT OUTER JOIN 
							           #CLIENT.LanPrefix#Ref_TopicClass C ON R.TopicClass = C.TopicClass				  
							  
							  WHERE    R.Operational = 1
							  
							  <!--- passed from the section tab --->
							  AND      R.Parent   = '#url.parent#'  
							  <!--- passed from the application submission record --->
							  AND      R.Source   = '#source#'		
							  <!--- filtering based on the owner --->
							  <!--- not aplied yet ---> 						  
							  <cfif getApplicableSkills.recordcount gte "1">						  
							  AND    R.Topic IN (#quotedvalueList(getApplicableSkills.Topic)#)						  
							  </cfif>
													  				  
							  ) as T
							  
							  ORDER BY T.ClassOrder, T.ListingOrder, T.Description

						</cfquery>							

						<cfquery name="getMaster" dbtype="query">
						SELECT DISTINCT Classorder FROM Master
						</cfquery>
																									
						<cfif Master.recordcount eq "0">						
							<tr><td align="center" style="height:40" class="labelmedium"><cf_tl id="No additional questions defined"></td></tr>						
						</cfif>
							
						<cfset row = 0>
						
						<cf_calendarscript>
																										
						<tr>
						  <td height="100%" valign="top" style="padding-left:20px;padding-top:6px;padding-right:20px">
						
						  <table width="100%" 						     						 
							  navigationselected="fafafa" 
							  navigationhover="transparent" 
							  class="navigation_table">
				  				
								<tr>
									<td colspan="6">	
	
								    <cfinvoke component = "Service.Presentation.TableFilter"  
						                  method           = "tablefilterfield" 
						                  filtermode       = "direct"
										  label            = "Find"
						                  name             = "filtersearch"
						                  style            = "font:15px;height:30px;width:115px;padding:4px;"
						                  rowclass         = "clsTopicRow"
						                  rowfields        = "ccontent">
																						  					
									</td>	
								</tr>
										
								<cfset showleft=false>
								
								<cfset prior = "">
								
								<cfset cntRow = 0>				
								
				
								<cfoutput query="Master" group="ClassOrder">
								
									 <cfif getMaster.recordcount gte "2">
															
										  <cfif ClassDescription neq "">
										  
										     <tr class="clsTopicRow">
											 <td colspan="6">
											 
												 <table width="100%" border="0">
											     <tr>
												 <cf_tl id="Click to toggle all help" var="1">
												 <td colspan="8" 
													class="labellarge" 
													onclick="$('.topicClass_#topicClass#').toggle();"
													style="font-size:26px; padding-top:7px; padding-bottom:5x; cursor:pointer;"
													title="#lt_text#">
														<table>
															<tr><td valign="middle" style="padding-top:8px;"></td>
																<td class="labellarge" valign="bottom" style="padding-left:8px; font-size:35px;">
																<b>#ClassDescription# #ClassTooltip#</b>
																</td>
															</tr>
														</table>
												 </td>
												 </tr>
												 </table>
												 									  
											  </td>
											  </tr>
											  
											  <cfset cntRow = 0>
											  
											</cfif> 
										
									   </cfif>	
									  										  
									<cfoutput>
									  
									  	  <cfif ListingMode eq "1" and prior neq description>
										  
										    <tr><td height="20"></td></tr>
										 
										    <tr class="clsTopicRow topicClass_#topicClass#"> 									  	
											  <td colspan="8" style="font-family:Helvetica Neue, Helvetica, Arial, sans-serif;background-color:eaeaea;height:40px;padding-top:15px;padding-bottom:10px;font-size:24px;padding-left:40px;cursor:pointer;"
												width="40%" class="labelmedium ccontent"><font color="0080C0">#ucase(Description)#</td></tr>
												
											 <tr><td height="10"></td></tr>	
												
											<cfset cntRow = 0>
										  							  
										  </cfif>
										  									  	 		
										  <cfif valueClass eq "List">	
										  
										  	    <cfset cntRow = cntRow + 1>	 	
											  
											   <tr class="navigation_row clsTopicRow topicClass_#topicClass#"> 	
										  
												  <td style="height:26px;padding-left:4px;padding-top:2px" class="navigation_pointer"></td>										  	  		
												  <td class="labelit" align="right" style="width:20px;padding-right:5px;padding-top:5px" valign="top">#cntRow#.</td>									
												  <td class="hide" width="1%" class="ccontent">#Description# </td>	
																					  	
												  <!--- show help and show right inspection --->												  
												  											  
												  <cfif len(Tooltip) gte "4">
												  <td style="padding-top:3px;padding-right:4px; padding-top:7px width:16px;" 
												  onclick="toggleTopicHelp('#topic#');" valign="top"><img src="#session.root#/Images/info1_green.png" alt="" width="16" height="16" border="0"></td> <!--- kristhian --->
												  <cfelse>
												  <td style="width:16px;"></td>
												  </cfif>
												  
												  <cfset vAssignmentHighlight = "">
												  <cfset vAssignmentTitle = "">
												  <cfif isAssignmentTopic eq topic>
												  	<cfset vAssignmentHighlight = "color:##1C8CD6; font-weight:bold;">
													<cf_tl id="This skill is related to your current assignment" var="1">
													<cfset vAssignmentTitle = lt_text>
												  </cfif>
												  														  				  
												  <td width="50%"
												    class="labelit ccontent action fixlength" 
													onclick="showtopiccode('#topic#','#listcode#',document.getElementById('Value_#topic#_selected').value); toggleTopicHelp('#topic#');"
													title="#vAssignmentTitle#"
													valign="top"
												    style="font-family:Helvetica Neue, Helvetica, Arial, sans-serif;font-size:14px;padding-top:4px;height:14px; #vAssignmentHighlight#" align="left">#Question# <cfif ValueObligatory eq "1"><font color="D90000">*</font></cfif>
												  </td>			
												  
												  <td style="width:600px;padding-left:4px;padding-right:5px;padding-top:1px;" valign="top">
											  																												  										  										
												   <cf_TopicEntry 
												       Mode="#edit#"									   
												       ApplicantNo="#URL.ApplicantNo#" 
													   Attachment="#Attachment#"
													   Tooltip="1"												   
											           Topic="#Topic#">
																										   										
												  </td>		
												  
												  </tr>
												  
											  <cfelseif valueClass eq "Memo">		
											  
											  	 <tr class="navigation_row clsTopicRow topicClass_#topicClass#" style="padding-top:5px;" valign="top"> 								  
											  	  <td style="height:30px;padding-left:4px;padding-top:3px" class="navigation_pointer" valign="top"></td>										  	  		
												  <td class="labelit" align="right" style="width:20px;padding-right:5px;padding-top:2px;padding-top:3px;" valign="top"></td>									
												  <td class="hide" width="1%" class="ccontent" valign="top" style="padding-top:3px;">#Description#</td>										  										  										  
											      
												  <cfif len(Tooltip) gte "4">
											  	  <td style="padding-top:3px;padding-right:4px; width:16px;" onclick="toggleTopicHelp('#topic#');" valign="top"><img src="#session.root#/#vHelpImage#" style="height:16px;"></td>  											 	
												  <cfelse>
												  <td style="width:16px;"></td>
												  </cfif>										  
												  
												  <td colspan="2" class="labelit ccontent navigation_action" 
												      style="font-size:15px;padding-top:2px;height:14px" align="left" valign="top">#Question# <cfif ValueObligatory eq "1"><font color="D90000">*</font></cfif>
												  </td>													  
												 
												 </tr>
												  
												 <tr class="clsTopicRow topicClass_#topicClass#">
												  <td></td>
												  <td colspan="5" style="width:100%;padding-left:20px;padding-right:30px">
												  											  
												    <cf_TopicEntry 
												       Mode="#edit#"									   
												       ApplicantNo="#URL.ApplicantNo#" 
													   Attachment="#Attachment#"
													   Tooltip="1"														   
											           Topic="#Topic#">
												  
												  </td>
												  
												  </tr>												     
											  
											  <cfelse>
											  
											  	 <cfset cntRow = cntRow + 1>	 	
											  
											  	 <tr class="navigation_row clsTopicRow topicClass_#topicClass#"> 	
										  
											     <td style="height:30px;padding-left:4px;padding-top:4px" class="navigation_pointer" valign="top"></td>										  	  		
											     <td class="labelit" align="right" style="width:20px;padding-right:5px;padding-top:2px; padding-top:3px;" valign="top">#cntRow#.</td>									
											     <td class="hide" width="1%" class="ccontent" valign="top" style="padding-top:4px;">#Description#</td>	
											  										  
											     <cfif len(Tooltip) gte "4">
											  	  <td style="padding-top:3px;padding-right:4px; width:16px;" onclick="toggleTopicHelp('#topic#');" valign="top"><img src="#session.root#/#vHelpImage#" style="height:15px;"></td>  											 	
												 <cfelse>
												  <td style="width:16px;"></td>
												 </cfif>
											  
												 <td class="labelit ccontent navigation_action" 
												    style="font-size:15px;padding-top:2px;height:14px" align="left" valign="top">#Question# <cfif ValueObligatory eq "1"><font color="D90000">*</font></cfif>
												 </td>		
												  
												  <td style="width:600px;padding-left:4px;padding-right:5px;padding-top:2px;" valign="top">
											  										  										  										
												   <cf_TopicEntry 
												       Mode="#edit#"									   
												       ApplicantNo="#URL.ApplicantNo#" 
													   Attachment="#Attachment#"
													   Tooltip="1"												   
											           Topic="#Topic#">
											
												  </td>												  
																				 
											  </tr>						  
												  										  
										  </cfif>																
										  
										  <cfif QuestionCondition neq "">
											  
											  <tr class="topicClass_#topicClass#">
												  <td></td>
												  <td class="labelmedium" colspan="5"><b>Note:&nbsp;</b>#QuestionCondition#</i></td>
											  </tr>
											  
										  </cfif>
										  
										  <cfif len(Tooltip) gte "4">
										  	  <tr class="clsTopicRow topicHelp_#topic# topicHelpClass_#topicClass# topicClass_#topicClass#" 
											      style="display:none;">
												  <td colspan="3"></td>
												  <td class="labelmedium" colspan="5" style="color:##828282;">#topicLabel#: #Tooltip#</td>
											  </tr>
										  </cfif>
									  							  
									  <cfset prior = description>			  
								 						  
									</cfoutput>	
									
									<tr class="clsTopicRow"><td height="5"></td></tr>
									<tr class="clsTopicRow"><td class="linedotted" colspan="8"></td></tr>
									<tr class="clsTopicRow"><td height="15"></td></tr>
													  		  
							    </cfoutput>		  
									 								
						  </table>
								
						  </td>					 
						 			  
						</tr>	
												
						</table>						
									
						</cf_divscroll>
																
						
					</td>					
							 
					</tr>
									
											
					
												 
				</table>
							
    </cf_layoutarea>	
					
	<cfparam name="section.Templatecflayout" default="1">	
		  
	<cfif (section.Templatecflayout eq "1" or url.entryscope eq "Portal") and edit eq "edit">
		
		<cf_layoutarea 
			    position    = "top" 
				name        = "tipbox" 
				maxsize     = "30%" 		
				size        = "30%" 
				minsize     = "30%"
				collapsible = "false" 
				initcollapsed="true"
				splitter    = "true"
				overflow    = "scroll">		
				
						   
					<table width="99%" height="100%" align="center">
																
						<tr>
						<td valign="top" height="100%" align="center" style="padding-top:6px">
							<cf_divscroll id="tiptopic"></cf_divscroll>
						</td>
						</tr>
					
					</table>						
						
		</cf_layoutarea>

		<cf_layoutarea 
			    position    = "right" 
				name        = "codebox" 
				maxsize     = "470" 		
				size        = "470" 
				minsize     = "470"
				collapsible = "true" 
				splitter    = "true"
				overflow    = "scroll">			
																		   
					<table width="100%" height="100%" align="center">
														
						<tr>
						<td valign="top" width="100%" height="100%" align="center">
							<cf_divscroll id="tiptopiccode"></cf_divscroll>
						</td>
						</tr>
					
					</table>						
						
		</cf_layoutarea>
		
		</cfif>
		
		<cf_layoutarea 
			    position    = "bottom" 
				name        = "bottombox" 
				maxsize     = "40" 		
				size        = "40" 
				minsize     = "40"
				collapsible = "false" 
				splitter    = "true">
				
				<table width="100%">
								
				<cfif url.entryscope eq "Profile">	
						
						<tr><td height="20" colspan="2" valign="top">									
							
								 <cfparam name="URL.Next" default="Default">
								 <cfparam name="URL.ID" default="">
								 <cfinclude template="../NavigationSet.cfm">
								  
								 <cfif Section.Obligatory eq "1">
										
										<cfquery name="Check" 
											datasource="appsSelection" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											SELECT COUNT(1) AS TOTAL
											FROM   ApplicantSubmissionTopic				
											WHERE  ApplicantNo = '#URL.ApplicantNo#'
											AND    Source      = '#source#'
										</cfquery>
										
								 </cfif>
								
							   <cf_Navigation
									 Alias         = "AppsSelection"
									 TableName     = "ApplicantSubmission"
									 Object        = "Applicant"
									 ObjectId      = "No"
									 Section       = "#URL.Section#"
									 SectionTable  = "Ref_ApplicantSection"
									 Id            = "#URL.ApplicantNo#"
									 Owner         = "#url.owner#"
									 BackEnable    = "#BackEnable#"
									 BackName	   = "<span>Previous</span>"
									 HomeEnable    = "0"
									 ResetEnable   = "0"
									 ResetDelete   = "0"	
									 ProcessEnable = "0"
									 NextEnable    = "#NextEnable#"
									 NextName	   = "Save and Continue"
									 NextScript	   = "formvalidate()"							 
									 NextSubmit    = "0"										
									 ButtonWidth   = "165px"				 
									 SetNext       = "0"
									 NextMode      = "#setNext#"
									 IconWidth 	   = "32"
									 IconHeight	   = "32">
							 
						</td>
						</tr> 
												
					<cfelse>
						
						<tr><td colspan="2" align="center" style="padding-top:5px">
							<cf_tl id="Save" var="1">
							<cfoutput>
						    <input type="button" onclick="formvalidate()" name="Submit" class="button10g" value="#lt_text#" style="width:120px">
							</cfoutput>
						</td></tr>							
											
					</cfif>
					
					</table>
					
		</cf_layoutarea>
			

</cf_layout>

</cfform>
