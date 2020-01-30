
<cfoutput>

<cfquery name="Delete" 
	     datasource="AppsControl" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM ClassFunctionAttribute
		 WHERE ClassFunctionId= '#URL.ID#' and
		 Attribute='#URL.AttrName#'
</cfquery>


<script>
	#ajaxlink('#SESSION.root#/system/parameter/functionClass/ViewDetail/UseCaseSelectAttr.cfm?id=#URL.ID#')#
</script>

</cfoutput>