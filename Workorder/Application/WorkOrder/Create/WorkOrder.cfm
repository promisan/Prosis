
<cfoutput>

<cfparam name="url.context" default="backoffice">
<cfparam name="url.mid" default="">

<table width="100%" height="100%">
<tr><td style="height:100%;width:100%;overflow:hidden">
<iframe src="#SESSION.root#/WorkOrder/Application/WorkOrder/Create/WorkOrderAdd.cfm?context=#url.context#&mission=#url.mission#&customerid=#url.customerid#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&mid=#url.mid#" 
width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>