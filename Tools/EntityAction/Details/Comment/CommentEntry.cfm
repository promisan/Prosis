
<cfparam name="url.objectid" default="47939CF6-CF9B-8A52-AFB7-4CBAE9DB7C63">
<cfparam name="url.threadid" default="47939CF6-CF9B-8A52-AFB7-4CBAE9DB7C63">
<cfparam name="url.serialno" default="1">

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM       OrganizationObject
WHERE      ObjectId = '#URL.Objectid#'
</cfquery>

<cfif Object.recordcount eq "0">

	<table><tr><td align="center" class="labelmedium"><cf_tl id="Problem"></td></tr></table>

<cfelse>

	<form method="post" name="entryform" id="entryform" style="width:100%">
	
		<table align="center" style="width:100%">
			
			<tr><td style="padding-top:2px;padding-left:1px;padding-right:1px">
	
				<table style="width:100%">
				
				<tr><td style="padding-top:3px;padding-bottom:2px">
				
				<table width="100%"><tr>
				
						<td style="padding-left:8px" width="80">
						<select name="Priority" id="Priority" class="regularxl" style="width:90" title="Important comments will be shown as red and be tagges as such in the mail.">
						        <option value="3"><cf_tl id="Normal"></option>			
								<option value="1"><cf_tl id="Important"></option>
								</select>
						</td>
	
						
						<cfif attributes.mail eq "1">
						
							<cfif getFlyActors.recordcount gte "1" or Object.PersonEMail neq "">
												
								<td style="padding-left:5px;width:20px">
								<input style="cursor:pointer" type="checkbox" 
								  onclick="document.getElementById('mailbox').className = 'regular'" 
								  name="Mode" value="mail" class="radiol" title="Send this comment also as a mail to the actors">
								</td>	
								<td style="padding-left:2px" class="labelit"><cf_tl id="Mail"></td>					
							
							</cfif>
						
						</cfif>
						
						<cfif getAdministrator("*") eq "1">
							<td style="padding-left:5px">
							<input style="cursor:pointer" type="checkbox" class="radiol" name="MailScope" value="support" title="This comment will be only visible to the actor; BUT notto the requester.">
							</td>	
							<td style="padding-left:2px" class="labelit"><cf_tl id="Support"></td>
						</cfif>
				
						<td align="right" style="padding-left:6px;padding-right:7px">			
							<cfoutput>		
								<input type="button" onclick="updateTextArea();ptoken.navigate('#session.root#/Tools/EntityAction/Details/Comment/CommentEntrySubmit.cfm?objectid=#url.objectid#','processchat','','','POST','entryform')" name="Submit" value="Submit" class="button10g" style="width:100px;height:25px;border-radius:0px">
							</cfoutput>			
						</td>
						</tr>
												
						
				</table>
			
				</td></tr>
								
				<cfif getFlyActors.recordcount gte "1">
						
						
					<tr id="mailbox" class="hide">
						<td colspan="5" style="padding-right:6px">
							<table width="100%">
								<tr class="labelmedium" style="height:20px">
								    <td valign="top" width="20"><img src="<cfoutput>#session.root#</cfoutput>/images/join.gif" alt="" border="0"></td>
									<td width="30" style="padding-left:4px;color:#6688aa;padding-right:3px"><b><cf_tl id="Mail"></td>
									
									<td id="mailselect" align="left">
									
										<table>
										<tr>
																					
											<cfoutput query="getFlyActors">
											    <td class="labelit" style="padding-left:1px; color:black;">
												#LastName#
												</td>
												<td style="padding-top:2px;padding-left:2px;padding-right:4px">
												<cf_img icon="delete" onclick="ptoken.navigate('#session.root#/Tools/EntityAction/Details/Comment/setMailAddress.cfm?objectid=#url.objectid#&action=delete&useraccount=#useraccount#','mailselect','','','POST','entryform')">
												</td> 												
											</cfoutput>
											
											
																					
										</tr>
										</table>
										
										<cfoutput>										
											<input type="hidden" id="mailaddress" name="mailaddress" 
											    value="#quotedvalueList(getFlyActors.UserAccount)#">
											</cfoutput>
											
									</td>	
									
									<td align="right" style="padding-right:4px">
									
									 <cf_tl id="Add" var="lbl">				   	  	  
									 <cfset link = "#session.root#/Tools/EntityAction/Details/Comment/setMailAddress.cfm?objectid=#url.objectid#|action=insert">
																	
									  <cf_selectlookup
										    box          = "mailselect"
											title        = "#lbl#"
											link         = "#link#"
											form         = "entryform"
											button       = "No"
											close        = "No"
											class        = "user"
											des1         = "useraccount">	
													
									</td>								
																		
								</tr>
							</table>
						</td>
					</tr>
				
				</cfif>
				
				<tr><td style="padding-bottom:6px;padding-left:5px;padding-right:6px;">

					<cfif Attributes.ajax eq "No">
					
					 <cf_textarea name="MailBody"	           		 
						 init="Yes"							
						 color="ffffff"	 
						 resize="true"		 
						 toolbar="Basic" 
						 height="130"
						 width="100%"/>
						 
					<cfelse>
					
					 <cf_textarea name="MailBody"	           		 						 						
						 color="ffffff"	 
						 resize="true"		 
						 toolbar="Basic" 
						 height="130"
						 width="100%"/>
						 				
					</cfif>	 
			
				</td></tr>
				
				<tr><td style="padding-top:2px;padding-left:4px;padding-right:9px;padding-bottom:4px">
				
				<cf_assignid>   
				<cfset att = rowguid>	
						  
				<cfoutput>				
					<input type="hidden" name="ObjectId" id="ObjectId"      value="#URL.ObjectId#">
					<input type="hidden" name="ThreadId" id="ThreadId"      value="#URL.ThreadId#">
					<input type="hidden" name="SerialNo" id="SerialNo"      value="#URL.SerialNo#">
					<input type="hidden" name="AttachId" id="AttachId"      value="#att#">			
				</cfoutput>      
				
				<cf_filelibraryN
					DocumentPath="#Object.EntityCode#"
					SubDirectory="#att#" 
					Filter=""		
					color="Transparent"		
					Width="100%"
					Box = "#att#"
					attachdialog="cfwindow"
					showsize="0"
					Insert="yes"
					Remove="yes">	
					
				</td></tr>
							
				<!--- 25/9/2015 we also involve the people that have their 
			     name in the process OrganizationObjectAction recorded --->		 	
				
				</table>
				
			</td></tr>
					
		</table>
	
	</form>
	
</cfif>	


