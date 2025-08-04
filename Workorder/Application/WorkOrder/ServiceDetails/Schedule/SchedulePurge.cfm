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