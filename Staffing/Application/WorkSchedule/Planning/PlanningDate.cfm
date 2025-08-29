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
<cfquery name="get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   CalendarDate
		FROM     WorkScheduleDateHour
		WHERE    WorkSchedule = '#url.workschedule#' 		 
		AND      CalendarDate = #url.calendardate#				
</cfquery>

<cfif get.recordcount gte "1">
	
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="#E5E5E5" style="border:1px solid silver">
	<tr>
		
		<td valign="top" class="labelit" style="padding:2px;">
			
			<cfquery name="get" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     WorkSchedule
					WHERE    Code    = '#url.workschedule#' 		 
			</cfquery>
			
			<cfoutput>
				<cfsavecontent variable="scheduleQuery">
					SELECT	DH.*,
							A.ActionDescription
				    FROM   	WorkScheduleDateHour DH
				    		LEFT OUTER JOIN Ref_WorkAction A
				    			ON DH.ActionClass = A.ActionClass
					WHERE  	DH.WorkSchedule = '#url.workschedule#' 
					AND    	DH.CalendarDate = #url.calendardate#
				</cfsavecontent>
			</cfoutput>
			
			<cf_groupScheduleHours 
				dataSource		= "AppsEmployee"
				scheduleQuery	= "#scheduleQuery#"
				hourField		= "CalendarHour"
				memoField		= "ActionDescription"
				hourMode		= "#get.HourMode#">	
		
		</td>
		
	</tr>
	</table>

</cfif>
	