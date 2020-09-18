
<cfquery name="delete" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE
	FROM 	WarehouseProgram
	WHERE 	Warehouse = '#url.warehouse#'
	AND		ProgramCode = '#url.programcode#'
</cfquery>

<cfoutput>
	<script>
	    _cf_loadingtexthtml='';	
		ptoken.navigate('Program/ProgramListing.cfm?warehouse=#url.warehouse#', 'contentbox2');
	</script>
</cfoutput>