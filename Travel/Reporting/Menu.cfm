<cf_submenuLogo module="Pmstars" selection="Inquiry">

<HTML><HEAD>
    <TITLE>Submenu</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">

<cfinclude template="../accesslist.cfm">

<cfif ListFind(aList, SESSION.acc) eq 0 and Session.isAdministrator eq "No">
	<cf_message message="You are not authorized for this module. Please contact FPD IMU Helpdesk [ineed-imu-fpd@un.org] for access request" return="no">
	<cfabort>
</cfif>



<cfset heading = "Online Graphs">
<cfset module = "'PMSTARS'">
<cfset selection = "'Graph'">
<cfset class = "'main'">
<cfinclude template="../../Tools/submenu.cfm">

<cfset heading = "Online Views">
<cfset module = "'PMSTARS'">
<cfset selection = "'Inquiry'">
<cfset class = "'main'">
<cfinclude template="../../Tools/submenu.cfm">

<cfset heading = "PDF Reports">
<cfset module = "'PMSTARS'">
<cfset selection = "'PDF'">
<cfset class = "'main'">


<cfinclude template="../../Tools/submenu.cfm">
<cfinclude template="../../Tools/submenuFooter.cfm">

</BODY></HTML>
