<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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