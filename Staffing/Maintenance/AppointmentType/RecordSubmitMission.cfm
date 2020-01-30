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