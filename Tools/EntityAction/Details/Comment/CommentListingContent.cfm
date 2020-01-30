
<cf_param name="url.objectid" default="47939CF6-CF9B-8A52-AFB7-4CBAE9DB7C63" type="String">
<cf_param name="url.threadid" default="47939CF6-CF9B-8A52-AFB7-4CBAE9DB7C63" type="String">
<cf_param name="url.serialno" default="1" type="String">

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM       OrganizationObject
WHERE      ObjectId = '#URL.Objectid#'
</cfquery>

<cfquery name="Get" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       OrganizationObjectActionMail M
	WHERE      ObjectId = '#url.objectid#'
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

<table width="100%" align="center" class="navigation_table">

	<cfif get.recordcount eq "0">
	
	<tr><td align="center" style="padding-top:20px" class="labelmedium"><font color="808080"><cf_tl id="No information found to show in this view"></font></td></tr>
	
	</cfif>
	
	<cfoutput query="Get">
		
		<tr class="line navigation_row clsFilterRow clsFilterRow_#currentrow#">
			<td>
				<table width="100%" align="center" class="formpadding"> 
				
					<tr class="clsRow_#currentrow#">
					    <!---
						<td class="labelit" valign="top" width="50" style="padding-top:5px;padding-left:14px;padding-right:10px"><font color="0080C0">#currentrow#.<font color="0080C0"></b></td>
						--->
					    <td width="90%" style="padding-left:4px">
						 
							 <table style="width:100%">
							 <tr>
							 
							    <!--- Picture --->
								
							 	<td width="60">
									<cfif not FileExists("#session.rootdocumentpath#\EmployeePhoto\#OfficerUserId#.jpg")>
										<cfset vEmpPhotoPath = "#session.root#/images/logos/no-picture-male.png">	
									<cfelse>
										<cfset vEmpPhotoPath = "#session.rootdocument#/EmployeePhoto/#OfficerUserId#.jpg">									
									</cfif>
									<img src="#vEmpPhotoPath#" title="#OfficerFirstName# #OfficerLastName#" style="border:1px solid black;height:37px;" align="absmiddle">
									
								</td>
								
								<!--- name --->
								
								<td style="padding-left:6px;">
									<table width="100%">
										<tr>
											<td>
											<table width="100%">
												<tr>
												<td  style="padding-left:4px;height:20px;" class="labelmedium ccontent">#OfficerFirstName# #OfficerLastName#</td>												
												
												 <cfif session.acc eq OfficerUserId>		
												 
												  <td width="20" align="right" style="padding-top:3px">
												   	  <cf_img icon="delete" onclick="ColdFusion.navigate('#session.root#/Tools/EntityAction/Details/Comment/CommentDelete.cfm?objectid=#objectid#&threadid=#threadid#&serialno=#serialno#','process')">
												   </td>		
												 
												   <cfif getAdministrator("*") eq "1">												   
												 											 
														<td style="padding-left:4px;padding-right:5px" 
														  style="cursor:pointer" align="right"
														  id="box_#threadid#_#serialno#" 
														  onclick="ColdFusion.navigate('#session.root#/Tools/EntityAction/Details/Comment/setComment.cfm?objectid=#objectid#&threadid=#threadid#&serialno=#serialno#&field=mailscope&value='+document.getElementById('mailscope_#threadid#_#serialno#').value,'box_#threadid#_#serialno#')" 
														  class="labelit ccontent"><font color="6688aa"><u>
														  <cfif MailScope eq "All"><cf_tl id="public"><cfelse><cf_tl id="support"></cfif></font>
														
															<cfif MailScope eq "All">
																<input type="hidden" id="mailscope_#threadid#_#serialno#" value="support">
															<cfelse>
																<input type="hidden" id="mailscope_#threadid#_#serialno#" value="all">
															</cfif>				
																									   
													   </td>
													   
												   </cfif>								 		 
												  										   
												   
												 </cfif>
												 
												 </tr>
											</table>										
											</td>
										</tr>
										<tr>
											<td  valign="top" class="labelit ccontent" style="padding-left:13px">#dateformat(MailDate,"DDD")# #dateformat(MailDate,CLIENT.DateFormatShow)# #TimeFormat(MailDate,"HH:MM")#</td>
										</tr>
									</table>
								</td>
							 </tr>
							 </table>
						 
						 </td>
						 </tr>
						 
						 <!--- attachment --->								
						 					
						<cfdirectory action="LIST"
						             directory="#SESSION.rootDocumentPath#\#object.entitycode#\#attachmentid#"
						             name="GetFiles"
						             filter="*.*"
						             sort="DateLastModified DESC"
						             type="file"
						             listinfo="name">
							
						<cfif getfiles.recordcount gte "1">
																	
							<tr class="clsRow_#currentrow#">
							  
							   <td style="padding-left:10px">
							       <table cellspacing="0" cellpadding="0">
								   <td style="padding-left:10px;font-size:11px;padding-right:3px" class="labelit"><cf_tl id="Attach">:</td>
							       <cfloop query="getfiles">								   			
										<td class="labelit ccontent">
											<a href="#SESSION.rootDocument#/#object.entitycode#/#get.attachmentid#/#name#" target="_blank"><font color="0080C0">#name#</a>
										</td>										
								   </cfloop>
								   </table>
							   </td>
							</tr>
					
					    </cfif>	
						
						<!--- body --->
						
						<cfset vPriorityColor = "">
						<cfif get.Priority eq "1">
							<cfset vPriorityColor = "color:##FF0000;">
						</cfif>
						<cfset vMaxChars = 100>
							
						<tr class="clsRow_#currentrow#">
							
							<td valign="top" style="padding-left:20px;padding-right:15px;padding-top:4px;padding-bottom:8px" class="label ccontent">
								<table width="100%" >
									<input type="Hidden" value="1" id="commentListingMailBodyToggler_#currentrow#">
									<cfset vMailBody = replace(Get.MailBody,"<strong>","<b>","ALL")>
									<cfset vMailBody = replace(vMailBody,"</strong>","</b>","ALL")>
									<cfset vMailBody = replace(vMailBody,"<em>","<i>","ALL")>
									<cfset vMailBody = replace(vMailBody,"</em>","</i>","ALL")>
									<div id="commentListingMailBodyContent_#currentrow#" style="display:none;">#vMailBody#</div>
									<tr>
										<td valign="top" bgcolor="ffffff" class="ccontent" id="commentListingMailBodyContainer_#currentrow#" style="height:30px;border-radius:7px;border:0px solid silver;padding-left:10px;padding:6px;#vPriorityColor#">
										
											<div style="font-size:13px">#left(vMailBody,vMaxChars)# <cfif len(get.mailBody) gt vMaxChars>...</cfif></div>
											
											<cfif len(get.mailBody) gt vMaxChars>
												<cf_tl id="more" var="1">
												<a id="commentListingMailBodyTwistie_#currentrow#" 
													style="color:##46B6F2;" 
													onclick="toggleCommentLength('##commentListingMailBodyContent_#currentrow#','##commentListingMailBodyContainer_#currentrow#','##commentListingMailBodyToggler_#currentrow#','##commentListingMailBodyTwistie_#currentrow#',#vMaxChars#);"> 
													 <font size="1"><u>#lt_text#</u></font>
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
		
	</cfoutput>
	
	<tr><td class="clsBottomLine"></td></tr>
					
</table>

<cfset vURLObjectId = replace(url.objectId,"-","","ALL")>
<cf_tl id="There are messages recorded" var="1">
<cfset vMessagesLabel = lt_text>

<cfoutput>

	<cfsavecontent variable="ajaxFunction">
		
	    <!--- show content icon --->
		<cfif get.recordcount gt 0>					
		    notifyBorderById('mybox', 'left', 'message.png', '#vMessagesLabel#', 'myboxhascontent');
		<cfelse>
			removeNotificationBorderById('mybox', 'left', 'myboxhascontent');
		</cfif>	
		 
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
		
		<!--- Do search filter 
		$('##filtersearchsearch').keyup();--->
	</cfsavecontent>
	
</cfoutput>

<cfset AjaxOnLoad("function() { #ajaxFunction# }")>