
<cfquery name="Delete" 
	     datasource="AppsControl" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM ClassFunctionTemplate
		 WHERE TemplateFunctionId = '#URL.TemplateFunctionId#' 	
</cfquery>

<cfoutput>
<script>
	#ajaxlink('#SESSION.root#/system/parameter/functionClass/ViewDetail/FunctionTemplate.cfm?id=#URL.ID#')#
</script>

</cfoutput>