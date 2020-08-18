
<cftry>
	
	<cfquery name="Delete" 
		datasource="#url.dsn#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		UPDATE #url.table#
		SET ActionStatus = '9'
		WHERE #url.key# = '#url.val#'	
	</cfquery>	

<cfcatch>
	
	<cfquery name="Delete" 
		datasource="#url.dsn#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		DELETE FROM #url.table#
		WHERE #url.key# = '#url.val#'	
	</cfquery>	

</cfcatch>

</cftry>


	