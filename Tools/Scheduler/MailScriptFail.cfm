
<cfoutput>
	
<cfset face = "Trebuchet MS">
<cfset size = "2">

<cfif !isDefined("Parameter.DateFormat")>

	<cfquery name="Parameter"  datasource="AppsSystem">
	    SELECT * 
		FROM Parameter
	</cfquery>

</cfif>

<cfif Parameter.DateFormat is "EU">
     <cfset CLIENT.DateFormatShow      = "dd/mm/yyyy">
<cfelse> 
     <cfset CLIENT.DateFormatShow      = "mm/dd/yyyy">
</cfif>

<cfif Template.ScriptFailureMail neq "">
		
			
		<cfmail TO  = "#Template.ScriptFailureMail#"
		        FROM        = "#SESSION.welcome# Task Agent <#Template.ScriptFailureMail#>"
				ReplyTo     = "#Template.ScriptFailureMail#"
				SUBJECT     = "ERROR: #Template.ScheduleName#"
				mailerID    = "#SESSION.welcome#"
				TYPE        = "html"
				spoolEnable = "Yes"
				wraptext    = "100">					

				
					<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
						<tr>
							<td valign="top">
								<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">	
									<tr>
										<td align="center" height="60" bgcolor="white" style=" border-bottom:1px dotted gray; padding-top:3px; padding-bottom:3px">
											<table width="100%" height="100%">
												<tr>
													<td valign="middle" width="80px">
														<img src="cid:logo" alt="Action" border="0" width="70px" height="70px" align="absmiddle">
														<br>
													</td>
													<td align="left" valign="middle" style="padding-left:10px;">
														<font size="5" color="003059" face="calibri">
															Error Notification
														</font>
														<br>
														<font face="calibri" color="black" size="4">
															Scheduled Task:<b>&nbsp;#Template.scheduleName#</b>													
														</font>
														<br>
														<font size="2" face="calibri" color="003059">
															<b>#template.schedulememo#</b>
														</font>
													</td>
												</tr>
											</table>
										</td>
									</tr>		
									
									<tr>
										<td height="5px"></td>
									</tr>
									
									<tr>
										<td>
											<table cellpadding="0" cellspacing="0" border="0" width="100%">    
											    <tr>		     
													<td valign="top" width="40%" height="20">
														<table width="96%" align="center" cellspacing="0" cellpadding="0">
															<tr>
																<td height="25" colspan="2" style="background-color:##f9f9f9; border-bottom:1px solid silver;">
																	<font size="3" color="003059" face="calibri">
																		&nbsp;<b>Schedule</b>
																	</font>
																</td>
															</tr>
															<tr>
																<td height="20" width="150px"><font size="2" color="1562a4" face="calibri">&nbsp;<b>Interval:</b></td>
																<td><font size="2" color="black" face="calibri">#Template.ScheduleInterval#</td>
															</tr>
															<tr>
																<td height="20"><font size="2" color="1562a4" face="calibri">&nbsp;<b>Class:</b></font></td>
																<td><font face="calibri" size="2" color="black">#Template.ScheduleClass#</font></td>
															</tr>
															<tr>
																<td height="20"><font size="2" color="1562a4" face="calibri">&nbsp;<b>Time start:</b></td>
																<td><font face="calibri" size="2" color="black">#Template.ScheduleStartTime#</td>
															</tr>			
														</table>
													</td>
												
												</tr>
												
												<tr><td height="10"></td></tr>
												
												<tr>
													 
													<td valign="top" height="20" width="60%">			 
														<table width="96%" cellspacing="0" cellpadding="0" align="center">
															<tr>
																<td height="25" colspan="2" style="background-color:##f9f9f9; border-bottom:1px solid silver;">
																	<font size="3" color="003059" face="calibri">
																		&nbsp;<b>Failure information</b>
																	</font>
																</td>
															</tr>
															
															<tr>
																<td height="20" width="150px"><font size="2" color="1562a4" face="calibri">&nbsp;<b>Account:</b></font></td>
																<td><font size="2" color="black" face="calibri">#Last.OfficerUserId#</font></td>
															</tr>	 
															
															<tr>
																<td height="20"><font size="2" color="1562a4" face="calibri">&nbsp;<b>Application Server:</b></font></td>
																<td><font size="2" color="black" face="calibri">#Template.ApplicationServer#</font></td>
															</tr>
															
															<tr>
																<td height="20"><font size="2" color="1562a4" face="calibri">&nbsp;<b>Remote Address:</b></font></td>
																<td><font size="2" color="black" face="calibri">#Last.NodeIP#</font></td>
															</tr>
															
															<tr>
																<td height="20"><font size="2" color="1562a4" face="calibri">&nbsp;<b>Timestamp:</b></font></td>
																<td><font size="2" color="black" face="calibri">#DateFormat(Last.ProcessEnd,CLIENT.DateFormatShow)# #TimeFormat(Last.ProcessEnd,"HH:MM:SS")#</font></td>
															</tr>
															
															<tr>
																<td height="20" style="font-family: verdana; padding-top:3px;" valign="top"><font size="2" color="1562a4" face="calibri">&nbsp;<b>Error:</b></font></td>
																<td style="padding-top:3px;" valign="top"><font size="2" color="black" face="calibri">#Last.ScriptError#</font></td>
															</tr>				
														</table>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									
									<tr>
										<td height="10"></td>
									</tr>					
								</table>
							</td>
						</tr>
					</table>
				
					<cfmailparam file="#SESSION.root#/Images/error.png" contentid="logo" disposition="inline"/>
	 											  
	</cfmail>			
</cfif>
</cfoutput>

