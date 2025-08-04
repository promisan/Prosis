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
<cfquery name="CleanMissionList" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE  FROM Ref_AppointmentStatusMission
		WHERE	AppointmentStatus = '#Form.Code#'
</cfquery>

<cfquery name="MissionList" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	*
		FROM   	Ref_ParameterMission
</cfquery>

<cfoutput query="MissionList">

	<cfset idMission = replace(mission, " ", "", "ALL")>
	<cfset idMission = replace(idmission, "-", "", "ALL")>
	<cfset idMission = replace(idmission, "&", "", "ALL")>
	<cfset idMission = replace(idmission, ".", "", "ALL")>
	
	<cfif isDefined("Form.mission_#idMission#")>
	
		<cfquery name="InsertMission" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_AppointmentStatusMission (
						AppointmentStatus,
						Mission	)
				VALUES ('#Form.Code#','#Mission#')
		</cfquery>
		
	</cfif>
	
</cfoutput>