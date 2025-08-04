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