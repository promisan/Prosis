
<cf_submenutop>

<cf_submenuLogo module="Staffing" selection="Maintenance">

<cfset heading   = "Monitoring Tools">
<cfset module    = "'Staffing'">
<cfset selection = "'System'">
<cfset class     = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "System">
<cfset selection = "'Maintain'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Employee">
<cfset class = "'Employee'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfset heading = "Staffing">
<cfset class = "'Staffing'">

<cfinclude template="../../Tools/Submenu.cfm">


<cfset heading = "Payroll and entitlements">
<cfset class = "'Payroll'">

<cfinclude template="../../Tools/Submenu.cfm">