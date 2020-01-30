
<cf_submenutop>

<cf_submenuLogo module="Warehouse" selection="Maintenance">

<cfset heading = "System">
<cfset module = "'Warehouse'">
<cfset selection = "'Maintain'">
<cfset Class = "'System'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Stock and Requests">
<cfset Class = "'Stock'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Sales">
<cfset Class = "'Sale'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Assets">
<cfset Class = "'Asset'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Reference Tables">
<cfset Class = "'Lookup'">

<cfinclude template="../../Tools/Submenu.cfm">

