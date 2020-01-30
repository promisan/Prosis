
<cf_submenutop>

<cf_submenuLogo module="Insurance" selection="Application">

<cfset heading = "Application">
<cfset module = "'Insurance'">
<cfset selection = "'Application'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<!--- specific menu--->
<cfset verifysource       = "'CaseFileOfficer','CaseFileManager'">
<cfset verifytable        = "">
<cfset menutemplate       = "">
<cfset module             = "'Insurance'">
<cfset class = "'Mission','Builder'">

<cfinclude template="../../Tools/SubmenuMission.cfm">

