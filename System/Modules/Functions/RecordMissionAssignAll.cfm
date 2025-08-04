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