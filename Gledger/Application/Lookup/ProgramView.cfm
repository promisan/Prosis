
<cfparam name="url.script" default="">
<cfparam name="url.scope"  default="">

<cfoutput>
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%;overflow:hidden">
<iframe src="#session.root#/Gledger/Application/Lookup/ProgramSelect.cfm?mode=cfwindow&mission=#url.mission#&period=#url.period#&script=#url.script#&scope=#url.scope#" width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>