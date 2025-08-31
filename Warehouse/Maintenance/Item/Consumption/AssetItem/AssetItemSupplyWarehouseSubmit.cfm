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
<cfquery name="warehouse" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	W.*,
			SW.Warehouse as Selected
	FROM 	Warehouse W
			LEFT OUTER JOIN AssetItemSupplyWarehouse SW
				ON SW.Warehouse = W.Warehouse
				AND 	SW.AssetId = '#url.itemno#'
				AND 	SW.SupplyItemNo = '#url.supply#'
				AND		SW.SupplyItemUoM = '#url.uom#'
	WHERE	W.Mission IN (SELECT Mission FROM AssetItem WHERE AssetId = '#url.itemNo#')
	AND     W.Operational = 1
	ORDER BY W.City, W.Warehousename
</cfquery>

<cfquery name="clear" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE
	FROM 	AssetItemSupplyWarehouse
	WHERE 	AssetId = '#url.itemno#'
	AND 	SupplyItemNo = '#url.supply#'
	AND		SupplyItemUoM = '#url.uom#'
</cfquery>

<cfloop query="warehouse">

	<cfif isDefined("Form.wh_#trim(warehouse)#")>
	
		<cfquery name="insert" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO AssetItemSupplyWarehouse (
					AssetId,
					SupplyItemNo,
					SupplyItemUoM,
					Warehouse,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName )
			VALUES (
					'#url.itemno#',
					'#url.supply#',
					'#url.uom#',
					'#warehouse#',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#' )
		</cfquery>
		
	</cfif>

</cfloop>

<cfoutput>
	<script>
		ColdFusion.navigate('#session.root#/warehouse/maintenance/item/Consumption/AssetItem/AssetItemSupplyWarehouse.cfm?itemno=#url.itemno#&supply=#url.supply#&uom=#url.uom#,'divAssetItemSupplyWarehouse');
	</script>
</cfoutput>