
<cfquery name="Update" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM ItemUoM
	WHERE   ItemNo = '#URL.id#'
	AND     UoM    = '#URL.UoM#' 
</cfquery>	

<cfoutput>
<script>
	ColdFusion.navigate('UoM/ItemUoMList.cfm?id=#url.id#&uomselected=#url.uom#','uomlist')
</script> 
</cfoutput> 