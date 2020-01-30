
<cf_submenutop>

<cf_submenuLogo module="Accounting" selection="Inquiry">

<cfset heading = "Statements">
<cfset module = "'Accounting'">
<cfset selection = "'Reporting'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Standard Views">
<cfset selection = "'Inquiry','Reporting'">
<cfset class = "'Builder'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Extended Search (Collection)">
<cfset selection = "'Search','Listing'">
<cfset class = "'Collection'">
<cfinclude template="../../Tools/Submenu.cfm">

