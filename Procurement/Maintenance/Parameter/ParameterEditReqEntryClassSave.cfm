<cf_compression>

<cfquery name="Update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_ParameterMissionEntryClass
	<cfif url.value neq "">
	SET    #url.field# = '#url.value#' 
	<cfelse>
	SET    #url.field# = NULL 
	</cfif>
	WHERE  Mission    = '#URL.Mission#'
	<cfif url.period neq "">
	AND    Period     = '#URL.Period#'
	</cfif>
	AND    EntryClass = '#url.class#' 		
</cfquery>
