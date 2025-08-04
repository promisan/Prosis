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
<cfif url.everyNSelector eq "day">
	<cfset vSchemaPeriodicityInterval = url.everyNDays>
<cfelseif url.everyNSelector eq "month">
	<cfset vSchemaPeriodicityInterval = url.everyNMonths>
<cfelseif url.everyNSelector eq "year">
	<cfset vSchemaPeriodicityInterval = url.everyNYears>
</cfif>

<cfset weekDayList = "">
<cfloop index="vDay" from="1" to="7">
	<cfif evaluate("url.day_" & vDay) eq "true">
		<cfset weekDayList = ListAppend(weekDayList, vDay, ",")>
	</cfif>
</cfloop>

<cfset monthDayList = "">
<cfloop index="vMonthDay" from="1" to="3">
	<cfif trim(evaluate("url.mth_" & vMonthDay)) neq "">
		<cfset monthDayList = ListAppend(monthDayList, evaluate("url.mth_" & vMonthDay), ",")>
	</cfif>
</cfloop>

<cfquery name="getSerialNo" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  ISNULL(MAX(SchemaSerialNo),0) as LastSerial
		FROM    WorkOrderLineScheduleSchema
		WHERE   ScheduleId = '#url.scheduleId#'
</cfquery>

<cfset vSerialNo = 1>
<cfif getSerialNo.recordCount eq 1>
	<cfset vSerialNo = getSerialNo.LastSerial + 1>
</cfif>


<cfquery name="insert" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO WorkOrderLineScheduleSchema
			(
				ScheduleId,
				SchemaSerialNo,
				DateEffective,
				DateExpiration,
				Periodicity,
				PeriodicityInterval,
				ApplyDaysOfWeek,
				ApplyDaysOfMonth,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName
			)
		VALUES
			(
				'#url.ScheduleId#',
				#vSerialNo#,
				#url.schemaEffective#,
				#url.schemaExpiration#,
				'#url.everyNSelector#',
				#vSchemaPeriodicityInterval#,
				'#weekDayList#',
				'#monthDayList#',
				'#session.acc#',
				'#session.last#',
				'#session.first#'
			)
</cfquery>
