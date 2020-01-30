
<cfquery name="check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  TOP 1 *
	FROM   	WorkScheduleDate
	WHERE  	WorkSchedule = '#url.workschedule#'	
</cfquery>	

<cfif check.recordcount eq "0">

<cfquery name="delete" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE
	FROM   	WorkSchedule
	WHERE  	Code = '#url.workschedule#'
	AND		Mission   = '#URL.Mission#'	
</cfquery>	

<cfelse>
	
	<cfquery name="check" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  TOP 1 *
		FROM   	WorkScheduleDateHour
		WHERE  	WorkSchedule = '#url.workschedule#'
		AND     CalendarDate > getDate()	
	</cfquery>	
	
	
	<cfif check.recordcount eq "0">			
			
		<cfquery name="update" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE 	WorkSchedule
			SET     Operational = 0
			WHERE  	Code = '#url.workschedule#'	
		</cfquery>	

	</cfif>

</cfif>

<cfoutput>
	<script>
		ColdFusion.navigate('#SESSION.root#/staffing/application/workschedule/WorkScheduleListing.cfm?mission=#url.mission#&mandate=#url.mandate#','contentbox5');
	</script>
</cfoutput>