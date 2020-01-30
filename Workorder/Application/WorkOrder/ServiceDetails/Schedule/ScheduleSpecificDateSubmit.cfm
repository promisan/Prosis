
<cfif url.action eq "insert">
	
	<cfif url.date neq "">
		
		<cfset selDate = replace("#url.date#","'","","ALL")>
		<cfset dateValue = "">
		<cf_dateConvert value="#selDate#">
		<cfset vDate = dateValue>
	
		<cfset vValue = createDate(year(vDate),month(vDate),day(vDate)) + 0>
	
		<cftry>
		
			<cfquery name="insert" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO WorkOrderLineScheduleDetail (
							ScheduleId,
							IntervalDomain,
							IntervalValue,
							Memo,
							Operational,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )
					VALUES ('#url.ScheduleId#',
							'date',
							#vValue#,
							'#url.memo#',
							1,
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#' )
			</cfquery>
			
			<cfcatch></cfcatch>
			
		</cftry>
		
	</cfif>
	
</cfif>

<cfif url.action eq "delete">
	<cfquery name="delete" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM WorkOrderLineScheduleDetail
			WHERE	ScheduleId = '#url.ScheduleId#'
			AND		IntervalDomain = 'date'
			AND		IntervalValue = #url.value#
	</cfquery>
</cfif>

<cfoutput>
	<script>
	    ColdFusion.navigate('ScheduleSummary.cfm?scheduleid=#url.scheduleid#','summarybox')
		ColdFusion.navigate('ScheduleSpecificDate.cfm?ScheduleId=#url.ScheduleId#','divSpecificDate');
	</script>
</cfoutput>