<cfquery name="delete"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE
		FROM	Ref_PersonEventTrigger
		WHERE	EventTrigger = '#url.trigger#'
		AND		EventCode = '#url.code#'
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('PersonEventListing.cfm?id1=#URL.trigger#','divPersonEvent');
		ColdFusion.Window.hide('mydialog');
	</script>
</cfoutput>