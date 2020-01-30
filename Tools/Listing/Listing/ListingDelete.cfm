
<cfquery name="Delete" 
	datasource="#url.dsn#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	DELETE FROM #url.table#
	WHERE #url.key# = '#url.val#'	
</cfquery>	

<cf_compression>


	