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
<cfparam name="url.visibilityMission" default="">

<!---Define the date that will be generated, always tomorrow--->
<cfset vGenerationDate = dateAdd("d", 1, now())>
<cfset vVisibilityDate = createDate(year(vGenerationDate), month(vGenerationDate), day(vGenerationDate))>

<cfquery name="getActions" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

		SELECT 	ISNULL(MAX(BatchDaysSpan), 0) as CalculationDaysSpan
		FROM 	Ref_Action
		WHERE	EntryMode = 'Batch'
		AND		Mission = '#url.visibilityMission#'

</cfquery>

<cfquery name="RemoveActionVisibilityForTheFuture" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		DELETE
		FROM	WorkOrderLineActionTopic
		WHERE	WorkActionId IN 
				(
					SELECT 	WorkActionId
					FROM 	WorkOrderLineAction
					WHERE	CONVERT(VARCHAR(10),DateTimePlanning,126) >= '#dateformat(vVisibilityDate,"YYYY-MM-DD")#' 
					AND		WorkOrderId IN (SELECT WorkOrderId FROM WorkOrder WHERE Mission = '#url.visibilityMission#')	   
				)
		AND		Topic = 'AC001'
	
</cfquery>

<cfloop index="vCalulationVisibilityDate" from="#vVisibilityDate#" to="#dateAdd('d',getActions.CalculationDaysSpan,vVisibilityDate)#">

	<cfquery name="getWorkOrders" 
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT DISTINCT 	
					W.WorkOrderId,
					W.ServiceItem,
					W.Mission
			FROM	WorkOrder W
					INNER JOIN WorkOrderLine L
						ON W.WorkOrderId = L.WorkOrderId
			WHERE	L.Operational   = 1
			AND		L.DateEffective <= #vCalulationVisibilityDate# AND (L.DateExpiration is NULL or L.DateExpiration >= #vCalulationVisibilityDate#)
			AND		W.ServiceItem IN (SELECT ServiceItem FROM Ref_TopicServiceItem WHERE Code = 'AC001')
			AND		W.Mission = '#url.visibilityMission#'
		
	</cfquery>
	
	<cfloop query="getWorkOrders">
	
		<cfquery name="ActionsList" 
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	A.*,
						ISNULL(
							(
							SELECT 	ListCode 
							FROM 	Ref_ActionServiceItemTopic 
							WHERE 	Code = A.Code 
							AND 	ServiceItem = '#ServiceItem#' 
							AND 	Topic = 'AP002'
							),
							(
								SELECT 	ListCode
								FROM	Ref_TopicList
								WHERE	Code = 'AP002'
								AND		Operational = 1
								AND		ListDefault = 1
							)
						) DisplayRecords,
						ISNULL(
							(
								SELECT 	ListCode 
								FROM 	Ref_ActionServiceItemTopic 
								WHERE 	Code = A.Code 
								AND 	ServiceItem = '#ServiceItem#' 
								AND 	Topic = 'AP001'
							),
							(
								SELECT 	ListCode
								FROM	Ref_TopicList
								WHERE	Code = 'AP001'
								AND		Operational = 1
								AND		ListDefault = 1
							)
						) DisplayRecordsMode
				FROM 	Ref_Action A
				WHERE	A.Mission = '#mission#'
				AND		A.Operational = 1
		</cfquery>
		
		<cfquery name="qVisibilityActions" 
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 	
			
			   SELECT 	Data.*
			   FROM	
			   		(
						<cfoutput query="ActionsList">
							<cfset vSelectStatement = "SELECT *">
							<cfset vOrderStatement = "DateTimePlanning DESC">
							
							<cfif DisplayRecords neq "" and DisplayRecordsMode neq "">
								<!--- regular --->
								<cfif DisplayRecordsMode eq "0">
									<cfif DisplayRecords gt 0>
										<cfset vSelectStatement = "SELECT TOP " & DisplayRecords & " * ">
									</cfif>
								</cfif>
								
								<!--- random --->
								<cfif DisplayRecordsMode eq "1">
									<cfif DisplayRecords gt 0>
										<cfset vSelectStatement = "SELECT TOP " & DisplayRecords & " * ">
										
										<!--- Randomness --->
										<cfset cnt = 0>
										<cfset vOrderStatement = "">
										
										<cfloop condition="cnt lte 3">
											
											<!--- allowed fields in the query --->
											<cfset vTestN = RandRange(6,9)>
											<cfset vTestD = RandRange(1,2)>
											
											<cfif vTestD eq 1>
												<cfset vTestDirection = "ASC">									
											<cfelseif vTestD eq 2>
												<cfset vTestDirection = "DESC">
											</cfif>
											
											<cfif Find(vTestN,vOrderStatement) eq 0>
												<cfset vOrderStatement = vOrderStatement & vTestN & " " & vTestDirection & ",">
												<cfset cnt = cnt + 1>
											</cfif>
											
										</cfloop>
										
										<cfset vOrderStatement = mid(vOrderStatement, 1, len(vOrderStatement) - 1)>
										
									</cfif>
								</cfif>
							</cfif>
							
							SELECT 	*
							FROM 
							(
								#vSelectStatement#
								FROM
									(
										SELECT	Wa.WorkOrderId,
												Wa.ActionClass,
												Wa.SerialNo,
												Wa.DateTimeRequested,
												Wa.DateTimeActual,
												Wa.DateTimePlanning,
												Wa.WorkActionId,
												Wa.ScheduleId,
												Wa.WorkOrderLine,
												CONVERT(VARCHAR(5000),Wa.ActionMemo) AS ActionMemo
										FROM	WorkOrderLineAction Wa
										WHERE   Wa.WorkOrderId   = '#getWorkOrders.workorderid#'		
									   	AND     CONVERT(VARCHAR(10),WA.DateTimePlanning,126) = '#dateformat(vCalulationVisibilityDate,"YYYY-MM-DD")#' 	   
									   	<!--- only batch actions --->
									   	AND     WA.ActionClass IN (SELECT Code 
									                               FROM   Ref_Action 
												        		   WHERE  Code = WA.ActionClass
																   AND    EntryMode = 'Batch')
										AND		WA.ActionClass = '#Code#'
									) as Data#Code#
								<cfif (DisplayRecordsMode eq "0" or DisplayRecordsMode eq "1") and DisplayRecords gt 0>
									ORDER BY #vOrderStatement#
								</cfif>
							) AS OrderedData#Code#
							
							<cfif ActionsList.recordCount neq currentrow>
								UNION
							</cfif>
						</cfoutput>
					) as Data
			   
		</cfquery>

		<cfloop query="qVisibilityActions">
		
			<cfquery name="RemoveActionVisibility" 
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					DELETE
					FROM	WorkOrderLineActionTopic
					WHERE	WorkActionId = '#qVisibilityActions.WorkActionId#'
					AND		Topic = 'AC001'
				
			</cfquery>
			
			<cfquery name="InsertActionVisibility" 
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					INSERT INTO WorkOrderLineActionTopic
						(
							WorkActionId,
							Topic,
							ListCode,
							TopicValue,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					VALUES
						(
							'#qVisibilityActions.WorkActionId#',
							'AC001',
							'0',
							'true',
							'#session.acc#',
							'#session.last#',
							'#session.first#'
						)
				
			</cfquery>
			
		</cfloop>
	
	
	</cfloop>

</cfloop>