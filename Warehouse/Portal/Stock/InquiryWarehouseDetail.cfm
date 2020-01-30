
<!--- retouted this to the template --->

<cf_screentop height="100%" scroll="no" layout="webapp" banner="gray" label="Stock History" user="yes" close="ColdFusion.Window.hide('dialoghistory')">

	<cf_divscroll>
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white">
	
		<tr><td style="padding:9px" valign="top">				
		<cfinclude template="../../Maintenance/WarehouseLocation/LocationItemUoM/ItemUoMHistory.cfm">				
		</td></tr>
	
	</table>
	</cf_divscroll>

<cf_screenbottom layout="webdialog">