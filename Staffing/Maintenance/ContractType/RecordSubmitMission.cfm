<cfquery name="CleanMissionList" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM   	Ref_ContractTypeMission
		WHERE	ContractType = '#Form.ContractType#'
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
	<cfset idMission = replace(idMission, "-", "", "ALL")>
	<cfset idMission = replace(idMission, "&", "", "ALL")>
	<cfset idMission = replace(idMission, ".", "", "ALL")>
	
	<cfif isDefined("Form.mission_#idMission#")>
		<cfquery name="InsertMission" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_ContractTypeMission
					(
						ContractType,
						Mission
					)
				VALUES
					(
						'#Form.ContractType#',
						'#Mission#'
					)
		</cfquery>
	</cfif>
	
</cfoutput>