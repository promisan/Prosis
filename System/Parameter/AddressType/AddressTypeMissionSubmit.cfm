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