	
<!--- Query returning search results --->
<cfquery name="Template"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Schedule S
	WHERE  ScheduleId = '#URL.ID#' 
</cfquery>

<!--- verify if a schedule is already running for this id with a actionstatus = 0 and created time less than
10 minutes different then we do not launch this one --->
			
	<cfoutput> 
		<cfdiv bind="url:#SESSION.root#/Tools/Scheduler/RunScheduler.cfm?idlog=#url.idlog#&id=#url.id#&mode=manual&#Template.SchedulePassThru#">
	</cfoutput>

