<cfparam name="url.init" default="0">

<table height="100%" width="100%" align="center">
<tr><td align="center" valign="top" style="padding:6px">
	
	<cfif NOT IsDefined("URL.Mission")>
		<cfset url.claimId = Object.ObjectKeyValue4>
		<cfset url.mission = Object.Mission>
		<cfset vPath = "../../../CaseFile/Application/Case/Header">
	<cfelse>
		<cfset vPath = "../Header">
	</cfif>
	                      

<cfoutput>	

<cfinclude template="ClaimHeaderContent.cfm">

<!---

	<cf_getMid>   
	<iframe src="#vPath#/ClaimHeaderContent.cfm?mission=#url.mission#&claimid=#url.claimid#&init=#url.init#&mid=#mid#" width="100%" height="100%" marginwidth="0" marginheight="0" frameborder="0"></iframe>
	--->
	
</cfoutput>

</td></tr></table>