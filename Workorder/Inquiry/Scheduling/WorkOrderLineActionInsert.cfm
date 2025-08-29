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
<cfset vDateTimePlanning = createDateTime(vYear, vMonth, vDay, vHour, vMinute, 0)>
		
<cfquery name="validate"
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT 	*
		FROM	WorkOrderLineAction
		WHERE	WorkOrderId = '#WorkOrderId#'
		AND		WorkOrderLine = #WorkOrderLine#
		AND		ActionClass = '#ActionClass#'
		AND		DateTimePlanning = #vDateTimePlanning#
		AND		ScheduleId IN 
					(
						SELECT 	ScheduleId 
						FROM 	WorkOrderLineSchedule 
						WHERE	WorkOrderId = '#WorkOrderId#'
						AND		WorkOrderLine = #WorkOrderLine#
						AND		ActionClass = '#ActionClass#'
						AND		WorkSchedule = '#WorkSchedule#'
						AND		ScheduleEffective = '#ScheduleEffective#'
					)
</cfquery>	

<cfif validate.recordCount eq 0>
	<cf_assignId>
	<cfset vSerialNo = vSerialNo + 1>
	
	<cfset vMemo = Memo>
	<cfif trim(DetailMemo) neq "">
		<cfset vMemo = vMemo & " - " & DetailMemo>
	</cfif>
	
	<cfquery name="Action"
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO WorkOrderLineAction
				(
					WorkActionId,
					WorkOrderId,
					WorkOrderLine,
					ActionClass,
					SerialNo,
					ScheduleId,
					DateTimePlanning,
					ActionMemo,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName
				)
			VALUES
				(
					'#RowGuid#',
					'#WorkOrderId#',
					#WorkOrderLine#,
					'#ActionClass#',
					'#vSerialNo#',
					'#ScheduleId#',
					#vDateTimePlanning#,
					'#vMemo#',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#'
				)
	</cfquery>
</cfif>