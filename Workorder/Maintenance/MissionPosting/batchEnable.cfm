<cfdiv id="iconContainer_#url.id1#_#url.id2#">

<cfset iconSize = 15>
<cfset iconName = "icon_confirm.gif">
<cfset tooltipText = "Enabled. Click to disable.">
<cfif url.batch eq 0>
	<cfset iconName = "icon_stop.gif">
	<cfset tooltipText = "Disabled. Click to enable.">
</cfif>
<cfoutput>

	<img src="#SESSION.root#/images/#iconName#" title="#tooltipText#" width="#iconSize#" height="#iconSize#" style="cursor: pointer;" 
			onclick="javascript: ColdFusion.navigate('batchSet.cfm?id1=#url.id1#&id2=#url.id2#&id3=#url.id3#&batch=#url.batch#', 'iconContainer_#url.id1#_#url.id2#');">

</cfoutput>
</cfdiv>