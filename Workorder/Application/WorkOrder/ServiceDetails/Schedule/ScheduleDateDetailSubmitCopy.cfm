
<cfparam name="url.close" default="1">

<cfset dateValue = "">
<CF_DateConvert Value="#url.effective#">
<cfset vDate = dateValue>

<cftransaction>

	<cf_assignId>
		
	<cfquery name="getSchedule" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	*
		FROM	WorkOrderLineSchedule
		WHERE	ScheduleId = '#url.ScheduleId#'
	</cfquery>

	<cfquery name  = "createSchedule" 
	   	datasource= "AppsWorkOrder" 
	    username  = "#SESSION.login#" 
		password  = "#SESSION.dbpw#">    
		INSERT INTO WorkOrderLineSchedule (
				ScheduleId,
				WorkOrderId,
				WorkOrderLine,
				ActionClass,
				ScheduleEffective,
				<cfif form.ScheduleClass neq "">ScheduleClass,</cfif>
				ScheduleName,
				Memo,
				WorkSchedule,
				WorkSchedulePriority,
				ActionStatus,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName )
		SELECT	'#rowguid#',
				WorkOrderId,
				WorkOrderLine,
				'#form.actionClass#',
				#vDate#,
				<cfif form.ScheduleClass neq "">'#Form.ScheduleClass#',</cfif>
				'#Form.ScheduleName#',
				'#Form.Memo#',
				'#Form.WorkSchedule#',
				WorkSchedulePriority,
				#url.actionStatus#,
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#'
		FROM   	WorkOrderLineSchedule
	    WHERE   ScheduleId = '#url.ScheduleId#'
	</cfquery>
	
	<cfset url.scheduleid     = rowguid>
	<cfset url.workorderid    = getSchedule.workorderid>
	<cfset url.workorderline  = getSchedule.workorderline>
		
	<cfinclude template="ScheduleCustomSubmit.cfm">	
	
	<cfquery name  = "validDateHours" 
	   	datasource= "AppsWorkOrder" 
	    username  = "#SESSION.login#" 
		password  = "#SESSION.dbpw#">
			SELECT	*
			FROM	Employee.dbo.WorkScheduleDateHour
			WHERE	WorkSchedule = '#url.workSchedule#'
			AND		CalendarDate >= #url.selecteddate#
			AND		CalendarDate <= ISNULL((SELECT MAX(ScheduleDate) FROM WorkOrderLineScheduleDate WHERE ScheduleId = '#url.ScheduleId#' AND Operational = 1), '30001231')
			ORDER BY CalendarHour ASC
	</cfquery>
	
	<cfquery name  = "dateDefinition" 
	   	datasource= "AppsWorkOrder" 
	    username  = "#SESSION.login#" 
		password  = "#SESSION.dbpw#">
			SELECT	*
			FROM	WorkOrderLineScheduleDate
			WHERE	ScheduleId   = '#url.ScheduleId#'
			AND		ScheduleDate = #url.selecteddate#
			AND     Operational = 1
	</cfquery>
	
	<cfquery name  = "getWorkSchedule" 
	   	datasource= "AppsWorkOrder" 
	    username  = "#SESSION.login#" 
		password  = "#SESSION.dbpw#">    
		SELECT  *
		FROM   	Employee.dbo.WorkSchedule
	    WHERE   Code = '#url.workSchedule#'
	</cfquery>
	
	
	<!--- Anytime provision --->
	<cfquery name = "validateAnyDateDefinition" dbtype="query">
		SELECT	*
		FROM	dateDefinition
	</cfquery>
	
	<cfif validateAnyDateDefinition.recordCount eq 1>
	
		<cfif validateAnyDateDefinition.ScheduleHour eq -1>
			
			<cfquery name  = "createScheduleDate" 
			   	datasource= "AppsWorkOrder" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">
				INSERT INTO WorkOrderLineScheduleDate
					(
						ScheduleId,
						ScheduleDate,
						ScheduleHour,
						Memo,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#RowGuid#',
						'#validateAnyDateDefinition.ScheduleDate#',
						#validateAnyDateDefinition.ScheduleHour#,
						'#validateAnyDateDefinition.Memo#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
			</cfquery>
			
		</cfif>
		
	</cfif>
	
	<cfoutput query="validDateHours" maxrows="1">
	
		<cfset vCalendarHour = CalendarHour>
	
		<cfquery name = "validateDateDefinition" dbtype="query">
			SELECT	*
			FROM	dateDefinition
			WHERE	ScheduleHour = #vCalendarHour#
		</cfquery>
	
		<cfif validateDateDefinition.recordCount gt 0>
		
			<cfquery name  = "createScheduleDate" 
			   	datasource= "AppsWorkOrder" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">
				INSERT INTO WorkOrderLineScheduleDate
					(
						ScheduleId,
						ScheduleDate,
						ScheduleHour,
						Memo,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#RowGuid#',
						'#CalendarDate#',
						#vCalendarHour#,
						'#validateDateDefinition.Memo#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
			</cfquery>
		
		</cfif>
	
	</cfoutput>
	
	<cfoutput query="validDateHours">
	
		<cfset vCalendarHour = CalendarHour + (getWorkSchedule.HourMode/60)>
	
		<cfquery name = "validateDateDefinition" dbtype="query">
			SELECT	*
			FROM	dateDefinition
			WHERE	ScheduleHour = #vCalendarHour#
		</cfquery>
	
		<cfif validateDateDefinition.recordCount gt 0>
		
			<cfquery name  = "createScheduleDate" 
			   	datasource= "AppsWorkOrder" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">
				INSERT INTO WorkOrderLineScheduleDate
					(
						ScheduleId,
						ScheduleDate,
						ScheduleHour,
						Memo,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#RowGuid#',
						'#CalendarDate#',
						#vCalendarHour#,
						'#validateDateDefinition.Memo#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
			</cfquery>
		
		</cfif>
	
	</cfoutput>

	
	<cfquery name  = "createSchedulePerson" 
	   	datasource= "AppsWorkOrder" 
	    username  = "#SESSION.login#" 
		password  = "#SESSION.dbpw#">
		INSERT INTO WorkOrderLineSchedulePosition (
	           ScheduleId,
	           PersonNo,
	           PositionNo,
			   isActor,
			   Operational,
	           Memo,
	           OfficerUserId,
	           OfficerLastName,
	           OfficerFirstName	)
		SELECT	'#RowGuid#',
				PersonNo,
				PositionNo,
				isActor,
				Operational,
				Memo,
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#'
		FROM	WorkOrderLineSchedulePosition
		WHERE	ScheduleId = '#url.ScheduleId#'
	</cfquery>


</cftransaction>

<cfoutput>
<cfif url.close eq 1>
	<script>
		parent.window.close();
		try { opener.applyfilter('1','','#url.scheduleid#') } catch(e) { }	
	</script>
</cfif>
</cfoutput>