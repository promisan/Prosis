<cfquery name="delete" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	Ref_ModuleControl
		WHERE 	SystemFunctionId = '#url.id#'
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('TopicListingDetail.cfm','divTopicListing');
	</script>
</cfoutput>