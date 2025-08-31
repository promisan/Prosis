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

		<cf_assignid>   
		<cfset att = rowguid>	
	
		<table align="center" style="height:100%;width:98%;pdding-left:4px;">
			
			<tr><td style="padding:2px;padding-left:1px;padding-right:1px">
			
			<form method="post" name="entryform" id="entryform" style="width:99%">
	
				<table style="width:100%">
				
				<tr><td style="padding-top:3px;padding-bottom:2px">
				
				<table width="100%"><tr>
				
						<td style="padding-left:5px" width="80">
						<select name="Priority" id="Priority" class="regularxl" style="background-color:transparent;border:0px;width:90" title="Important comments will be shown as red and be tagges as such in the mail.">
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
								<input type="button" onclick="updateTextArea();ptoken.navigate('#session.root#/Tools/EntityAction/Details/Comment/CommentEntrySubmit.cfm?objectid=#url.objectid#&attbox=mycomment','processchat','','','POST','entryform')" name="Submit" value="Submit" class="button10g" style="width:100px;height:25px;border-radius:0px">
							</cfoutput>			
						</td>
						</tr>
												
						
				</table>
			
				</td></tr>
								
				<cfif getFlyActors.recordcount gte "1">						
						
					<tr id="mailbox" class="hide">
						<td colspan="5" style="padding-right:6px">
							<table width="100%">
								<tr class="labelmedium" style="height:26px;border-top:1px solid silver">								    
									<td width="30" valign="top" style="border-right:1px solid silver;padding-top:3px;min-width:70px;padding-left:12px;padding-right:3px">
									<cf_tl id="Send to"></td>
									
									<td id="mailselect" align="left" style="width:80%;padding-left:4px">
									
										<table style="width:100%">
																				
											<cfoutput query="getFlyActors">
											    <tr class="<cfif currentrow neq recordcount>line</cfif>">
											    <td class="labelit" style="padding-top:1px;padding-left:1px; color:black;">#LastName#</td>
												<td align="right" style="padding-top:2px;padding-left:1px;padding-right:4px">
												<cf_img icon="delete" onclick="ptoken.navigate('#session.root#/Tools/EntityAction/Details/Comment/setMailAddress.cfm?objectid=#url.objectid#&action=delete&useraccount=#useraccount#','mailselect','','','POST','entryform')">
												</td> 												
												</tr>
											</cfoutput>
																			
										
										</table>
										
										<cfoutput>										
											<input type="hidden" id="mailaddress" name="mailaddress" 
											    value="#quotedvalueList(getFlyActors.UserAccount)#">
											</cfoutput>
											
									</td>	
									
									<td align="right" valign="top" style="padding-left:4px;border-left:1px solid silver;padding-top:3px;padding-right:2px">
									
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
				
				<tr><td style="padding-top:4px;padding-bottom:2px;padding-left:3px;padding-right:3px;">

					<cfif Attributes.ajax eq "No">
																			
					 <cf_textarea name="MailBody"	           		 
						 init="Yes"							
						 color="f6f6f6"	 
						 resize="false"		
						 border="0" 
						 toolbar="mini"
						 height="90"
						 width="99%"/>
						 
					<cfelse>
					
																									
					 <cf_textarea name="MailBody"	           		 						 						
						 color="f6f6f6"	 						 
						 resize="false"		
						 border="0" 
						 toolbar="mini" 
						 height="90"
						 width="99%"/>
						 				
					</cfif>	 
			
				</td></tr>
							
					  
				<cfoutput>							
					<input type="hidden" name="ObjectId" id="ObjectId"      value="#URL.ObjectId#">
					<input type="hidden" name="ThreadId" id="ThreadId"      value="#URL.ThreadId#">
					<input type="hidden" name="SerialNo" id="SerialNo"      value="#URL.SerialNo#">						
				</cfoutput>      
				
				<tr><td style="padding-left:4px;padding-right:5px">				
								
				<cf_filelibraryN
					DocumentPath="#Object.EntityCode#"
					SubDirectory="#att#" 
					Filter=""		
					color="Transparent"		
					Width="100%"
					height="100%"
					Box = "mycomment"
					attachdialog="cfwindow"
					showsize="0"
					Insert="yes"
					Remove="yes">	
					
				</td></tr>
							
				<!--- 25/9/2015 we also involve the people that have their 
			     name in the process OrganizationObjectAction recorded --->		 	
				
				</table>
				
				</form>
				
			</td></tr>
					
		</table>	
		
</cfif>	

<cfif Attributes.ajax eq "Yes">

	<cfset ajaxonload("initTextArea")>

</cfif>




