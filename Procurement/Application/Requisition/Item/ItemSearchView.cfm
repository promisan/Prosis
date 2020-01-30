
<cfparam name="url.id" default="">
<cfparam name="url.mission"       default="">
<cfparam name="url.flditemmaster" default="">
<cfparam name="url.period"        default="">

<cfoutput>
<table width="100%" height="99%">
<tr><td style="height:100%;width:100%" valign="top">
<cfif flditemmaster neq "">
	<iframe src="#SESSION.root#/Procurement/Application/Requisition/Item/ItemSearchMaster.cfm?id=#url.id#&mission=#url.mission#&period=#url.period#&flditemmaster=#url.flditemmaster#" width="100%" height="100%" frameborder="0"></iframe>
<cfelse>
	<iframe src="#SESSION.root#/Procurement/Application/Requisition/Item/ItemSearch.cfm?access=#url.access#&mission=#url.mission#&itemmaster=#url.itemmaster#&field=#url.field#&script=#url.script#&scope=#url.scope#" width="100%" height="100%" frameborder="0"></iframe></cfif>	
</td></tr>
</table>
</cfoutput>