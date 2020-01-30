<cfquery name="validate" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 	SELECT	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule = '#url.systemmodule#'
		AND		FunctionClass = '#url.functionClass#'
		AND		MenuClass = 'Main'
		AND		FunctionName = '#evaluate("Form.FunctionName_#client.languageId#")#'
</cfquery>

<cfif validate.recordCount gt 0>
			
	<script>
		alert('This name already exists.  Please, enter a new name.');
	</script>
	
<cfelse>
	
	<cf_AssignId>
		
	<cfset vFunctionId = rowguid>
	
	<cfquery name="Insert" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 INSERT INTO Ref_ModuleControl
		 	(
				SystemFunctionId,
				SystemModule,
				FunctionClass,
				MenuClass,
				MenuOrder,
				FunctionName,
				<cfif trim(evaluate("Form.FunctionMemo_#client.languageId#")) neq "">FunctionMemo,</cfif>
				<cfif trim(Form.FunctionHost) neq "">FunctionHost,</cfif>
				<cfif trim(Form.FunctionDirectory) neq "">FunctionDirectory,</cfif>
				<cfif trim(Form.FunctionPath) neq "">FunctionPath,</cfif>
				FunctionTarget,
				OfficerUserId,
				OfficerFirstName,
				OfficerLastName
			)
		VALUES
			(
				'#vFunctionId#',
				'#url.systemmodule#',
				'#url.functionClass#',
				'Main',
				#Form.menuOrder#,
				'#evaluate("Form.FunctionName_#client.languageId#")#',
				<cfif trim(evaluate("Form.FunctionMemo_#client.languageId#")) neq "">'#evaluate("Form.FunctionMemo_#client.languageId#")#',</cfif>
				<cfif trim(Form.FunctionHost) neq "">'#Form.FunctionHost#',</cfif>
				<cfif trim(Form.FunctionDirectory) neq "">'#Form.FunctionDirectory#',</cfif>
				<cfif trim(Form.FunctionPath) neq "">'#Form.FunctionPath#',</cfif>
				'new',
				'#SESSION.acc#',
				'#SESSION.first#',
				'#SESSION.last#' 
			)
	</cfquery>
	
	<cf_LanguageInput
		TableCode       		= "Ref_ModuleControl" 
		Key1Value       		= "#vFunctionId#"
		Key2Value      		 	= ""
		Mode           		 	= "Save"
		Name1           		= "FunctionName"	
		Operational     		= "1">
	
	<cf_LanguageInput
		TableCode       		= "Ref_ModuleControl" 
		Key1Value       		= "#vFunctionId#"
		Key2Value      		 	= ""
		Mode           		 	= "Save"
		Name1           		= "FunctionMemo"	
		Operational     		= "1">

</cfif>

<script>
	window.close();
</script>