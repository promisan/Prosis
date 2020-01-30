
<cfquery name="Update" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	Ref_WarehouseCity
		WHERE  	Mission = '#url.mission#'
		AND		City = '#url.city#'
</cfquery>

<script language="JavaScript">
     parent.window.close();
	 opener.location.reload();
</script>  
