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
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  TOP 1 *
	FROM   	WorkScheduleDate
	WHERE  	WorkSchedule = '#url.workschedule#'	
</cfquery>	

<cfif check.recordcount eq "0">

<cfquery name="delete" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE
	FROM   	WorkSchedule
	WHERE  	Code = '#url.workschedule#'
	AND		Mission   = '#URL.Mission#'	
</cfquery>	

<cfelse>
	
	<cfquery name="check" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  TOP 1 *
		FROM   	WorkScheduleDateHour
		WHERE  	WorkSchedule = '#url.workschedule#'
		AND     CalendarDate > getDate()	
	</cfquery>	
	
	
	<cfif check.recordcount eq "0">			
			
		<cfquery name="update" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE 	WorkSchedule
			SET     Operational = 0
			WHERE  	Code = '#url.workschedule#'	
		</cfquery>	

	</cfif>

</cfif>

<cfoutput>
	<script>
		ColdFusion.navigate('#SESSION.root#/staffing/application/workschedule/WorkScheduleListing.cfm?mission=#url.mission#&mandate=#url.mandate#','contentbox5');
	</script>
</cfoutput>