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
<cfparam name="url.isCopy" default="0">

<cf_screentop height="100%" html="no">

<cfset dateValue = "">
<CF_DateConvert Value="#form.feffective#">
<cfset vDate = dateValue>

<cfset vWorkOrderLine = url.WorkOrderLine>
<cfif isDefined("Form.fworkorderline")>
	<cfif trim(Form.fworkorderline) neq "">
		<cfset vWorkOrderLine = Form.fworkorderline>
	</cfif>
</cfif>


<cfquery name="schedulesToCopy" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	*
		FROM	WorkOrderLineSchedule
		WHERE	WorkOrderId   = '#url.WorkOrderId#'
		AND		WorkOrderLine = '#url.WorkOrderLine#'
		AND		ActionClass   = '#url.ActionClass#'
		AND		WorkSchedule  = '#url.WorkSchedule#'
</cfquery>

<cfloop query="schedulesToCopy">

	<cftransaction>
	
		<cf_assignId>
		
		<!--- Schedule --->
		<cfquery name="insertSchedule" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO WorkOrderLineSchedule (
						ScheduleId,
						WorkOrderId,
						WorkOrderLine,
						ActionClass,
						WorkSchedule,
						WorkSchedulePriority,
						ScheduleEffective,
						ScheduleClass,
						ScheduleName,
						Memo,
						ActionStatus,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName )
				VALUES (
						'#RowGuid#',
						'#url.workorderId#',
						'#vWorkOrderLine#',
						'#form.factionclass#',
						'#form.fworkschedule#',
						'#WorkSchedulePriority#',
						#vDate#,
						'#ScheduleClass#',
						'#ScheduleName#',
						'#memo#',
						'#ActionStatus#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
		
		<cfset url.scheduleid = rowguid>
		<cfif url.isCopy eq "0">
			<cfinclude template="ScheduleCustomSubmit.cfm">
		</cfif>
		
		<cfif isDefined("Form.PersonNo")>
		
			<cfif trim(Form.PersonNo) neq "">
		
				<!--- Get current assignment --->
				<cfquery name  = "currentAssignment" 
				   	datasource= "AppsWorkOrder" 
				    username  = "#SESSION.login#" 
					password  = "#SESSION.dbpw#">
					SELECT 	*
					FROM	Employee.dbo.PersonAssignment
					WHERE	PersonNO = '#Form.PersonNo#'
					AND		AssignmentStatus IN ('0','1')
					AND		AssignmentType = 'Actual'
					AND		Incumbency > 0
					AND		getDate() BETWEEN DateEffective AND DateExpiration
				</cfquery>
				
				<!--- Person Responsible --->
				<cfquery name  = "insertSchedulePerson" 
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
					VALUES ('#RowGuid#',
							'#form.personNo#',
							'#currentAssignment.positionNo#',
							'2',
							1,
							null,
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
						)
				</cfquery>
				
			</cfif>
		
		</cfif>
		
		
		<!--- Dates and hours --->
		
		<!--- The effective date --->
		<cfif form.fhours eq "1">
			<cfquery name  = "dateDefinition" 
			   	datasource= "AppsWorkOrder" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">
					SELECT 	*
					FROM	WorkOrderLineScheduleDate
					WHERE	ScheduleId = '#ScheduleId#'
					AND		ScheduleDate = #vDate#
					AND     Operational = 1
			</cfquery>
		</cfif>
		
		<!--- First date after or equal to effective date --->
		<cfif form.fhours eq "2">
			<cfquery name  = "dateDefinition" 
			   	datasource= "AppsWorkOrder" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">
					SELECT	*
					FROM	WorkOrderLineScheduleDate D
					WHERE	ScheduleId = '#ScheduleId#'
					AND 	Operational = 1
					AND		ScheduleDate = 
											(
												SELECT TOP 1 ScheduleDate
												FROM	WorkOrderLineScheduleDate
												WHERE	ScheduleId = D.ScheduleId
												AND		ScheduleDate >= #vDate#
												AND     Operational = 1
												ORDER BY ScheduleDate ASC
											)
			</cfquery>
		</cfif>
		
		<!--- First date before or equal to effective date --->
		<cfif form.fhours eq "3">
		
			<cfquery name  = "dateDefinition" 
			   	datasource= "AppsWorkOrder" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">
					SELECT	*
					FROM	WorkOrderLineScheduleDate D
					WHERE	ScheduleId = '#ScheduleId#'
					AND     Operational = 1
					AND		ScheduleDate = 
											(
												SELECT TOP 1 ScheduleDate
												FROM	 WorkOrderLineScheduleDate
												WHERE	 ScheduleId = D.ScheduleId
												AND		 ScheduleDate <= #vDate#
												AND      Operational = 1
												ORDER BY ScheduleDate DESC
											)
			</cfquery>
		</cfif>
		
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
		
		<cfif dateDefinition.recordCount gt 0>
		
			<cfquery name  = "validDateHours" 
			   	datasource= "AppsWorkOrder" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">
					SELECT	*
					FROM	Employee.dbo.WorkScheduleDateHour
					WHERE	WorkSchedule = '#form.fworkschedule#'
					AND		CalendarDate >= '#dateDefinition.scheduleDate#'
					AND		CalendarDate <= ISNULL((SELECT MAX(ScheduleDate) FROM WorkOrderLineScheduleDate WHERE ScheduleId = '#ScheduleId#' AND Operational = 1), '30001231')
					ORDER BY CalendarHour ASC
			</cfquery>
			
			<cfquery name  = "getWorkSchedule" 
			   	datasource= "AppsWorkOrder" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">    
				SELECT  *
				FROM   	Employee.dbo.WorkSchedule
			    WHERE   Code = '#form.fworkschedule#'		
			</cfquery>
			
			<cfloop query="validDateHours" endrow="1">
			
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
						INSERT INTO WorkOrderLineScheduleDate (
								ScheduleId,
								ScheduleDate,
								ScheduleHour,
								Memo,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName )
						VALUES ('#RowGuid#',
								'#CalendarDate#',
								#vCalendarHour#,
								'#validateDateDefinition.Memo#',
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#' )
					</cfquery>
				
				</cfif>
			
			</cfloop>
			
			<cfloop query="validDateHours">
			
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
						INSERT INTO WorkOrderLineScheduleDate (
								ScheduleId,
								ScheduleDate,
								ScheduleHour,
								Memo,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName )
						VALUES ('#RowGuid#',
								'#CalendarDate#',
								#vCalendarHour#,
								'#validateDateDefinition.Memo#',
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#' )
					</cfquery>
				
				</cfif>
			
			</cfloop>
		
		</cfif>		
	
	</cftransaction>

</cfloop>

<cfoutput>
	<script>
		ColdFusion.navigate('#session.root#/workorder/application/workorder/servicedetails/Schedule/ScheduleListing.cfm?workorderid=#url.workOrderId#&workorderline=#url.workorderline#','contentbox1');
		try {
			ColdFusion.Window.destroy('windowCopyWorkSchedule');
		}catch(e){}
	</script>
</cfoutput>