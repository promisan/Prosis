
<cfquery name="delete"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE
	FROM 	Promotion 
	WHERE	PromotionId = '#url.id1#'
</cfquery>

<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
				                     action="Delete" 
									 content="#form#">

<cfoutput>
	<script>
		ColdFusion.navigate('RecordListingDetail.cfm?idmenu=#url.idmenu#&fmission=#url.fmission#','divListing');
	</script>
</cfoutput>