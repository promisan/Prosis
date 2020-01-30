
<cfparam name="url.script" default="">
<cfparam name="url.scope"  default="">

<cfoutput>
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%">
<iframe src="#session.root#/Gledger/Application/Lookup/DonorSelect.cfm?mission=#url.mission#&fund=#url.fund#&programcode=#url.programcode#&journal=#url.journal#&journalserialno=#url.journalserialno#&scope=#url.scope#&script=#url.script#&selected=#url.selected#" width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>