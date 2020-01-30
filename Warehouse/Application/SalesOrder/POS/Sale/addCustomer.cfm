
<cfparam name="url.mode" default="customer">
<cfoutput>
<table width="100%" height="100%" bgcolor="FFFFFF">
<tr><td height="100%" style="overflow:hidden">
<iframe src="#session.root#/warehouse/Application/SalesOrder/POS/Sale/addCustomerForm.cfm?mode=#url.mode#&mission=#url.mission#&warehouse=#url.warehouse#&reference=#url.reference#" width="100%" height="100%" scrolling="no" frameborder="0">
</iframe>
</td></tr>
</table>
</cfoutput>