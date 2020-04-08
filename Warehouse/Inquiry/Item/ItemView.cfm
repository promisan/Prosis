<cfparam name="url.close" 		default="yes">

<cfoutput>
<table width="100%" height="100%" style="overflow:hidden">
<tr><td style="height:99%;width:100%">
	<iframe src="#session.root#/Warehouse/Inquiry/Item/ItemSelect.cfm?mode=cfwindow&mission=#url.mission#&itemmaster=#url.itemmaster#&itemclass=#url.itemclass#&script=#url.script#&scope=#url.scope#&close=#url.close#" width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>

