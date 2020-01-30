<cfparam name="url.type" 	default="from">

<cfset vTable = "CopySchedulePerson_#session.acc#">
<cfif trim(url.type) eq "to">
	<cfset vTable = "CopySchedulePersonTo_#session.acc#">
</cfif>

<cfquery name="removePerson" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	#vTable#
		WHERE 	PersonNo = '#url.personNo#'
</cfquery>

<cfoutput>
	<script>
		ptoken.navigate('#session.root#/Attendance/Application/TimeView/Propagate/ScheduleCopy.cfm?orgunit=#url.orgunit#&personno=&asof=#url.asof#&weeks=#url.weeks#&effective=#url.effective#&max=#url.max#&maxTo=#url.maxTo#', 'properties');
	</script>
</cfoutput>