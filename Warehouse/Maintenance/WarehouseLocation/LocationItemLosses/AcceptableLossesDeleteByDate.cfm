<cfset vyear = mid(url.dateEffective, 1, 4)>
<cfset vmonth = mid(url.dateEffective, 6, 2)>
<cfset vday = mid(url.dateEffective, 9, 2)>

<cfset vDateEffective = createDate(vyear, vmonth, vday)>

<cfquery name="delete" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 DELETE FROM ItemWarehouseLocationLoss
		 WHERE		Warehouse = '#url.warehouse#'
		 AND       	Location = '#url.location#'		
		 AND		ItemNo = '#url.itemNo#'
		 AND		UoM = '#url.UoM#'
		 AND		DateEffective = #vDateEffective#
</cfquery>


<cfoutput>
	<script>
		ColdFusion.navigate('../LocationItemLosses/AcceptableLosses.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#','contentbox2');
	</script>
</cfoutput>