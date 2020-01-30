
<cf_submenutop>

<cf_submenuLogo module="Workorder" selection="Inquiry">

<cf_tl id="General" var="lblGeneral">
<cfset heading         = "#lblGeneral#">
<cfset module          = "'WorkOrder'">
<cfset selection       = "'Inquiry'">
<cfset verifytable     = "">
<cfset menutemplate    = "">
<cfset class           = "'Mission'">

<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Standard Views" var="lblViews">
<cfset heading         = "#lblViews#">
<cfset selection       = "'Inquiry'">
<cfset class           = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Custom Views" var="lblExtended">
<cfset heading        = "#lblExtended#">
<cfset selection      = "">
<cfset class          = "'Builder'">

<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Extended Inquiry" var="lblViews">
<cfset heading        = "#lblViews#">
<cfset selection      = "'Dataset'">
<cfset class          = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Extended Search (Collection)" var="lblExtended">
<cfset heading       = "#lblExtended#">
<cfset selection     = "'Search','Listing'">
<cfset class         = "'Collection'">

<cfinclude template="../../Tools/Submenu.cfm">
