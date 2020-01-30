<cfquery name="delete" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE	Publication
		SET		ActionStatus = '9'
		WHERE	PublicationId = '#url.publicationId#'
</cfquery>

<cfoutput>
	<script>
		window.close();
		window.opener.ColdFusion.navigate('#session.root#/WorkOrder/Application/Activity/Publication/PublicationListing.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#url.workorderid#','contentbox2');
	</script>
</cfoutput>