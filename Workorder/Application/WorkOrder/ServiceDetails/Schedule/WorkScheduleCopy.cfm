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
<cf_tl id="Copy Shift" var="1">

<cf_screentop 
	height="100%" 
	line="no"  
	html="Yes" 
	layout="webapp" 
	label="#lt_text#" 
	option="#lt_text#" 
	banner="gray" 
	bannerforce="Yes"
	user="no"
	JQuery="yes">
		
<cfquery name="getWO" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	WorkOrder
		WHERE 	WorkOrderId = '#url.workorderid#'
</cfquery>
	
<cfquery name="getAction" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Ref_Action
		WHERE 	Code = '#url.actionclass#'
</cfquery>

<cfquery name="getWorkSchedule" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	WorkSchedule
		WHERE 	Code = '#url.workSchedule#'
</cfquery>

<cfoutput>

	<cfform name="frmWorkScheduleCopy" 
		action="Schedule/WorkScheduleCopySubmit.cfm?workorderId=#url.workorderId#&workorderline=#url.workorderline#&ActionClass=#url.ActionClass#&WorkSchedule=#url.WorkSchedule#&isCopy=1">
		
		<table width="93%" align="center" cellspacing="3" class="formpadding">
			<tr><td height="5"></td></tr>
			<tr>
				<td class="labelmedium" colspan="2"><cf_tl id="From" var="1">#ucase(lt_text)#:</td>
			</tr>
			<tr><td colspan="2" class="line"></td></tr>
			<tr>
				<td width="25%" class="labelmedium" style="padding-left:15px;"><cf_tl id="Action">:</td>
				<td class="labelmedium">
					#getAction.Description#
					<input type="Hidden" name="factionclassold" id="factionclassold" value="#url.ActionClass#">
				</td>
			</tr>
			<tr>
				<td class="labelmedium" style="padding-left:15px;"><cf_tl id="Shift">:</td>
				<td class="labelmedium">
					#getWorkSchedule.Description#
					<input type="Hidden" name="fworkscheduleold" id="fworkscheduleold" value="#url.WorkSchedule#">
				</td>
			</tr>
			
			<tr><td height="5"></td></tr>
			<tr>
				<td class="labelmedium" colspan="2"><cf_tl id="To" var="1">#ucase(lt_text)#:</td>
			</tr>
			<tr><td colspan="2" class="line"></td></tr>
			<tr>
				<td class="labelmedium" style="padding-left:15px;"><cf_tl id="Line">:</td>
				<td>
					
					<cfquery name="getLines" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT	L.*,
									(L.Reference + ' - ' + WS.Description) as display
							FROM	WorkOrderLine L
									INNER JOIN WorkOrderService WS
										ON L.ServiceDomain = WS.ServiceDomain
										AND L.Reference = WS.Reference
							WHERE	L.WorkOrderId = '#url.workorderid#'
							AND		L.WorkOrderLine != '#url.workorderline#'
							AND		L.Operational = 1
							ORDER BY L.Reference ASC
					</cfquery>
					
					<cfselect 
						name="fworkorderline" 
						id="fworkorderline" 
						query="getLines" 
						display="display" 
						class="regularxl"
						value="WorkOrderLine" 
						queryposition="below" 
						required="No" 
						onchange="validateCopyWorkSchedule(this);">
						<option value=""> - <cf_tl id="Current Line"> -
					</cfselect>
				</td>
			</tr>
			<tr>
				<td class="labelmedium" style="padding-left:15px;"><cf_tl id="Action">:</td>
				<td>
					<cfquery name="getActions" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT 	*
							FROM	Ref_Action
							WHERE	Mission = '#getWO.Mission#'
							AND    	Code IN (SELECT Code FROM Ref_ActionServiceItem WHERE ServiceItem = '#getWO.serviceitem#')
							AND		EntryMode = 'Batch'
							ORDER BY ListingOrder
					</cfquery>
					
					<cfselect 
						name="factionclass" 
						id="factionclass" 
						query="getActions" 
						display="description" 
						class="regularxl"
						value="code" 
						queryposition="below" 
						required="Yes" 
						message="Please, select a valid action."
						onchange="validateCopyWorkSchedule(this);">
						<option value="">
					</cfselect>
				</td>
			</tr>
			<tr>
				<td class="labelmedium" style="padding-left:15px;"><cf_tl id="Shift">:</td>
				<td>
					<cfquery name="getWorkSchedules" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  WS.*
							FROM    WorkSchedule WS
									INNER JOIN WorkScheduleOrganization WSO
										ON WS.Code = WSO.WorkSchedule
							WHERE   WS.Mission = '#getWO.mission#'
							AND		WS.Operational = 1
							AND		WSO.OrgUnit IN (SELECT OrgUnit FROM WorkOrder.dbo.WorkOrderImplementer WHERE WorkOrderId = '#getWO.WorkOrderId#')
							ORDER BY WS.Description
					</cfquery>
					
					<cfselect 
						name="fworkschedule" 
						id="fworkschedule" 
						class="regularxl"
						query="getWorkSchedules" 
						display="description" 
						value="code" 
						queryposition="below"
						required="Yes" 
						message="Please, select a valid shift." 
						onchange="validateCopyWorkSchedule(this);">
						<option value="">
					</cfselect>
				</td>
			</tr>
			<tr>
				<td class="labelmedium" style="padding-left:15px;"><cf_tl id="Effective from">:</td>
				<td>
					<cf_intelliCalendarDate9
						FieldName="feffective" 
						class="regularxl"
						Default="#dateformat(now(), CLIENT.DateFormatShow)#"
						AllowBlank="False">
				</td>
			</tr>
			<tr>
				<td class="labelmedium" style="padding-left:15px;"><cf_tl id="Get Hours From">:</td>
				<td>
					<select id="fhours" name="fhours" class="regularxl">
						<option value="1"><cf_tl id="The effective date">
						<option value="2" selected><cf_tl id="First date after or equal to effective date">
						<option value="3"><cf_tl id="First date before or equal to effective date">
					</select>
				</td>
			</tr>
			<tr>
				<td class="labelmedium" style="padding-left:15px;"><cf_tl id="Responsible">:</td>
				<td>
					<cfdiv id="divAssignResponsiblePersonWS" bind="url:Schedule/getPerson.cfm?workorderId=#getWO.workorderId#&workorderline=#url.workorderline#&ActionClass=#url.ActionClass#&WorkSchedule={fworkschedule}&selectedDate=#dateFormat(now(),client.dateFormatShow)#&boxName=divEmployee">
				</td>
			</tr>
			
			<tr><td height="10"></td></tr>
			<tr><td colspan="2" class="line"></td></tr>
			<tr><td height="10"></td></tr>
			
			<tr>
				<td colspan="2" align="center">
					<cf_tl id="Create copy" var="1">
					<!--- <cf_button type="Submit" name="btnSubmitWSC" id="btnSubmitWSC" value="#lt_text#" onclick="return validatePersonField('PersonNo');"> --->
					<cf_button type="Submit" name="btnSubmitWSC" id="btnSubmitWSC" value="#lt_text#">
				</td>
			</tr>
			
		</table>
	</cfform>
</cfoutput>

<cfset ajaxOnLoad("doCalendar")>