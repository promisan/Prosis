<cfquery name="delete" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM	PublicationCluster
		WHERE	PublicationId = '#url.publicationId#'
		AND		Code = '#url.code#'
</cfquery>

<cfoutput>
	<script>
		parent.window.location.reload();
	</script>
</cfoutput>