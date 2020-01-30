
<cfparam name="url.search" default="yes">

<cfoutput>
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%">
<iframe src="#SESSION.root#/Tools/Maps/MapDialog.cfm?search=#url.search#&field=#url.field#&coordinates=#url.coordinates#" width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>