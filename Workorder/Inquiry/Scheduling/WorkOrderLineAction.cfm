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
<cfparam name="url.mission" 	default="">
<cfparam name="url.year" 		default="">
<cfparam name="url.month" 		default="">
<cfparam name="url.day" 		default="">

<cfset vProgressCount = "300">

<!---Define the date that will be generated, always tomorrow--->
<cfset vGenerationDate = dateAdd("d", 1, now())>
<cfset givenDate = createDate(year(vGenerationDate), month(vGenerationDate), day(vGenerationDate))>

<!--- Pause Hour Cleaning --->
<!--- <cfschedule action = "pause"
		task   = "ScheduledActionsCleaning"
		group  = "WorkOrder">
		
<cf_ScheduleLogInsert
  	ScheduleRunId  = "#schedulelogid#"
	Description    = "Hour Cleanup Process On Pause"
	StepStatus     = "1"> --->
	
<cfif url.year neq "" and url.month neq "" and url.day neq "">
	<cfset givenDate = createDate(url.year, url.month, url.day)>
<cfelse>
	<!---Do cleanup only if we are calculating for the default date--->
	<cfinclude template="WorkOrderLineSchedulingCleanup.cfm">
	
	<cfquery name="cleanWorkOrderLineAction"
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			DELETE
			FROM	WorkOrderLineAction
			WHERE	WorkActionId IN
					(
						SELECT	A.WorkActionId
						FROM	WorkOrderLineAction A
								INNER JOIN Workorder W
									ON A.WorkOrderId = W.WorkOrderId
						WHERE	A.DateTimePlanning >= #givenDate#
						<cfif url.mission neq "">
						AND		W.Mission = '#url.mission#'
						</cfif>
						AND		A.DateTimeActual IS NULL
						AND		A.ActionStatus NOT IN ('3')
						AND		(
									NOT EXISTS
									(
										SELECT	'X'
										FROM	WorkOrderLineSchedule
										WHERE	ScheduleId = A.ScheduleId
										AND		ActionStatus = '1'
									)
									OR
									NOT EXISTS
									(
										SELECT	'X'
										FROM	WorkOrderLineScheduleDate
										WHERE	ScheduleId = A.ScheduleId
										AND		YEAR(ScheduleDate) = YEAR(A.DateTimePlanning)
										AND		MONTH(ScheduleDate) = MONTH(A.DateTimePlanning)
										AND		DAY(ScheduleDate) = DAY(A.DateTimePlanning)
										AND		ScheduleHour = CONVERT(FLOAT, DATEPART(HOUR,A.DateTimePlanning)) + (CONVERT(FLOAT, DATEPART(MINUTE,A.DateTimePlanning)) / 60.0)
										AND		Operational = 1
									)
									OR
									NOT EXISTS
									(
										SELECT	'X'
										FROM	WorkOrderLineSchedule
										WHERE	WorkOrderId = A.WorkOrderId
										AND		WorkOrderLine = A.WorkOrderLine
										AND		ScheduleId = A.ScheduleId
										AND		ActionClass = A.ActionClass
									)
								)
					)
		
		
	</cfquery>
	
</cfif>

<!-------------------------------------------------------->
<!--- Get valid planning to be converted into an action--->
<!--------------------------------------------------------> 


<!---valid action types--->
<cfquery name="ActionClasses"
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Ref_Action
		WHERE	Operational = 1
</cfquery>

<!---Generating the base query, which will be looped thru all action types--->
<!---
		1. Valid schedule, action status 1
		2. Valid workOrderLine, operational 1 and the current generation date is valid in the effective period
		3. Valid WorkOrder, operational 1
		4. And that this date has valid hours defined in staffing
--->

