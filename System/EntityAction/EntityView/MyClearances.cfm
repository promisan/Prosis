
<cfparam name="scope" default="default">
<cfparam name="URL.EntityGroup" default="">
<cfparam name="URL.Mission" default="">
<cfparam name="URL.Owner" default="">
<cfparam name="URL.Me" default="false">

<cfinclude template="MyClearancesScript.cfm">
<cf_dialogStaffing>
<cf_PresentationScript>


<cf_screentop height="100%" html="No" scroll="yes" busy="busy10.gif" jquery="Yes">

<table width="100%" height="100%" align="center">
			
	<tr>
	<td id="main" align="center" height="100%" valign="top" style="padding-left:10px">	
	<cfinclude template="MyClearancesMain.cfm">		  
	</td>
	</tr>
	
</table>



