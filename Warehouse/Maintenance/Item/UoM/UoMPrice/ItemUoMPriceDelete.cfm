<cfquery name="delete" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM ItemUoMPrice
	WHERE   ItemNo    = '#URL.id#'
	AND     UoM       = '#URL.uom#' 
	AND		PriceId   = '#URL.price#' 
</cfquery>	

<cfoutput>
<script>
	ColdFusion.navigate('UoMPrice/ItemUoMPriceView.cfm?id=#url.id#&UoM=#URL.UoM#&selectedmission=#URL.selectedMission#','itemUoMPricelist')
</script> 
</cfoutput> 