<cfoutput>
	<cfsavecontent variable="baseQuery">
		SELECT	W.Mission,
				W.WorkOrderId,
				L.WorkOrderLine,
				S.ActionClass,
				S.WorkSchedule,
				S.ScheduleEffective,
				S.Memo as ScheduleMemo,
				D.*,
				YEAR(D.ScheduleDate) AS ScheduleDateYear,
				MONTH(D.ScheduleDate) AS ScheduleDateMonth,
				Day(D.ScheduleDate) AS ScheduleDateDay
		FROM	WorkOrderLineScheduleDate D
				INNER JOIN WorkOrderLineSchedule S
					ON D.ScheduleId = S.ScheduleId
				INNER JOIN WorkOrderLine L
					ON S.WorkOrderId = L.WorkOrderId
					AND	S.WorkOrderLine = L.WorkOrderLine
				INNER JOIN WorkOrder W
					ON S.WorkOrderId = W.WorkOrderId 
				INNER JOIN Employee.dbo.WorkSchedule eS
					ON S.WorkSchedule = eS.Code
				INNER JOIN Employee.dbo.WorkScheduleDate eD
					ON S.WorkSchedule = eD.WorkSchedule
					AND D.ScheduleDate = eD.CalendarDate
				INNER JOIN Employee.dbo.WorkScheduleOrganization eO
					ON S.WorkSchedule = eO.WorkSchedule
					AND	eO.OrgUnit IN (SELECT OrgUnit FROM WorkOrderImplementer WHERE WorkOrderId = W.WorkOrderId)
		WHERE	S.ActionStatus = '1'
		AND		L.Operational = 1
		AND     D.Operational = 1
		AND		L.DateEffective <= #givenDate#
		AND		(L.DateExpiration >= #givenDate# OR L.DateExpiration IS NULL)
		AND		W.ActionStatus = '1'
		AND
		(
			EXISTS
					(
						SELECT 	'X'
						FROM	Employee.dbo.WorkScheduleDateHour
						WHERE	WorkSchedule = S.WorkSchedule
						AND		CalendarDate = D.ScheduleDate
						<!--- the initial or the last time of the period --->
						AND		CalendarHour BETWEEN (D.ScheduleHour - (eS.HourMode/60.0)) AND D.ScheduleHour
					)
			<!--- Provision for any hour --->
			OR		D.ScheduleHour = -1
		)
		<cfif url.mission neq "">
		AND		W.Mission = '#url.mission#'
		</cfif>
	</cfsavecontent>
</cfoutput>

<!---Get all actions, type by type, and calculate the correct day span for each one---> 
<cfquery name="ScheduledDates"
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		<cfoutput query="ActionClasses">
			#preserveSingleQuotes(baseQuery)#
			AND		D.ScheduleDate BETWEEN #givenDate# AND dateAdd(day, #BatchDaysSpan#, #givenDate#)
			AND		S.ActionClass = '#Code#'
			<cfif currentRow neq ActionClasses.recordCount>
			UNION
			</cfif>
		</cfoutput>
		
</cfquery>

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Completed Valid Schedule Gathering"
	StepStatus     = "1">
	
<cfset temp_ScheduledPersons = "_Temp_ScheduledPersons">
<cf_dropTable dbName="AppsQuery" tblName="#temp_ScheduledPersons#">


<!---Get all planned persons--->
<cfquery name="ScheduledPersons"
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	P.*
		INTO	UserQuery.dbo.#temp_ScheduledPersons#
		FROM	WorkOrderLineSchedulePosition P
				INNER JOIN WorkOrderLineSchedule S
					ON P.ScheduleId = S.ScheduleId
				INNER JOIN WorkOrderLine L
					ON S.WorkOrderId = L.WorkOrderId
					AND	S.WorkOrderLine = L.WorkOrderLine
				INNER JOIN WorkOrder W
					ON S.WorkOrderId = W.WorkOrderId 
		WHERE	P.IsActor IN ('1','2')
		AND		P.Operational = 1
		AND		S.ActionStatus = '1'
		AND		L.Operational = 1
		AND		L.DateEffective <= #givenDate#
		AND		(L.DateExpiration >= #givenDate# OR L.DateExpiration IS NULL)
		AND		W.ActionStatus = '1'
		<cfif url.mission neq "">
		AND		W.Mission = '#url.mission#'
		</cfif>
</cfquery>

<cfquery name="createIndexes" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	ALTER TABLE dbo.#temp_ScheduledPersons# ADD CONSTRAINT PK_#temp_ScheduledPersons#
	PRIMARY KEY CLUSTERED (ScheduleId,PersonNo);
	
</cfquery>

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Completed Scheduled Persons Gathering"
	StepStatus     = "1">
	
<cfset temp_ValidScheduledPersons = "_Temp_ValidScheduledPersons">
<cf_dropTable dbName="AppsQuery" tblName="#temp_ValidScheduledPersons#">


<!---Get all valid planned persons--->

<!---
		0. Just Persons involved or responsible, isActor 1 or 2
		1. Within a valid schedule, action status 1
		2. Within a valid workOrderLine, operational 1 and the calculation date is valid within the effective period
		3. Within a valid workOrder, operational 1
		4. The workShedule position calendar date is valid in the person assignment period
		5. The personAssignment is valid, assignmentStatus 0 or 1, assignmentType is Actual and the incumbency greater than 0
		6. The workShedule position calendar date is valid in the position valid period
--->


<cfquery name="ValidScheduledPersons"
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT DISTINCT	
				P.*
		INTO 	UserQuery.dbo.#temp_ValidScheduledPersons#
		FROM	WorkOrderLineSchedulePosition P
				INNER JOIN WorkOrderLineSchedule S
					ON P.ScheduleId = S.ScheduleId
				INNER JOIN WorkOrderLine L
					ON S.WorkOrderId = L.WorkOrderId
					AND	S.WorkOrderLine = L.WorkOrderLine
				INNER JOIN WorkOrder W
					ON S.WorkOrderId = W.WorkOrderId 
				INNER JOIN Employee.dbo.PersonAssignment ePA
					ON P.PersonNo = ePA.PersonNo
				INNER JOIN Employee.dbo.Position ePos
					ON ePA.PositionNo = ePos.PositionNo
				INNER JOIN Employee.dbo.WorkSchedulePosition eWPos
					ON S.WorkSchedule = eWPos.WorkSchedule
					AND	eWPos.CalendarDate >= #givenDate#
					AND	ePos.PositionNo = eWPos.PositionNo
		WHERE	P.IsActor IN ('1','2')
		AND		S.ActionStatus = '1'
		AND		L.Operational = 1
		AND  	P.Operational = 1
		AND		L.DateEffective <= #givenDate#
		AND		(L.DateExpiration >= #givenDate# OR L.DateExpiration IS NULL)
		AND		W.ActionStatus = '1'
		AND		eWPos.CalendarDate BETWEEN ePA.DateEffective AND ePA.DateExpiration
		AND		ePA.AssignmentStatus IN ('0','1')
		AND		ePA.AssignmentType = 'Actual'
		AND		ePA.Incumbency > 0
		AND		EXISTS 
				(
					SELECT 	'X'
					FROM 	Employee.dbo.WorkScheduleOrganization WO
							INNER JOIN Organization.dbo.Organization O
								ON WO.OrgUnit = O.OrgUnit
							INNER JOIN Organization.dbo.Organization O2
								ON O.Mission = O2.Mission
								AND	O.MandateNo = O2.MandateNo
					WHERE 	WO.WorkSchedule = S.WorkSchedule
					AND		O2.HierarchyCode like O.HierarchyCode + '%'
					AND		O2.OrgUnit = ePos.OrgUnitOperational
				)
		<!--- Redundant validation since we are validating the PersonAssignment effective period --->
		<!--- AND		eWPos.CalendarDate BETWEEN ePos.DateEffective AND ePos.DateExpiration --->
		<cfif url.mission neq "">
		AND		W.Mission = '#url.mission#'
		</cfif>
	
</cfquery>

<cfquery name="createIndexes" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	ALTER TABLE dbo.#temp_ValidScheduledPersons# ADD CONSTRAINT PK_#temp_ValidScheduledPersons#
	PRIMARY KEY CLUSTERED (ScheduleId,PersonNo);
	
</cfquery>

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Completed Valid Scheduled Persons Gathering"
	StepStatus     = "1">

<cfset vSerialNo = 0>
<cfset cnt = 0>

<!---loop thru all valid actions to be generated--->
<cfoutput query="ScheduledDates" group="mission">
	
	<cfset cnt = 0>
	
	<cfoutput group="ScheduleId">
	
		<cfoutput>
		
			<!--- provision made for ScheduleHour = -1, which means any hour, for our case, means the last valid hour of our schedule --->
			<cfset vScheduleHour = ScheduleHour>
			<cfif vScheduleHour eq -1>
				
				<cfset vScheduleHour = 0>
				
				<cfquery name="getMaxHour" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT 	MAX(CalendarHour) as CalendarHour
						FROM	WorkScheduleDateHour
						WHERE	WorkSchedule = '#WorkSchedule#'
						AND		CalendarDate = '#ScheduleDate#'
				</cfquery>
				
				<cfif getMaxHour.recordCount eq 1>
					<cfset vScheduleHour = getMaxHour.CalendarHour>
				</cfif>
				
			</cfif>
		
			<!--- define hour and minutes based on the scheduleHour --->
			<cfset vHour = Int(Abs(vScheduleHour))>
			<cfset vMinute = Abs(vScheduleHour) - Int(Abs(vScheduleHour))>
			<cfset vMinute = Round(vMinute * 60)>

			<cfif vHour gte 24>
				<cfset vHour = 23>
				<cfset vMinute = 59>
			</cfif>

			<cfif vMinute gte 60>
				<cfset vMinute = 59>
			</cfif>
			
			<!--- constructing this action dateTimePlanning --->
			<cfset vDateTimePlanning = createDateTime(ScheduleDateYear, ScheduleDateMonth, ScheduleDateDay, vHour, vMinute, 0)>
		
			<!---By default no action will be recorded--->
			<cfset vInsert = 0>
			
			<!--- validate this action existence --->
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
					AND		ScheduleId = '#ScheduleId#'
			</cfquery>
			
			<!---existing action--->
			<cfif validate.recordCount eq 1>
				
				<!--- if not completed yet --->
				<cfif validate.ActionStatus neq '3'>
				
					<!--- delete this action --->
					<cfquery name="delete"
						datasource="AppsWorkorder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							DELETE 
							FROM	WorkOrderLineAction
							WHERE	WorkActionId = '#validate.WorkActionId#'
					</cfquery>
					
					<!---Allow Insert this action--->
					<cfset vInsert = 1>
					
				</cfif>
			
			<!--- not existing action--->
			<cfelseif validate.recordCount eq 0>
			
				<!---Allow Insert this action--->
				<cfset vInsert = 1>
				
			</cfif>
			
			<!---Insert the action--->
			<cfif vInsert eq 1>
			
				<!--- set memo field --->
				<cfset vMemo = trim(ScheduleMemo)>
				<cfif vMemo eq "">
					<cfset vMemo = trim(Memo)>
				<cfelse>
					<cfif trim(Memo) neq "">
						<cfset vMemo = vMemo & " - " & trim(Memo)>
					</cfif>
				</cfif>
				
				<!--- Id and SerialNo --->
				<cf_assignId>
				<cfset vSerialNo = vSerialNo + 1>
				
				<!---Insert the valid action--->
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
								DateTimeRequested,
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
								#vDateTimePlanning#,
								'#vMemo#',
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#'
							)
				</cfquery>
				
				
				<!------------------------------------------------->
				<!--- Add/Disable valid persons for this action --->
				<!------------------------------------------------->
				
				<!---Get all planned persons for this schedule--->
				<cfquery name="qScheduledPersons" 
						datasource="AppsQuery" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT 	*
						FROM	#temp_ScheduledPersons#
						WHERE	ScheduleId = '#ScheduledDates.ScheduleId#'
				</cfquery>
		
				<!---loop thru all planned person for this action--->
				<cfloop query="qScheduledPersons">
					
					<!---always a valid action person--->
					<cfset vValidPerson = 1>
					<cfset vAssignment = "">
				
					<!---Check if this person is a valid person--->
					<cfquery name="qValidPersons" 
						datasource="AppsQuery" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT 	*
							FROM	#temp_ValidScheduledPersons#
							WHERE	ScheduleId = '#ScheduledDates.ScheduleId#'
							AND		PersonNo = '#qScheduledPersons.PersonNo#'				
					</cfquery>
					
					<!---not valid person--->
					<cfif qValidPersons.recordcount eq 0>
						
						<!--- Invalidate persons if and only if the date is today --->
						<cfif dateFormat(vDateTimePlanning,"yyyy-mm-dd") eq dateFormat(now(),"yyyy-mm-dd")>

							<!--- Disable invalid persons --->
							<cfquery name="DisableInvalidPersons"
								datasource="AppsWorkorder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									UPDATE	WorkOrderLineSchedulePosition
									SET		Operational = 0
									WHERE	ScheduleId = '#ScheduledDates.ScheduleId#'
									AND		PersonNo = '#qScheduledPersons.PersonNo#'
							</cfquery>
							
							<!---Get the current assignment--->	
							<cfquery name="currentAssignment"
								datasource="AppsEmployee" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT TOP 1 *
									FROM 	PersonAssignment
									WHERE	PersonNo = '#qScheduledPersons.PersonNo#'
									AND		AssignmentStatus IN ('0','1')
									AND		#dateAdd('d',-1,vDateTimePlanning)# BETWEEN DateEffective AND DateExpiration
									ORDER BY DateExpiration DESC
							</cfquery>
							
							<cfset vAssignment = currentAssignment.AssignmentNo>
						
						</cfif>
						
						<!---set this person as a not valid action person---> 
						<cfset vValidPerson = 0>
						
					</cfif>
		
					<!---Validate if this person was previously assigned to this action--->
					<cfquery name="validateP"
						datasource="AppsWorkorder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT 	*
							FROM 	WorkOrderLineActionPerson
							WHERE	WorkActionId = '#RowGuid#'
							AND		PersonNo = '#qScheduledPersons.PersonNo#'
					</cfquery>
					
					<!--- not previously assigned --->
					<cfif validateP.recordCount eq 0>
					
						<!---insert valid person to this action--->
						<cfquery name="AddInvalidPersons"
							datasource="AppsWorkorder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								INSERT INTO	WorkOrderLineActionPerson
									(
										WorkActionId,
										PersonNo,
										Operational,
										isActor,
										<cfif vAssignment neq "">AssignmentNo,</cfif>
										PositionNo,
										Source,
										OfficerUserId,
										OfficerLastName,
										OfficerFirstName
									)
								VALUES
									(
										'#RowGuid#',
										'#qScheduledPersons.PersonNo#',
										'#vValidPerson#',
										'#qScheduledPersons.isActor#',
										<cfif vAssignment neq "">'#vAssignment#',</cfif>
										'#qScheduledPersons.PositionNo#',
										'Batch',
										'#SESSION.acc#',
										'#SESSION.last#',
										'#SESSION.first#'
									)
						</cfquery>
					
					</cfif>
				
				</cfloop>
				
				<cfset cnt = cnt +1>
				
				<!---Log the progress every vProgressCount records--->
				<cfif cnt eq vProgressCount or currentrow eq ScheduledDates.recordcount>
				
					<cf_ScheduleLogInsert
					   	ScheduleRunId  = "#schedulelogid#"
						Description    = "  ------- Total Progress: #NumberFormat(((currentrow*100)/ScheduledDates.recordcount),',.__')# % [Records: #NumberFormat(currentrow,',')# of #NumberFormat(ScheduledDates.recordcount,',')#]"
						StepStatus     = "1">	
			
					<cfset cnt = 0>
		
				</cfif>
			
			</cfif>
			
		</cfoutput>
		
	</cfoutput>

	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Completed Valid Data Insertion for Entity: #mission#"
		StepStatus     = "1">
	
	<cfset url.visibilityMission = mission>
	<cfinclude template="WorkOrderLineActionSetVisibility.cfm">	
	
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Completed Valid Visibility Insertion for Entity: #mission#"
		StepStatus     = "1">

</cfoutput>

<!---Drop temporary tables--->
<cf_dropTable dbName="AppsQuery" tblName="#temp_ScheduledPersons#">
<cf_dropTable dbName="AppsQuery" tblName="#temp_ValidScheduledPersons#">

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Completed Data Insertion"
	StepStatus     = "1">
	
<!--- Resume Hour Cleaning --->	
<!--- <cfschedule action = "resume"
		task   = "ScheduledActionsCleaning"
		group  = "WorkOrder">
		
<cf_ScheduleLogInsert
  	ScheduleRunId  = "#schedulelogid#"
	Description    = "Hour Cleanup Process Reinstated"
	StepStatus     = "1"> --->