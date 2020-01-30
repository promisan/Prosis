
<cfparam name="url.action" 	default="">
<cfparam name="url.account" default="">
<cfparam name="url.node" 	default="">
<cfparam name="url.host" 	default="">
<cfparam name="url.initial"	default="">
<cfparam name="url.end"		default="">

<cfset vInitialDate = now()>
<cfset vEndDate = now()>

<cfif url.initial neq "">
	<cfset vInitialDate = createDate(mid(url.initial,1,4),mid(url.initial,5,2),mid(url.initial,7,2))>
</cfif>

<cfif url.end neq "">
	<cfset vEndDate = createDate(mid(url.end,1,4),mid(url.end,5,2),mid(url.end,7,2))>
</cfif>

<cfset vEndDate = dateAdd('d',1,vEndDate)>
<cfset vEndDate = dateAdd('l',-1,vEndDate)>

<cfquery name="get" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	A.*,
				(CAST(datePart(year,ActionTimeStamp) AS varchar) + ' ' + CAST(datePart(month,ActionTimeStamp) AS varchar)) as Month,
				(CAST(datePart(day,ActionTimeStamp) AS varchar)) as Day,
				(SELECT FirstName + ' ' + LastName FROM UserNames WHERE Account = A.Account) as FullName
		FROM   	UserActionModule A
		WHERE  	A.SystemFunctionId = '#url.id#'
		<cfif url.filter eq 0>
			AND	A.ActionTimeStamp >=
									(
										SELECT TOP 1 (CONVERT(DateTime, LimitDate))
										FROM
											(
												SELECT DISTINCT TOP #url.lastNDays# CONVERT(VARCHAR, ActionTimeStamp, 112) AS LimitDate
												FROM	UserActionModule 
												WHERE	SystemFunctionId = '#url.id#'
												<!--- AND		ActionDescription != 'Open Function' --->
												ORDER BY CONVERT(VARCHAR, ActionTimeStamp, 112) DESC
											) AS D
										ORDER BY LimitDate ASC
									)
			
			<!--- AND	lower(ltrim(rtrim(A.ActionDescription))) != 'open function' --->
		</cfif>
		<cfif url.action neq "">
		AND		A.ActionDescription = '#url.action#'
		</cfif>
		<cfif url.account neq "">
		AND		A.Account = '#url.account#'
		</cfif>
		<cfif url.node neq "">
		AND		A.NodeIP = '#url.node#'
		</cfif>
		<cfif url.host neq "">
		AND		A.HostName = '#url.host#'
		</cfif>
		<cfif url.initial neq "" and url.end neq "">
		AND		A.ActionTimeStamp BETWEEN #vInitialDate# AND #vEndDate#
		</cfif>
		ORDER BY A.ActionTimeStamp DESC		
		
</cfquery>

