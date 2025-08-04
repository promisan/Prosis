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
<cf_presentationScript>
<cf_paneScript>
<cf_layoutScript>
<cf_calendarScript>

<cfajaximport tags="cfform,cfinput-datefield">

<cfset vItemSize = 500>
<cfset vItemOffset = 52>


<cf_layout type="border" id="ticketSummaryPanelLayout">

	<cf_layoutArea 
		name="left" 
		position="left" 
		size="12%" 
		minSize="215px"
		collapsible="true" 
		initCollapsed="true"
		onshow="_pane_resizeMenuItems('#vItemSize#', #vItemOffset#);"
		onhide="_pane_resizeMenuItems('#vItemSize#', #vItemOffset#);">
			
			<cf_divScroll width="100%" height="100%">
				<table width="98%" align="center">
					<tr><td height="10"></td></tr>
					
					
					<tr>
						<td class="labelmedium" width="20%" style="padding-left:10px;font-weight:bold;"><cf_tl id="Filters"></td>
					</tr>
					<tr>
						<td colspan="2" align="right" style="padding-left:10px;padding-right:10px">
							<!---
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
							
							--->
							
						</td>
					</tr>
					
				</table>
			</cf_divScroll>
			
	</cf_layoutArea>
	
	<cf_layoutArea 
		name="center" 
		position="center">
		   <cf_divscroll style="height:100%">
			<cfdiv id="divSummaryPanel" 
				style="width:100%; height:100%;"
				bind="url:#session.root#/System/Portal/Support/ApplicationServer/ApplicationServerDetail.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&itemSize=#vItemSize#&itemOffset=#vItemOffset#">
			</cf_divscroll>	
	</cf_layoutArea>

</cf_layout>

 