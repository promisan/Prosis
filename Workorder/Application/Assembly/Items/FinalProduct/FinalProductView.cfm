
<cfoutput>
<table width="100%" height="100%">
<tr>
<td style="height: 100%; width: 100%;" valign="top">
<cfif accessmode eq "edit">
	<iframe src="#session.root#/workorder/application/Assembly/Items/FinalProduct/FinalProductEdit.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&workorderitemid=#url.workorderitemid#" width="100%" height="99%" scrolling="no" frameborder="0"></iframe>
<cfelse>
</cfif>	
</td></tr>
</table>
</cfoutput>