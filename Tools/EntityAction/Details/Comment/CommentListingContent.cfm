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

<cf_param name="url.objectid" default="47939CF6-CF9B-8A52-AFB7-4CBAE9DB7C63" type="String">
<cf_param name="url.threadid" default="47939CF6-CF9B-8A52-AFB7-4CBAE9DB7C63" type="String">
<cf_param name="url.serialno" default="1" type="String">

<cf_param name="url.ajax" default="">

<cfif url.objectid neq "">

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       OrganizationObject
	WHERE      ObjectId = '#URL.Objectid#'
</cfquery>

<cfquery name="Related" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     ObjectId
	FROM       OrganizationObject
	WHERE      EntityCode = '#Object.EntityCode#'
	<cfif Object.ObjectKeyValue1 neq "">
	AND        ObjectKeyValue1 = '#Object.ObjectKeyValue1#' 
	</cfif>
	<cfif Object.ObjectKeyValue2 neq "">
	AND        ObjectKeyValue2 = '#Object.ObjectKeyValue2#' 
	</cfif>
	<cfif Object.ObjectKeyValue3 neq "">
	AND        ObjectKeyValue3 = '#Object.ObjectKeyValue3#' 
	</cfif>
	<cfif Object.ObjectKeyValue4 neq "">
	AND        ObjectKeyValue4 = '#Object.ObjectKeyValue4#' 
	</cfif>	
</cfquery>

