
<cf_screentop height="100%" scroll="vertical" html="No" ValidateSession="No">

<cfset searchbar = false>

<cf_submenuLogo module="Workorder" selection="Application">

<cfset heading         = "Administration">
<cfset module          = "'WorkOrder'">
<cfset selection       = "'Application'">
<cfset class           = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset verifyarea      = "WorkOrder Management">
<cfset verifytable     = "">
<cfset menutemplate    = "">
<cfset class           = "'Mission','Builder'">

<cfinclude template="../../Tools/SubmenuMission.cfm">

