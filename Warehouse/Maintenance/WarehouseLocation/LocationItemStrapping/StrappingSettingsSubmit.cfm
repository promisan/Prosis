<cfquery name="clear" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	UPDATE	ItemWarehouseLocation
	SET
			StrappingScale = '#form.StrappingScale#',
			StrappingIncrement = '#form.StrappingIncrement#',
			StrappingIncrementMode = '#form.StrappingIncrementMode#'
	WHERE 	Warehouse = '#url.warehouse#'
	AND		Location = '#url.location#'
	AND		ItemNo = '#url.itemNo#'
	AND		UoM = '#url.uom#'
</cfquery>

<cfset url.redirect = 0>
<cfinclude template="StrappingRefresh.cfm">

<cfoutput>
	<script>
		ColdFusion.navigate('../LocationItemStrapping/Strapping.cfm?warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#&showOpenST=1','contentbox2');		
	</script>
</cfoutput>