		
<cfquery name="Delete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_EntryClass
		WHERE Code   = '#url.id1#'
</cfquery>


<cfoutput>
	<script>
		window.opener.ColdFusion.navigate('RecordListingDetail.cfm?idmenu=#url.idmenu#&fmission=#url.fmission#','divListing');
		window.close();
	</script>
</cfoutput>