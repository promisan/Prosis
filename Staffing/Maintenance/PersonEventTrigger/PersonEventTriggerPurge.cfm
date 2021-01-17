
<cfquery name="delete"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE
		FROM	Ref_PersonEventTrigger
		WHERE	EventTrigger = '#url.trigger#'
		AND		EventCode    = '#url.code#'
</cfquery>

<cfoutput>
	<script>
		ptoken.navigate('PersonEventListing.cfm?id1=#URL.trigger#','divPersonEvent');
		
	</script>
</cfoutput>