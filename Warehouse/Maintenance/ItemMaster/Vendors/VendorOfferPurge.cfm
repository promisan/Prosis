<cfquery name="Delete" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		DELETE FROM	ItemVendorOffer
		WHERE	ItemNo = '#url.itemno#'
		AND		UoM = '#url.uom#'
		AND		OrgUnitVendor = #url.orgunitvendor#
		AND		OfferId = '#url.offerId#'
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('#SESSION.root#/Warehouse/Maintenance/ItemMaster/vendors/vendorEditDetail.cfm?mission=#url.mission#&itemno=#url.itemno#&uom=#uom#&orgunitvendor=#orgunitvendor#','divVendorOfferListing');
	</script>
</cfoutput>

