<cfquery name="delete" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	Ref_AssetActionCategoryWorkflow
		WHERE	ActionCategory = '#url.action#'
		AND		Category = '#url.category#'
		AND		Code = '#url.code#'
</cfquery>

<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                         action ="Delete"
							 contenttype="Scalar" 
							 content="ActionCategory:#url.action#, Category:#url.category#, Code:#url.code#">

<cfoutput>
	<script>
		ptoken.navigate('Logging/CategoryWorkflowListing.cfm?category=#url.category#&code=#url.action#', 'divObservations_#url.action#');
	</script>
</cfoutput>