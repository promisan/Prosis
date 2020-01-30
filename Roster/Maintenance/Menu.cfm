
<cf_submenutop>

<cf_submenuLogo module="Roster" selection="Maintenance">

<cfset heading = "Configuration and Titles">
<cfset module = "'Roster'">
<cfset selection = "'System'">
<cfset class = "'Main'">
<cfinclude template="../../Tools/Submenu.cfm">

<cfset selection = "'Maintain'">
<cfset heading = "Bucket Reference tables">
<cfset class = "'Bucket'">
<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Personal History Profile Settings">
<cfset class = "'PHP'">
<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Roster Processing">
<cfset class = "'Roster'">
<cfinclude template="../../Tools/Submenu.cfm">

</BODY></HTML>