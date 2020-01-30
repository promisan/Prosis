
<cf_submenutop>

<cf_submenuLogo module="Procurement" selection="Application">

<cfset heading         = "General">
<cfset module          = "'Procurement'">
<cfset selection       = "'Application'">
<cfset class           = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<!--- specific menu--->
<cfset verifysource    = "">
<cfset verifyarea      = "Material Management"> 
<cfset verifytable     = "">
<cfset menutemplate    = "">
<cfset module          = "'Procurement'">
<cfset class           = "'Mission','Builder'">

<cfinclude template="../../Tools/SubmenuMission.cfm">
