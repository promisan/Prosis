<cfquery name="delete" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM ItemUoMVolume
	WHERE   ItemNo      = '#URL.id#'
	AND     UoM         = '#URL.uom#' 
	AND		Temperature = '#URL.Temperature#' 
</cfquery>	

<cfoutput>
<script>
	ColdFusion.navigate('UoMVolume/ItemUoMVolume.cfm?id=#url.id#&UoM=#URL.UoM#','itemUoMVolumelist')
</script> 
</cfoutput> 