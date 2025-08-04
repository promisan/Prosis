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

<cf_tl id="This code was already registered!" var="vMes1">

<cfoutput>

<cfif URL.WorkSchedule eq "">

	<cfquery name="validate" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT	*
		FROM   	WorkSchedule
		WHERE  	Code     = '#form.code#'		
	</cfquery>	
	
	<cfif validate.recordCount eq 0>
	
		<cfquery name="insert" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO WorkSchedule (
					Code,
					Mission,
					Description,
					ListingOrder,
					HourMode,
					MultipleActions,
					<cfif Form.ScheduleClass neq "">ScheduleClass,</cfif>
					Operational,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName )
			VALUES
				(
					'#trim(Form.Code)#',
					'#URL.Mission#',
					'#Form.Description#',
					#Form.ListingOrder#,
					'#Form.HourMode#',
					'#Form.MultipleActions#',
					<cfif Form.ScheduleClass neq "">'#ScheduleClass#',</cfif>
					#Form.Operational#,
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#'
				)	
		</cfquery>	
		
		<script>
			parent.parent.ColdFusion.Window.destroy('scheduledialog',true)
			parent.parent.editWorkScheduleRefresh('#url.mission#','#url.mandate#')		
		</script>
		
	<cfelse>
	
		<cfif validate.operational eq "0" and validate.mission eq url.mission>
		
			<cfquery name="validate" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE 	WorkSchedule
				SET     Operational = 1
				WHERE  	Code     = '#form.code#'	     	
		    </cfquery>	
			
			<script>
				parent.parent.ColdFusion.Window.destroy('scheduledialog',true)
				parent.parent.editWorkScheduleRefresh('#url.mission#','#url.mandate#')		
			</script>
		
		<cfelse>
		
			<cfoutput>
				<script>
					alert('#vMes1#');
				</script>
			</cfoutput>
			
		</cfif>
	
	</cfif>

<cfelse>

	<cfquery name="update" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE 	WorkSchedule
		SET		Description     = '#form.description#',
				Operational     = #Form.Operational#,
				HourMode        = '#Form.HourMode#', 
				MultipleActions = '#Form.MultipleActions#',
				ListingOrder    = #Form.ListingOrder#,
				ScheduleClass   = <cfif Form.ScheduleClass neq "">'#ScheduleClass#'<cfelse>null</cfif>
		WHERE 	Code            = '#URL.WorkSchedule#'
	</cfquery>
	
	<cfif Form.OldHourMode lt Form.HourMode>
		
		<cfquery name="deleteHours" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE 
			FROM 	WorkScheduleDateHour
			WHERE 	WorkSchedule = '#URL.WorkSchedule#'
			AND		CalendarDate > #dateAdd('d', -1, now())#
		</cfquery>
		
	</cfif>	
	
	<script>
		parent.parent.ColdFusion.Window.destroy('scheduledialog',true)
		parent.parent.editWorkScheduleRefresh('#url.mission#','#url.mandate#')		
	</script>

</cfif>

</cfoutput>

