<cfset vTable = "RemoveSchedulePerson_#session.acc#">

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
		ptoken.navigate('#session.root#/Attendance/Application/TimeView/Propagate/ScheduleRemove.cfm?orgunit=#url.orgunit#&personno=&removeEffectiveDate=#url.removeEffectiveDate#&removeExpirationDate=#url.removeExpirationDate#', 'properties');
	</script>
</cfoutput>