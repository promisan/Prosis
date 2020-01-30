<cf_submenuLogo module="Vacancy" selection="Inquiry" ValidateSession="No">

<cfset heading = "On-line graphs"> 
<cfset module = "'Vacancy'">
<cfset selection = "'Graph'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "On-line Views"> 
<cfset module = "'Vacancy'">
<cfset selection = "'Listing'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Standard Views">
<cfset selection = "'Inquiry','Listing'">
<cfset class = "'Builder'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Extended Search (Collection)">
<cfset selection = "'Search','Listing'">
<cfset class = "'Collection'">

<cfinclude template="../../Tools/Submenu.cfm">

