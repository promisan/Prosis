<!---#sendto#--->
<!--- CC      = "vanpelt@promisan.com"--->

<cfparam name="client.languageid" default="ENG">

<cfif client.eMail eq "">
    <cfset from = System.DefaultEMail>
<cfelse>
    <cfset from = client.EMail> 
</cfif>

<cfoutput>
	
	<cfmail TO          = "#sendto#"        
		    FROM        = "#from#"
			SUBJECT     = "#Attributes.text#: #Action.ActionDescription#"	
			mailerID    = "#SESSION.welcome#"
			FAILTO      = "#from#"
			REPLYTO     = "#from#"
			TYPE        = "html"
			spoolEnable = "Yes"
			wraptext    = "100">
			
		<!--- ------------------------------- --->
		<!--- get the atachment of the object --->
		<!--- ------------------------------- --->
				
		<cfparam name="attributes.sendattobj" default="">
						
		<cfif attributes.sendAttObj eq "1" and qObject.DocumentPathName neq "">
											
			<cf_fileExist
				DocumentPath  = "#qObject.DocumentPathName#"
				SubDirectory  = "#qObject.ObjectId#" 
				Filter        = ""					
				ListInfo      = "all">		
			
			<cfif filelist.recordcount eq "0">
			
				<cf_fileExist
					DocumentPath  = "#qObject.DocumentPathName#"
					SubDirectory  = "#qObject.ObjectKeyValue4#" 
					Filter        = ""					
					ListInfo      = "all">		
								
			</cfif>		
							
			<!--- returns a query object filelist --->
			
			<cfloop query="filelist">
			
				<cfquery name="qAttachment" 
						 datasource="AppsOrganization"  
						 username="#SESSION.login#" 
						 password ="#SESSION.dbpw#"> 
							SELECT * 
							FROM   System.dbo.Attachment
							WHERE  Reference        = '#qObject.ObjectId#'
							AND    DocumentPathName = '#qObject.DocumentPathName#'
							AND    FileName         = '#name#'							
				</cfquery>
				   
				   <cfif qAttachment.fileStatus neq "9">
				   
				   	   <cfmailparam file="#directory#\#name#">						   				
													
				   </cfif>				
			
			</cfloop>					
		
		</cfif>				
			
		<!--- ---------------Hanno 17/5/2012 --------------------- --->	
		<!--- add a provsion to include attachmenta of the object --->
		<!--- --------------------------------------------------- --->	
			
		<style>
			td.mainheader {
			line-height:17px;
			color:##4186c9;
			}
			
			td.header {
			line-height:15px;
			color:##003b74;
			}
			
			td.description {
			line-height:15px;
			color:gray;
			}

		</style>
					
					<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">	  
						<tr>
							<td colspan="2" style="padding-top:8px">
								<table width="100%" height="50px" style="border-bottom:1px solid silver">								
									<tr>
										<td width="80px">						
											<img src="cid:logo" width="70" height="70" border="0" align="absmiddle" style="display:block">
										</td>
										<td style="padding-left:10px;">
											<font size="5" color="003059">
											<b>
											<cfif attributes.accesslevel eq "1">
											#SESSION.welcome# <cf_tl id="Alert"><br> 
											<cfelse>
											#SESSION.welcome# <cf_tl id="Notification"><br>
											</cfif>
											</font>
											<br>
											<font size="3" color="black"><cf_tl id="Request was logged"></font>		 
										</td>	
									</tr>
								</table>
							</td>
						</tr>
				 		<tr>
							<td valign="top" style="padding-top:8px">						
								<table width="96%"  cellspacing="0" cellpadding="0" align="center">
									<tr>
										<td height="20" class="header" colspan="2"><font size="3"><cf_tl id="Requested by"></font></td>
									</tr>
									<tr>
										<td class="line" colspan="2"></td>
									</tr>
									<tr>
										<td height="20" class="header"><cf_tl id="Name">:</td>
										<td class="description">#Last.OfficerFirstName# #Last.OfficerLastName#</td>
									</tr>
									<tr>
										<td height="20" class="header"><cf_tl id="Timestamp">:</td>
										<td class="description">#dateformat(now(),"#CLIENT.DateFormatShow#")# #timeformat(now(),"HH:MM")# <td>
									</tr>
									<tr>
										<td height="20" class="header"><cf_tl id="UserId">:</td>
										<td class="description">#Last.OfficerUserId#</td>
									</tr>
									<tr>
										<td height="20" class="header"><cf_tl id="eMail">:</td>
										<td class="description"><a href = "mailto:#Mail.eMailAddress#">#Mail.eMailAddress#</a></td>
									</tr>
									<tr>
										<td height="20" class="header"><cf_tl id="Report problems to">: 
										<td class="description"><a href = "mailto:#Parameter.SystemContactEMail#">#Parameter.SystemContactEMail#</a></td>
									</tr>	
									
									<tr><td height="20"></td></tr>
									
									<tr>
										<td height="20" colspan="2" class="header"><font size="3"><cf_tl id="Action details"></font></td>
									</tr>
									<tr>
										<td class="line" colspan="2"></td>
									</tr>							
									<tr>
										<td height="20" class="header"><cf_tl id="Subject">:</td>
										<td class="description">#qObject.EntityDescription#</td>
									</tr>					
									<tr>
										<td height="20" class="header"><cf_tl id="Action">:</td>
										<td class="description">#Action.ActionDescription#</td>
									</tr>
									<tr>
										<td height="20" class="header"><cf_tl id="Reference">:</td>
										<td class="description">#qObject.ObjectReference#</td>
									</tr>
									<tr>
										<td height="20" class="header"><cf_tl id="Memo">:</td>
										<td class="description">#qObject.ObjectReference2#</td>
									</tr>					
									<cfset FileNo = round(Rand()*100)>					
									<cfif attributes.accesslevel eq "1">					
									<tr>
										<td height="25" class="header"><cf_tl id="Link">:</td>
										<td class="description" valign="middle">
										    <table><tr><td>
											<img src="cid:click" width="15" height="15" border="0" align="baseline" style="display:block"></b>
											</td>
											<td style="padding-left:10px">
											<a href="#SESSION.root#/ActionView.cfm?id=#qObject.Objectid#">
											<b>
											<cfif client.languageid eq "ENG">
												Click here to process this action
											<cfelseif client.languageid eq "ESP">
												Hacer click aqu� para procesar la acci�n
											</cfif>
											</b>
											</a>
											</td></tr>
											</table>
											</td>
									</tr>					
									<cfelse>					
									<tr>
										<td height="20" class="header"><cf_tl id="Link">:</td>
										<td class="description"><b><img src="cid:click2" width="15" height="15" border="0" align="baseline" style="display:block">&nbsp;<a href="#SESSION.root#/ActionView.cfm?id=#qObject.Objectid#"><font color="0080FF">Press here to view</a></b></td>
									</tr>					
									</cfif>					
													
								</table>
							</td>
						</tr>		
						<tr style="border-top:1px solid silver;height:30px">
							<td colspan="2" align="center"><font size="1" color="silver"><cf_tl id="Paste link"> : #SESSION.root#/ActionView.cfm?id=#qObject.Objectid#</td>
						</tr>
					</table>
					
					<cfmailparam file="#SESSION.root#/Images/action_person.gif"   contentid="logo"   disposition="inline"/>
					<cfmailparam file="#SESSION.root#/Images/Mail/click_here.png" contentid="click"  disposition="inline"/>
					<cfmailparam file="#SESSION.root#/Images/Mail/click_here.png" contentid="click2" disposition="inline"/>
												
		</cfmail>
</cfoutput>
	