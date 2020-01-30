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