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
<cfquery name="WH" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	Warehouse
		WHERE  	Operational = 1
		AND		Distribution = 1
</cfquery>

<cfquery name="clear" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM   	Ref_RequestWorkflowWarehouse
		WHERE  	RequestType = '#url.type#'
		AND		RequestAction = '#url.action#'
</cfquery>

<cfloop query="WH">
	<cfif isDefined("Form.wh_#warehouse#")>
		
		<cfquery name="insert" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_RequestWorkflowWarehouse
					(
						RequestType,
						RequestAction,
						Warehouse,
						Operational,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#url.type#',
						'#url.action#',
						'#warehouse#',
						1,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
	
	<cfelse>
	
		<cfquery name="delete" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE 
				FROM 	Ref_RequestWorkflowWarehouse
				WHERE  	RequestType = '#url.type#'
				AND		RequestAction = '#url.action#'
				AND		Warehouse = '#warehouse#'
		</cfquery>
			
	</cfif>
</cfloop>