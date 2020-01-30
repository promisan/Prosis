
	<cfquery name="get" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT	*
	FROM 	Ref_ModuleControl
	WHERE  	SystemFunctionId = '#URL.ID#'
	</cfquery>
	
	<cfquery name="Delete" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_ModuleControlDetailLog
	WHERE  SystemFunctionId = '#URL.ID#'
	</cfquery>
	
	<cfquery name="Delete" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_ModuleControl
	WHERE  SystemFunctionId = '#URL.ID#'
	</cfquery>
	
	<cfquery name="Delete" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_ModuleControl
	WHERE  MenuClass = 'Builder'
	AND FunctionName = '---'
	</cfquery>
	
	<script language="JavaScript">
		window.close();
		returnValue = 9;
	</script>