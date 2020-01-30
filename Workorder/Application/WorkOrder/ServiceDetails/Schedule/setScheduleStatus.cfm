
<cfif url.actionstatus eq "true">
	 <cfset actionstatus = "1">
	 Enabled
<cfelse>
	 <cfset actionstatus = "0">
	 <font color="FF0000">Disabled</font>
</cfif>

<cfquery name="set" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   WorkOrderLineSchedule 
		SET   ActionStatus = '#actionstatus#', ActionStatusDate = getDate(), ActionStatusOfficer = '#session.acc#'
		WHERE ScheduleId = '#url.scheduleid#'		
</cfquery>
