<cfparam name="URL.bex" default="0">

<cfdiv id="iconBatchContainer_#url.id1#_#url.id2#">

<cfset iconSize = 15>
<cfset iconName = "run_button3.gif">
<cfset tooltipText = "Click to execute posting.">
<cfset cursortype = "cursor: pointer;">

<cfif url.bex eq "1">
	<cfset iconName = "success.png">
	<cfset tooltipText = "Posting executed">
	<cfset cursortype = "cursor: default;">
</cfif>

<cfoutput>
	<img src="#SESSION.root#/images/#iconName#" title="#tooltipText#" width="#iconSize#" height="#iconSize#" style="#cursortype#" 
	onclick="javascript: ColdFusion.navigate('batchToggle.cfm?id1=#url.id1#&id2=#url.id2#', 'iconBatchContainer_#url.id1#_#url.id2#');">
</cfoutput>
</cfdiv>