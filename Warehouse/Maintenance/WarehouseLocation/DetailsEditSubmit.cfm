
<cfset vCapacity = replace(form.capacity, ",", "", "ALL")>

<cfquery name="update" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		UPDATE   WarehouseLocationCapacity
		SET		 DetailDescription = '#form.detailDescription#',
				 DetailStorageCode = '#form.DetailStorageCode#',
				 Capacity          = #vCapacity#
		WHERE    Warehouse         = '#url.warehouse#'
		AND		 Location          = '#url.location#'
		AND		 DetailId          = '#url.detailid#'
		
</cfquery>

<cfoutput>
<script>
	parent.parent.editLocationRefresh('#url.warehouse#','#url.location#')
	parent.parent.ProsisUI.closeWindow('mydialog',true)	
</script>
</cfoutput>