
<cf_submenutop>

<cf_SubMenulogo module="Insurance" selection="Inquiry">

<cfset heading = "Application">
<cfset module = "'Insurance'">
<cfset selection = "'Inquiry'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Standard Views">
<cfset selection = "'Inquiry'">
<cfset class = "'Builder'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Extended Search (Collection)">
<cfset selection = "'Search','Listing'">
<cfset class = "'Collection'">

<cfinclude template="../../Tools/Submenu.cfm">

