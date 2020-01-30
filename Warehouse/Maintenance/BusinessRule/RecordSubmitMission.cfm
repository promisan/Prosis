<cfquery name="Clear" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	Ref_MissionBusinessRule
		WHERE 	ValidationCode = '#url.Code#' 
</cfquery>

<cfquery name="GetMissions" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ParameterMission
</cfquery>


<cfloop query="GetMissions">

	<cfif isDefined("Form.Mission_#Mission#")>
	
		<cfquery name="Insert" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_MissionBusinessRule
					(
						Mission,
						ValidationCode,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#Evaluate("Form.Mission_#Mission#")#',
						'#url.code#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
	
	</cfif>

</cfloop>