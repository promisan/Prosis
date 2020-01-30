		
<cfset face = "Trebuchet MS">
<cfset size = "2">
<cfparam name="CLIENT.trialMode" default="0">
<cfparam name="URL.Batch" default="0">

<cfif CLIENT.reportingServer neq "">
    <cfset rptserver  = "#CLIENT.reportingServer#">
<cfelse>
    <cfset rptserver = "#rptserver#">
</cfif>

<cfif User.eMailAddress neq "">
    <cfset fail = "#User.eMailAddress#">
<cfelse>
    <cfset fail = "#Layout.eMailAddress#">
</cfif>

<cfparam name="attach" default="">

<cfquery name="Param" 
    datasource="AppsSystem">
	 SELECT   *
	 FROM     UserReport U 
	 WHERE    U.ReportId = '#URL.ReportId#' 
</cfquery>

<cfquery name="Admin" 
    datasource="AppsOrganization">
	 SELECT   *
	 FROM     OrganizationAuthorization 
	 WHERE    Role = 'Support'
	 AND      UserAccount = '#Param.account#' 
</cfquery>
<!--- do not send mail if in trial mode --->

<cfif client.TrialMode neq "1" or Admin.recordcount gte "1">
	
	<cfset mail = "#User.DistributionEMailCC#">
	
	<cfif URL.Batch eq "1">
	
		<cfquery name="Mailing" 
		datasource="AppsSystem">
			SELECT    U.eMailAddress
			FROM      UserNamesGroup G INNER JOIN
	                  UserReportMailing M ON G.AccountGroup = M.Account INNER JOIN
	                  UserNames U ON G.Account = U.Account
			WHERE     M.ReportId = '#URL.ReportId#'		
			AND       U.Disabled = 0	  
			AND       U.eMailAddress > ''  
		</cfquery>
			
		<cfloop query="Mailing">
		
			<cfif FindNoCase("#Mailing.eMailAddress#", "#mail#") 
			   or FindNoCase("#Mailing.eMailAddress#", "#User.DistributionEMail#")>
			
			<cfelse>
		        
				<cfif mail eq "">
					<cfset mail = "#Mailing.eMailAddress#">
				<cfelse>
					<cfset mail = "#mail#,#Mailing.eMailAddress#">
				</cfif>
			
			</cfif>
		
		</cfloop>
	
	</cfif>
	
	<cfset headercolor = "ffffff">
				
	<!--- #Layout.Owner# --->
	<!--- TO          = "#User.DistributionEMail#"
		  CC          = "#mail#"--->
		  
