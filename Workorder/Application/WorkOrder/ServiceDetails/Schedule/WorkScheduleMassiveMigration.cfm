
<cfquery name="intASchedules" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	*,
				'INTB' as newWorkschedule
		FROM	WorkOrderLineSchedule S
		WHERE	S.WorkSchedule = 'INTA'
		AND		S.ScheduleEffective = '2000-04-25 00:00:00.000'
</cfquery>

<cfset cnt = 0>
<cfset vfhours = 2>

<cfloop query="intASchedules">

	<cfset vDate = intASchedules.ScheduleEffective>

	<cfquery name="schedulesToCopy" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT	*
			FROM	WorkOrderLineSchedule
			WHERE	ScheduleId = '#intASchedules.ScheduleId#'
	</cfquery>
	
	<cfloop query="schedulesToCopy">
	
		<cftransaction>
		
			<cf_assignId>
			
			<!--- Schedule --->
			<cfquery name="insertSchedule" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO WorkOrderLineSchedule
						(
							ScheduleId,
							WorkOrderId,
							WorkOrderLine,
							ActionClass,
							WorkSchedule,
							WorkSchedulePriority,
							ScheduleEffective,
							Memo,
							ActionStatus,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					VALUES
						(
							'#RowGuid#',
							'#intASchedules.workorderId#',
							'#intASchedules.workorderline#',
							'#intASchedules.actionclass#',
							'#intASchedules.newWorkschedule#',
							'#WorkSchedulePriority#',
							'#vDate#',
							'#memo#',
							'#ActionStatus#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
						)
			</cfquery>
			
			<!--- Person Responsible --->
			<cfquery name  = "insertSchedulePerson" 
			   	datasource= "AppsWorkOrder" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">
				INSERT INTO WorkOrderLineSchedulePosition 
					(
			           ScheduleId,
			           PersonNo,
			           PositionNo,
					   isResponsible,
					   Operational,
			           Memo,
			           OfficerUserId,
			           OfficerLastName,
			           OfficerFirstName
					)
					SELECT
						'#RowGuid#',
						ISNULL((SELECT PersonNoB FROM Employee.dbo._PersonA_B WHERE PersonNoA = P.PersonNo), P.PersonNo),
						P.PositionNo,
						P.isActor,
						P.Operational,
						P.Memo,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					FROM 	WorkOrderLineSchedulePosition P
					WHERE	P.ScheduleId = '#ScheduleId#'
			</cfquery>
			
			
			<!--- Dates and hours --->
			
			<!--- The effective date --->
			<cfif vfhours eq "1">
				<cfquery name  = "dateDefinition" 
				   	datasource= "AppsWorkOrder" 
				    username  = "#SESSION.login#" 
					password  = "#SESSION.dbpw#">
						SELECT 	*
						FROM	WorkOrderLineScheduleDate
						WHERE	ScheduleId = '#ScheduleId#'
						AND		ScheduleDate = '#vDate#'
						AND     Operational = 1
				</cfquery>
			</cfif>
			
			<!--- First date after or equal to effective date --->
			<cfif vfhours eq "2">
				<cfquery name  = "dateDefinition" 
				   	datasource= "AppsWorkOrder" 
				    username  = "#SESSION.login#" 
					password  = "#SESSION.dbpw#">
						SELECT	*
						FROM	WorkOrderLineScheduleDate
						WHERE	ScheduleId = '#ScheduleId#'
						AND     Operational = 1
						AND		ScheduleDate = 
												(
													SELECT TOP 1 ScheduleDate
													FROM	WorkOrderLineScheduleDate
													WHERE	ScheduleDate >= '#vDate#'
													AND     Operational = 1
													ORDER BY ScheduleDate ASC
												)
				</cfquery>
			</cfif>
			
			<!--- First date before or equal to effective date --->
			<cfif vfhours eq "3">
				<cfquery name  = "dateDefinition" 
				   	datasource= "AppsWorkOrder" 
				    username  = "#SESSION.login#" 
					password  = "#SESSION.dbpw#">
						SELECT	*
						FROM	WorkOrderLineScheduleDate
						WHERE	ScheduleId = '#ScheduleId#'
						AND     Operational = 1
						AND		ScheduleDate = 
												(
													SELECT   TOP 1 ScheduleDate
													FROM	 WorkOrderLineScheduleDate
													WHERE	 ScheduleDate <= '#vDate#'
													AND      Operational = 1
													ORDER BY ScheduleDate DESC
												)
				</cfquery>
			</cfif>
			
			<cfif dateDefinition.recordCount gt 0>
			
				<cfquery name  = "validDateHours" 
				   	datasource= "AppsWorkOrder" 
				    username  = "#SESSION.login#" 
					password  = "#SESSION.dbpw#">
						SELECT	*
						FROM	Employee.dbo.WorkScheduleDateHour
						WHERE	WorkSchedule = '#intASchedules.newWorkschedule#'
						AND		CalendarDate >= '#dateDefinition.scheduleDate#'
						AND		CalendarDate <= ISNULL((SELECT MAX(ScheduleDate) FROM WorkOrderLineScheduleDate WHERE ScheduleId = '#ScheduleId#' AND Operational = 1), '30001231')
				</cfquery>
				
				<cfloop query="validDateHours">
				
					<cfquery name = "validateDateDefinition" dbtype="query">
						SELECT	*
						FROM	dateDefinition
						WHERE	ScheduleHour = #CalendarHour#
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
									#CalendarHour#,
									'#validateDateDefinition.Memo#',
									'#SESSION.acc#',
									'#SESSION.last#',
									'#SESSION.first#'
								)
						</cfquery>
					
					</cfif>
				
				</cfloop>
			
			</cfif>
			
		
		</cftransaction>
	
	</cfloop>
	
	<cfset cnt = cnt + 1>
	
	<cfoutput>Record: #cnt# completed.<br></cfoutput>

</cfloop>


<h1>End!!</h1>