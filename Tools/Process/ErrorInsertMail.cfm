
<cfparam name="client.browser"          default="undefined">
<cfparam name="client.dateformatshow"   default="DD/MM/YY">
<cfparam name="client.eMail"            default="">

<cfquery name="Log" 
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT * 
	FROM   UserError
	WHERE  ErrorId = '#attributes.errorid#'		
</cfquery>		

<cfquery name="Parameter" 
datasource="AppsInit">
	SELECT * 
	FROM   Parameter
	WHERE  HostName = '#CGI.HTTP_HOST#' 
</cfquery>

<!--- send by default to the defined system contact --->
<cfset to = "#Parameter.SystemContactEMail#">
<cfset ccto = "">
<cfset bcc  = "">

<cfquery name="check" 
	datasource="AppsControl">
	SELECT *
	FROM   Ref_Template
	WHERE  FileName = '#Log.filename#'
	AND    PathName = '#Log.pathname#'
</cfquery>

<cfif check.recordcount eq "1">

	<!--- check if template exist and HAS responsible account and retrieve OWNER email address --->
	
	<cfquery name="Last" 
	datasource="AppsControl">
		SELECT   *
		FROM     Ref_TemplateContent T 
		WHERE    T.FileName = '#Log.filename#'
		AND      T.PathName = '#Log.pathname#'
		ORDER BY T.VersionDate DESC 
    </cfquery>

	<cfquery name="cc" 
	datasource="AppsSystem">
		SELECT   *
		FROM     UserNames 
		WHERE    Account = '#Last.Templateofficer#'	
    </cfquery>
	
	<cfif cc.recordcount eq "1">
	
		<cfswitch expression="#Parameter.ErrorMailToOwner#">
		
		<cfcase value="2">
		
			<!--- send to template owner and to Promisan --->
			<cfset to   = cc.eMailAddress>
			<cfset bcc  = "vanpelt@promisan.com">
					
		</cfcase>
		
		<cfcase value="1">
		
			<!--- do not sent to manager but to the owner of the template only --->
			<cfset to   = cc.eMailAddress>
					
		</cfcase>
		
		<cfcase value="0">
		
		    <!--- only to the application server contact
			<cfset ccto = cc.eMailAddress>
			--->
						
		</cfcase>
		
		</cfswitch>
		
	</cfif>
	
</cfif>
		
<cfif log.controlid neq "">

	<cfquery name="Report" 
		datasource="AppsSystem">
		SELECT * 
		FROM   Ref_ReportControl
		WHERE  ControlId = '#log.controlId#'			
	</cfquery>		
	
	<cfif Report.NotificationEmail neq "">
		<cfset ccto = "#ccto#,#Report.NotificationEmail#">
	</cfif>

</cfif>

<cf_assignid>

<cfmail TO      = "#to#" 
	CC          = "#ccto#"
	bcc         = "#bcc#"
    FROM        = "#SESSION.first# #SESSION.last# <#Client.eMail#>"
	SUBJECT     = "#SESSION.welcome# Error in : #CGI.HTTP_HOST#/#Log.ErrorTemplate#"
	FAILTO      = "#CLIENT.eMail#"
	mailerID    = "#SESSION.welcome#"
	TYPE        = "html"
	spoolEnable = "Yes"
	wraptext    = "100">

<cfset lbl = "#SESSION.welcome# Application Agent">		
<cfset headercolor = "ffffff">

