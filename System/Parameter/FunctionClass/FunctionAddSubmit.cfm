<!--
    Copyright © 2025 Promisan B.V.

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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.Operational" default="0">

	<cf_assignId>
	<cfset ClassId=#RowGuid#>
	<cfquery name="INSERTCLASSFUNCTION" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		INSERT INTO ClassFunction
		(ClassFunctionId,ClassFunctionCode, ClassId, FunctionDescription, FunctionReference)
		VALUES('#ClassId#','#Form.ClassFunctionCode#', '#Form.ClassId#', '#Form.FunctionDescription#', '#Form.FunctionReference#')
	</cfquery>

	<cfquery name="List" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM Ref_ClassElement
		WHERE ElementClass = 'UseCase'
		ORDER By ListingOrder
	</cfquery>
	
	<cfloop query="List">
	
		<cfset txt = evaluate("Form.#List.ElementCode#")>

		
		
		<cfquery name="INSERTCLASSFUNCTIONELEMENT" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		INSERT INTO ClassFunctionElement(ClassFunctionId, ElementCode, TextContent)
		VALUES('#ClassId#', '#List.ElementCode#','#txt#')
		 
	 	</cfquery>	
	</cfloop>

	
	<script>
		window.close();
		opener.history.go(); 
	</script>		
		

</body>
</html>
