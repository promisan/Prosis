
	<cfquery name="Module" 
		 datasource="AppsSystem"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Ref_ModuleControl
		 WHERE  SystemModule = '#url.systemmodule#'	
		 AND    FunctionClass = 'Application'		
		 AND    MenuClass != 'Builder'
	</cfquery> 		
				
	<select name="SystemFunctionName" id="SystemFunctionName" style="font:10px">
	  <option value="">n/a</option>
	  <cfoutput query="Module">
	  <option value="#FunctionName#">#FunctionName#</option>
	  </cfoutput>
	</select>
