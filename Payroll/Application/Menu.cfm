
<cf_submenutop>

<cf_SubMenulogo module="Payroll" selection="Application">

<cfset heading            = "Application">
<cfset selection          = "'Application'">

<!--- specific menu--->
<cfset verifysource       = "'AdminProgram','PayrollOfficer','PayrollClear','Accountant','HRPosition'">
<cfset verifytable        = "">
<cfset menutemplate       = "">
<cfset module             = "'Payroll'">
<cfset class              = "'Mission','Builder'">

<cfinclude template="../../Tools/SubmenuMission.cfm">

<cfset module             = "'Payroll'">
<cfset class              = "'Main'">
<cfset heading            = "Custom">

<cfinclude template="../../Tools/Submenu.cfm">