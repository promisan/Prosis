
<cfif url.type eq "Remove">	
	
	<cfquery name="DeleteMissions" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Ref_ModuleControlRoleMission
		WHERE 	SystemFunctionId = '#URL.id#'
		AND		Role             = '#URL.id1#'
	</cfquery>
	
<cfelse>	
	
	<cfquery name="InsertMissions" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Ref_Mission
		WHERE	Operational = 1
	</cfquery>
	
	<cfloop query="InsertMissions">
		<cftry>
			<cfquery name="Insert" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Ref_ModuleControlRoleMission
				    (SystemFunctionId,
					 Role,
					 Mission,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
				VALUES
				  ('#URL.id#',
					'#URL.id1#',
					'#Mission#',
					'#SESSION.acc#',
			   		'#SESSION.last#',
			   		'#SESSION.first#') 
			</cfquery>
		<cfcatch></cfcatch>		
		</cftry>
	</cfloop>

</cfif>

<cfoutput>
	<script>
		ColdFusion.navigate('RecordMissionListing.cfm?ID=#URL.ID#&role=#url.id1#&allType=#url.type#','irolen');
		ColdFusion.navigate('#SESSION.root#/System/Modules/Functions/Role_Mission.cfm?ID=#URL.ID#&role=#url.id1#', 'divRoleMission_#URL.ID#_#url.id1#');
	</script>
</cfoutput>