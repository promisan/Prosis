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