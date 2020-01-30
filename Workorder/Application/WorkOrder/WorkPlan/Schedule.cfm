

<cfoutput>
<table width="100%" height="99%">
<tr><td style="height:100%;width:100%" valign="top">
	<iframe src="#session.root#/workorder/application/workorder/workplan/ScheduleView.cfm?workactionid=#url.workactionid#&selecteddate=#dateformat(now(),client.datesql)#" width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>