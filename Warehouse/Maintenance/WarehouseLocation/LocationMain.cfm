
<!--- location box --->

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td>
	
	<cfparam name="url.access"           default="READ">
	<cfparam name="url.systemfunctionid" default="">
	
	<cfoutput>
		<iframe src="#SESSION.root#/Warehouse/Maintenance/WarehouseLocation/LocationView.cfm?systemfunctionid=#url.systemfunctionid#&access=#url.access#&warehouse=#url.warehouse#&location=#url.location#" width="100%" height="100%" marginwidth="0" marginheight="0" align="middle" scrolling="no" frameborder="0" style="overflow:hidden"></iframe>
	</cfoutput>	

</td></tr>

</table>