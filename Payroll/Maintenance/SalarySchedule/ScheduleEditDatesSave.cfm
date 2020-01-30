
<cfquery name="Comp"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM SalaryScheduleComponent
	WHERE ComponentId = '#URL.ComponentId#'	
</cfquery>

<cfquery name="Dates"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM SalaryScheduleComponentDate
	WHERE  SalarySchedule = '#comp.SalarySchedule#'
	AND    ComponentName  = '#comp.ComponentName#'
</cfquery>

<cfloop index="dt" list="#URL.Dates#" delimiters=":">

	  <cfset dateValue = "">
		<CF_DateConvert Value="#dt#">
		<cfset STR = dateValue>
	
	<cftry>
	
		<cfquery name="Dates"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO SalaryScheduleComponentDate
			       (SalarySchedule,ComponentName,EntitlementDate)
			VALUES ('#comp.SalarySchedule#','#comp.ComponentName#',#str#)
		</cfquery>
	
	<cfcatch></cfcatch>
	</cftry>

</cfloop>

<cfinclude template="ScheduleEditDates.cfm">
