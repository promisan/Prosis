
<cfquery name="Delete" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE 
	FROM 	ServiceItemUnitItem
	WHERE 	ServiceItem = '#url.id1#'
	AND		Unit = '#url.id2#'
	AND		ItemNo = '#url.id3#'
</cfquery>	

<cfoutput>
<script language="JavaScript">   
	ColdFusion.navigate('#SESSION.root#/workorder/maintenance/unitRate/ItemUnitItemListing.cfm?ID1=#URL.ID1#&ID2=#URL.ID2#','listingItem')
</script> 
</cfoutput>