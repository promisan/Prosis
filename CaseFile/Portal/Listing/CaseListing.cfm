
<cfparam name="url.id"  default="Status">
<cfparam name="url.id1" default="">
<cfparam name="url.id2" default="#url.mission#">
<cfparam name="url.id3" default="">
<cfparam name="url.id4" default="">

<cfinclude template="../../Application/Case/ControlEmployee/ClaimScript.cfm">

<table width="100%" height="100%">
	<tr><td align="center">	
	<cfinclude template="../../Application/Case/ControlEmployee/ClaimListing.cfm">
	</td></tr>
</table>