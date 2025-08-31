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
<cf_tl id="Add New Requirement" var="1">

<cf_screentop JQuery="yes" label="#lt_text#" layout="webapp" user="no" banner="red">

<cf_divScroll style="height:100%; min-height:100%;">
	<cfoutput>
		<table width="95%" cellpadding="0" cellspacing="0" align="center">
			<tr><td height="10"></td></tr>
			<tr>
				<td class="labelit" width="18%" style="padding-left:8px; font-size:18px;"><cf_tl id="Service Area">:</td>
				<td>
				
					<cfset vSelectedActionDate = dateFormat(now(), "yyyy-mm-dd")>
					<cfif isDefined("session.selectActionDate")>
						<cfif session.selectActionDate neq "">
							<CF_DateConvert Value="#session.selectActionDate#">
							<cfset vSelectedActionDate = dateFormat(dateValue, "yyyy-mm-dd")>
						</cfif>
					</cfif>

					<cfquery name="Lines" 
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT 	L.*,
									C.Description as DomainClassDescription,
									(L.Reference + ' - ' + WS.Description) as ServiceDescription
							FROM 	WorkOrderLine L
									INNER JOIN Ref_ServiceItemDomainClass C
										ON L.ServiceDomain = C.ServiceDomain
										AND L.ServiceDomainClass = C.Code
									INNER JOIN WorkOrderService WS 
										ON L.ServiceDomain = WS.ServiceDomain 
										AND L.Reference = WS.Reference 
							WHERE	L.WorkOrderId = '#session.selectworkorderid#'
							AND		L.Operational = 1
							AND     L.DateEffective <= '#vSelectedActionDate#' AND (L.DateExpiration is NULL or L.DateExpiration >= '#vSelectedActionDate#')
							ORDER BY L.ServiceDomain, L.ServiceDomainClass
					</cfquery>
					
					<cfform name="frmScheduleRequirementAdd">
						<cfselect 
							name="pworkorderline" 
							id="pworkorderline" 
							class="regularxl" 
							style="width:350px;" 
							query="Lines" 
							display="ServiceDescription" 
							value="workOrderLine" 
							group="DomainClassDescription" 
							onchange="ColdFusion.navigate('#session.root#/workorder/Application/WorkOrder/ServiceDetails/Action/WorkActionListing.cfm?workorderid=#session.selectworkorderid#&workorderline='+this.value+'&tabno=ScheduleAdd&entrymode=manual&actionstatus=1&id2=new','contentboxScheduleAdd');">
						</cfselect>
					</cfform>
					
				</td>
			</tr>
			<tr>
				<td colspan="2" valign="top">
					<cfset vWOL = "00000000-0000-0000-0000-000000000000">
					<cfif Lines.recordCount gt 0>
						<cfset vWOL = Lines.WorkOrderLine>
					</cfif>
					<cfdiv id="contentboxScheduleAdd" bind="url:#session.root#/workorder/Application/WorkOrder/ServiceDetails/Action/WorkActionListing.cfm?workorderid=#session.selectworkorderid#&workorderline=#vWOL#&tabno=ScheduleAdd&entrymode=manual&actionstatus=1&id2=new">
				</td>
			</tr>
			<tr><td height="10"></td></tr>
			<tr><td colspan="2" class="line"></td></tr>
			<tr><td height="10"></td></tr>
			<tr>
				<td colspan="2" align="center">
					<cf_tl id="Close" var="1">
					<cf_button type="button" value="  #lt_text#  " onclick="try{ ColdFusion.Window.destroy('popupCreateNewRequirement',true); } catch(e){} ColdFusion.navigate('Schedule/Schedule.cfm?mission=#url.mission#','menucontent');">
				</td>
			</tr>
		</table>
	</cfoutput>
</cf_divScroll>