
<cfparam name="URL.mid"  default="">
<cfparam name="URL.Mode" default="Lookup">

<cfoutput>
	<table width="100%" height="100%">
	<tr><td style="height:100%;width:100%;overflow:hidden">
		<iframe src="#session.root#/Staffing/Application/Location/Lookup/LocationMain.cfm?id=#url.id#&FormName=#URL.formname#&fldlocationcode=#URL.fldlocationcode#&fldlocationname=#URL.fldlocationname#&Mission=#URL.Mission#&Mode=#URL.Mode#&mid=#url.mid#" width="100%" height="100%" frameborder="0"></iframe>
	</td></tr>
	</table>
</cfoutput>