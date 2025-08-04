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

<cf_verifyOperational module="WorkOrder" Warning="No">

<cftransaction>

	<cfquery name="UpdatePositions" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			UPDATE	Employee.dbo.WorkSchedulePosition 
			SET		WorkSchedule = '#Form.newSchedule#'
			FROM	Employee.dbo.WorkSchedulePosition UP
			WHERE	PositionNo = '#url.positionNo#'
			AND		WorkSchedule = '#url.workSchedule#'
			AND		CalendarDate > GETDATE()
			AND		NOT EXISTS
					(
						SELECT 	'X'
						FROM	Employee.dbo.WorkSchedulePosition
						WHERE	WorkSchedule = '#Form.newSchedule#'
						AND		CalendarDate = UP.CalendarDate
						AND		PositionNo = UP.PositionNo
					)
			AND		EXISTS
					(
						SELECT 	'X'
						FROM	Employee.dbo.WorkScheduleDate
						WHERE	WorkSchedule = '#Form.newSchedule#'
						AND		CalendarDate = UP.CalendarDate
					)
			
	</cfquery>
	
	<cfif operational eq 1>
	
		<cfquery name="Tasks" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	S.*
			    FROM 	WorkOrderLineSchedule S
				WHERE 	S.WorkSchedule = '#url.workSchedule#'
				AND		S.ActionStatus <> '9'
				AND		EXISTS
						(
							SELECT	'X'
							FROM	WorkOrderLineSchedulePosition
							WHERE	ScheduleId = S.ScheduleId
							AND		PositionNo = '#url.positionNo#'
							AND		Operational = 1
						)
		</cfquery>
		
		<cfloop query="tasks">
		
			<cfset vIdScheduleId = replace(ScheduleId,"-","","ALL")>
	
			<cfif IsDefined("Form.cb_#vIdScheduleId#")>
			
				<cfquery name="UpdateTask" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						UPDATE	WorkOrderLineSchedule
						SET		WorkSchedule = '#Form.newSchedule#'
						WHERE	ScheduleId = '#ScheduleId#'
					
				</cfquery>
			
			</cfif>
		
		</cfloop>
	
	</cfif>

</cftransaction>

<script>
//	parent.window.close();
</script>

<cfoutput>
	<script>
		ColdFusion.Window.hide('mydialog'); 
		ColdFusion.navigate('#session.root#/Staffing/Application/WorkSchedule/Position/WorkScheduleView.cfm?ID=#url.positionNo#&ID2=#url.positionParentId#', 'contentbox2');
	</script>
</cfoutput>