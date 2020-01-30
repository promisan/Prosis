
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
	