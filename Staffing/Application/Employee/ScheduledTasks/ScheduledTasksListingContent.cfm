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
<cfoutput>
	
	<cfsavecontent variable="myquery">	
	
		SELECT 	*
		FROM
			(
				SELECT DISTINCT
						(WS.Code + '__' + P.Mission) as cKey,
						P.Mission,
						P.PositionNo,
						PA.FunctionDescription,
						PA.AssignmentNo,
						PA.DateEffective,
						PA.DateExpiration,
						WS.Code AS WorkScheduleCode,
						WS.Description AS WorkScheduleDescription,
						(
							SELECT	MIN(CalendarDate)
							FROM	WorkScheduleDate
							WHERE	WorkSchedule = WS.Code
						) AS MinCalendarDate,
						(
							SELECT	CASE
										WHEN PA.DateExpiration < MAX(CalendarDate) THEN PA.DateExpiration
										ELSE MAX(CalendarDate)
									END
							FROM	WorkScheduleDate
							WHERE	WorkSchedule = WS.Code
						) AS MaxCalendarDate,
						(
							ISNULL(
								(
									SELECT	CONVERT(VARCHAR(10),MIN(CalendarHour))
									FROM	WorkScheduleDateHour
									WHERE	WorkSchedule = WS.Code
								)
							,'N/A')
							+ ' - ' +
							ISNULL(
								(
									SELECT	CONVERT(VARCHAR(10),MAX(CalendarHour))
									FROM	WorkScheduleDateHour
									WHERE	WorkSchedule = WS.Code
								)
							,'N/A')
						) AS ShiftHours
				FROM	WorkSchedule WS
						INNER JOIN WorkSchedulePosition WSP
							ON WS.Code = WSP.WorkSchedule
						INNER JOIN Position P
							ON WSP.PositionNo = P.PositionNo
						INNER JOIN PersonAssignment PA
							ON P.PositionNo = PA.PositionNo
				WHERE	PA.AssignmentStatus IN ('0', '1')
				AND		WS.Operational = 1
				AND		PA.PersonNo = '#url.id1#'
			) AS Data
 				 
	</cfsavecontent>	

</cfoutput>				  
		
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

				
<cfset fields[1] = {label   = "Entity",                
					field   = "Mission",
					filtermode = "2",
					search  = "text"}>

<cfset fields[2] = {label   = "No.",                    
					field   = "AssignmentNo",
					search  = "text"}>

<cfset fields[3] = {label   = "Function",                    
					field   = "FunctionDescription",
					search  = "text"}>									
						
<cfset fields[4] = {label      = "Effective",  				
					field      = "DateEffective",
					search     = "date",
					align      = "left",
					formatted  = "dateformat(DateEffective,'#CLIENT.DateFormatShow#')"}>	
					
<cfset fields[5] = {label      = "Expiration", 					
					field      = "DateExpiration",
					search     = "date",
					align      = "left",
					formatted  = "dateformat(DateExpiration,'#CLIENT.DateFormatShow#')"}>	
					
<cfset fields[6] = {label   = "Shift",                
					field   = "WorkScheduleDescription",
					filtermode = "2",
					search  = "text"}>
					
<cfset fields[7] = {label      = "Shift from", 					
					field      = "MinCalendarDate",
					align      = "left",
					formatted  = "dateformat(MinCalendarDate,'#CLIENT.DateFormatShow#')"}>
					
<cfset fields[8] = {label      = "Shift to", 					
					field      = "MaxCalendarDate",
					align      = "left",
					formatted  = "dateformat(MaxCalendarDate,'#CLIENT.DateFormatShow#')"}>
					
<cfset fields[9] = {label   = "Shift Hours",                    
					field   = "ShiftHours",
					align   = "right"}>
								
<cf_listing
    header         = "ScheduledTasks"
    box            = "ScheduledTasks"
	link           = "#SESSION.root#/Staffing/Application/Employee/ScheduledTasks/ScheduledTasksListingContent.cfm?id1=#url.id1#"
    html           = "No"
	show           = "40"
	height         = "100%"
	datasource     = "AppsEmployee"
	listquery      = "#myquery#"
	listgroup      = "Mission"
	listorder      = "DateExpiration"
	listorderdir   = "ASC"	
	listlayout     = "#fields#"
	filterShow     = "Hide"
	excelShow      = "Yes"
	drillmode      = "window"
	drillargument  = "800;1000;false;true"
	drilltemplate  = "Staffing/Application/WorkSchedule/Planning/PlanningViewWrapper.cfm?id1=#url.id1#&key="
	drillkey       = "cKey">
	
					  