<cfquery name="Purge" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM   	Customer
		WHERE  	CustomerId = '#url.id#'
</cfquery>

<script>
	parent.window.close();
	opener.applyfilter('','','content');
</script>