<table cellpadding="0" cellspacing="0" border="0" width="98%" align="center">
	<tr>
		<td>
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" >  
				<tr>
					<td colspan="2">
						<table width="100%" cellspacing="0" cellpadding="0">													 	 
							<tr>
								<td>
									<table width="100%">
										<tr style="border-bottom:1px dotted silver">
											<td width="80px">
												<img src="cid:logo" border="0" align="absmiddle" width="70" height="70">
											</td>
											<td style="padding-left:10px;">
												<font face="calibri" size="5" color="003059">
													<b>#SESSION.welcome# Error Notification</b>
												</font>
												<br>
												<font color="1562a4" size="3" face="calibri">
													An <b>automatic</b> EMAIL was <b>sent</b> to: 
													<br>
													<font color="003059" size="3" face="calibri">#Parameter.SystemContactEMail# (#Parameter.SystemContact#)
												</font>
											</td>	
										</tr>
									</table>
								</td>
							</tr>					 		 
						</table>		
					</td>
				</tr>		
				<tr><td height="10"></td></tr>
			    <tr>     
					<td valign="top">
						<table width="100%" align="center" cellspacing="0" cellpadding="0">
							<tr>
								<td height="25" colspan="2" style="border-bottom:1px solid silver;  background-color:##F9F9F9;">
									<font size="3" color="003059" face="calibri">
										<b>Posted by</b>
									</font>
								</td>
							</tr>
							
							<tr>
								<td height="20" width="150px"><font size="2" face="calibri" color="1562a4"><b>Case No:</b></font></td>
								<td><font size="2" color="black" face="calibri">#Log.HostName#/#Log.ErrorNo#</font></td>
							</tr>		
							<tr>
								<td height="20"><font size="2" face="calibri" color="1562a4"><b>UserId:</b></font></td>
								<td><font size="2" color="black" face="calibri">#SESSION.acc#</font></td>
							</tr>
							<tr>
								<td height="20"><font size="2" face="calibri" color="1562a4"><b>Name:</b></font></td>
								<td><font size="2" color="black" face="calibri">#SESSION.first# #SESSION.last#</font></td>
							</tr>
							<tr>
								<td height="20"><font size="2" face="calibri" color="1562a4"><b>eMail:</b></font></td>
								<td><font size="2" color="black" face="calibri">#client.eMail#</font></td>
							</tr>
							<tr>
								<td height="20"><font size="2" face="calibri" color="1562a4"><b>IP:</b></font></td>
								<td><font size="2" color="black" face="calibri">#Log.NodeIP#</font></td>
							</tr>
							<tr>
								<td height="20"><font size="2" face="calibri" color="1562a4"><b>Source:</b></font></td>
								<td><font size="2" color="black" face="calibri">#Log.Source#</font></td>
							</tr>						
						</table>
					</td>
				</tr>
				
				<tr><td height="10"></td></tr>
				
				<tr>
					
					<td valign="top">			 
						<table width="100%" cellspacing="0" cellpadding="0" align="center">
							<tr>
								<td height="25" colspan="2" style="border-bottom:1px solid silver;  background-color:##F9F9F9;">
									<font size="3" color="003059" face="calibri">
										<b>Details</b>
									</font>
								</td>
							</tr>				
										
							<tr>
								<td height="20" width="150px"><font size="2" face="calibri" color="1562a4"><b>Date and Time:</b></font></td>
								<td><font size="2" color="black" face="calibri">#dateformat(Log.ErrorTimeStamp,CLIENT.DateFormatShow)# at #timeformat(log.ErrorTimeStamp,"HH:MM:SS")#</font></td>
							</tr>
							<tr>
								<td height="20"><font size="2" face="calibri" color="1562a4"><b>CFMX Server:</b></font></td>
								<td><font size="2" color="black" face="calibri">#CGI.HTTP_HOST# (#Server.Coldfusion.ProductVersion#)</font></td>
							</tr>
							<tr>
								<td height="20"><font size="2" face="calibri" color="1562a4"><b>OS:</b></font></td>
								<td><font size="2" color="black" face="calibri">#Server.OS.Name# #Server.OS.Version#</font></td>
							</tr>
							<tr>
								<td height="20"><font size="2" face="calibri" color="1562a4"><b>Client Browser:</b></font></td>
								<td><font size="2" color="black" face="calibri">
								
									<cfif find("MSIE 7","#CGI.HTTP_USER_AGENT#")>
										Explorer 7
									<cfelseif find("MSIE 8","#CGI.HTTP_USER_AGENT#")>
										Explorer 8	
									<cfelseif find("MSIE 9","#CGI.HTTP_USER_AGENT#")>
										Explorer 9
									<cfelseif find("MSIE 10","#CGI.HTTP_USER_AGENT#")>
										Explorer 10												
									<cfelseif find("Firefox","#CGI.HTTP_USER_AGENT#")>
										Firefox
									<cfelseif find("Chrome","#CGI.HTTP_USER_AGENT#")>
										Chrome	 
									<cfelseif find("Opera","#CGI.HTTP_USER_AGENT#")>
										Opera	
									<cfelseif find("Safari","#CGI.HTTP_USER_AGENT#")>
										Safari 
									<cfelse>	
										Undetermined
									</cfif>
												
								
								</font></td>
							</tr>
							<tr>
								<td height="20"><font size="2" face="calibri" color="1562a4"><b>Referrer:</b></font></td>
								<td style="word-wrap: break-word; word-break: break-all;">
									<cfif Log.ErrorReferer eq "">
										<font size="2" color="black" face="calibri">
											N/A
										</font>
									<cfelse>
										<font size="2" color="black" face="calibri">
											#Log.ErrorReferer#
										</font>
									</cfif>
								</td>
							</tr>
					
							<cfif log.controlid neq "">
		
								<cfquery name="Report" 
									datasource="AppsSystem">
									SELECT * FROM Ref_ReportControl
									WHERE ControlId = '#log.controlId#'			
								</cfquery>		
							
								<cfif report.recordcount eq "1">						
									<tr>
							    		<td height="20" width="150px"><font size="2" face="calibri" color="1562a4"><b>Report:</b></font></td>
										<td><font size="2" color="black" face="calibri" style="text-decoration: underline;">#Report.FunctionName#</font></td>
									</tr>							
									<tr>
							    		<td height="20"><font size="2" face="calibri" color="1562a4"><b>Directory:</b></font></td>
										<td><font size="2" color="black" face="calibri" style="text-decoration: underline;">#Report.ReportPath#</font></td>
									</tr>							
								<cfelse>						
									<tr>
							    		<td height="20" width="150px"><font size="2" face="calibri" color="1562a4"><b>Template:</b></font></td>
										<td><font size="2" color="black" face="calibri" style="text-decoration: underline;">#Log.ErrorTemplate#</font></td>
									</tr>															
								</cfif>		
									
							
							<cfelseif log.actionid neq "">
												
								<cftry>					
									<cfquery name="Workflow" 
										datasource="AppsOrganization">							
										SELECT     O.EntityCode, O.EntityClass, R.ActionDescription, Dialog.DocumentTemplate
										FROM       OrganizationObjectAction OA INNER JOIN
										           OrganizationObject O ON OA.ObjectId = O.ObjectId INNER JOIN
										           Ref_EntityAction R ON OA.ActionCode = R.ActionCode INNER JOIN
										           Ref_EntityActionPublish P ON R.ActionCode = P.ActionCode AND OA.ActionPublishNo = P.ActionPublishNo LEFT OUTER JOIN
										           Ref_EntityDocument Dialog ON R.EntityCode = Dialog.EntityCode AND P.ActionDialog = Dialog.DocumentCode
										WHERE      OA.ActionId = '#Log.actionId#'
									</cfquery>	
																							
									<cfif workflow.recordcount eq "1">								
										<tr>
									    	<td height="20" width="150px"><font size="2" face="calibri" color="1562a4"><b>Workflow:</b></font></td>
											<td><font size="2" color="black" face="calibri" style="text-decoration: underline;">#Workflow.EntityCode# / #Workflow.EntityClass#</font></td>
										</tr>															
										<tr>
									    	<td height="20"><font size="2" face="calibri" color="1562a4"><b>Action:</b></font></td>
											<td><font style="text-decoration: underline;">#Workflow.ActionDescription#</font></td>
										</tr>														
										<tr>
									    	<td height="20"><font size="2" face="calibri" color="1562a4"><b>Embedded Template:</b></font></td>
											<td><font size="2" color="black" face="calibri" style="text-decoration: underline;">#Workflow.DocumentTemplate#</font></td>
										</tr>							
									<cfelse>					
										<tr>
									    	<td height="20" width="150px"><font size="2" face="calibri" color="1562a4"><b>Template:</b></font></td>
											<td style="word-wrap: break-word; word-break: break-all;"><font size="2" color="black" face="calibri" style="text-decoration: underline;"><u>#Log.ErrorTemplate#</u></font></td>
										</tr>								
									</cfif>	
								
									<cfcatch>
								
									<tr>
								    	<td height="20" width="150px"><font size="2" face="calibri" color="1562a4"><b>Template:</b></font></td>
										<td style="word-wrap: break-word; word-break: break-all;"><font size="2" color="black" face="calibri" style="text-decoration: underline;"><u>#Log.ErrorTemplate#</u></font></td>
									</tr>								
								
									</cfcatch>							
							
								</cftry>
							
							
							<cfelse>
												
								<tr>
								   	<td height="20" width="150px"><font size="2" face="calibri" color="1562a4"><b>Template:</b></font></td>
									<td style="word-wrap: break-word; word-break: break-all;"><font size="2" color="black" face="calibri" style="text-decoration: underline;"><u>#Log.ErrorTemplate#</u></font></td>
								</tr>	
														
							</cfif>			
																												
							<tr>
								<td height="20" width="150px"><font size="2" face="calibri" color="1562a4"><b>String:</b></font></td>
								<td style="word-wrap: break-word; word-break: break-all;"><font size="2" color="black" face="calibri" style="text-decoration: underline;">#Log.ErrorString#</font></td>
							</tr>					   												
						</table>
					</td>	
				</tr>
				
				<tr><td colspan="2" height="12"></td></tr>
			
				
				<tr>
					<td height="20" colspan="2">						 
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
							<tr>
								<td bgcolor="F0DCDA" style="padding:8px; border:1px solid ##D93723;">
									<font color="D93723" face="calibri" size="3">
										<cfset diag = replace(#Log.ErrorDiagnostics#,". ",".<br>","ALL")>
										#diag#
									</font>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				
			<cfif Log.errorcontent neq "">
			
				<tr><td colspan="2" height="12"></td></tr>		
				<tr>
					<td height="20" colspan="2" style="border:1px solid silver">						 
						<table width="100%" border="0" cellspacing="0" cellpadding="0">							
							<cfset r = 0>
							
							<cfloop index="itm" list="#Log.ErrorContent#" delimiters="#chr(10)#">
							
								<cfif findNoCase("runpage",itm)>				
								
								<cfset s = findNoCase("runpage",itm)>					    						
								<cfset itm = replaceNoCase(itm, ".cfm:", ".cfm: line ")> 
								<cfset itm = replaceNoCase(itm, "(", "")>
								<cfset itm = replaceNoCase(itm, ")", "")>
								<cfset sel = len(itm)-s-6>
								
								<cfset r = r + 1>
								
								<cfif r eq "1">
								<tr>
									<td bgcolor="f9f9f9"><font color="003059" size="3" face="calibri"><b>The Error Occurred in</b></font></td>
								</tr>
								<cfelse>
								<tr>
									<td bgcolor="f9f9f9" style="border-top:1px solid silver"><font color="003059" size="3" face="calibri"><b>Called from</b></font></td>
								</tr>
								</cfif>					
								<tr>
									<td bgcolor="ffffff" style="border-top:1px solid silver">
										<font color="1562a4" size="2" face="calibri">
											- <b>#Right(itm, sel)#</b>
										</font>
									</td>
								</tr>
								
								</cfif>				
								
								<cfif findNoCase("factor",itm)>				
								
								<cfset s = findNoCase("factor",itm)>					    						
								<cfset itm = replaceNoCase(itm, ".cfm:", ".cfm: line ")> 
								<cfset itm = replaceNoCase(itm, "(", "")>
								<cfset itm = replaceNoCase(itm, ")", "")>
								<cfset sel = len(itm)-s-6>
								
								<tr>
									<td bgcolor="f9f9f9">
										<font color="003059" size="3" face="calibri">
											<b>Called from</b>
										</font>
									</td>
								</tr>
								<tr>
									<td bgcolor="ffffff">
										<font color="1562a4" size="2" face="calibri">
											- <b>#Right(itm, sel)#</b>
										</font>
									</td>
								</tr>
								
								</cfif>					
							</cfloop>
								</td>
							</tr>
						</table>
					</td>
				</tr>	
					
				<tr><td colspan="2" height="10"></td></tr>		
				<tr>
					<td height="20" colspan="2" style="border:1px solid silver">						 
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td style="padding:5px">
									<font color="black" size="2" face="calibri">
										#Log.ErrorContent#
									</font>
								</td>
							</tr>
						</table>
					</td>
				</tr>		
			</cfif>						
				<tr><td colspan="2" height="10"></td></tr>								
			</table>
		</td>
	</tr>
</table>		

<br><br><br>
<!--- disclaimer --->
<cf_maildisclaimer context="password" id="mailid:#rowguid#">

<cfmailparam file="#SESSION.root#/Images/error_3.png" contentid="logo" disposition="inline"/>

</cfmail>


