<cfdiv id="iconStatusContainer_#url.id1#_#url.id2#">

<cfset iconSize = 15>
<cfset iconName = "icon_stop.gif">
<cfset tooltipText = "Closed. Click to reopen.">
<cfset confirmText = "reopen">

<cfif url.actionStatus eq 0>
	<cfset iconName = "icon_confirm.gif">
	<cfset tooltipText = "Open. Click to close.">
	<cfset confirmText = "lock">
</cfif>

<cfoutput>
	<img src="#SESSION.root#/images/#iconName#" title="#tooltipText#" width="#iconSize#" height="#iconSize#" style="cursor: pointer;"
			onclick="javascript: if (confirm('Do you want to #confirmText# this financial period ?')) { ColdFusion.navigate('ToggleActionStatus_MissionPosting.cfm?id1=#url.id1#&id2=#url.id2#&id3=#url.id3#&actionStatus=#url.actionStatus#', 'iconStatusContainer_#url.id1#_#url.id2#'); }">
</cfoutput>

</cfdiv>