<cfset vLandingMission = "">
<cfif isDefined("client.mission")>
	<cfset vLandingMission = client.mission>
</cfif>

<cfparam name="url.mission" default="#vLandingMission#">

<cf_screentop html="no" scroll="no" Jquery="yes" busy="busy10.gif">

<div style="width:100%; height:100%; margin:0px; padding:0px;">
	<cfinclude template="PortalFunctionOpen.cfm"> 
</div>