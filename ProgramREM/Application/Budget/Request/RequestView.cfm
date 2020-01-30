
<cfparam name="url.activityid" default="">
<cfparam name="url.requirementid" default="">
<cfparam name="url.editionid" default="">
<cfparam name="url.mode" default="view">
<cfparam name="url.cell" default="">
<cfparam name="url.objectcode" default="">

<cfoutput>
<table width="100%" height="100%">

<tr><td style="height:100%;width:100%">
	<iframe src="#SESSION.root#/programrem/Application/Budget/Request/RequestDialog.cfm?mode=#url.mode#&requirementid=#url.requirementid#&programcode=#url.programcode#&period=#url.period#&activityid=#url.activityid#&editionid=#url.editionid#&objectcode=#url.objectcode#&cell=#url.cell#" width="100%" height="99%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>