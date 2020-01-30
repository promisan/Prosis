
<cfquery name="get" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ItemWarehouseLocation
		WHERE	ItemLocationId = '#url.id#'
</cfquery>


<cfquery name="clear" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	DELETE 
	FROM 	ItemWarehouseLocationStrapping
	WHERE 	Warehouse = '#get.warehouse#'
	AND		Location = '#get.location#'
	AND		ItemNo = '#get.itemNo#'
	AND		UoM = '#get.uom#'
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('../LocationItemStrapping/Strapping.cfm?warehouse=#get.warehouse#&location=#get.location#&itemNo=#get.ItemNo#&uoM=#get.UoM#&showOpenST=1','contentbox2');		
	</script>
</cfoutput>