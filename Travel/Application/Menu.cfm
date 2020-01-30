<cf_submenuLogo module="Pmstars" selection="Application">

<HTML><HEAD>
    <TITLE>Document - Search Form</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">

<cfset heading = "Application">
<cfset module = "'PMSTARS'">
<cfset selection = "'Application'">
<cfset class = "'Main'">

<cfinclude template="../accesslist.cfm">

<cfif ListFind(aList, SESSION.acc) eq 0 and Session.isAdministrator eq "No">
	<cf_message message="You are not authorized for this module. Please contact FPD IMU Helpdesk [ineed-imu-fpd@un.org] for access request" return="no">
	<cfabort>
</cfif>





<cfinclude template="../../Tools/submenu.cfm">
<cfinclude template="../../Tools/submenuFooter.cfm">

</BODY></HTML>