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
<cfparam name="url.action" default="">

<cfswitch expression="#url.action#">
	
	<cfcase value="Delete">
	
		<cfquery name= "remove" 
		    datasource= "AppsEmployee" 
		    username  = "#SESSION.login#" 
			password  = "#SESSION.dbpw#">      				 
				DELETE FROM WorkScheduleOrganization
				WHERE   WorkSchedule = '#url.workschedule#'		
				AND     OrgUnit      = '#url.orgunit#'				
		</cfquery>
	
	</cfcase>
	
	<cfcase value="Insert">
		
		<cfquery name= "check" 
		    datasource= "AppsEmployee" 
		    username  = "#SESSION.login#" 
			password  = "#SESSION.dbpw#">      				 
				SELECT * FROM WorkScheduleOrganization
				WHERE   WorkSchedule = '#url.workschedule#'		
				AND     OrgUnit      = '#url.orgunit#'				
		</cfquery>
		
		<cfif check.recordcount eq "0">
		
		<cfquery name= "add" 
		    datasource= "AppsEmployee" 
		    username  = "#SESSION.login#" 
			password  = "#SESSION.dbpw#">      				 
				INSERT INTO WorkScheduleOrganization
				(WorkSchedule,OrgUnit,OfficerUserId,OfficerLastName,OfficerFirstName)
				VALUES
				('#url.workschedule#',
				 '#url.orgunit#',
				 '#session.acc#',
				 '#session.last#',
				 '#session.first#')
		</cfquery>
		
		</cfif>
	
	</cfcase>
	
</cfswitch>

<cfinclude template="ScheduleOrganizationDetail.cfm">

<cfoutput>
	<script>
		ColdFusion.navigate('#session.root#/Staffing/Application/WorkSchedule/Planning/PlanningDateDetailPosition.cfm?workschedule=#url.workschedule#&selecteddate='+document.getElementById('currentDate').value,'positionContainer');
	</script>
</cfoutput>