<cfquery name="Delete" 
     datasource="AppsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     DELETE FROM WarehouseCategory
	 WHERE 	Warehouse   = '#url.Warehouse#'
	 AND	Category    = '#url.Category#'
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('Category/CategoryListing.cfm?ID1=#url.warehouse#', '#url.warehouse#_list');
	</script>
</cfoutput>