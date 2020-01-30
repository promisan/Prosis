
<cf_submenutop>

<cf_submenuLogo module="Staffing" selection="Utilities">

<cfset presentation = "2">

<cf_tl id="Application Functions" var="lblGeneral">
<cfset heading   = "#lblGeneral#">
<cfset module = "'Staffing'">
<cfset selection = "'Application'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Custom Views" var="lblCustomViews">
<cfset heading   = "#lblCustomViews#">
<cfset selection = "">
<cfset class = "'Builder'">

<cfinclude template="../../Tools/Submenu.cfm">
