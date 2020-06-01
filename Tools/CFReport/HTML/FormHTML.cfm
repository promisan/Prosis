
<cfparam name="URL.height"  default="#client.height#">					
<cfparam name="URL.Context" default="Default">	
		
<cfinclude template="FormHTMLScript.cfm">  
<style>
    #menu1,
    #menu2,
    #menu3,
    #menu4,
    #menu5,
    #menu6{
        padding: 8px 5px 10px !important;
        border-bottom: 1px solid #dddddd!important;
    }
    #menu1:hover,
    #menu2:hover,
    #menu3:hover,
    #menu4:hover,
    #menu5:hover,
    #menu6:hover{
        background:#eeeeee!important;
    }

    #menu1 .labelmedium,
    #menu2 .labelmedium,
    #menu3 .labelmedium,
    #menu4 .labelmedium,
    #menu5 .labelmedium,
    #menu6 .labelmedium{
        padding: 0!important;
        font-size: 13px;
        
    }
</style>			
<cfoutput>	

	<cf_tl id="Web reporter" var="label">
	
	<cf_screentop layout="webapp" label="#label#">
	
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">	
	<tr><td style="padding-left:10px;padding-right:10px;padding-bottom:5px">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">	
	    
		<tr>
			<td style="padding:2px; height:30">
				<cfdiv id="reportmenu">				
					<cfinclude template="FormHTMLMenu.cfm">							
				</cfdiv>
			</td>			
		</tr>	
				
		<tr><td style="padding-left:4px;padding-right:4px;padding-bottom:4px">
		<table width="100%" height="100%">
		
		<tr>
		
			<!--- right bar --->	
			
			<cfif url.context neq "embed">
			
			<td width="150" style="padding-right:5px" height="100%" align="center" valign="top">	
			
				<table width="100%" align="center">	
				<!--- <tr><td><cf_space spaces="30"></td></tr> --->	
		
					<!--- ------------------ --->
					<!--- 1. Criteria Option --->
					<!--- ------------------ --->					
					<tr>
						<td id="menu1" class="highlight" style="padding:3px;" align="center" onclick="toggle('reportcriteria','menu1')">
							<cf_space spaces="25"> 
							<table width="100%" align="center" style="cursor:pointer">
								<tr>
									<td align="center">									
										<img src="#SESSION.root#/Images/Report/criteria.png" width="48">
									</td>
								</tr>
								<tr>
									<td align="center" class="labelmedium">
										<cf_tl id="Criteria and Subscription">
									<td>
								</tr>
							</table>	
						</td>
					</tr>
	
					<!--- ------------------- --->
					<!--- 2. Report preview-- --->
					<!--- ------------------- --->							
					<tr id="reportshow" class="hide">
						<td id="menu2" style="padding:3" align="center" class="regular" <cfif client.browser eq "Explorer">onclick="toggle('reportbox','menu2')"<cfelse>onclick="perform('preview');"</cfif>>	
							<table width="100%" align="center" style="cursor:pointer">
							<tr><td height="0"></td></tr>
								<tr>
									<td align="center">
										<img src="#SESSION.root#/Images/Report/Preview.png" width="48">
									</td>
								</tr>	
								<tr>
									<td align="center" class="labelit">
										<cf_tl id="Preview">
									<td>
								</tr>
							</table>	
						</td>
					</tr>
	
					<!--- ------------------ --->
					<!--- 3. Report Info---- --->
					<!--- ------------------ --->				
					<cfset sc = "HTML/FormHTMLAbout.cfm?reportid=#reportId#&controlid=#controlid#">					
					<tr><td height="0"></td></tr>
					<tr>
						<td id="menu3" style="padding:3" class="regular" align="center" onclick="toggle('reportother','menu3');ColdFusion.navigate('#sc#','reportselection')">	
							<table width="100%" align="center" style="cursor:pointer">
								<tr>
									<td align="center">
										<img src="#SESSION.root#/Images/Report/about.png" width="48">
									</td>
								</tr>
								<tr>
									<td align="center" class="labelmedium">
										<cf_tl id="About">
									<td>
								</tr>
							</table>	
						</td>
					</tr>
					<tr><td height="0"></td></tr>
					
					<cfif Report.TemplateSQL eq "SQL.cfm">
						<cfset sc = "#SESSION.root#/Tools/CFreport/ReportSQL8.cfm?mode=Form&controlId=#ControlId#&reportId=#ReportId#&GUI=HTML&formselect=sql">	
						<tr>
							<td id="menu4" style="padding:3" align="center" class="regular" onclick="toggle('reportother','menu4');ptoken.navigate('#sc#','reportselection','','','POST','selection')">	
								<table width="100%" align="center" style="cursor:pointer">
									<tr>
										<td align="center">
											<img src="#SESSION.root#/Images/Report/script.png" width="48">
										</td>
									</tr>
									<tr>
										<td align="center" class="labelmedium">
											<cf_tl id="Script">
										<td>
									</tr>
								</table>	
							</td>
						</tr>		
						<tr><td height="0"></td></tr>			
					</cfif>
	
					<!--- ------------------ --->
					<!--- 5. Data source Info --->
					<!--- ------------------ --->					
					<cfif Report.DataSource neq "">
					
					<!--- <cfset sc = "HTML/FormHTMLUpload.cfm?datasource=#report.datasource#">	
					<tr>
						<td id="menu5" style="padding:3" align="center" class="regular" onclick="toggle('reportother','menu5');ptoken.navigate('#sc#','reportselection')">	
							<table width="100%" align="center" style="cursor:pointer">
								<tr>
									<td align="center">
										<img src="#SESSION.root#/Images/Report/source.gif" width="48">
									</td>
								</tr>
								<tr>
									<td align="center" class="labelmedium">
										<cf_tl id="Data source">
									<td>
								</tr>
							</table>	
						</td>
					</tr>	
					<tr><td height="0"></td></tr>			 --->	
					
					</cfif>	
	
					<!--- -------------------------- --->
					<!--- 6. Logging Report Info---- --->
					<!--- -------------------------- --->					
					<cf_listingscript>					
					<cfset sc = "HTML/FormHTMLLog.cfm?reportid=#reportId#&controlid=#controlid#">	
					<tr>
						<td id="menu6" style="padding:3" align="center" class="regular" onclick="toggle('reportother','menu6');ptoken.navigate('#sc#','reportselection')">	
							<table width="100%" style="cursor:pointer">
								<tr>
									<td align="center">
										<img src="#SESSION.root#/Images/Report/log.png" width="48">
									</td>
								</tr>
								<tr>
									<td align="center" class="labelmedium">
										<cf_tl id="Archive">
									<td>
								</tr>
							</table>	
						</td>
					</tr>	
				</table>	
			</td>	
			
			</cfif>		
		
			<td valign="top" width="93%" style="border-left:solid 1px c4c4c4;background-color:##FCFCFC;" height="100%">
			
				<cfquery name="Parameter" 
					datasource="AppsInit">
						SELECT * 
						FROM Parameter
						WHERE HostName = '#CGI.HTTP_HOST#'
				</cfquery>  	
				
				<table width="100%" 
				       height="100%" 					  
					   style="">	  	
				
				    <!--- criteria box --->
									
					<tr id="reportcriteria" class="regular">
					
						<td valign="top" style="height:100%">		     
						
						 <cf_divscroll style="height:100%">						 
						
							<cfdiv id="criteria">
							<cfset url.controlid = controlid>
							<cfset url.reportid = reportid>
																																			
								<cfinclude template="FormHTMLVariant.cfm">							
								
							</cfdiv> 
							
						 </cf_divscroll>	
							
						</td>
					</tr>	
					
					<!--- report preview box : please keep it as xhide, otherwise the progressbar displays incorrectly --->	
					
					<tr id="reportbox" class="xhide" style="height:0%">	
					
						<td style="height:1%"> 
						
							<cf_divscroll overflowy="hidden" style="height:100%">
							
							<table width="100%" height="100%" cellspacing="0" cellpadding="0">	
							
								<tr id="myprogressbox">								
															
									<td height="60" style="padding-top:5px" align="center">	
											
											<cfif isDefined("Session.status")>
												<cfscript>
													StructDelete(Session,"Status");
												</cfscript>
											</cfif>											
											
											<cfquery name="get"
											datasource="AppsSystem" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												SELECT   TOP 1 PreparationMillisecond
												FROM     UserReportDistribution
												WHERE    ControlId = '#url.controlid#' 
												AND      Account   = '#SESSION.acc#'
												ORDER BY Created DESC 
											</cfquery>																												
											
											<cfif get.PreparationMillisecond gte "500">																								
											
												<cfprogressbar name="pBar" 
														style="bgcolor:f4f4f4;progresscolor:0080C0" 
														duration="#get.PreparationMillisecond#" 
														height="19" 
														interval="240" 																											
														autoDisplay="false" 
														width="506"/>  
											
											<cfelse>
											
											<cfprogressbar name="pBar" 
													style="bgcolor:f4f4f4;progresscolor:0080C0" 
													bind="cfc:Service.Authorization.AuthorizationBatch.getstatus()" 
													height="19" 
													interval="240" 																								
													autoDisplay="false" 
													width="506"/>  
													
											</cfif>		
																							
									</td>
								</tr>	
																																					
								<tr id="myreportcontent" height="100%">
									<td  style="border:0px solid silver">	
										
										<cfif client.browser eq "Chrome">
												
											<cf_divscroll overflowy="hidden">
												<iframe name="report" 
												id="report" 
												scrolling="auto" style="height:100%; width:100%" 
												frameborder="0">																					
												</iframe>	
											</cf_divscroll>																			
											
										<cfelseif client.browser eq "Safari">
										
											<table height="100%" width="100%">
													<tr>
														<td>
															<iframe name="report" 
																id="report" 
																scrolling="auto" style="height:100%; width:100%; overflow-y:scroll" 
																frameborder="0">																								
															</iframe>	
														</td>
													</tr>
												</table>	
										<cfelse>
																									
												<iframe name="report" 
												id="report" 																								
												scrolling="auto" 
												style="border:0px;height:100%; width:100%" 
												frameborder="1"></iframe>													
																			
										</cfif>
							
									</td>
									
									
								</tr>
																
							</table>
							</cf_divscroll>
						</td>	
					</tr>	
					
					<!--- miscellaneous box, ajax load --->	  
					<tr class="hide" id="reportother">		  
						<td valign="top" height="1%">
						<cf_divscroll id="reportselection"></cf_divscroll>
						</td>
					</tr>						
					
				</table>	
				
			</td>	
			
			<cfif url.context eq "embed">
			
			<td width="150" style="padding-left:5px" height="100%" align="center" valign="top">	
						
				<table width="100%" align="center">	
				<!--- <tr><td><cf_space spaces="30"></td></tr> --->	
		
					<!--- ------------------ --->
					<!--- 1. Criteria Option --->
					<!--- ------------------ --->					
					<tr>
						<td id="menu1" class="highlight" style="padding:3px;" align="center" onclick="toggle('reportcriteria','menu1')">
							<cf_space spaces="25"> 
							<table width="100%" align="center" style="cursor:pointer">
								<tr>
									<td align="center">
										<img src="#SESSION.root#/Images/Report/criteria.png" width="48">
									</td>
								</tr>
								<tr>
									<td align="center" class="labelmedium">
									    <cf_tl id="Criteria and Subscription">
									<td>
								</tr>
							</table>	
						</td>
					</tr>
	
					<!--- ------------------- --->
					<!--- 2. Report preview-- --->
					<!--- ------------------- --->							
					<tr id="reportshow" class="hide">
						<td id="menu2" style="padding:3" align="center" class="regular" <cfif client.browser eq "Explorer">onclick="toggle('reportbox','menu2')"<cfelse>onclick="perform('preview');"</cfif>>	
							<table width="100%" align="center" style="cursor:pointer">
							<tr><td height="0"></td></tr>
								<tr>
									<td align="center">
										<img src="#SESSION.root#/Images/Report/Preview.png" width="48">
									</td>
								</tr>	
								<tr>
									<td align="center" class="labelit">
										<cf_tl id="Preview">
									<td>
								</tr>
							</table>	
						</td>
					</tr>
	
					<!--- ------------------ --->
					<!--- 3. Report Info---- --->
					<!--- ------------------ --->				
					<cfset sc = "HTML/FormHTMLAbout.cfm?reportid=#reportId#&controlid=#controlid#">					
					<tr><td height="0"></td></tr>
					<tr>
						<td id="menu3" style="padding:3" class="regular" align="center" onclick="toggle('reportother','menu3');ColdFusion.navigate('#sc#','reportselection')">	
							<table width="100%" align="center" style="cursor:pointer">
								<tr>
									<td align="center">
										<img src="#SESSION.root#/Images/Report/about.png" width="48">
									</td>
								</tr>
								<tr>
									<td align="center" class="labelmedium">
										<cf_tl id="About">
									<td>
								</tr>
							</table>	
						</td>
					</tr>
					<tr><td height="0"></td></tr>
					<cfif Report.TemplateSQL eq "SQL.cfm">					
					<cfset sc = "#SESSION.root#/Tools/CFreport/ReportSQL8.cfm?mode=Form&controlId=#ControlId#&reportId=#ReportId#&GUI=HTML&formselect=sql">	
					<tr>
						<td id="menu4" style="padding:3" align="center" class="regular" onclick="toggle('reportother','menu4');ColdFusion.navigate('#sc#','reportselection','','','POST','selection')">	
							<table width="100%" align="center" style="cursor:pointer">
								<tr>
									<td align="center">
										<img src="#SESSION.root#/Images/Report/script.png" width="48">
									</td>
								</tr>
								<tr>
									<td align="center" class="labelmedium">
										<cf_tl id="Script">
									<td>
								</tr>
							</table>	
						</td>
					</tr>		
					<tr><td height="0"></td></tr>			
					</cfif>
	
					<!--- ------------------ --->
					<!--- 5. Data source Info --->
					<!--- ------------------ --->					
					<cfif Report.DataSource neq "">
					
					<cfset sc = "HTML/FormHTMLUpload.cfm?datasource=#report.datasource#">	
					<tr>
						<td id="menu5" style="padding:3" align="center" class="regular" onclick="toggle('reportother','menu5');ColdFusion.navigate('#sc#','reportselection')">	
							<table width="100%" align="center" style="cursor:pointer">
								<tr>
									<td align="center">
										<img src="#SESSION.root#/Images/Report/source.gif" width="48">
									</td>
								</tr>
								<tr>
									<td align="center" class="labelmwedium">
										<cf_tl id="Data source">
									<td>
								</tr>
							</table>	
						</td>
					</tr>	
					<tr><td height="0"></td></tr>				
					</cfif>	
	
					<!--- -------------------------- --->
					<!--- 6. Logging Report Info---- --->
					<!--- -------------------------- --->					
					<cf_listingscript>					
					<cfset sc = "HTML/FormHTMLLog.cfm?reportid=#reportId#&controlid=#controlid#">	
					<tr>
						<td id="menu6" style="padding:3" align="center" class="regular" onclick="toggle('reportother','menu6');ColdFusion.navigate('#sc#','reportselection')">	
							<table width="100%" style="cursor:pointer">
								<tr>
									<td align="center">
										<img src="#SESSION.root#/Images/Report/log.png" width="48">
									</td>
								</tr>
								<tr>
									<td align="center" class="labelmedium">
										<cf_tl id="Archive">
									<td>
								</tr>
							</table>	
						</td>
					</tr>	
				</table>	
			</td>	
			
			</cfif>		
			
		</tr>	
		
		</table>
		</td></tr>				
		
		</cfoutput>		
			
	</table>	
	
	</td></tr>
	</table>
	
	<cf_screenbottom layout="webapp">
	
<cfset ajaxonload("function() { doCalendar(); }")>
		
