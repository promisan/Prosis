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

<cfquery name="Comp"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM SalaryScheduleComponent
	WHERE ComponentId = '#URL.ComponentId#'	
</cfquery>

<cfquery name="Dates"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM SalaryScheduleComponentDate
	WHERE  SalarySchedule = '#comp.SalarySchedule#'
	AND    ComponentName  = '#comp.ComponentName#'
</cfquery>

<cfloop index="dt" list="#URL.Dates#" delimiters=":">

	  <cfset dateValue = "">
		<CF_DateConvert Value="#dt#">
		<cfset STR = dateValue>
	
	<cftry>
	
		<cfquery name="Dates"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO SalaryScheduleComponentDate
			       (SalarySchedule,ComponentName,EntitlementDate)
			VALUES ('#comp.SalarySchedule#','#comp.ComponentName#',#str#)
		</cfquery>
	
	<cfcatch></cfcatch>
	</cftry>

</cfloop>

<cfinclude template="ScheduleEditDates.cfm">
