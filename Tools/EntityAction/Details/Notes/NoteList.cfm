

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

<cfquery name="Notes" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     OrganizationObjectActionMail
		WHERE    ObjectId = '#url.ObjectId#'
		AND      SerialNo = 1 
		AND      MailType != 'Action'
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
			(
			  MailSubject like '%#URL.filter#%'
			  OR
			  MailBody like '%#URL.filter#%'
			)
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
		 
			<tr>					
				<td width="100%" colspan="9" style="padding-top:4px" height="20" class="labelit">
				    <a href="javascript:noteentry('#url.objectid#','','','notes','','#url.mode#','#url.box#','#url.actioncode#')">
					<font color="0080FF"><cf_tl id="Add Note"></font>
					</a>
					&nbsp;|&nbsp;
				    <a href="javascript:noteentry('#url.objectid#','','','mail','','#url.mode#','#url.box#','#url.actioncode#')">
					<font color="0080FF"><cf_tl id="Send Mail"></font>
					</a>
			    </td>
			</tr>
			<tr><td height="1" class="linedotted" colspan="8"></td></tr>
			</cfoutput> 	 
			
		<cfelse>
		
			<cfset cl = "regular">	
		
		</cfif>
				
	</cfif>
	
	<cfif Notes.recordcount gt "0">
	
		<tr>
		<td class="#cl#"><cf_space spaces="4"></td>
		<td class="#cl#"><cf_space spaces="4"></td>
		<td class="#cl#"><cf_space spaces="4"></td>
		<td class="#cl#"><cf_space spaces="5"></td>
		<td class="#cl#"><cf_space spaces="45"></td>
		<td class="#cl#"><cf_space spaces="60"></td>			
		<td class="#cl#"></td>					
		<td class="#cl#"></td>
		</tr>
		
	<cfelse>
	
		<cfif url.detailedit eq "Yes"> 
			<tr><td colspan="8" align="center"></td></tr>
		</cfif>
			
	</cfif>
	
	<cfset rowline = 0>		
	
    <cfoutput query="Notes">
	
			<cfset rowline = rowline+1>
			
			<cfdirectory action="LIST"
             directory="#SESSION.rootDocumentPath#\#object.entitycode#\#attachmentid#"
             name="attach" type="file" listinfo="name">	
							
			<cfif url.mode eq "regular">						        
		    <tr id="r#rowline#" class="navigation_row" onclick="show('#rowline#','#threadid#','#serialno#')">
			<cfelse>				
			<tr id="r#rowline#" class="navigation_row" onclick="show('#rowline#','#threadid#','#serialno#')">				
			</cfif>
							
			<td>
			 <cfif priority eq "1">
			     <img src="#SESSION.root#/Images/exclamation.gif" alt="high priority" border="0" align="absmiddle">
			 </cfif>
			</td>
			
			<TD height="23" width="20" valign="top" align="center" style="padding-top:3px">
							
			<cfif url.detailedit eq "Yes">
			
				<cfif mailtype eq "notes">
				   <cfset icn = "note2.gif">
				<cfelse>
				   <cfset icn = "mail.gif">
				</cfif>  
									
				<img src="#SESSION.root#/Images/#icn#" name="img5_#currentrow#" 
				  onMouseOver="document.img5_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.img5_#currentrow#.src='#SESSION.root#/Images/#icn#'"				 
				  style="cursor: pointer;" border="0" align="absmiddle" width="16" height="10"
				  onClick="noteentry('#objectid#','#threadid#','#serialno#','#mailtype#','','#url.mode#','#url.box#','#url.actioncode#')">
				
			</cfif> 
			</TD>
			
			<td width="20" valign="top" style="padding-top:3px">
				<cfif attach.recordcount gte "1">				
					 <img src="#SESSION.root#/Images/paperclip2.gif" alt="attachment" border="0" align="absmiddle">
			    </cfif>
				
			</td>								
			
			<td colspan="3">				
				
				<table width="100%" cellspacing="0" cellpadding="0">
				<tr><td class="labelit">#OfficerFirstName# #OfficerLastName#</td></tr>
				<tr><td class="labelit"><cfif MailSubject neq "">#MailSubject#<cfelse>..</cfif></td></tr>
				</table>
			</td>	
						
			<td align="right" class="labelit">				
			<cfif dateformat(maildate,CLIENT.DateFormatShow) neq dateformat(now(),CLIENT.DateFormatShow)>
			#dateformat(MailDate,"DDD DD/MM")#
			<cfelse>
			#timeformat(Created,"HH:MM")#
			</cfif>						
			</td>			
			
			<td width="3"></td>
			
			</tr>
							
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
		             name="attach"
		             type="file"
		             listinfo="name">		
					
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
			
				<tr><td class="linedotted" colspan="8"></td></tr>		
				
			</cfif>
							
	</cfoutput>
	
	<cfoutput>
			<input type="hidden" name="rows" id="rows"        value="0">
			<input type="hidden" name="threadid" id="threadid"    value="#Notes.threadid#">
			<input type="hidden" name="serialno" id="serialno"    value="#Notes.serialno#">
			<input type="hidden" name="total" id="total"       value="#rowline#">
	</cfoutput>
	
</table>
	
<cfset ajaxonload("doHighlight")>
