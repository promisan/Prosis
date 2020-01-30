
<cfset vyear = mid(url.effectiveDate, 1, 4)>
<cfset vmonth = mid(url.effectiveDate, 6, 2)>
<cfset vday = mid(url.effectiveDate, 9, 2)>
<cfset vEffectiveDate = createDate(vyear, vmonth, vday)>


<cfquery name="Delete" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		DELETE FROM	ItemVendorOffer
		WHERE	OfferId     = '#url.OfferId#'		
</cfquery>

<cfoutput>
	<script>
	    _cf_loadingtexthtml='';	
		ptoken.navigate('#SESSION.root#/Warehouse/Maintenance/ItemMaster/vendors/vendorEditDetail.cfm?mission=#url.mission#&itemno=#url.itemno#&uom=#uom#&orgunitvendor=#orgunitvendor#','divVendorOfferListing');
	</script>
</cfoutput>