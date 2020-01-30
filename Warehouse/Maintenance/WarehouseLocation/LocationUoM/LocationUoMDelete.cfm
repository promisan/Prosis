
<cfquery name="delete" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 DELETE FROM ItemWarehouseLocationUoM
		 WHERE		Warehouse = '#url.warehouse#'
		 AND       	Location = '#url.location#'		
		 AND		ItemNo = '#url.itemNo#'
		 AND		UoM = '#url.UoM#'
		 AND		MovementUoM = '#url.movement#'
</cfquery>


<cfoutput>
	<script>
		ColdFusion.navigate('../LocationUoM/LocationUoM.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#','contentbox2');
	</script>
</cfoutput>