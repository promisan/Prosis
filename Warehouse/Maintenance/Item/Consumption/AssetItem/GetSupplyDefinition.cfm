
<!--- <cfquery name="clearWarehouses" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM AssetItemSupplyWarehouse
	WHERE   AssetId = '#URL.id#'
</cfquery>

<cfquery name="clear" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM AssetItemSupply
	WHERE   AssetId = '#URL.id#'
</cfquery> --->

<cfinclude template="AssetItemSupplyDefinition.cfm">

<cfoutput>
	<script>
		ColdFusion.navigate('#SESSION.root#/Warehouse/Maintenance/Item/Consumption/ItemSupplyListing.cfm?type=AssetItem&id=#url.id#','supplylist');
	</script>
</cfoutput>