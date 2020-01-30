
<cf_submenutop>

<cf_submenuLogo module="Warehouse" selection="Inquiry">

<cf_tl id="Inquiry" var="lblInquiry">
<cfset heading   = "#lblInquiry#">
<cfset module = "'Warehouse'">
<cfset selection = "'Inquiry'">
<cfset Class = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Standard Views" var="lblViews">
<cfset heading   = "#lblViews#">
<cfset selection = "'Inquiry'">
<cfset class = "'Builder'">

<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Extended Search (Collection)" var="lblExtended">
<cfset heading = "#lblExtended#">
<cfset selection = "'Search','Listing'">
<cfset class = "'Collection'">

<cfinclude template="../../Tools/Submenu.cfm">
