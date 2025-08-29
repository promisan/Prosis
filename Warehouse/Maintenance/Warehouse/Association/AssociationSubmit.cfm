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
<cftransaction>


	<cfquery name="getMission" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Warehouse
			WHERE	Warehouse = '#url.warehouse#'
	</cfquery>

	<cfquery name="listing" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	SELECT 	*
	    	FROM 	Warehouse
			WHERE	Operational = 1
			AND		Warehouse != '#url.warehouse#'
			-- AND		Mission = '#getMission.mission#'
	</cfquery>
	
	<cfquery name="clean" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	DELETE
	    	FROM 	WarehouseAssociation
			WHERE	Warehouse = '#url.warehouse#'
			AND		AssociationType = '#url.type#'
	</cfquery>
	
	<cfloop query="listing">
		
		<cfif isDefined("Form.cb_#warehouse#")>
		
			<cfset vWA = evaluate("Form.cb_#warehouse#")>
			<cfquery name="insert" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    	INSERT INTO WarehouseAssociation (
							Warehouse,
							AssociationType,
							AssociationWarehouse,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						) VALUES (
							'#url.warehouse#',
							'#url.type#',
							'#warehouse#',
							'#session.acc#',
							'#session.last#',
							'#session.first#'
						)
			</cfquery>
			
		</cfif>
		
	</cfloop>

</cftransaction>

<cfoutput>
	<script>
		ptoken.navigate('Association/AssociationListingDetail.cfm?warehouse=#url.warehouse#&type=#url.type#','divAssociation');
	</script>
</cfoutput>