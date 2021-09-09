
<cfparam name="url.mid" default="">
<cfoutput>
<table width="100%" height="100%">
<tr><td style="height: 97%; width: 100%; overflow: hidden;">

	<iframe src="#session.root#/Procurement/Application/Requisition/Process/RequisitionCreateForm.cfm?req=#url.req#&status=#url.status#&mission=#URL.Mission#&period=#url.period#&mid=#url.mid#" 
	width="100%" height="100%" frameborder="0"></iframe>

</td></tr>
</table>
</cfoutput>