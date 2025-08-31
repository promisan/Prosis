<!--
    Copyright © 2025 Promisan B.V.

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