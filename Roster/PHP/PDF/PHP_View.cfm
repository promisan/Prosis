<html>
<head>
<title>PHP View</title>

<!--- wrapper to display PHP_FULL as a CFDocument  --->

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>


<cfquery name="List" 
	datasource="AppsQuery"	
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT PersonNo
	FROM #Table1#
	</cfquery>		

<cfloop query="list"> 

	<cfset PHPPersonNO = #List.PersonNo#>

	<cfinclude template="PHP.cfm">

</cfloop>

</body>
</html>
