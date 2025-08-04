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
<cfquery name="ClearItemMasterMission" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE 	ItemMasterMission
		WHERE	ItemMaster = '#url.immCode#'
</cfquery>

<cfquery name="Mis" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	M.*
	FROM 	Ref_ParameterMission M
	WHERE 	M.Mission IN (SELECT Mission 
                          FROM   Organization.dbo.Ref_MissionModule 
			              WHERE  SystemModule = 'Procurement')
	AND     M.MissionPrefix is not NULL						  
</cfquery>

<cfloop query="Mis">

    <cfparam name="Form.Mission_#MissionPrefix#" default="">

	<cfset selected = evaluate("Form.Mission_#MissionPrefix#")>
	
	<cfif selected neq "">
		
		<cfquery name="InsertItemMasterMission" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				INSERT INTO	ItemMasterMission (
						ItemMaster,
						Mission,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName )
						
				VALUES ('#url.immCode#',
						'#Mission#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#' )					
						
		 </cfquery>
		
	</cfif>

</cfloop>