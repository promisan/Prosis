
<cfparam name="url.mission" default="">
<cfparam name="url.mandate" default="">
<cfparam name="url.period"  default="">
<cfparam name="url.role"    default="">
<cfparam name="url.singleMission"  default="0">

<cfif url.scope eq "undefined">
	<cfset url.scope = "">
</cfif>

<cfoutput>
<table width="100%" height="99%">
<tr><td style="height:100%;width:100%" valign="top">
<iframe src="#session.root#/System/Organization/Application/OrganizationSearch.cfm?singlemission=#url.singlemission#&mode=#url.mode#&script=#url.script#&mission=#url.mission#&mandate=#url.mandate#&period=#url.period#&role=#url.role#&orgtype=#url.orgtype#&fldorgunit=#url.fldorgunit#&scope=#url.scope#" width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>