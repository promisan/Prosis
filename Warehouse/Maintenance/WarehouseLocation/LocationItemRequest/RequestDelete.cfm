
<cfquery name="delete" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 DELETE FROM ItemWarehouseLocationRequest
		 WHERE		Warehouse = '#url.warehouse#'
		 AND       	Location = '#url.location#'		
		 AND		ItemNo = '#url.itemNo#'
		 AND		UoM = '#url.UoM#'
		 AND		ScheduleEffective = '#url.ScheduleEffective#'
</cfquery>


<cfoutput>
	<script>
		ColdFusion.navigate('../LocationItemRequest/Request.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#','contentbox2');
	</script>
</cfoutput>