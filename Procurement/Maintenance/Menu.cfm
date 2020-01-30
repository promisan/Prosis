
<cf_submenutop>

<cf_submenuLogo module="Procurement" selection="Maintenance">

<cfset heading   = "System tables">
<cfset module    = "'Procurement'">
<cfset selection = "'System'">
<cfset class     = "'Main'">
<cfinclude template="../../Tools/Submenu.cfm">


<cfset heading = "Requisition Reference tables">
<cfset selection = "'Maintain'">
<cfset class = "'Requisition'">
<cfinclude template="../../Tools/Submenu.cfm">


<cfset heading = "Purchase Reference tables">
<cfset class = "'Purchase'">
<cfinclude template="../../Tools/Submenu.cfm">


<cfset heading = "Invoice Reference tables">
<cfset class = "'Invoice'">
<cfinclude template="../../Tools/Submenu.cfm">

