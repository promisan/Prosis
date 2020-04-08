<cfparam name="URL.Mission" 				default="SCBD">
<cfparam name="URL.configsystemfunctionid" 	default="2332F797-5056-9F5C-E4D7-21C45863C92E">

<cfinclude template="../CheckDrillAccess.cfm">

<cfoutput>
	<div class="clsDirectoryDetail">
		<iframe height="90%" width="100%" frameborder="0" name="iDirectoryFrame" src="#session.root#/System/Organization/OrgTree/OrgTree.cfm?mission=#url.mission#&showDirectoryView=0&systemfunctionid=#url.systemfunctionid#&configsystemfunctionid=#url.configsystemfunctionid#&systemProfileAccess=#vDrillAccess#">
	</div>
</cfoutput>