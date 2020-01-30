
<!--- saving the form content --->

<cftransaction>


<cfif lcase(url.field) eq "operational">

	<cfif url.fieldValue eq 0>
	
		<cfquery name="removePeriodicity" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE
				FROM	WorkOrderLineScheduleDetail
				WHERE	ScheduleId     = '#url.scheduleId#'
				AND		IntervalDomain = '#url.IntervalDomain#'
				AND		IntervalValue  = '#url.IntervalValue#'
		</cfquery>
	
	<cfelse>
	
		<cfquery name="insertPeriodicity" 
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
				VALUES	(
						'#url.ScheduleId#',
						'#url.intervalDomain#',
						'#url.intervalValue#',
						null,
						1,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#' )
		</cfquery>
	
	</cfif>
	
</cfif>

<cfif lcase(url.field) eq "memo">

	<cfquery name="updatePeriodicity" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE	WorkOrderLineScheduleDetail
			SET		Memo = '#url.fieldValue#'
			WHERE	ScheduleId = '#url.scheduleId#'
			AND		IntervalDomain = '#url.IntervalDomain#'
			AND		IntervalValue = '#url.IntervalValue#'
	</cfquery>

</cfif>

</cftransaction>

<cfoutput>
<script>
	try { opener.applyfilter('1','','#url.scheduleid#') } catch(e) { }		
</script>
</cfoutput>

<table>
	<tr>
		<td style="color:77B4F7; font-size:10px; padding-right:3px;"><cf_tl id="Saved"></td>
	</tr>
</table>