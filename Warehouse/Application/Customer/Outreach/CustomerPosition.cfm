
<!--- customer position add --->

<cfparam name="url.mid" default="">
<cfoutput>
<table style="width:100%;height:100%">
<iframe src="../../../../Staffing/Application/Position/Lookup/PositionView.cfm?mission=#url.mission#&customerid=#url.customerid#&source=cus&mid=#url.mid#" frameborder="0" style="width:100%;height:99%" border="0"></iframe>
</table>
</cfoutput>