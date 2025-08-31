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
<cfparam name="url.activityid" 		default="">
<cfparam name="url.ProgramCode" 	default="">
<cfparam name="url.Period" 			default="">
<cfparam name="url.refresh" 		default="0">

<cfif not isDefined("vThisActivity")>
	<cfset vThisActivity = url.ActivityId>
</cfif>

<cfif isDefined("Form.ProgramCode")>
	<cfset vThisProgramCode = Form.ProgramCode>
<cfelse>
	<cfset vThisProgramCode = url.ProgramCode>
</cfif>

<cfif isDefined("Form.Period")>
	<cfset vThisPeriod = form.Period>
<cfelse>
	<cfset vThisPeriod = url.Period>
</cfif>

<cfquery name="Parameter" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
	    FROM	Employee.dbo.Parameter
</cfquery>

<cfquery name="removeSchemas" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE 
		FROM 	ProgramActivitySchema
		WHERE 	ProgramCode = '#vThisProgramCode#'
		AND 	ActivityPeriod = '#vThisPeriod#'
		AND 	ActivityId = '#vThisActivity#'
</cfquery>

<cfloop index="vDay" from="1" to="7">
	<cf_AssignId>
	
	<cfset vTarget = evaluate("Form.target_#vDay#")>
	<cfset vColor = evaluate("Form.PresentationColor_#vDay#")>
	
	<cfquery name="addSchema" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO [dbo].[ProgramActivitySchema]
		           ([ActivitySchemaId]
				   ,[ProgramCode]
		           ,[ActivityPeriod]
		           ,[ActivityId]
		           ,[WeekDay]
		           ,[TargetUoM]
		           ,[Target]
		           ,[PresentationColor]
		           ,[Operational]
		           ,[OfficerUserId]
		           ,[OfficerLastName]
		           ,[OfficerFirstName])
		     VALUES
		           ('#RowGuid#'
				   ,'#vThisProgramCode#'
		           ,'#vThisPeriod#'
		           ,'#vThisActivity#'
		           ,'#vDay#'
		           ,'FTE'
		           ,'#vTarget#'
		           ,'#vColor#'
		           ,'1'
		           ,'#session.acc#'
		           ,'#session.last#'
		           ,'#session.first#')
	</cfquery>
	
	<cfloop index="vHour" from="#parameter.hourStart#" to="#parameter.hourEnd#">
		<cfset vActualHour = vHour>
		<cfif vActualHour lt 0>
			<cfset vActualHour = 24 + vHour>
		</cfif>
		
		<cfif isDefined("Form.hourDay_#vActualHour#_#vDay#")>
			<cfset vPayment = evaluate("Form.payment_#vActualHour#_#vDay#")>
			
			<cfquery name="addSchemaSchedule" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO [dbo].[ProgramActivitySchemaSchedule]
				           ([ActivitySchemaId]
				           ,[CalendarDateHour]
				           ,[Hourslot]
				           ,[ActivityPayment]
				           ,[OfficerUserId]
				           ,[OfficerLastName]
				           ,[OfficerFirstName])
				     VALUES
				           ('#RowGuid#'
				           ,'#vHour#'
				           ,'1'
				           ,'#vPayment#'
						   ,'#session.acc#'
				           ,'#session.last#'
		           		   ,'#session.first#')
			</cfquery>
		</cfif>
	</cfloop>
</cfloop>

<cfif url.refresh eq "1">
	<cfinclude template="ActivitySchemaEdit.cfm">
	<script>
		Prosis.busy('no');
	</script>
</cfif>