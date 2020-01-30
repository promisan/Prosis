
<HTML><HEAD>
    <TITLE>Operational reports</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">
   
<cfset CLIENT.width = 1100>
<cfset CLIENT.height = 940>
   
<cfinclude template="PublicInit.cfm">

<cfset heading   = "Operational reports">
<cfset module    = "'#URL.Module#'">
<cfset selection = "'#URL.Selection#'">
<cfset class     = "'Main'">

<cfinclude template="../MenuReport/SubmenuReport.cfm">

</BODY></HTML>