<cfquery name="Get" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       OrganizationObjectActionMail M
	<cfif Related.recordcount gte "1">
	WHERE      ObjectId IN (#quotedvalueList(Related.ObjectId)#)
	<cfelse>
	WHERE      1=0
	</cfif>
	AND        MailType = 'Comment'
	<cfif getAdministrator("*") eq "0">
	AND        MailScope = 'All'
	</cfif>
	<!---
	WHERE      ThreadId  = '#URL.ThreadId#'
	AND        SerialNo >= '#URL.SerialNo#'
	--->
	ORDER BY SerialNo 
</cfquery>

<table style="width:97%" class="navigation_table">

	<cfif get.recordcount eq "0">
	
	<tr><td align="center" style="padding-top:20px" class="labelmedium"><font color="808080"><cf_tl id="No information found to show in this view"></font></td></tr>
	
	</cfif>
	
	<cfset prior = "">
	
	<cfoutput query="Get">
	
		<cfif prior neq dateformat(MailDate,CLIENT.DateFormatShow)>
		
		<tr class="labelmedium2 line"><td style="font-size:13px">#dateformat(MailDate,"DDD")# #dateformat(MailDate,CLIENT.DateFormatShow)#</td></tr>
		
		</cfif>
		
		<cfset prior = dateformat(MailDate,CLIENT.DateFormatShow)>
		
		<tr class="navigation_row clsFilterRow clsFilterRow_#currentrow#">
			<td>
				<table border="0" width="100%" align="center" class="formpadding formspacing"> 
				
					<tr class="clsRow_#currentrow#">
					    <!---
						<td class="labelit" valign="top" width="50" style="padding-top:5px;padding-left:14px;padding-right:10px"><font color="0080C0">#currentrow#.<font color="0080C0"></b></td>
						--->
					    <td width="95%" style="padding-left:4px;padding-bottom:1px">
						 
							 <table style="width:100%">
							 <tr>
							 
							    <!--- Picture --->
								
							 	<td style="width:35px">
								
								    <cfif session.acc neq OfficerUserId>	
									
									<cfif not FileExists("#session.rootdocumentpath#\EmployeePhoto\#OfficerUserId#.jpg")>
									
										<cfset vEmpPhotoPath = "#session.root#/images/logos/no-picture-male.png">	
									
									<cfelse>
																		
											<cffile action="COPY" 
												source="#SESSION.rootDocumentpath#\EmployeePhoto\#OfficerUserId#.jpg" 
									  	    	destination="#SESSION.rootPath#\CFRStage\EmployeePhoto\#OfficerUserId#.jpg" nameconflict="OVERWRITE">
									
										<cfset vEmpPhotoPath = "#session.root#/CFRStage/EmployeePhoto/#OfficerUserId#.jpg">									
										
									</cfif>								
									
									<img src="#vEmpPhotoPath#" title="#OfficerFirstName# #OfficerLastName#" style="border-radius:20px;border:1px solid gray;height:30px;" align="absmiddle">
									
									</cfif>
									
								</td>
								
								<!--- name --->
																
								<td style="padding-left:2px;">
									<table width="100%">
										<tr>
											<td style="padding-right:4px">
											<table width="100%">
												<tr class="fixlengthlist">
												<td align="<cfif officerUserId eq session.acc>right<cfelse>left</cfif>" style="border-radius:5px;padding-left:4px;height:20px;background-color:<cfif officerUserId eq session.acc>##E0F9FE<cfelse>##fffff</cfif>" class="labelmedium ccontent">

												<table>
																									
												 <cfif session.acc eq OfficerUserId>		
												 
													  <td style="padding-top:2px" align="right">
													   	  <cf_img icon="delete" onclick="ptoken.navigate('#session.root#/Tools/EntityAction/Details/Comment/CommentDelete.cfm?objectid=#objectid#&threadid=#threadid#&serialno=#serialno#','process')">
													  </td>		
													 
													  <cfif getAdministrator("*") eq "1">												   
													 											 
															<td style="padding-top:1px;cursor:pointer;font-size:11px" 
															  id="box_#threadid#_#serialno#" 
															  onclick="ptoken.navigate('#session.root#/Tools/EntityAction/Details/Comment/setComment.cfm?objectid=#objectid#&threadid=#threadid#&serialno=#serialno#&field=mailscope&value='+document.getElementById('mailscope_#threadid#_#serialno#').value,'box_#threadid#_#serialno#')" 
															  class="ccontent">
															  <cfif MailScope eq "All">
															  <img src="#session.root#/images/logos/system/public.png" style="height:17px" alt="" border="0">															  
															  <cfelse><cf_tl id="support"></cfif>
															
																<cfif MailScope eq "All">
																	<input type="hidden" id="mailscope_#threadid#_#serialno#" value="support">
																<cfelse>
																	<input type="hidden" id="mailscope_#threadid#_#serialno#" value="all">
																</cfif>				
																										   
														   </td>
														   
													   </cfif>								   
												   
												 </cfif>												
												
  												   <td style="font-size:11px" class="labelit"><cfif officerUserId neq session.acc><b>#OfficerFirstName# #OfficerLastName#</b></cfif><cfif dateformat(now(),client.dateformatshow) neq Dateformat(MailDate,client.dateformatshow)>#Dateformat(MailDate,"dd/mm/yy")#</cfif> #TimeFormat(MailDate,"HH:MM")#
												   
												   </td>
												   </tr>
												   </table>

												</td>												
												
												 </tr>
											</table>										
											</td>
										</tr>
										
										<!--- body --->
						
										<cfset vPriorityColor = "">
										<cfif get.Priority eq "1">
											<cfset vPriorityColor = "color:##FF0000;">
										</cfif>
										<cfset vMaxChars = 100>
											
										<tr class="clsRow_#currentrow#">
																	
											<td valign="top" style="padding-right:15px" class="ccontent">
																	
												<table width="98%" border="0" align="center">
												
													<input type="Hidden" value="1" id="commentListingMailBodyToggler_#currentrow#">
													<cfset vMailBody = replace(Get.MailBody,"<strong>","<b>","ALL")>
													<cfset vMailBody = replace(vMailBody,"</strong>","</b>","ALL")>
													<cfset vMailBody = replace(vMailBody,"<em>","<i>","ALL")>
													<cfset vMailBody = replace(vMailBody,"</em>","</i>","ALL")>
													<div id="commentListingMailBodyContent_#currentrow#" style="display:none;">#vMailBody#</div>
													
													<tr>			
																				
																																									
														<td valign="top" class="ccontent" id="commentListingMailBodyContainer_#currentrow#" 
														 style="padding:1px;border:1px solid d1d1d1;#vPriorityColor#;padding-left:5px">
																								
															<div style="font-size:13px;color:<cfif officerUserId eq session.acc>black<cfelse>black</cfif>">#left(vMailBody,vMaxChars)# <cfif len(get.mailBody) gt vMaxChars>...</cfif></div>
															
															<cfif len(get.mailBody) gt vMaxChars>
																<cf_tl id="more" var="1">
																<a id="commentListingMailBodyTwistie_#currentrow#" style="font-size:10px;<cfif officerUserId eq session.acc>color:white</cfif>"													
																	onclick="toggleCommentLength('##commentListingMailBodyContent_#currentrow#','##commentListingMailBodyContainer_#currentrow#','##commentListingMailBodyToggler_#currentrow#','##commentListingMailBodyTwistie_#currentrow#',#vMaxChars#);"> 
																	 #lt_text#
																</a>
															</cfif>
														</td>
													</tr>
												</table>
											</td>
										</tr>	
																				
									</table>
								</td>
							 </tr>
							 </table>
						 
						 </td>
						 </tr>
						 
						 <cfquery name="Attachment" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT    *
						    FROM      System.dbo.Ref_Attachment
							WHERE     DocumentPathName = '#Object.entitycode#'	
						</cfquery>
						 
						 <!--- attachment --->			
						 <cfif attachment.recordcount eq "1">
						    <cfset DocumentHost = Attachment.DocumentFileServerRoot>							 
						<cfelse>
							<cfset DocumentHost = SESSION.rootDocumentPath>							
						</cfif>		
																		
						<cfif right(DocumentHost,1) eq "\">
							<cfset documentHost = left(DocumentHost,len(documentHost)-1)>
						</cfif>
						
						<cfif right(DocumentHost,1) eq "\">
							<cfset documentHost = left(DocumentHost,len(documentHost)-1)>
						</cfif>
						
						<cfdirectory action="LIST"
				             directory="#documentHost#\#object.entitycode#\#attachmentid#"
				             name="GetFiles"
				             filter="*.*"
				             sort="DateLastModified DESC"
				             type="file"
				             listinfo="name">
							
						<cfif getfiles.recordcount gte "1">
																							
							<tr class="clsRow_#currentrow# line" style="border-top:1px solid silver">
							  
							   <td style="padding-left:10px">
							       <table cellspacing="0" cellpadding="0">
								   <tr class="labelmedium">
								  
							       <cfloop query="getfiles">	
								   
								   <cfinvoke component = "Service.Document.Attachment"  
									   method           = "VerifyDBAttachment" 
									   server           = "#documentHost#"
									   docpath          = "#object.entitycode#" 
									   filename         = "#name#"
									   returnvariable   = "Attachment">			
								   
								   <td class="labelmedium" style="padding-left:10px" 
										   onclick="showfile('attachment','view','#attachment.attachmentid#')">												   										
											<a href="##">
											<cfif len(name) gt "20">#left(name,20)#...<cfelse>#name#</cfif></a><cfif currentrow neq recordcount>;</cfif>												
										   </td>							   																			
								   </cfloop>
								   </tr>
								   </table>
							   </td>
							</tr>
					
					    </cfif>	
																								
						<cf_filelibraryCheck
							DocumentHost="#DocumentHost#"
							DocumentPath="#object.entitycode#"
							SubDirectory="#attachmentid#" 
							name="GetFiles"
							filter="*.*"
							listinfo="name">  
													
						<cfif files gte "1">
																																									
							<tr class="clsRow_#currentrow# line" style="border-top:1px solid silver">
							  
							   <td style="padding-right:10px" align="right">
							   
							       <table width="100%">
								   								   
								   <cf_filelibraryN
								        DocumentHost="#DocumentHost#"
										DocumentPath="#object.entitycode#"
										SubDirectory="#attachmentid#" 
										Filter=""
										Presentation="name"
										Insert="no"
										Remove="no"
										width="100%"	
										Loadscript="no"				
										border="1">	
								  							  
								   </table>
							   </td>
							</tr>
					
					    </cfif>	
						
						
							
	
				</table>
			</td>
		</tr>
		
		
	</cfoutput>
	
	<tr><td class="clsBottomLine"></td></tr>
					
</table>

<cfset vURLObjectId = replace(url.objectId,"-","","ALL")>
<cf_tl id="There are messages recorded" var="1">
<cfset vMessagesLabel = lt_text>

<cfoutput>

	<cfsavecontent variable="ajaxFunction">
					
	    if (document.getElementById('mybox')) {
		<cfif get.recordcount gt 0>					
		    notifyBorderById('mybox', 'left', 'message.png', '#vMessagesLabel#', 'myboxhascontent');
		<cfelse>
			removeNotificationBorderById('mybox', 'left', 'myboxhascontent');
		</cfif>	
		}
						 
		<!--- remove wait gif --->
		_cf_loadingtexthtml='';
		
		<!--- do highlight --->
		doHighlight();		
		
		<!--- Scroll to the bottom --->
   		$('##communicatecomment_#vURLObjectId#').animate({
       		scrollTop: $(".clsBottomLine").first().offset().top + 5000
   		}, 2000);	
		
		<!--- Emphasize last record --->	
		$('.clsFilterRow_#Get.recordCount# > td').addClass('clsLastRowHL');
		$('.clsRow_#Get.recordCount# td').animate({fontSize:'+=3px'}, 800);	
				
		<!--- reset any backoffice scripts that might be still running --->
		try { clearInterval ( commentrefresh_#left(url.objectid,8)# ); } catch(e) {}		
		commentrefresh_#left(url.objectid,8)# = setInterval('commentstatus("#get.recordcount#","#url.objectid#","communicatecomment_#vURLObjectId#")',20000);
				
	</cfsavecontent>
	
</cfoutput>

<cfset AjaxOnLoad("function() { #ajaxFunction# }")>

</cfif>
	