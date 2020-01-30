<html>
<head>
<title>Menu</title>
</head>

<cfoutput>

<body bgcolor="#CLIENT.color#">

<cfparam name="URL.Description" default="#CLIENT.MenuDescription#">
<cfparam name="URL.Selection" default="#CLIENT.MenuSelection#">

<cfset CLIENT.MenuSelection    = "#URL.Selection#">
<cfset CLIENT.MenuDescription  = "#URL.Description#">

<cfinclude template="accesslist.cfm">

<cfif ListFind(aList, SESSION.acc) eq 0 and Session.isAdministrator eq "No">
	<cf_message message="You are not authorized for this module. Please contact FPD IMU Helpdesk [ineed-imu-fpd@un.org] for access request" return="no">
	<cfabort>
</cfif>



<cf_submenuMenu
   Heading    = "#CLIENT.MenuDescription#"
   Module     = "'Portal'"
   Selection  = "'#CLIENT.MenuSelection#'"
   Class      = "'Main'"
   align      = "right"
   bgColor    = "#CLIENT.color#"
   selColor   = "ffffcf">
   
</cfoutput>   



</body>

</html>