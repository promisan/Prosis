<cfquery name="Delete" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		DELETE FROM	ItemVendor
		WHERE	ItemNo = '#url.id#'
		AND		UoM = '#url.uom#'
		AND		OrgUnitVendor = #url.orgunitvendor#
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('#SESSION.root#/Warehouse/Maintenance/ItemMaster/vendors/vendorListing.cfm?id=#url.id#&mission=#url.mission#','divVendorListing');
	</script>
</cfoutput>

