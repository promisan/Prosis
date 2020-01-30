
<cfparam name="url.mission" default="">
<cfparam name="url.mandate" default="">
<cfparam name="url.period"  default="">
<cfparam name="url.role"    default="">
<cfparam name="url.action"  default="">

<cfif url.scope eq "undefined">
	<cfset url.scope = "">
</cfif>

<cfoutput>
<table width="100%" height="99%">
<tr><td style="height:100%;width:100%" valign="top">
<iframe src="#session.root#/System/Organization/Application/LookupRole/OrganizationListing.cfm?mission=#url.mission#&mandate=#url.mandate#&period=#url.period#&role=#url.role#&script=#url.script#&fldorgunit=#url.fldorgunit#&scope=#url.scope#&action=#url.action#" width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>