<cfif User.DistributionEMail neq "">		  
					  
	<cfmail TO          = "#User.DistributionEMail#"
			CC          = "#mail#"        
			FROM        = "#SESSION.welcome# Reporter <#Layout.eMailAddress#>"
			ReplyTo     = "#User.DistributionReplyTo#"
			SUBJECT     = "REPORTER: #User.DistributionSubject#"
			FAILTO      = "#fail#"			
			mailerID    = "#Layout.Owner# [#Layout.SystemModule#]"
			TYPE        = "html"
			spoolEnable = "Yes"
			wraptext    = "100">
	
	<cfset lbl = "#Layout.Owner# Report Agent">
			<table cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" bgcolor="ffffff">
				<tr>
					<td style="border: 1px dotted silver;padding:10px" valign="top">
						<table cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
							<tr>
								<td style="border-right: 1px solid white" valign="top">
									<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">    
										<tr>
											<td>
												<table cellspacing="0" cellpadding="0" border="0" align="left" width="100%" height="78px">
													<tr>
														<td height="15px" colspan="2">
														&nbsp;
														</td>
													</tr>
													
													<tr>
														<td height="56px" width="10%" valign="middle" align="right" bgcolor="white" style="border-top:1px solid gray; border-bottom:1px solid gray; padding-top:3px; padding-bottom:3px">
														<cfoutput>												
															<img src="#SESSION.root#/Images/report_action.png" alt="Report" border="0" align="right" style="display:block">   
														</cfoutput>	 
														</td>
														
														<td height="56px" width="90%" valign="middle" align="left" style="border-top:1px solid gray; border-bottom:1px solid gray; padding-top:3px; padding-bottom:3px" bgcolor="white">
															&nbsp;&nbsp;<font face="calibri" size="6" color="003059"><b><i>#SESSION.welcome# report notification</font></b>
															<br><font face="calibri" size="4" color="1562a4"><i>&nbsp;&nbsp;&nbsp;&nbsp;<b>Your report is attached</b></font>
														</td>
													</tr>
												</table>
											</td>
										</tr>
										
										<tr>
											<td height="20"></td>
										</tr>  	 
										
										<tr>	     
											<td valign="top">
												<table cellpadding="0" cellspacing="0" border="0" width="96%" align="center">
													<tr>
														<td width="35%" valign="top">
															<table height="100%" width="96%" align="center" cellspacing="0" cellpadding="0">
																<tr>
																	<td height="20" colspan="2" align="left" style="border-bottom:1px solid silver">
																		<font face="calibri" size="4" color="003059">
																			&nbsp;Subscriber</b>
																		</font>
																	</td>
																</tr>																
																															
																<tr>
																	<td height="18px" width="120px">
																		<font size="2" color="1562a4" face="calibri">	
																			&nbsp;Account:
																		</font>
																	</td>
																	<td>
																		<font size="2" color="black" face="calibri">
																			#Param.OfficerUserId#
																		</font>
																	</td>
																</tr>
																<tr>
																	<td height="18px" width="120px">
																		<font size="2" color="1562a4" face="calibri">
																			&nbsp;Name:
																		</font>
																	</td>
																	<td>
																		<font size="2" color="black" face="calibri">
																			#Param.OfficerFirstName# #Param.OfficerLastName#
																		</font>
																	</td>
																</tr>
																<tr>
																	<td height="18px" width="120px">
																		<font size="2" color="1562a4" face="calibri">
																			&nbsp;Subscription Period:
																		</font>
																	</td>
																	<td>
																		<font size="2" color="black" face="calibri">
																			#DateFormat(Param.DateEffective,CLIENT.DateFormatShow)# - #DateFormat(Param.DateExpiration,CLIENT.DateFormatShow)#
																		</font>
																	</td>
																</tr>				
															</table>
														</td>					 
														<td width="65%" valign="top">			
															<table width="96%" cellspacing="0" cellpadding="0" align="center">
																<tr>
																	<td height="20" colspan="2" style="border-bottom:1px solid silver">
																		<font face="calibri" size="4" color="003059">
																			&nbsp;Report Information
																		</font>
																	</td>
																</tr>
																
															
																<tr>
																	<td height="18" width="40%">
																		<font size="2" color="1562a4" face="calibri">
																			&nbsp;Name:
																		</font>
																	</td>
																	<td width="60%">
																		<font size="2" color="black" face="calibri">
																			#User.DistributionSubject#
																		</font>
																	</td>
																</tr>
															
																<tr>
																	<td height="18" width="40%">
																		<font size="2" color="1562a4" face="calibri">
																			&nbsp;Selected layout:
																		</font>
																	</td>
																	<td width="60%">
																		<font size="2" color="black" face="calibri">
																			#Layout.LayoutName#
																		</font>
																	</td>
																</tr>
																<tr>
																	<td height="18" width="40%">
																		<font size="2" color="1562a4" face="calibri">
																			&nbsp;Sent to:
																		</font>
																	</td>
																	<td width="60%">
																		<font size="2" color="black" face="calibri">
																			#User.DistributioneMail#
																		</font>
																	</td>
																</tr>
																
																<cfif User.DistributioneMailCC neq "">
																<tr>
																	<td height="18" width="40%">
																		<font size="2" color="1562a4" face="calibri">
																			&nbsp;CC to:
																		</font>
																	</td>
																	<td width="60%">
																		<font size="2" color="black" face="calibri">
																			#User.DistributioneMailCC#
																		</font>
																	</td>
																</tr>
																</cfif>
																
																<tr>
																	<td height="18" width="40%">
																		<font size="2" color="1562a4" face="calibri">
																			&nbsp;Server Id:
																		</font>
																	</td>
																	<td width="60%">
																		<font size="2" color="black" face="calibri">
																			#CGI.HTTP_HOST#
																		</font>
																	</td>
																</tr>
																<tr>
																	<td height="18" width="40%">
																		<font size="2" color="1562a4" face="calibri">
																			&nbsp;Mode:
																		</font>
																	</td>
																	<td width="60%">
																		<font size="2" color="black" face="calibri">
																			<cfif User.DistributionMode neq "Hyperlink">Attachment<cfelse>Hyperlink</cfif>
																		</font>
																	</td>
																</tr>
																<tr>
																	<td height="18" width="40%">
																		<font size="2" color="1562a4" face="calibri">
																			&nbsp;Format:
																		</font>
																	</td>
																	<td width="60%">
																		<font size="2" color="black" face="calibri">
																			<cfif Layout.TemplateReport neq "Excel">#User.Fileformat#<cfelse>Excel</cfif>
																		</font>
																	</td>
																</tr>
															
																<cfif Param.DistributionMode neq "Attachment" or (Layout.LayoutClass eq "View" and Report.EnableAttachment eq "0")>
																
																<tr>
																	<td height="20" width="40%">
																		<font size="2" color="1562a4" face="calibri">
																			&nbsp;Hyperlink *):
																		</font>
																	</td>
																	<td width="60%">																	
																			<a href="#rptserver#/Report.cfm?id=#URL.reportId#" target="_blank">
																				<font face="Calibri" size="4" color="0080FF"><b><u>Press here to open your report</u></b></font>
																			</a>
																		</font>
																	</td>
																</tr>
																
																<cfelse>
																
																<cfloop index="att" list="#attach#" delimiters=","> 
																	<cfmailparam file = "#SESSION.root#/CFRStage/User/#SESSION.acc#/#Att#">
																</cfloop>   
																
																</cfif>
																
																</tr>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									
										<tr>
											<td height="5"></td>
										</tr>
										
										<tr>
											<td>
												<table cellpadding="0" cellspacing="0" width="96%" border="0" align="center">													
													<cftry>  
															
															<cfquery name="Detail" 
														     datasource="AppsSystem">
															 SELECT   C.*, U.DistributionMode, CR.CriteriaDescription AS CriteriaDescription
												             FROM     UserReportCriteria C INNER JOIN
												                      UserReport U ON C.ReportId = U.ReportId INNER JOIN
												                      Ref_ReportControlCriteria CR ON C.CriteriaName = CR.CriteriaName INNER JOIN
												                      Ref_ReportControlLayout L ON U.LayoutId = L.LayoutId AND CR.ControlId = L.ControlId
															 WHERE    U.ReportId = '#URL.ReportId#' 
															 AND      CR.Operational = 1
															 ORDER BY CriteriaOrder
															</cfquery>
																								
															<cfcatch>
															
																<cfset URL.ReportId = "#attributes.ReportId#">
																
																<cfquery name="Detail" 
															     datasource="AppsSystem">
																 SELECT   C.*, U.DistributionMode, CR.CriteriaDescription AS CriteriaDescription
													             FROM     UserReportCriteria C INNER JOIN
													                      UserReport U ON C.ReportId = U.ReportId INNER JOIN
													                      Ref_ReportControlCriteria CR ON C.CriteriaName = CR.CriteriaName INNER JOIN
													                      Ref_ReportControlLayout L ON U.LayoutId = L.LayoutId AND CR.ControlId = L.ControlId
																 WHERE    U.ReportId = '#attributes.ReportId#'
																 AND      CR.Operational = 1
																 ORDER BY CriteriaOrder
																</cfquery>
															
															</cfcatch>
															
													</cftry>
													<tr>
														<td>
															
																<table cellpadding="0" cellspacing="0"  bgcolor="ffffff" border="0" width="100%" align="center">
																	<tr>
																		<td style="padding:2px">										
																			<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
																				<tr>
																					<td height="22px" bgcolor="ffffff" style="border-left:0px solid silver; border-bottom:1px solid silver; border-right:0px solid silver;">
																						<table cellpadding="0" cellspacing="0" border="0" align="center" width="100%" height="22px">
																							<tr>																																												
																								<td valign="left">
																									<font face="calibri" size="4" color="003059">
																										&nbsp;Applied content filtering criteria
																									</font>
																								</td>
																							</tr>
																						</table>
																					</td>
																				</tr>
																	
																				<tr>
																					<td valign="top">
																						<table cellpadding="0" cellspacing="0" border="0" width="100%" align="center">																
																							<cfloop query="Detail">
																							<cfif criteriavalue neq "">
																							<tr>
																								<td align="center" bgcolor="fbfbfb" style="border-left:0px solid silver; border-right:0px solid silver; border-bottom:1px dotted silver">
																									<table cellpadding="0" cellspacing="0" width="100%" border="0" align="center">
																										<tr>
																											<td height="20" width="260" style="padding-left:5px">
																												<font size="2" color="1562a4" face="calibri">
																													#CriteriaDescription#:
																												</font>
																											</td>
																											<td style="padding-left:4px;word-wrap: break-word; word-break: break-all;">
																												<font size="2" color="black" face="calibri">
																													<b>#CriteriaValue#
																												</font>
																											</td>
																										</tr>																									
																									</table>
																								</td>
																							</tr>																						
																							</cfif>	
																							</cfloop>
																						</table>
																					</td>
																				</tr>
																			</table>			
																		</td>
																	</tr>
																	
																	<tr>
																		<td height="6" bgcolor="ffffff"></td>
																	</tr>
																	
																	<cfif Param.DistributionMode neq "Attachment" or (Layout.LayoutClass eq "View" and layout.EnableAttachment eq "0")>			
																																						
																	<tr>
																		<td>
																			<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
																				<tr>
																					<td width="190" height="25" style="padding-left:10px">
																						<font face="calibri" size="2" color="FF0000">
																							*) paste the link in browser:
																						</font>
																					</td>
																				</tr>
																				<tr>	
																					<td bgcolor="ffffff" align="center" style="border-bottom:1px dotted silver;padding-left:35px;word-wrap: break-word; word-break: break-all;">
																						<font face="Calibri" size="3" color="0080C0">
																							<i>#rptserver#/Report.cfm?id=#URL.reportId#</i>
																						</font>
																					</td>
																				</tr>
																			</table>
																		</td> 
																	</tr>
																	
																	<tr>
																		<td height="3"></td>
																	</tr>
																	</cfif>
																	
																</table>
															
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
			</table>									  
		</cfmail>		
		
</cfif>
	
</cfif>

