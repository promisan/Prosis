<cfquery name="delete" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM ItemUoMMission
	WHERE   ItemNo    = '#URL.id#'
	AND     UoM       = '#URL.uom#' 
	AND		Mission   = '#URL.mission#' 
</cfquery>	

<cfoutput>
<script>
	ColdFusion.navigate('UoMMission/ItemUoMMissionView.cfm?id=#url.id#&UoM=#URL.UoM#','itemUoMMissionlist')
</script> 
</cfoutput> 