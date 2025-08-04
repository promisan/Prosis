<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfset vFunctionId = "00000000-0000-0000-0000-000000000000">

<cfquery name="validate" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 	SELECT	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule = 'Portal'
		AND		FunctionClass = 'Portal'
		AND		MenuClass = 'Topic'
		AND		FunctionName = '#Form.FunctionName#'
</cfquery>


<cfif url.id neq "">

	<cfif validate.recordCount gt 0 and Form.FunctionName neq Form.FunctionNameOld>
		<script>
			alert('This name already exists.  Please, enter a new name.');
		</script>
	
	<cfelse>

		<cfset vFunctionId = "#url.id#">
	
		<cfquery name="update" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">		 
			 UPDATE     Ref_ModuleControl
			 SET		FunctionName       	= '#Form.FunctionName#',
			 			FunctionMemo       	= <cfif trim(evaluate("Form.FunctionMemo_#client.languageId#")) neq "">'#evaluate("Form.FunctionMemo_#client.languageId#")#'<cfelse>null</cfif>,
						FunctionDirectory 	= <cfif trim(Form.FunctionDirectory) neq "">'#Form.FunctionDirectory#'<cfelse>null</cfif>,
						FunctionPath 		= <cfif trim(Form.FunctionPath) neq "">'#Form.FunctionPath#'<cfelse>null</cfif>,
						MenuOrder  			= #Form.MenuOrder#
			 WHERE		SystemFunctionId 	= '#url.id#'
		</cfquery>
	
		<cf_LanguageInput
			TableCode       = "Ref_ModuleControl" 
			Key1Value       = "#vFunctionId#"
			Key2Value       = ""
			Mode            = "Save"
			Name1           = "FunctionMemo"	
			Operational     = "1">
		
		<script>
			window.close();
		</script>
	
	</cfif>
		
<cfelse>

	<cfif validate.recordCount gt 0>
			
		<script>
			alert('This name already exists.  Please, enter a new name.');
		</script>
	
	<cfelse>

		<cfquery name="getNewId" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT 	newId() as Id
		</cfquery>
		
		<cfset vFunctionId = "#getNewId.Id#">
		
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
					<cfif trim(Form.MenuOrder) neq "">MenuOrder,</cfif>
					FunctionName,
					MainMenuItem,
					<cfif trim(evaluate("Form.FunctionMemo_#client.languageId#")) neq "">FunctionMemo,</cfif>
					<cfif trim(Form.FunctionDirectory) neq "">FunctionDirectory,</cfif>
					<cfif trim(Form.FunctionPath) neq "">FunctionPath,</cfif>
					OfficerUserId,
					OfficerFirstName,
					OfficerLastName
				)
			VALUES
				(
					'#vFunctionId#',
					'Portal',
					'Portal',
					'Topic',
					<cfif trim(Form.menuOrder) neq "">'#Form.menuOrder#',</cfif>
					'#Form.FunctionName#',
					0,
					<cfif trim(evaluate("Form.FunctionMemo_#client.languageId#")) neq "">'#evaluate("Form.FunctionMemo_#client.languageId#")#',</cfif>
					<cfif trim(Form.FunctionDirectory) neq "">'#Form.FunctionDirectory#',</cfif>
					<cfif trim(Form.FunctionPath) neq "">'#Form.FunctionPath#',</cfif>
					'#SESSION.acc#',
					'#SESSION.first#',
					'#SESSION.last#'
				)
		</cfquery>
		
		<cf_LanguageInput
			TableCode       = "Ref_ModuleControl" 
			Key1Value       = "#vFunctionId#"
			Key2Value       = ""
			Mode            = "Save"
			Name1           = "FunctionMemo"	
			Operational     = "1">
	
		<script>
			window.close();
		</script>
	
	</cfif>
	
</cfif>