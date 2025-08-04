<!--
    Copyright © 2025 Promisan

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
<cfparam name="url.mode" default="0"> <!--- pending --->

<cf_screentop html="no" jquery="yes">

<cf_presentationScript>
<cf_paneScript>
<cf_layoutScript>
<cf_calendarScript>

<cfajaximport tags="cfform">

<cfset vItemSize = 425>
<cfset vItemOffset = 42>

<cfif url.mode eq "0">
	<cfset modestatus = " < '3' ">
<cfelse>
    <cfset modestatus = " = '3' ">
</cfif>

<cfoutput>
	<script>
		var globalChartCount = 0;
		
		function reloadview(p) {
			window.location.href = '#session.root#/System/Portal/Support/Summary/SummaryPanel.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&mode='+p;
		}
		
		function summaryPanelApplyFilter(dte){
			ptoken.navigate('#session.root#/System/Portal/Support/Summary/SummaryPanelDetail.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&itemSize=#vItemSize#&itemOffset=#vItemOffset#&accFilter='+$('##filterAcc').val()+'&statusFilter='+$('##filterStatus').val()+'&sortingFilter='+$('##filterSorting').val()+'&dateFilter='+$('input[name=filterDate_date').val()+'&classFilter='+$('##filterClass').val()+'&mode='+$('input[name=Mode]:checked').val(),'divSummaryPanel');
		}
		
		function addNewChart(sel){
			var paramBy = $('##supportChartBy').val();
			var paramType = $('##supportChartType').val();
			var paramInitDate = $('##supportChartEffective').val();
			var paramEndDate = $('##supportChartExpiration').val();
			
			globalChartCount = globalChartCount + 1;
			
			var newDiv = '<div id="supportChart_'+globalChartCount+'" name="supportChart_'+globalChartCount+'" class="clsChartContainer"></div>';
			$(newDiv).prependTo(sel);			
			ptoken.navigate('#session.root#/System/Portal/Support/Summary/Statistics/setGraph.cfm?id='+globalChartCount+'&by='+paramBy+'&type='+paramType+'&init='+paramInitDate+'&end='+paramEndDate,'supportChart_'+globalChartCount);
		}
		
		function removeChart(id) {
			$('##supportChart_'+id).remove();
		}
		
		function supportDrill(val,item,series,id) {
			var paramBy = $('##supportChartBy').val();
			var paramInitDate = $('##supportChartEffective').val();
			var paramEndDate = $('##supportChartExpiration').val();
			
			ptoken.navigate('#session.root#/System/Portal/Support/Summary/Statistics/drillDetail.cfm?val='+val+'&item='+item+'&series='+series+'&by='+paramBy+'&init='+paramInitDate+'&end='+paramEndDate+'&id='+id,'bottom');
			expandArea('ticketSummaryPanelLayout', 'bottom');
		}
		
	</script>
</cfoutput>

<cfquery name="getSystemParameter" datasource="AppsSystem">
	SELECT TOP 1 *
	FROM   Parameter
</cfquery>

