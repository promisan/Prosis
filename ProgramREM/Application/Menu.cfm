
<cf_submenutop>

<cf_submenuLogo module="Program" selection="Application">

	<cfset heading         = "General">
	<cfset module          = "'Program'">
	<cfset selection       = "'Application'">
	<cfset class           = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

	<!--- specific menu--->
	<cfset verifysource    = "'AdminProgram','ProgressOfficer','ProgramManager','ProgramOfficer','ProgramAuditor','BudgetManager','BudgetOfficer'">
	<cfset verifytable     = "">
	<cfset menutemplate    = "">
	<cfset class           = "'Mission','Builder'">

<cfinclude template="../../Tools/SubmenuMission.cfm">
