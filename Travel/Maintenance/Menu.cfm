<cf_submenuLogo module="Pmstars" selection="Maintenance">

<HTML><HEAD>
    <TITLE>Document - Search Form</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">

<cfinclude template="../accesslist.cfm">

<cfif ListFind(aList, SESSION.acc) eq 0 and Session.isAdministrator eq "No">
	<cf_message message="This module is deprecated. Please contact your administrator" return="no">
	<cfabort>
</cfif>



<cfset heading = "Maintenance">
<cfset module = "'PMSTARS'">
<cfset selection = "'Maintain'">
<cfset class = "'main'">

<cfinclude template="../../Tools/submenu.cfm">
<cfinclude template="../../Tools/submenuFooter.cfm">


</BODY></HTML>