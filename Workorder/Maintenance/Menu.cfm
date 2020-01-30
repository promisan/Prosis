
<cf_submenutop>

<cf_submenuLogo module="Workorder" selection="Maintenance">

<cfset heading = "Maintenance">
<cfset module = "'Workorder'">
<cfset selection = "'Maintain'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Lookup">
<cfset module = "'Workorder'">
<cfset selection = "'Maintain'">
<cfset class = "'Reference'">

<cfinclude template="../../Tools/Submenu.cfm">


<cfset heading = "Localised">
<cfset module = "'Workorder'">
<cfset selection = "'Maintain'">
<cfset class = "'UN Specific'">

<cfinclude template="../../Tools/Submenu.cfm">
