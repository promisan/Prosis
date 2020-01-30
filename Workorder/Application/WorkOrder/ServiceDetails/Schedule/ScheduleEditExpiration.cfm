							
	<cfquery name="last" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 1 ScheduleDate				
			FROM     WorkOrderLineScheduleDate						
			WHERE    ScheduleId = '#URL.scheduleId#'		
			AND      Operational = 1										
			ORDER BY ScheduleDate DESC
	</cfquery>
	
	<cfoutput>
	<b>#dateformat(last.ScheduleDate, CLIENT.DateFormatShow)#</b>
	</cfoutput>
