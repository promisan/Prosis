<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE 
		FROM 	Ref_AssetEventCategory
		WHERE 	EventCode = '#url.id1#'
		AND		Category = '#url.category#'
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('RecordEditDetail.cfm?idmenu=#url.idmenu#&id1=#url.id1#','divDetail');
	</script> 
</cfoutput>