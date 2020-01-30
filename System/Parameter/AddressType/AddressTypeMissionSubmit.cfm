<cfquery name="GetMissions" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_Mission
</cfquery>

<cfquery name="Clear" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE
	FROM   Ref_AddressTypeMission
	WHERE  Code  = '#url.id1#' 
</cfquery>

<cfoutput query="GetMissions">
	<cfset vMission = "Form.mission_" & trim(replace(mission,'-','_','ALL'))>
	<cfif isDefined(vMission)>
		<cfquery name="Clear" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_AddressTypeMission
				(
					Code,
					Mission,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName
				)
			VALUES
				(
					'#url.id1#',
					'#mission#',
					'#SESSION.acc#',
			    	'#SESSION.last#',		  
				  	'#SESSION.first#'
				)
		</cfquery>
	</cfif>
</cfoutput>