<table width="100%" align="center">

	<tr><td height="5" colspan="2"></td></tr>
	
	<cfif get.recordCount eq 0>
		<tr><td height="35" colspan="2" style="color:808080;font-size:18px;" align="center">[No logs found]</td></tr>
	<cfelse>
		<tr>
			<td id="tdHideAll" colspan="2" height="25" style="display:none;" valign="middle">
				<cfoutput>
					<label onclick="hideAllDetails();" style="cursor:pointer;">
						<img src="#SESSION.root#/images/collapse.png" align="absmiddle" height="13"><font face="Calibri" size="2">&nbsp;Hide all details
					</label>
				</cfoutput>
			</td>
		</tr>
	</cfif>
	
	<cfoutput query="get" group="Month">

		<tr><td colspan="2" style="font-size:30px;">#dateFormat(ActionTimeStamp,'mmmm yyyy')#</td></tr>
		
		<tr><td height="3"></td></tr>
		<tr><td colspan="2" height="1" style="border-bottom:1px solid ##C0C0C0;"></td></tr>
		<tr><td height="4"></td></tr>

		<cfoutput group="Day">
		
			<tr>
				<td align="center" valign="top" width="10%">
					<table>
						<tr>
							<td width="5"></td>
							<td align="center" valign="top" style="padding-top:3px">
							
								<cfset thisDay = dateFormat(ActionTimeStamp,'d')>
								<cfset daySuffix = "">
								<cfif thisDay eq 1 or thisDay eq 21 or thisDay eq 31>
									<cfset daySuffix = "st.">
								<cfelseif thisDay eq 2 or thisDay eq 22>
									<cfset daySuffix = "nd.">
								<cfelseif thisDay eq 3 or thisDay eq 23>
									<cfset daySuffix = "rd.">
								<cfelse>
									<cfset daySuffix = "th.">
								</cfif>
								
								<table width="100%">
									<tr>
										<td style="font-size:23px; font-weigth:bold;" align="right">#dateFormat(ActionTimeStamp,'d')#</td>
										<td style="font-size:13px; font-weigth:bold; padding-top:2px;" valign="top">#daySuffix#</td>
									</tr>
									<tr>
										<td colspan="2" align="center" style="font-size:10px;">
											#dateFormat(ActionTimeStamp,'dddd')#
										</td>
									</tr>
									<tr>
										<td colspan="2" align="center" style="font-size:10px;">
											<cfif dateFormat(ActionTimeStamp,'yyyy mm dd') eq dateFormat(now(),'yyyy mm dd')>(<i>Today</i>)</cfif>
											<cfif dateFormat(ActionTimeStamp,'yyyy mm dd') eq dateFormat(dateAdd('d',-1,now()),'yyyy mm dd')> (<i>Yesterday</i>)</cfif>
										</td>
									</tr>
								</table>
								
							</td>
						</tr>
					</table>
				</td>
				
				<td style="border-left:2px solid ##C0C0C0;" valign="top">
					<table width="100%" align="center">
						<cfoutput>
							<tr>
								<td onMouseOver="this.bgColor='FFFFCF'" 
									onMouseOut="this.bgColor=''" bgcolor="" 
									style="font-size:11px; padding-left:5px;">
										<table width="100%" align="center">
											<tr>
												<td width="15%" title="time">
													<cfif lcase(trim(ActionDescription)) neq "open function">
														<a href="javascript: viewLoggingDetail('#moduleActionId#', '#lcase(ActionDescription)#');" id="btnViewDetail_#moduleActionId#" style="color:1E70D2;" title="view #lcase(ActionDescription)# detail">
															#timeFormat(ActionTimeStamp,'hh:MM:SS TT')#
														</a>
													<cfelse>
														#timeFormat(ActionTimeStamp,'hh:MM:SS TT')#
													</cfif>
												</td>
												<td width="15%" title="action">#ActionDescription#</td>
												<td width="15%" title="account">#account#</td>
												<td width="25%" title="name">#FullName#</td>
												<td width="15%" title="IP address">#NodeIP#</td>
												<td width="15%" title="host">#ucase(HostName)#</td>
											</tr>
										</table>
								</td>
							</tr>
							<tr><td height="2"></td></tr>
							<tr>
								<td style="padding-left:5px;">
									<div 
										id="detailPanel_#moduleActionId#" 
										class="detailPanel" 
										style="display:none;height:215px;width:100%;overflow:auto;">
											<table width="100%">
												<tr>
													<td valign="top" align="right">
														<img src="#SESSION.root#/images/join.gif">
													</td>
													<td width="99%" id="loggingDetail_#moduleActionId#"></td>
												</tr>
											</table>
									</div>
								</td>
							</tr>
						</cfoutput>
					</table>
				</td>			
			</tr>
			
			<tr><td colspan="2" height="1" style="padding-top:4px;padding-bottom:4px;border-bottom:1px solid ##C0C0C0;"></td></tr>
			
		</cfoutput>
		
		<tr><td height="10"></td></tr>
		
	</cfoutput>
	
</table>