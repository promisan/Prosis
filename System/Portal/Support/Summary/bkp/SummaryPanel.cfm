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
<cf_presentationScript>
<cf_paneScript>
<cf_layoutScript>
<cf_calendarScript>

<cfajaximport tags="cfform,cfinput-datefield">

<cfset vItemSize = 348>
<cfset vItemOffset = 52>


<cfoutput>
	<script>
		var globalChartCount = 0;
		
		function summaryPanelApplyFilter(dte){
			ColdFusion.navigate('#session.root#/System/Portal/Support/Summary/SummaryPanelDetail.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&itemSize=#vItemSize#&itemOffset=#vItemOffset#&accFilter='+$('##filterAcc').val()+'&statusFilter='+$('##filterStatus').val()+'&sortingFilter='+$('##filterSorting').val()+'&dateFilter='+$('input[name=filterDate_date').val()+'&classFilter='+$('##filterClass').val(),'divSummaryPanel');
		}
		
		function addNewChart(sel){
			var paramBy = $('##supportChartBy').val();
			var paramType = $('##supportChartType').val();
			var paramInitDate = $('##supportChartEffective').val();
			var paramEndDate = $('##supportChartExpiration').val();
			
			globalChartCount = globalChartCount + 1;
			
			var newDiv = '<div id="supportChart_'+globalChartCount+'" name="supportChart_'+globalChartCount+'" class="clsChartContainer"></div>';
			$(newDiv).prependTo(sel);
			
			ColdFusion.navigate('#session.root#/System/Portal/Support/Summary/Statistics/setGraph.cfm?id='+globalChartCount+'&by='+paramBy+'&type='+paramType+'&init='+paramInitDate+'&end='+paramEndDate,'supportChart_'+globalChartCount);
		}
		
		function removeChart(id) {
			$('##supportChart_'+id).remove();
		}
	</script>
</cfoutput>

<cfquery name="getUnassigned" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	COUNT(*) AS Tickets
		FROM	Control.dbo.Observation O 
		WHERE   ObservationId NOT IN (SELECT OO.ObjectId
									  FROM   OrganizationObjectActionAccess OAS INNER JOIN OrganizationObject OO ON OAS.ObjectId = OO.ObjectId														
									  WHERE	 OO.EntityCode = 'SysTicket'
									  AND	 OO.ObjectId = O.ObservationId)
		AND     O.ActionStatus < '3'
		AND		O.ObservationClass = 'Inquiry'
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
							INNER JOIN Control.dbo.Observation O
								ON OO.ObjectId = O.ObservationId
					WHERE	OO.EntityCode = 'SysTicket'
					AND		O.ObservationClass = 'Inquiry'
					AND		O.ActionStatus < '3'
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
		size="12%" 
		minSize="215px"
		collapsible="true" 
		initCollapsed="false"
		onshow="_pane_resizeMenuItems('#vItemSize#', #vItemOffset#);"
		onhide="_pane_resizeMenuItems('#vItemSize#', #vItemOffset#);">
			
			<cf_divScroll width="100%" height="100%">
				<table width="98%" align="center">
					<tr><td height="10"></td></tr>
					
					
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
									  FROM  Control.dbo.Observation
									  WHERE	ObservationClass = 'Inquiry'
									  AND   ActionStatus = R.EntityStatus) as Tickets
									
									FROM	Ref_EntityStatus R
									WHERE	R.EntityCode = 'SysTicket'
									AND		R.EntityStatus < '3'
									AND		EXISTS
											(
												SELECT	'X'
												FROM	Control.dbo.Observation O 
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
						<td class="labelmedium" style="padding-left:10px;font-weight:bold;"><cf_tl id="Sort">:</td>
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
						<td class="labelmedium" style="padding-left:10px;font-weight:bold;"><cf_tl id="Date">:</td>
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
		   <cf_divscroll style="height:100%">
			<cfdiv id="divSummaryPanel" 
				style="width:100%; height:100%;"
				bind="url:#session.root#/System/Portal/Support/Summary/SummaryPanelDetail.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&itemSize=#vItemSize#&itemOffset=#vItemOffset#">
			</cf_divscroll>	
	</cf_layoutArea>

</cf_layout>

 