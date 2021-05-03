	
<cfoutput>

	<cfif isdefined("session.status")>
		<cfset session.status = 1.0>
	</cfif>

	<cfquery name="Control" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  Ref_ReportControl
			WHERE ControlId = '#ControlId#'		
	</cfquery>

	<cfset head = "regular">
	<cfset btn  = "buttonPrint">

	
	<cfparam name="url.layoutid" default="">
	<cfparam name="url.portal" default="0">

	<cfif url.layoutid eq "">	
		<cfif reportId  eq "00000000-0000-0000-0000-000000000000">

			<cfquery name="ReportMenu" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT top 1 R.*, U.EnableAttachment
					FROM  Ref_ReportControlLayOut R INNER JOIN Ref_ReportControl U ON R.ControlId = U.ControlId 	
					WHERE R.ControlId = '#ControlId#'
					AND   R.Operational = 1
					AND   R.LayoutName != 'Export Fields to MS-Excel'		 
					UNION
					SELECT R.*, U.EnableAttachment
					FROM   Ref_ReportControlLayOut R INNER JOIN Ref_ReportControl U ON R.ControlId = U.ControlId 	
					WHERE  R.ControlId = '#ControlId#'
					AND    R.Operational = 1
					AND    R.LayoutName = 'Export Fields to MS-Excel'
					AND    R.ControlId IN (SELECT ControlId FROM Ref_ReportControlOutput)
					ORDER BY R.ListingOrder 		
			</cfquery>
			
			<cfset url.layoutclass = reportMenu.layoutclass>	

		<cfelse>

			<cfquery name="ReportMenu" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   U.*, L.*, R.EnableAttachment
					FROM     UserReport U INNER JOIN
					Ref_ReportControlLayout L ON U.LayoutId = L.LayoutId INNER JOIN
					Ref_ReportControl R ON L.ControlId = R.ControlId
					WHERE   U.ReportId = '#reportid#' 
			</cfquery>

			<cfset url.layoutclass = reportMenu.layoutclass>

		</cfif>

	<cfelse>

		<cfquery name="ReportMenu" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  * 
				FROM    Ref_ReportControl C INNER JOIN
				Ref_ReportControlLayout L ON C.ControlId = L.ControlId  
				WHERE   L.LayoutId = '#url.layoutid#' 
		</cfquery>

	</cfif>
	
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" onDblClick="printmenu()">	
		
		<tr class="line">		
			<td height="100%">	
				<table height="100%" border="0" cellspacing="0" cellpadding="0">	
					<tr>	
						<td style="padding:1px" colspan="2" height="100%">	
							<table height="100%" cellspacing="0" cellpadding="0">
								<tr>	
																   
									<td style="padding-left:4px">										
									
									<cfquery name="ShowReport" 
										datasource="AppsSystem" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT ControlId as ShowControlId, 
											(CASE WHEN ReportLabel is not NULL and ReportLabel != '' THEN ReportLabel ELSE FunctionName END) as ShowFunctionName											
											FROM   Ref_ReportControl C
											WHERE  SystemModule = '#Control.SystemModule#' 
											AND    Operational = '1' 
											AND    FunctionClass NOT IN ('System','Application') and TemplateSQL NOT IN ('Application')		
											AND      (LanguageCode  = '#Client.LanguageId#' or EnableLanguageAll = '1')
											 
											<cfif url.portal eq 1>
											AND    EnablePortal = 1
											AND	   EXISTS (SELECT LayoutId 
											               FROM   Ref_ReportControlLayout 
														   WHERE  ControlId = C.ControlId 
														   AND    Operational = 1 
														   AND    UserScoped = 1)
											</cfif>
											ORDER BY FunctionName
									</cfquery>			 
	
									<cfif ShowReport.recordcount gte "1" and Control.Operational eq "1">	
										<cfoutput>
										<cf_tl id="Select another report to which you have been granted access" Class="Message" var="1"> 
										
										<cf_UIToolTip tooltip="<table><tr><td>#lt_text#</td></tr></table>">
										
										<select name="myreport" 
										    id="myreport"
											class="regularxl" 
											style="border:0px;background-color:f1f1f1;font-size:18px;height:36px;width:400px"
											onChange="Prosis.busy('yes');reload(this.value,'#url.portal#')">	

											<option value=""><cfif Control.ReportLabel neq "">#Control.ReportLabel#<cfelse>#Control.FunctionName#</cfif></option>	
											
											<cfloop query="ShowReport">	
											
												<cfinvoke component="Service.AccessReport"  
													method="report"  
													ControlId="#ShowReport.ShowControlId#" 
													returnvariable="access">	
													
												<cfif ShowControlId neq ReportMenu.ControlId>	
												
													<CFIF access is "GRANTED"> 
														<option value="#ShowControlId#">#ShowFunctionName#</option>
													</cfif>	
												</cfif>	
												
											</cfloop>	
										</select>	
										
										</cf_UIToolTip>
										
										</cfoutput>
										
									</cfif>	
															
									</td>
								</tr>
							</table>	
						</td>	
					</tr>
				</table>	
			</td>	
			
			<td height="100%" id="stopping" class="labelit"></td>	
			
			<td height="100%" id="gobox" class="hide">
			</td>	
			
			<cfset vBWidth = "170px">
			<cfset vBHeight = "36px">
			<cfset vBTextSize = "16px">
			<cfset vBBorderColor = "##C0C0C0">
			<cfset vBMouseOverBorderColor = "##9BC9EE">
			<cfset vBBGColor = "##FCFCFC">
			<cfset vTextColor = "##003578">
			
			<td height="100%" align="right" style="padding-top:3px">	
				<table height="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
					<tr >	
						<td height="100%" valign="top" class="hide" align="center" id="stop" style="border: 0px solid Silver;">	
							<cf_tl id="Stop" var="vStop">
							<cf_button2 id="aborting" 
							    onclick="abort();" 
								width="#vBWidth#"
								height="#vBHeight#"
								text="#vStop#" 
								bgcolor="#vBBGColor#" 
								textsize="#vBTextSize#"
								textColor="#vTextColor#" 
								borderRadius="3px"
								borderColor="#vBBorderColor#"
								style="border:1px solid #vBBorderColor#;"
								image="stop.png"
								onmouseover="this.style.border='1px solid #vBMouseOverBorderColor#';"
								onmouseout="this.style.border='0px solid #vBBorderColor#';">
						</td>	
						<td height="100%" id="buttons" valign="top">
							<!--- <input type="hidden" name="start" id="start" onclick="init()"> --->
							<input type = "submit" class="hide" name="load" id="load" value = "Load in Excel">		
							<table height="100%" border="0" cellspacing="0" cellpadding="0" class="formspacing">	
								<tr>	
									<td height="100%" valign="top">
										<cf_tl id="Open Report" var="vOpenReport">
										<cf_button2 id="preview" 
										    onclick="perform('preview'); " 
											width="#vBWidth#"
											height="#vBHeight#"
											text="#vOpenReport#" 
											bgcolor="#vBBGColor#" 
											textsize="#vBTextSize#" 
											textColor="#vTextColor#"
											borderRadius="5px"
											borderColor="##cccccc"
											style="border:0px solid #vBBorderColor#;"
											image="blue_report.png"
											onmouseover="this.style.border='1px solid #vBMouseOverBorderColor#';"
											onmouseout="this.style.border='0px solid #vBBorderColor#';">
									</td>	
									<td height="100%" valign="top">
										<cf_tl id="Reset" var="vReset">
										<cf_button2 id="set" 
										    onclick="resetme('#controlid#','#reportid#')" 
											width="180"
											height="#vBHeight#"
											text="#vReset#" 
											bgcolor="#vBBGColor#" 
											textsize="#vBTextSize#" 
											textColor="#vTextColor#"
											borderRadius="3px"
											borderColor="#vBBorderColor#"
											style="border:0px solid #vBBorderColor#;"
											image="blue_reset.png"
											onmouseover="this.style.border='1px solid #vBMouseOverBorderColor#';"
											onmouseout="this.style.border='0px solid #vBBorderColor#';">							
									</td>										
									<td height="100%" valign="top">
										<cfif (reportMenu.layoutclass eq "view" 
										and reportMenu.enableAttachment eq "0") or reportMenu.templatereport eq "Excel" or control.menuclass eq "Analysis">
										<!--- do not show eMail button --->
										<cfelse>	
											   
											<cf_tl id="Mail" var="vEmail">
											<cf_button2 id="email" 
											    onclick="perform('email')" 
												width="180"
												height="#vBHeight#"
												text="#vEmail#" 
												bgcolor="#vBBGColor#" 
												textsize="#vBTextSize#" 
												textColor="#vTextColor#"
												borderRadius="3px"
												borderColor="#vBBorderColor#"
												style="border:0px solid #vBBorderColor#;"
												image="blue_eMail.png"
												onmouseover="this.style.border='1px solid #vBMouseOverBorderColor#';"
												onmouseout="this.style.border='0px solid #vBBorderColor#';">
											   
										</cfif>
									</td>
									
									<cfparam name="url.context" default="standard">
									
									<cfif url.context neq "embed">
									
									<td height="100%" valign="top">	
									
										<cfif Control.enableButtonBack eq "1">	
										
											<cf_tl id="Back" var="vBack">
											<cf_button2 id="back" 
											    onclick="parent.history.back()" 
												width="180"
												height="#vBHeight#"
												text="#vBack#" 
												bgcolor="#vBBGColor#" 
												textsize="#vBTextSize#" 
												textColor="#vTextColor#"
												borderRadius="3px"
												borderColor="#vBBorderColor#"
												style="border:0px solid #vBBorderColor#;"
												image="blue_back.png"
												onmouseover="this.style.border='1px solid #vBMouseOverBorderColor#';"
												onmouseout="this.style.border='0px solid #vBBorderColor#';">
												
										</cfif>	
										
									</td>	
									
									</cfif>
									
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
	</cfoutput>	