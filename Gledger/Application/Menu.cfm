
<cf_submenutop>

<cf_submenuLogo module="Accounting" selection="Application">

<cfset heading = "General ledger">
<cfset module = "'Accounting'">
<cfset selection = "'Application'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<!--- specific menu--->
<cfset verifysource       = "'Accountant'">
<cfset verifytable        = "">
<cfset menutemplate       = "">
<cfset module             = "'Accounting'">
<cfset class           = "'Mission','Builder'">

<cfinclude template="../../Tools/SubmenuMission.cfm">
