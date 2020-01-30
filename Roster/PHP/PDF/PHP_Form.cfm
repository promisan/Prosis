<html>
<head>
<title>PHP List</title>

<!--- wrapper to display PHP in new window  --->

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfparam name="PHP_Roster_List" default="">
<cfparam name="format" default="Document">
<cfparam name="PHPForm" default="New">
<cfparam name="RosterQueryID" default="">

<cfif RosterQueryId neq "">
	<cfset URLParamName = "RosterQueryID">
	<cfset URLParam = "#RosterQueryID#">
<cfelse>
	<cfset URLParamName = "PHP_Roster_List">
	<cfset URLParam = "#PHP_Roster_List#">
</cfif>

<cf_wait text="Loading PHP">

<cfoutput>

	<script language="JavaScript1.1">
	
	if ('#format#' == 'Document'){
	  window.location = "#SESSION.root#/Custom/DPKO/Candidate/PHP/PHP_Combined_List.cfm?#URLParamName#=#URLParam#";
		}			  
	else{
	  window.location = "#SESSION.root#/Custom/DPKO/Candidate/PHP/PHP_Combined_List.cfm?PHP_Roster_List=#PHP_Roster_List#";
	  }
		
	</script>


<!---	  window.location = "#SESSION.root#/Custom/DPKO/Candidate/PHP/PHP_Document_List.cfm?PHP_Roster_List=#PHP_Roster_List#";
--->

	
</cfoutput>
</body>
</html>
