
<cfquery name="get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemFunctionId = '#URL.SystemFunctionId#'	
</cfquery>


<cfquery name="check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemModule  = '#get.SystemModule#'
	AND    FunctionClass = '#get.FunctionClass#'
	AND    FunctionName  = '#url.name#'
	AND   SystemFunctionId != '#URL.SystemFunctionId#'	
</cfquery>

<cfif check.recordcount gte "1">

	<font color="FF0000">Name is already in use</font>
	
<cfelse>
	
	<cfquery name="get" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_ModuleControl
		SET FunctionName = '#url.name#'
		WHERE  SystemFunctionId = '#URL.SystemFunctionId#'	
	</cfquery>

	<cf_compression>	

</cfif>
