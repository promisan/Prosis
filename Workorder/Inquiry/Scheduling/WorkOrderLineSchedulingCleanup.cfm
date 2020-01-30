
<!--- the purpose of this template is to manage the content of the helper table
WorkOrderLineSchedulePosition to have its data refreshed in order to be3
used for the scheduling of actions onwards --->

<cfparam name="url.mission" 	default="">

<!---Define the date that will be generated, always tomorrow--->
<cfset vGenerationDate = dateAdd("d", 1, now())>
<cfset vCleanupDate = createDate(year(vGenerationDate), month(vGenerationDate), day(vGenerationDate))>

<!---Get Missions--->
<cfquery name="getMissions"
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT 	*
		FROM 	Ref_ParameterMission
		<cfif url.mission neq "">
		WHERE	Mission = '#url.mission#'
		</cfif>
		
</cfquery>

<cfloop query="getMissions">

	<!------------------------------------------>
	<!--- 1. Clean WorkOrderLineScheduleDate --->
	<!------------------------------------------>
	
	<!---Reenable all dates--->
	<cfquery name="reEnabledAllDatesForTheMission"
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			UPDATE	WorkOrderLineScheduleDate
			SET		Operational = 1
			FROM	WorkOrderLineScheduleDate UP
			WHERE	EXISTS
					(
						SELECT 	'X'
						FROM	WorkOrderLineScheduleDate D
								INNER JOIN WorkOrderLineSchedule S
									ON D.ScheduleId = S.ScheduleId
								INNER JOIN WorkOrderLine L
									ON S.WorkOrderId = L.WorkOrderId
									AND	S.WorkOrderLine = L.WorkOrderLine
								INNER JOIN WorkOrder W
									ON S.WorkOrderId = W.WorkOrderId
						WHERE	D.ScheduleId = UP.ScheduleId
						AND		D.ScheduleDate = UP.ScheduleDate
						AND		D.ScheduleHour = UP.ScheduleHour
						AND		D.Operational = 0
						AND		W.Mission = '#mission#'
					)
			
	</cfquery>
	
	<!---Get all invalid dates to be disabled--->
	<cfquery name="getInvalidDatesToDelete"
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			SELECT	*
			FROM
				(
					<!---Invalid WorkSchedule--->
					SELECT 	D.*,
							'Invalid WorkSchedule' as Reason
					FROM	WorkOrderLineScheduleDate D
							INNER JOIN WorkOrderLineSchedule S ON D.ScheduleId = S.ScheduleId
							INNER JOIN WorkOrderLine L  	   ON S.WorkOrderId = L.WorkOrderId	AND	S.WorkOrderLine = L.WorkOrderLine
							INNER JOIN WorkOrder W		       ON S.WorkOrderId = W.WorkOrderId 
					WHERE	S.WorkSchedule NOT IN (SELECT Code FROM Employee.dbo.WorkSchedule)
					AND		W.Mission = '#mission#'
					AND		D.Operational = 1
					AND 	D.ScheduleDate > '#dateFormat(vCleanupDate,"yyyy-mm-yy")#'
					
					UNION ALL
					
					<!---Invalid WorkSchedule Date--->
					SELECT 	D.*,
							'Invalid WorkSchedule Date' as Reason
					FROM	WorkOrderLineScheduleDate D
							INNER JOIN WorkOrderLineSchedule S	ON D.ScheduleId = S.ScheduleId
							INNER JOIN WorkOrderLine L			ON S.WorkOrderId = L.WorkOrderId AND	S.WorkOrderLine = L.WorkOrderLine
							INNER JOIN WorkOrder W				ON S.WorkOrderId = W.WorkOrderId 
					WHERE	D.ScheduleDate NOT IN (SELECT CalendarDate 
					                               FROM   Employee.dbo.WorkScheduleDate 
												   WHERE  WorkSchedule = S.WorkSchedule)
					AND		W.Mission = '#mission#'
					AND		D.Operational = 1
					AND 	D.ScheduleDate > '#dateFormat(vCleanupDate,"yyyy-mm-yy")#'
					
					UNION ALL
					
					<!---Invalid WorkSchedule Organization--->
					SELECT 	D.*,
							'Invalid WorkSchedule Organization' as Reason
					FROM	WorkOrderLineScheduleDate D
							INNER JOIN WorkOrderLineSchedule S	ON D.ScheduleId = S.ScheduleId
							INNER JOIN WorkOrderLine L			ON S.WorkOrderId = L.WorkOrderId AND S.WorkOrderLine = L.WorkOrderLine
							INNER JOIN WorkOrder W				ON S.WorkOrderId = W.WorkOrderId 
					WHERE	NOT EXISTS
							(
								SELECT 	'X'
								FROM 	Employee.dbo.WorkScheduleOrganization
								WHERE	WorkSchedule = S.WorkSchedule
								AND		OrgUnit IN (SELECT OrgUnit FROM WorkOrderImplementer WHERE WorkOrderId = W.WorkOrderId)
							)
					AND		W.Mission = '#mission#'
					AND		D.Operational = 1
					AND 	D.ScheduleDate > '#dateFormat(vCleanupDate,"yyyy-mm-yy")#'
					
					<!---No hours defined--->
					<!---UNION ALL
					
					SELECT 	D.*,
							'No hours defined' as Reason
					FROM	WorkOrderLineScheduleDate D
							INNER JOIN WorkOrderLineSchedule S
								ON D.ScheduleId = S.ScheduleId
							INNER JOIN WorkOrderLine L
								ON S.WorkOrderId = L.WorkOrderId
								AND	S.WorkOrderLine = L.WorkOrderLine
							INNER JOIN WorkOrder W
								ON S.WorkOrderId = W.WorkOrderId 
					WHERE	NOT EXISTS
							(
								SELECT 	'X'
								FROM	Employee.dbo.WorkScheduleDateHour
								WHERE	WorkSchedule = S.WorkSchedule
								AND		CalendarDate = D.ScheduleDate
								AND		CalendarHour = D.ScheduleHour
							)
					AND		W.Mission = '#mission#'--->
				) AS Data
			ORDER BY ScheduleId, ScheduleDate, ScheduleHour	
			
	</cfquery>
	
	<!---loop thru all invalid dates--->
	<cfoutput query="getInvalidDatesToDelete" group="ScheduleId">
		
		<cfoutput group="ScheduleDate">
			
			<cfoutput>
				
				<!---remove the date (the same schedule could have many reasons to be deleted) --->
				<cfquery name="delete"
					datasource="AppsWorkorder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						
						UPDATE	WorkOrderLineScheduleDate
						SET		Operational = 0
						WHERE	ScheduleId = '#ScheduleId#'
						AND		ScheduleDate = '#ScheduleDate#'
						AND		ScheduleHour = '#ScheduleHour#'
						
				</cfquery>
				
			</cfoutput>
				
			<!---Log deletion using reason field--->
			<cfset vReason = "Disabled: " & Reason>
			<cf_AssignId>
			<cfquery name="log"
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					
					INSERT INTO Log_WorkOrderLineScheduleDate (
							LogId,
							ScheduleId,
							ScheduleDate,
							Memo,
							Source,
							OfficerUserId,
							Created,
							LogAction,
							LogOfficerUserId )
					VALUES (
							'#RowGuid#',
							'#ScheduleId#',
							'#ScheduleDate#',
							'#Memo#',
							'#Source#',
							'#OfficerUserId#',
							'#Created#',
							'#vReason#',
							'#session.acc#'	
						   )
					
			</cfquery>
			
		</cfoutput>
		
	</cfoutput>
	
	
	<!--- -------------------------------------------------------------------------------------- --->
	<!--- 2. Update the positions that are loaned and thus the new instanced need to be linked  --->
	<!--- -------------------------------------------------------------------------------------- --->
	
	<cfquery name="updateLoanedPositions"
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			UPDATE	WorkOrderLineSchedulePosition
			SET		PositionNo = PosNew.PositionNo
			FROM 	WorkOrderLineSchedulePosition WLSP 
					INNER JOIN Employee.dbo.Position PosNew 
						ON WLSP.PositionNo = PosNew.SourcePositionNo
			WHERE	WLSP.PositionNo NOT IN (
						SELECT	PositionNo
						FROM  	Employee.dbo.Position
						WHERE   PositionNo = WLSP.PositionNo
						AND    	DateExpiration >= #vCleanupDate#
					)
		
	</cfquery>
	
	
	<!----------------------------------------------------------------->
	<!--- 3. Assign the person IF AND ONLY IF, THE PersonNo IS NULL --->
	<!----------------------------------------------------------------->
	
	<cfquery name="updatePersonPositions"
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			UPDATE 	WorkOrderLineSchedulePosition
			SET		PersonNo = 
								ISNULL(
									(
										SELECT TOP 1 PA.PersonNo
										FROM	Employee.dbo.PersonAssignment PA
										WHERE	PA.AssignmentStatus IN ('0','1')
										AND		PA.AssignmentType = 'Actual'
										AND		PA.Incumbency > 0
										AND		PA.DateEffective <= #vCleanupDate#
										AND		PA.PositionNo = UP.PositionNo
										ORDER BY PA.DateEffective DESC, PA.Created DESC 
									),
								PersonNo)
			FROM	WorkOrderLineSchedulePosition UP
			WHERE	EXISTS (	
						SELECT	'X'
						FROM	WorkOrderLineSchedulePosition P
								INNER JOIN WorkOrderLineSchedule S ON P.ScheduleId = S.ScheduleId
								INNER JOIN WorkOrderLine L		   ON S.WorkOrderId = L.WorkOrderId	AND	S.WorkOrderLine = L.WorkOrderLine
								INNER JOIN WorkOrder W			   ON S.WorkOrderId = W.WorkOrderId
						WHERE	W.Mission    = '#mission#'
						AND		P.ScheduleId = UP.ScheduleId
						AND		P.PositionNo = UP.PositionNo
						<!--- IF AND ONLY IF, THE PersonNo IS NULL --->
						AND		P.PersonNo IS NULL
					)
	
	</cfquery>
	
	
	<!-------------------------------------->
	<!--- 4. Reinstate all persons valid --->
	<!-------------------------------------->
	
	<cfquery name="reinstateInvalidPersons"
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			UPDATE	WorkOrderLineSchedulePosition
			SET		Operational = 1
			FROM	WorkOrderLineSchedulePosition UP
			WHERE	EXISTS (
						SELECT 	'X'
						FROM	WorkOrderLineSchedulePosition P
								INNER JOIN WorkOrderLineSchedule S	ON P.ScheduleId = S.ScheduleId
								INNER JOIN WorkOrderLine L			ON S.WorkOrderId = L.WorkOrderId AND	S.WorkOrderLine = L.WorkOrderLine
								INNER JOIN WorkOrder W				ON S.WorkOrderId = W.WorkOrderId
						WHERE	P.ScheduleId = UP.ScheduleId
						AND		P.PositionNo = UP.PositionNo
						AND		P.Operational = 0
						AND		W.Mission = '#mission#'	)		
	</cfquery>	
	
	<!---------------------------------------------------------------------------------------------------->
	<!--- 5. Now we get the people that are assigned which are no longer valid from the staffing table --->
	<!---------------------------------------------------------------------------------------------------->
	
	<cfquery name="getInvalidPersons"
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">

			SELECT	P.*,
					'No valid Assignment' as Reason
					
			FROM	WorkOrderLineSchedulePosition P 
			        INNER JOIN   WorkOrderLineSchedule S ON P.ScheduleId = S.ScheduleId 
					INNER JOIN   WorkOrderLine L ON S.WorkOrderId = L.WorkOrderId AND S.WorkOrderLine = L.WorkOrderLine 
					INNER JOIN   WorkOrder W	 ON S.WorkOrderId = W.WorkOrderId 
					
			WHERE	W.Mission = '#mission#'	
			AND		P.Operational = 1
			AND		S.ActionStatus <> '9'
			AND		P.PersonNo NOT IN
			
			        <!--- is on a valid assignment on a position enabled for this schedule --->
					 
					(
						SELECT	PersonNo
						FROM	Employee.dbo.PersonAssignment
						
						<!--- person has valid assignment for this position --->
						
						WHERE   PositionNo = P.PositionNo
						AND  	AssignmentStatus IN ('0','1')
						AND		AssignmentType = 'Actual'
						AND		Incumbency > 0
						AND		#vCleanupDate# BETWEEN DateEffective AND DateExpiration
						
						<!--- AND position itself is also valid for this task : date and unit --->
												
						AND		PositionNo IN (
									SELECT 	DISTINCT eWSP.PositionNo
									FROM	Employee.dbo.WorkSchedulePosition eWSP INNER JOIN 
									        Employee.dbo.Position Pos ON eWSP.PositionNo = Pos.PositionNo
									WHERE	eWSP.WorkSchedule     = S.WorkSchedule
									AND     eWSP.CalendarDate    >= '#dateFormat(vCleanupDate,client.dateSQL)#'
									AND     eWSP.CalendarDate    <= '#dateFormat(vCleanupDate+30,client.dateSQL)#'
									
									<!--- unit used for this workorder --->
									AND		Pos.OrgUnitOperational IN (SELECT OrgUnit 
									                                   FROM   WorkOrderImplementer 
																	   WHERE  WorkOrderId = S.WorkOrderId)					
								)
					)
		
	</cfquery>

	<!---Loop thru all invalid persons---> 
	
	<cfloop query="getInvalidPersons">
		
		<!---deactivate this person--->
		<cfquery name="update"
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				UPDATE 	WorkOrderLineSchedulePosition
				SET		Operational = 0
				WHERE	ScheduleId  = '#ScheduleId#'
				AND		PositionNo  = '#PositionNo#'
				
		</cfquery>
		
		<!---Log deactivation--->
		<cfset vReason = "Deactivated: " & Reason>
		
		<cf_AssignId>
		
		<cfquery name="log"
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				INSERT INTO WorkOrderLineSchedulePositionLog (
						LogId,
						ScheduleId,
						PersonNo,
						PositionNo,
						isActor,
						Memo,
						Operational,
						OfficerUserId,
						Created,
						LogAction,
						LogOfficerUserId )
				VALUES ('#RowGuid#',
						'#ScheduleId#',
						'#PersonNo#',
						'#PositionNo#',
						'#isActor#',
						'#Memo#',
						'#Operational#',
						'#OfficerUserId#',
						'#Created#',
						'#vReason#',
						'#session.acc#'	)
				
		</cfquery>	
		
		<!---remove the person when is 0 or 1--->
		<cfquery name="delete01"
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				DELETE 	FROM	WorkOrderLineSchedulePosition
				WHERE	ScheduleId = '#ScheduleId#'
				AND		PersonNo   = '#PersonNo#'
				AND		isActor IN ('0','1')
				AND		Operational = 0
				
		</cfquery>
			
		<!---Insert new person--->
			
		<!---Get NEW valid person to add --->
		
		<cfsavecontent variable="newValidPersonBaseQuery">
		
			<cfoutput>
				SELECT TOP 1 *
				FROM	Employee.dbo.PersonAssignment PA
				WHERE	PositionNo    = '#PositionNo#'
				AND     AssignmentStatus IN ('0','1')
				AND		AssignmentType = 'Actual'
				AND		Incumbency     > 0
				AND		#vCleanupDate# BETWEEN DateEffective AND DateExpiration
			</cfoutput>
			
		</cfsavecontent>
		
		<cfset vAllConditionsMet = 0>
		
		<cfquery name="getNewPerson"
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				#preserveSingleQuotes(newValidPersonBaseQuery)#
				
				<!--- is on a VALID assignment TODAY for a position enabled for this schedule /for relevant units either today or in the (near) future --->
				 
				AND		PositionNo IN (
							SELECT 	DISTINCT eWSP.PositionNo
							FROM	Employee.dbo.WorkSchedulePosition eWSP INNER JOIN 
							        Employee.dbo.Position Pos ON eWSP.PositionNo = Pos.PositionNo
							WHERE	eWSP.WorkSchedule = (
															SELECT 	WorkSchedule 
															FROM 	WorkOrderLineSchedule 
															WHERE 	ScheduleId = '#ScheduleId#'
														)
							AND     eWSP.CalendarDate  >= '#dateFormat(vCleanupDate,client.dateSQL)#'		
							AND     eWSP.CalendarDate  <= '#dateFormat(vCleanupDate+30,client.dateSQL)#'					
							AND		Pos.OrgUnitOperational IN 
															(
																SELECT 	OrgUnit 
																FROM 	WorkOrderImplementer
																WHERE 	WorkOrderId = 
																					(
																						SELECT 	WorkOrderId 
																						FROM 	WorkOrderLineSchedule 
																						WHERE 	ScheduleId = '#ScheduleId#'
																					)
															)					
						)
				ORDER BY Created DESC
				
		</cfquery>
		
		<!--- We only have to generate valid data --->
		<cfif getNewPerson.recordCount eq 0>
		
			<!--- <cfquery name="getNewPerson"
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					
					#preserveSingleQuotes(newValidPersonBaseQuery)#
					
					<!--- is on a VALID assignment TODAY for a position enabled for this schedule /for relevant units either today or in the (near) future --->
					 
					AND		PositionNo IN (
								SELECT 	DISTINCT eWSP.PositionNo
								FROM	Employee.dbo.WorkSchedulePosition eWSP INNER JOIN 
								        Employee.dbo.Position Pos ON eWSP.PositionNo = Pos.PositionNo
								WHERE	eWSP.WorkSchedule = 
															(
																SELECT 	WorkSchedule 
																FROM 	WorkOrderLineSchedule 
																WHERE 	ScheduleId = '#ScheduleId#'
															)		
								AND		Pos.OrgUnitOperational IN 
																(
																	SELECT 	OrgUnit 
																	FROM 	WorkOrderImplementer
																	WHERE 	WorkOrderId = 
																						(
																							SELECT 	WorkOrderId 
																							FROM 	WorkOrderLineSchedule 
																							WHERE 	ScheduleId = '#ScheduleId#'
																						)
																)					
							)
					ORDER BY Created DESC
					
			</cfquery> 
			
			<cfif getNewPerson.recordCount eq 1>
				<cfset vAllConditionsMet = 0>
			</cfif> --->
			
		<cfelse>
			
			<cfset vAllConditionsMet = 1>
		
		</cfif>
		
		<cfif getNewPerson.recordCount eq 0>
			
			<!---Log not possible sustitution due to not present employee in the same position on board--->
			<cfset vReason = "No substitution made: no employee in the same position on board with valid workSchedule settings">
			<cf_AssignId>
			
			<cfquery name="log"
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					
					INSERT INTO WorkOrderLineSchedulePositionLog (
							LogId,
							ScheduleId,
							PersonNo,
							PositionNo,
							isActor,
							Memo,
							Operational,
							OfficerUserId,
							Created,
							LogAction,
							LogOfficerUserId )
					VALUES ('#RowGuid#',
							'#ScheduleId#',
							'#PersonNo#',
							'#PositionNo#',
							'#isActor#',
							'#Memo#',
							'#Operational#',
							'#OfficerUserId#',
							'#Created#',
							'#vReason#',
							'#session.acc#'	)
					
			</cfquery>
				
		<cfelse>
			
			<!--- 
			   remove the person when is 2, BUT only if someone else can be assigned as 2 with the same POSITION 
			--->
			
			<cfquery name="delete2"
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">					
					DELETE 	FROM WorkOrderLineSchedulePosition
					WHERE	ScheduleId  = '#ScheduleId#'
					AND		PersonNo    = '#PersonNo#'
					AND		isActor     = '2'
					AND		Operational = 0					
			</cfquery>
			
			<cfquery name="insertNewPerson"
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					
					INSERT INTO	WorkOrderLineSchedulePosition	(
							ScheduleId,
							PersonNo,
							PositionNo,
							isActor,
							Memo,
							Operational,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )
					VALUES ('#ScheduleId#',
							'#getNewPerson.PersonNo#',
							'#getNewPerson.PositionNo#',
							'#isActor#',
							'#Memo#',
							1,
							'#session.acc#',
							'#session.last#',
							'#session.first#' )					
			</cfquery>
			
			<!---Log sustitution--->
			
			<cfset vReason = "Substitution made: " & getNewPerson.PersonNo>
			<cfif vAllConditionsMet eq 0>
				<cfset vReason = vReason & ", (Planning error)">
			</cfif>
			
			<cf_AssignId>
			
			<cfquery name="log"
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					
				INSERT INTO WorkOrderLineSchedulePositionLog (
						LogId,
						ScheduleId,
						PersonNo,
						PositionNo,
						isActor,
						Memo,
						Operational,
						OfficerUserId,
						Created,
						LogAction,
						LogOfficerUserId )
				VALUES ('#RowGuid#',
						'#ScheduleId#',
						'#PersonNo#',
						'#PositionNo#',
						'#isActor#',
						'#Memo#',
						'#Operational#',
						'#OfficerUserId#',
						'#Created#',
						'#vReason#',
						'#session.acc#'	)					
						
			</cfquery>
				
		</cfif>		
		
		<!---Log removal--->
		<cfif isActor eq 0 or isActor eq 1>
			<cfset vReason = "Removed: " & Reason>
		<cfelseif isActor eq 2>
			<cfif getNewPerson.recordCount eq 0>
				<cfset vReason = "Not Removed: " & Reason & " but no responsible still assigned">
			<cfelse>
				<cfset vReason = "Removed: " & Reason>
			</cfif>
		</cfif>
		
		<cf_AssignId>
		
		<cfquery name="log"
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
			INSERT INTO WorkOrderLineSchedulePositionLog (
					LogId,
					ScheduleId,
					PersonNo,
					PositionNo,
					isActor,
					Memo,
					Operational,
					OfficerUserId,
					Created,
					LogAction,
					LogOfficerUserId )
			VALUES	('#RowGuid#',
					'#ScheduleId#',
					'#PersonNo#',
					'#PositionNo#',
					'#isActor#',
					'#Memo#',
					'#Operational#',
					'#OfficerUserId#',
					'#Created#',
					'#vReason#',
					'#session.acc#'	)
				
		</cfquery>
		
	</cfloop>

	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Completed Schedule Cleanup for #mission#"
		StepStatus     = "1">

</cfloop>
