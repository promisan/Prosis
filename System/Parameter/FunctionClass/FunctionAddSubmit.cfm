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
