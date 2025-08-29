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
<cfparam name="url.mode"          default="regular">
<cfparam name="url.detailedit"    default="yes">
<cfparam name="url.box"           default="notecontainerdetail">
<cfparam name="url.sel"           default="">
<cfparam name="url.val"           default="">
<cfparam name="url.filter"        default="">
<cfparam name="url.actioncode"    default="">
<cfparam name="url.actionid"      default="">
<cfparam name="client.mailfilter" default="">
<cfparam name="url.sitem"         default="">
<cfset client.mailfilter = 	"">
		  
<cfif url.sel neq "">
	<cfset client.mailfilter = 	"AND #url.sel# = '#URL.val#'">
</cfif>	  
 
<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     * 
FROM       OrganizationObject
WHERE      ObjectId = '#URL.ObjectId#'	
</cfquery>

<cfif url.actionid neq "">
	<cfquery name="Action" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     * 
	FROM       OrganizationObjectAction
	WHERE      ActionId = '#URL.ActionId#'	
	</cfquery>
</cfif>

<cfquery name="Notes" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT   *
		FROM     OrganizationObjectActionMail
		WHERE    ObjectId  = '#url.ObjectId#'
		AND      SerialNo  = 1 
		AND      MailType != 'Action'
		AND      Documentid is not NULL
		<cfif client.mailfilter neq "" and url.actioncode eq "">
		#preservesingleQuotes(client.mailfilter)#
		<cfelseif url.actioncode neq "" and url.actioncode neq "undefined">
		AND      ActionCode = '#URL.actionCode#'
		<cfelseif url.actionid neq "">
		AND      ActionCode = '#URL.actionCode#'
		</cfif>
		<cfif url.mode eq "Actor">
		AND      ActionStatus = '1'
		</cfif>		
		<cfif url.filter neq "">
			AND 
			( MailSubject like '%#URL.filter#%'
			  OR MailBody like '%#URL.filter#%'
			)
		</cfif>
		<cfif url.actionid neq "">
			<cfif action.actionStatus neq "0">
			 AND    Created <= '#Action.OfficerDate#' 
 			</cfif>
		</cfif>		
		ORDER BY Created DESC
		
</cfquery>	
		
