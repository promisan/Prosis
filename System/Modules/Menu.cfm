
<cf_submenutop>

<cf_submenuLogo module="AdminConfig" selection="Library">

<!--- show only if the server is the distribution server, which means
it has replica directories in exactly the directories pointed out in the control tables
--->

<!--- general menu--->
<cfset heading      = "System Support Object Library">
<cfset module       = "'AdminConfig'">
<cfset selection    = "'Library'">
<cfset class        = "'Main'">
<cfinclude template = "../../Tools/Submenu.cfm">

<!--- general menu--->
<cfset heading      = "System Documentation utilities">
<cfset module       = "'AdminConfig'">
<cfset selection    = "'Documentation'">
<cfset class        = "'Main'">
<cfinclude template = "../../Tools/Submenu.cfm">

