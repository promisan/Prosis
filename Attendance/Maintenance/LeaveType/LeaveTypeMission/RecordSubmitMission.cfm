<cfquery name="CleanMissionList" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM   	Ref_LeaveTypeMission
		WHERE	LeaveType = '#url.Code#'
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
	
	<cftry>
	
		<cfif isDefined("Form.mission_#idMission#")>
		
			<cfquery name="InsertMission" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO Ref_LeaveTypeMission
						(
							LeaveType,
							Mission
						)
					VALUES
						(
							'#url.Code#',
							'#Mission#'
						)
			</cfquery>
		</cfif>
	
	<cfcatch></cfcatch>
	
	</cftry>
	
</cfoutput>

<cfoutput>
	<script>
		ColdFusion.navigate('LeaveTypeMission/RecordMission.cfm?code=#url.code#','contentbox2');
	</script>
</cfoutput>