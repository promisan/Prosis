
<cfparam name="url.filterstring" default="">
<cfparam name="url.filtervalue"  default="">
<cfparam name="url.script"       default="">

<cfoutput>
	<table width="100%" height="100%">
	<tr><td style="height:100%;width:100%">
		<iframe src="#session.root#/Tools/ComboBox/ComboMulti.cfm?fld=#url.fld#&alias=#url.alias#&table=#url.table#&pk=#url.pk#&desc=#url.desc#&order=#url.order#&filterstring=#url.filterstring#&filtervalue=#url.filtervalue#&selected=#url.selected#&script=#url.script#" width="100%" height="100%" frameborder="0"></iframe>
	</td></tr>
	</table>
</cfoutput>

