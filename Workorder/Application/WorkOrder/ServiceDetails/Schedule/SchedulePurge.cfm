

<cfquery name="check" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 * FROM  WorkOrderLineAction
		WHERE   ScheduleId = '#url.scheduleId#'
</cfquery>

<cfif check.recordcount gte "1">

	
	<cfquery name="delete" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE WorkOrderLineSchedule
			SET    ActionStatus = '9', 
			       ActionstatusDate = getDate(), 
				   ActionStatusOfficer = '#Session.acc#'
			WHERE  ScheduleId = '#url.scheduleId#'
	</cfquery>


<!--- no possible --->

<cfelse>
	
	<cfquery name="delete" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM  WorkOrderLineSchedule
			WHERE   ScheduleId = '#url.scheduleId#'
	</cfquery>

</cfif>
	
<cfoutput>
	<script>
		ColdFusion.navigate('Schedule/ScheduleListing.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#','contentbox1');
	</script>
</cfoutput>