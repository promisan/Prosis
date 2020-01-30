<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE 
		FROM Ref_AssetEvent
		WHERE Code = '#url.id1#'
</cfquery>

<script>
	opener.location.reload();
	window.close();
</script> 