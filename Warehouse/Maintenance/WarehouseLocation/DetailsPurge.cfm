<cfquery name="delete" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM     WarehouseLocationCapacity
		WHERE    Warehouse = '#url.warehouse#'
		AND		 Location = '#url.location#'
		AND		 DetailId = '#url.detailid#'
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('DetailsListing.cfm?warehouse=#url.warehouse#&location=#url.location#','divWLCapacity');
	</script>
</cfoutput>