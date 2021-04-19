
<cfparam name="url.mid" default="">

<cfoutput>
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%">
	<iframe src="#SESSION.root#/Workorder/Application/WorkOrder/ServiceAgreement/ServiceEdit.cfm?tabno=#url.tabno#&workorderid=#url.workorderid#&transactionid=#url.transactionid#&mid=#url.mid#" width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>