
<cfquery name="update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE 	WorkSchedulePosition
		<cfif url.pointerbreak eq "-">
		SET		PointerBreak = NULL		
		<cfelse>
		SET		PointerBreak = '#url.pointerbreak#'		
		</cfif>
		WHERE 	workschedule  = '#URL.WorkSchedule#'
		AND     PositionNo     = '#url.positionno#'
		AND     CalendarDate   >= #url.date#
</cfquery>
