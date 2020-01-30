<cfquery name="qDelete"
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE ItemBOMDetail
		WHERE  MaterialId = '#url.materialid#'		
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('UoMBOM/ItemUoMBOM.cfm?ID=#URL.ItemNo#&UoM=#URL.UoM#','itemUoMBOM');
	</script>
</cfoutput>