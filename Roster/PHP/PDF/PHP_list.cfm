<html>
<head>
<title>PHP List</title>

<!--- wrapper to display PHP_FULL as a CFDocument  --->

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfparam name="PHP_Roster_List" default="234567">

<cfloop Index="PHPPersonNo" List="#PHP_Roster_list#">

	<cfinclude template="PHP.cfm">

</cfloop>

</body>
</html>
