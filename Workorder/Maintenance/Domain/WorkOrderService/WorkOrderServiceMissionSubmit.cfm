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
<cfquery name="GetMissionsSubmit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	M.*
		FROM   	Ref_MissionModule MM
				INNER JOIN Ref_Mission M
					ON MM.Mission = M.Mission
		WHERE  	MM.SystemModule = 'WorkOrder'
</cfquery>

<cftransaction>

	<!--- Remove all missions --->
	<cfquery name="clean" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE 
			FROM	WorkOrderServiceMission
			WHERE	ServiceDomain = '#url.id1#'
			AND		Reference = '#url.id2#'
	</cfquery>
	
	<cfloop query="GetMissionsSubmit">
	
		<cfif isDefined("form.mission_#mission#")>
		
			<cfset vOrgUnit = evaluate("form.orgunit1_#mission#")>
			
			<cfquery name="insert" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO WorkOrderServiceMission
						(
							ServiceDomain,
							Reference,
							Mission,
							OrgUnitImplementer,
							OfficerUserId,
						 	OfficerLastName,
					 		OfficerFirstName
						)
					VALUES
						(
							'#url.id1#',
							'#url.id2#',
							'#mission#',
							'#vOrgUnit#',
							'#SESSION.acc#',
			    	  		'#SESSION.last#',		  
				  	  		'#SESSION.first#'
						)
			</cfquery>
			
		</cfif>
		
	</cfloop>

</cftransaction>