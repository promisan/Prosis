
<cfoutput>

<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   * 
	FROM     Ref_ModuleControl 
	WHERE    SystemFunctionId = '#URL.ID#'
	</cfquery>
	
	<script>
	{
	    window.location = "#SESSION.root#/Portal/Topics/#Searchresult.FunctionPath#/Topic.cfm?name=#Searchresult.FunctionName#&id=#id#&mode=regular"
	}			
	
	</script>
	
</cfoutput>	