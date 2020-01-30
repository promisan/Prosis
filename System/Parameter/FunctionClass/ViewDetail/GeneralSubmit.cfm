<cfquery name="Update" 
     datasource="AppsControl" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 UPDATE ClassFunction
	 SET ClassFunctionCode = '#Form.ClassFunctionCode#',
	     FunctionDescription = '#Form.FunctionDescription#',
		 FunctionReference = '#Form.FunctionReference#',
		 ClassFunctionType = '#Form.TypeId#',
		 ClassId= '#Form.ClassId#'
	 WHERE ClassFunctionId = '#Form.ClassFunctionId#' 
</cfquery>

<cfoutput>
<script>
	#ajaxlink('#SESSION.root#/system/parameter/functionClass/ViewDetail/General.cfm?id=#Form.ClassFunctionId#')#
</script>

</cfoutput>
	
