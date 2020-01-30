<cfquery name="delete" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 	DELETE
		FROM	Ref_ModuleControlSectionCell
		WHERE	SystemFunctionId = '#url.id#'
		AND		FunctionSection = '#url.section#'
		AND		CellCode = '#url.code#'
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('Section/FunctionSectionCell.cfm?id=#url.id#&section=#url.section#', 'divCellListing');
	</script>
</cfoutput>