<cfquery name="getUnassigned" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	COUNT(*) AS Tickets
		FROM	[#getSystemParameter.ControlServer#].Control.dbo.Observation O 
		WHERE   ObservationId NOT IN (SELECT OO.ObjectId
									  FROM   OrganizationObjectActionAccess OAS INNER JOIN OrganizationObject OO ON OAS.ObjectId = OO.ObjectId														
									  WHERE	 OO.EntityCode = 'SysTicket'
									  AND	 OO.ObjectId = O.ObservationId)
		AND     O.ActionStatus #preservesingleQuotes(modestatus)#
		AND		O.ObservationClass = 'Inquiry'
		
		<cfif session.isAdministrator eq "No">
		
		AND    O.Mission IN (SELECT Mission 
		                     FROM   Organization.dbo.OrganizationAuthorization  
							 WHERE  UserAccount = '#session.acc#'
							 AND    Role        = 'OrgUnitManager'
							 AND    Mission     = O.Mission)
		
		</cfif>
</cfquery>


<cfquery name="getSummaryActors" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	UserAccount, 
				FirstName, 
				LastName,
				COUNT(*) AS Tickets
		FROM	(
					SELECT DISTINCT
							O.ObservationId,	
							OAS.UserAccount, 
							U.FirstName, 
							U.LastName
					FROM   	OrganizationObjectActionAccess OAS 
							INNER JOIN OrganizationObject OO
								ON OAS.ObjectId = OO.ObjectId
							INNER JOIN System.dbo.UserNames U 
								ON OAS.UserAccount = U.Account
							INNER JOIN [#getSystemParameter.ControlServer#].Control.dbo.Observation O
								ON OO.ObjectId = O.ObservationId
					WHERE	OO.EntityCode = 'SysTicket'
					AND		O.ObservationClass = 'Inquiry'
					AND		O.ActionStatus #preservesingleQuotes(modestatus)#
					<cfif session.isAdministrator eq "No">
		
					AND    O.Mission IN (SELECT Mission 
					                     FROM   Organization.dbo.OrganizationAuthorization  
										 WHERE  UserAccount = '#session.acc#'
										 AND    Role        = 'OrgUnitManager'
										 AND    Mission     = O.Mission)
					
					</cfif>
					
					
					
				) AS Data
		GROUP BY
				UserAccount, 
				FirstName, 
				LastName
		ORDER BY 4 DESC
</cfquery>

<cfquery name="getClasses" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT
				EC.EntityClass,
				EC.EntityClassName
		FROM	OrganizationObject OO
				INNER JOIN Ref_EntityClass EC
					ON OO.EntityCode = EC.EntityCode
					AND OO.EntityClass = EC.EntityClass
		WHERE	EC.EntityCode = 'SysTicket'
		AND		EC.Operational = 1
</cfquery>

<cf_layout type="border" id="ticketSummaryPanelLayout">

	<cf_layoutArea 
		name="left" 
		position="left" 
		size="13%" 
		minSize="225px"
		collapsible="true" 
		initCollapsed="false"
		onshow="_pane_resizeMenuItems('#vItemSize#', #vItemOffset#);"
		onhide="_pane_resizeMenuItems('#vItemSize#', #vItemOffset#);">
			
			<cf_divScroll width="100%" height="100%">
				<table width="98%" align="center">
								
					<tr class="line"><td height="10" style="height:40px;padding-top:5px" colspan="2">
						
						<table>
						<tr class="labelmedium">
						<td style="padding-left:4px"><input onclick="javascript:reloadview('0')" class="radiol" type="radio" name="Mode" value="0" <cfif url.mode eq 0>checked</cfif>></td>
						<td>Pending</td>
						<td  style="padding-left:4px"><input onclick="javascript:reloadview('1')" class="radiol" type="radio" name="Mode" value="1" <cfif url.mode eq 1>checked</cfif>></td>
						<td>Completed</td>
						</tr>
						</table>					
					
					</td>
					</tr>
					
					<cfif url.mode eq "0">
										
					<tr>
						<td class="labelmedium" width="20%" style="padding-left:10px;font-weight:bold;"><cf_tl id="Status"></td>
					</tr>
					<tr>
						<td colspan="2" align="right" style="padding-left:10px;padding-right:10px">
						
							<cfquery name="getStatus" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT	R.*, 
									( SELECT count(*) 
									  FROM  [#getSystemParameter.ControlServer#].Control.dbo.Observation O
									  WHERE	ObservationClass = 'Inquiry'
									  <cfif session.isAdministrator eq "No">
		
										AND    Mission IN (SELECT Mission 
									                     FROM   Organization.dbo.OrganizationAuthorization  
														 WHERE  UserAccount = '#session.acc#'
														 AND    Role        = 'OrgUnitManager'
														 AND    Mission     = O.Mission)
									
									  </cfif>					  
									  
									  AND   ActionStatus = R.EntityStatus) as Tickets
									
									FROM	Ref_EntityStatus R
									WHERE	R.EntityCode = 'SysTicket'
									AND		R.EntityStatus #preservesingleQuotes(modestatus)#
									
									
									
									AND		EXISTS
											(
												SELECT	'X'
												FROM	[#getSystemParameter.ControlServer#].Control.dbo.Observation O 
														INNER JOIN Ref_EntityStatus Rx 
															ON O.ActionStatus = Rx.EntityStatus
												WHERE	Rx.EntityCode       = 'SysTicket'
												AND		O.ObservationClass = 'Inquiry'
												AND		O.ActionStatus = R.EntityStatus
											)
									ORDER BY R.EntityStatus ASC
							</cfquery>
							
							<cfoutput>
								<select 
									name="filterStatus" 
									id="filterStatus" 
									class="regularxl" 
									onchange="summaryPanelApplyFilter();"
									style="width:100%; height:75px;" 
									multiple>
										<cfloop query="getStatus">
											<option value="'#EntityStatus#'"> #StatusDescription# (#Tickets#)
										</cfloop>
								</select>
							</cfoutput>
						</td>
					</tr>
					
					<cfelse>
					
						<input type="hidden" name="filterStatus" id="filterStatus" value="3">
					
					</cfif>
					
					<tr>
						<td colspan="2" class="labelmedium" style="padding-left:10px;font-weight:bold;"><cf_tl id="Actor"></td>
					</tr>
									
					<tr>
						<td colspan="2" style="padding-left:10px;padding-right:10px">
							
							<cfoutput>
								<select 
									name="filterAcc" 
									id="filterAcc" 
									class="regularxl" 
									onchange="summaryPanelApplyFilter();"
									style="width:100%; height:180px;" 
									multiple>
										
										<option value="not"> - <cf_tl id="Unassigned"> - (#getUnassigned.Tickets#)
										<cfloop query="getSummaryActors">
											<option value="'#UserAccount#'">#LastName# (#Tickets#)
										</cfloop>
										<option value="all"> - <cf_tl id="All actors"> -
								</select>
							</cfoutput>
									
						</td>
					</tr>
					
					
					
					<tr>
						<td class="labelmedium" style="padding-left:10px;font-weight:bold;"><b><cf_tl id="Class"></td>
					</tr>
					<tr>
						<td colspan="2" align="right" style="padding-left:10px;padding-right:10px">
							<cfoutput>
								<select name="filterClass" 
									id="filterClass" 
									class="regularxl" 
									onchange="summaryPanelApplyFilter();"
									style="width:100%; height:55px;" 
									multiple>
										<cfloop query="getClasses">
											<option value="'#EntityClass#'">#EntityClassName#
										</cfloop>
								</select>
							</cfoutput>
						</td>
					</tr>
					
					<tr><td height="5"></td></tr>
					
					<tr>
						<td class="labelmedium" style="padding-left:10px" width="50%"><cf_tl id="Sort">:</td>
						<td align="right" style="padding-right:10px;">
							
								<select name="filterSorting" 
										id="filterSorting" 
										class="regularxl"
										onchange="summaryPanelApplyFilter();"
										style="width:130px;">
										<option value="0"> <cf_tl id="By Date DESC">
										<option value="1"> <cf_tl id="By Date ASC">
										<option value="2"> <cf_tl id="By Status DESC">
										<option value="3"> <cf_tl id="By Status ASC">
							
						</td>
					</tr>
					
					<tr><td height="5"></td></tr>
					<tr>
						<td class="labelmedium" style="padding-left:10px;"><cf_tl id="Selection">:</td>
						<td align="right" style="padding-right:10px;">
							<cf_setCalendarDate
								name     = "filterDate" 							
								font     = "15"	
								edit     = "No"
								value    = "#lsDateFormat(now(),client.dateFormatShow)#"			
								mode     = "date"
								future   = "No"
								function = "summaryPanelApplyFilter">	
						</td>
					</tr>
					<tr><td height="15"></td></tr>
					<tr><td colspan="2" class="linedotted"></td></tr>
					<tr><td colspan="2" class="labelmedium" style="font-weight:bold;"><cf_tl id="Real-time statistics"></td></tr>
					<tr>
						<td colspan="2" align="center" style="padding-right:10px">
							<cf_tl id="Statistic Charts" var="1">
							<cf_button2 
								text="#lt_text#"
								width="93%"
								height="38px"
								onclick="ColdFusion.navigate('#session.root#/System/Portal/Support/Summary/Statistics/Statistics.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&itemSize=#vItemSize#&itemOffset=#vItemOffset#','divSummaryPanel');">
						</td>
					</tr>
					<tr><td height="15"></td></tr>
					<tr><td colspan="2" class="linedotted"></td></tr>
				</table>
			</cf_divScroll>
			
	</cf_layoutArea>
	
	<cf_layoutArea 
		name="center" 
		position="center">
		   <cf_divscroll style="height:100%" TouchScroll="yes">
			<cfdiv id="divSummaryPanel" 
				style="width:100%; height:100%;"
				bind="url:#session.root#/System/Portal/Support/Summary/SummaryPanelDetail.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&itemSize=#vItemSize#&itemOffset=#vItemOffset#&mode=#url.mode#">
			</cf_divscroll>	
	</cf_layoutArea>
	
	<cf_layoutArea 
		name="bottom" 
		position="bottom"
		size="300px" 
		collapsible="true" 
		initCollapsed="true">
	</cf_layoutArea>

</cf_layout>

 