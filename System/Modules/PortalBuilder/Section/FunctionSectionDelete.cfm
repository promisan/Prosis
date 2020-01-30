
<cfquery name="delete" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 	DELETE
		FROM	Ref_ModuleControlSection
		WHERE	SystemFunctionId = '#url.id#'
		AND		FunctionSection = '#url.section#'
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('#SESSION.root#/System/Modules/PortalBuilder/Section/FunctionSection.cfm?id=#url.id#', 'contentbox1');
	</script>
</cfoutput>