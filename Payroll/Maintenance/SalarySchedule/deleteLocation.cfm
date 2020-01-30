

<cfquery name="check"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM SalaryScale
		WHERE ServiceLocation  = '#url.Location#'
		AND   SalarySchedule   = '#url.Schedule#'
		AND    Mission         = '#url.Mission#'					
</cfquery>			