<table width="98%" cellspacing="0" cellpadding="0" class="navigation_table">	 


	<tr class="hide"><td id="processnote"></td></tr>

	<cfif url.detailedit eq "Yes">   
			
		<cfif url.mode eq "Actor">
		
		    <!--- -------------------------- --->
		    <!--- to be reviewed for INSIGHT --->
		
		    <tr><td height="22" align="center" colspan="8">
			
			<table width="100%" align="center"><tr>
			
				<td width="100"><!--- <b>Status Sheet</b> ---></td>
			
				<td align="right">
				<table cellspacing="0" cellpadding="0" align="right"><tr><td>
			
				<cfmenu name="notemenu#objectid#"
			            font="verdana"
			            fontsize="14"
					    menustyle="height:10"
			            type="horizontal"		
					    bgcolor="transparent"	          
			            selecteditemcolor="6688AA"
			            selectedfontcolor="FFFFFF">								  

					  <cf_tl id="Record New Note" var="1">
					  <cfset tNote = "#Lt_text#">
					  						  
					  <cfmenuitem 
						     display="#tNote#"
						     name="addnote"			  
						     href="javascript:noteentry('#url.objectid#','','','notes','','#url.mode#','#url.box#','#url.actioncode#')"
						     image="#SESSION.root#/Images/note2.gif"/>

					  <cf_tl id="Send an EMail" var="1">
					  <cfset tEmail = "#Lt_text#">
					  									  
					  <cfmenuitem 
						    display="#tEmail#"
						    name="addmail"
							href="javascript:noteentry('#url.objectid#','','','mail','','#url.mode#','#url.box#','#url.actioncode#')"
						    image="#SESSION.root#/Images/mail_new.gif"/>				  							  					  	  	    
																		
				</cfmenu>	
				</td></tr></table>
				</td></tr>
				
				</table>  	  
			
			</td></tr>
			
			 <cfset cl = "top4n">
			 
		<cfelseif url.mode eq "note"> 
		
			<cfoutput>
		 
			<tr class="line">					
				<td width="100%" colspan="9" style="padding-top:4px" height="20" class="labelmedium2">
				    <a href="javascript:noteentry('#url.objectid#','','','notes','','#url.mode#','#url.box#','#url.actioncode#')">
					<cf_tl id="Add Action">
					</a>
					&nbsp;|&nbsp;
				    <a href="javascript:noteentry('#url.objectid#','','','mail','','#url.mode#','#url.box#','#url.actioncode#')">
					<cf_tl id="Send Mail">
					</a>
			    </td>
			</tr>
			
			</cfoutput> 	 
			
		<cfelse>
		
			<cfset cl = "regular">	
		
		</cfif>
				
	</cfif>
	
	<cfif Notes.recordcount gt "0">
	
				
	<cfelse>
	
		<cfif url.detailedit eq "Yes"> 
			<tr><td colspan="8" align="center"></td></tr>
		</cfif>
			
	</cfif>
	
	<cfset rowline = 0>		
	
    <cfoutput query="Notes">
	
			<cfquery name="Item" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      Ref_EntityDocumentItem
				<cfif documentid neq "">
				WHERE     DocumentId = '#documentid#' AND DocumentItem = '#documentitem#'
				<cfelse>
				WHERE 1=0				
				</cfif>
			</cfquery>	
	
			<cfset rowline = rowline+1>
			
			<cfdirectory action="LIST"
             directory="#SESSION.rootDocumentPath#\#object.entitycode#\#attachmentid#" name="attach" type="file" listinfo="name">	
							
			<cfif url.mode eq "regular">						        
		    <tr id="r#rowline#" class="navigation_row fixlengthlist linedotted" style="height:20px" onclick="show('#rowline#','#threadid#','#serialno#')">
			<cfelse>				
			<tr id="r#rowline#" class="navigation_row fixlengthlist linedotted" style="height:20px" onclick="show('#rowline#','#threadid#','#serialno#')">				
			</cfif>
							
			<td>
			 <cfif priority eq "1">
			     <img src="#SESSION.root#/Images/exclamation.gif" alt="high priority" border="0" align="absmiddle">
			 </cfif>
			</td>
			
			<TD valign="top" style="padding-top:3px">
							
			<cfif url.detailedit eq "Yes">
			
				<cfif mailtype eq "notes">
				   <cfset icn = "note2.gif">
				<cfelse>
				   <cfset icn = "mail.gif">
				</cfif>  
									
				<img src="#SESSION.root#/Images/#icn#" name="img5_#currentrow#" 
				  onMouseOver="document.img5_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.img5_#currentrow#.src='#SESSION.root#/Images/#icn#'"				 
				  style="cursor: pointer;" border="0" align="absmiddle" width="16" height="15"
				  onClick="noteentry('#objectid#','#threadid#','#serialno#','#mailtype#','','#url.mode#','#url.box#','#url.actioncode#')">
				
			</cfif> 
			
			</TD>
			
			<td width="20" valign="top" style="padding-top:5px">
				<cfif attach.recordcount gte "1" and attachmentid neq "">				
					 <img src="#SESSION.root#/Images/paperclip2.gif" alt="attachment" border="0" align="absmiddle">
			    </cfif>				
			</td>								
			
			<td colspan="4">#OfficerFirstName# #OfficerLastName# <cfif item.documentItemName neq "">#item.documentItemName#</cfif> <cfif MailSubject neq "">: #MailSubject#<cfelse>..</cfif></td>	
						
			<td align="right" class="labelit">				
				#dateformat(MailDate,"DD/MM/yyyy")# #timeformat(Created,"HH:MM")#									
			</td>			
			
			<td width="3"></td>
			
			</tr>
						
			<cfif attach.recordcount gte "1" and attachmentid neq "">	
			
			<tr style="height:1px" class="navigation_row_child">
			
			<td colspan="9" id="#attachmentid#">	
								
				<cf_filelibraryN
						DocumentPath="#Object.EntityCode#"
						SubDirectory="#attachmentid#" 
						Filter=""				
						Width="100%"
						Box = "#attachmentid#"
						Insert="no"
						Remove="no">			
								
				</td>
			</tr>	
			
			</cfif>					
							
			<cfquery name="Thread" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     OrganizationObjectActionMail
				WHERE    ThreadId = '#ThreadId#'
				AND      SerialNo <> 1
				ORDER BY SerialNo
			</cfquery>	
			
				
			<cfif thread.recordcount gte "1">				
			<tr><td class="linedotted" colspan="8"></td></tr>		
			</cfif>
											
			<cfloop query="Thread">
			
				<cfset rowline = rowline+1>
															
				<tr class="navigation_row_child">				
					
					<cfdirectory action="LIST"
		             directory="#SESSION.rootDocumentPath#\#object.entitycode#\#attachmentid#"
		             name="attach" type="file" listinfo="name">		
					
					<td>
					 <cfif priority eq "1">
					 <img src="#SESSION.root#/Images/exclamation.gif" 
					    alt="high priority" border="0" align="absmiddle">
					  </cfif>
					</td>
									
					<TD height="100%" align="center">
					
						<cfif currentrow eq recordcount>
							<img src="#SESSION.root#/Images/join.gif" align="absmiddle">
						<cfelse>
							<img src="#SESSION.root#/Images/joinbottom.gif" align="absmiddle">						
						</cfif>
					
					</TD>	
									
					<td>
								
					<cfif url.detailedit eq "Edit">
								
					 <img src="#SESSION.root#/Images/bullet.gif" name="img9_#currentrow#" 
						  onMouseOver="document.img9_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
						  onMouseOut="document.img9_#currentrow#.src='#SESSION.root#/Images/bullet.gif'"
						  style="cursor: pointer;" border="0" align="absmiddle" width="5" height="5"
						  onClick="noteentry('#objectid#','#threadid#','#serialno#','#mailtype#','','#url.mode#','#url.box#','#url.actioncode#')">						
					  
					</cfif>	  
									
					</td>		
					
					<td><cfif attach.recordcount gte "1">
					 <img src="#SESSION.root#/Images/paperclip2.gif" 
					    alt="attachment" border="0" align="absmiddle">
					  </cfif>
					</td>				
					
					<td class="labelit">#MailSubject#</td>
					
					<td align="left" class="labelit">#OfficerFirstName# #OfficerLastName#</td>						
					<td align="right" class="labelit">
						<cfif dateformat(maildate,CLIENT.DateFormatShow) neq dateformat(now(),CLIENT.DateFormatShow)>
						#dateformat(MailDate,"DDD DD/MM")#
						<cfelse>
						#timeformat(Created,"HH:MM")#
						</cfif>				
					</td>	
								
					<td></td>	
					
				</tr>
							
			<cfif url.mode neq "Regular">					
				
				<tr><td colspan="3"></td><td colspan="5">			
				
				<cf_filelibraryN
					DocumentPath="#Object.EntityCode#"
					SubDirectory="#attachmentid#" 
					Filter=""	
					color="F4FBFD"			
					Width="100%"						
					inputsize = "340"
					loadscript="No"
					insert="no"
					Remove="no">	
				
				</td>
				</tr>			
							
			</cfif>			
			
			<cfif currentrow eq recordcount>
			    
				<tr><td class="linedotted" colspan="8"></td></tr>		
				
			
			</cfif>
			
			</cfloop>	
			
			<cfif thread.recordcount eq "0">
			    <!---
				<tr><td class="linedotted" colspan="8"></td></tr>		
				--->
				
			</cfif>
							
	</cfoutput>
	
	<cfif url.detailedit eq "Yes">
	
	<cfoutput>
			<input type="hidden" name="rows" id="rows"        value="0">
			<input type="hidden" name="threadid" id="threadid"    value="#Notes.threadid#">
			<input type="hidden" name="serialno" id="serialno"    value="#Notes.serialno#">
			<input type="hidden" name="total" id="total"       value="#rowline#">
	</cfoutput>
	
	</cfif>
	
</table>
	
<cfset ajaxonload("doHighlight")>
