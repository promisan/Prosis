
<cfquery name="Update" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE   Ref_ModuleControl
	SET      FunctionInfo  = '#Form.FunctionInfo#'		
	WHERE    SystemFunctionId = '#URL.SystemFunctionId#'
</cfquery>

<!---
<cfinclude template="FunctionMemo.cfm">
--->

	

		
