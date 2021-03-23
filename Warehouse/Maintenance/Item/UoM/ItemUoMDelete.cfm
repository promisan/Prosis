
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
	ptoken.navigate('#session.root#/Warehouse/Maintenance/Item/UoM/ItemUoMList.cfm?id=#url.id#&uomselected=#url.uom#','uomlist')
</script> 
</cfoutput> 