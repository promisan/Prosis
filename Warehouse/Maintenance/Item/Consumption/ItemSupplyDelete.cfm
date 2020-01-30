<cfset vField = "ItemNo">
<cfset vPrefix = "">

<cfif url.type eq "AssetItem">
	<cfset vField = "AssetId">
	<cfset vPrefix = "Asset">
	
	<cfquery name="clearWarehouses" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM AssetItemSupplyWarehouse
		WHERE   AssetId = '#URL.id#'
	</cfquery>
	
</cfif>

<cfquery name="delete" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM #vPrefix#ItemSupply
	WHERE   #vField#      = '#URL.id#'
	AND     SupplyItemNo  = '#URL.supply#' 
	AND		SupplyItemUoM = '#URL.supplyuom#' 
</cfquery>	

<cfoutput>
	<script>
		ColdFusion.navigate('#SESSION.root#/Warehouse/Maintenance/Item/Consumption/ItemSupplyListing.cfm?type=#url.type#&id=#url.id#','supplylist')
	</script> 
</cfoutput>
