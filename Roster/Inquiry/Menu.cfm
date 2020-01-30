
<cf_submenutop>

<cf_submenuLogo module="Roster" selection="Inquiry">

<cfset module = "'Roster'">
<cfset heading = "Custom Views">
<cfset selection = "'Application','Inquiry'">
<cfset class = "'Builder'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Extended Search (Collection)">
<cfset selection = "'Search','Listing'">
<cfset class = "'Collection'">

<cfinclude template="../../Tools/Submenu.cfm">

