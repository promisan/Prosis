
<cf_submenutop>

<cf_submenuLogo module="Procurement" selection="Inquiry">

<cf_tl id="General" var="lblGeneral">
<cfset heading   = "#lblGeneral#">
<cfset module    = "'Procurement'">
<cfset selection = "'Inquiry'">
<cfset class     = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Standard Views" var="lblViews">
<cfset heading   = "#lblViews#">
<cfset selection = "">
<cfset class     = "'Builder'">

<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Extended Search (Collection)" var="lblExtended">
<cfset heading = "#lblExtended#">
<cfset selection = "'Search','Listing'">
<cfset class = "'Collection'">

<cfinclude template="../../Tools/Submenu.cfm">

