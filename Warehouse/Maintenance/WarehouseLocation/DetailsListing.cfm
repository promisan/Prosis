<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   C.*,
				(SELECT ItemDescription FROM Item WHERE ItemNo = C.ItemNo) as ItemDescription,
				(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = C.ItemNo and UoM = C.UoM) as UoMDescription
		FROM     WarehouseLocationCapacity C
		WHERE    C.Warehouse = '#url.warehouse#'
		AND		 C.Location  = '#url.location#'
		ORDER BY C.Created ASC	
</cfquery>

<table width="100%" align="center" class="navigation_table">

    <tr class="labelmedium"><td colspan="7" style="height:50">
	<font color="808080"><b>Usage</b> : Fuel/Water tanks in case a location effectively consist of several tanks that contain the stock. Example a location that consists of 10 drums having a total capacity of 5000 liters, you wnat to record each drum for reference purposes ONLY.</td>
	</tr>
	<tr class="line labelmedium">
		<td align="center" width="5%"></td>
		<td align="center" width="5%"><cf_tl id="No."></td>
		<td><cf_tl id="Description"></td>
		<td><cf_tl id="Storage Code"></td>
		<td><cf_tl id="Item"></td>
		<td align="right"><cf_tl id="Capacity"></td>
		<td align="right"><cf_tl id="UoM"></td>
	</tr>
		
		<cfoutput query="get">
		<tr class="navigation_row labelmedium">
			<td align="center" height="14">
			   <table cellspacing="0" cellpadding="0" class="formpadding">
			   
			     <tr>
				 <td><cf_img icon="edit" navigation="Yes" onClick="javascript: editLocationCapacity('#url.warehouse#','#url.location#','#detailid#');"></td>
				 <td style="padding-left:4px">
				 <cf_img icon="delete" onClick="javascript:if (confirm('Do you want to remove this record ?')) { ColdFusion.navigate('DetailsPurge.cfm?warehouse=#url.warehouse#&location=#url.location#&detailid=#detailid#','divWLCapacity');}"></td>
				 </tr>
			   
			   </table>
			   
			</td>
			<td align="center">#currentrow#.</td>
			<td>#DetailDescription#</td>
			<td>#DetailStorageCode#</td>
			<td>#ItemDescription#</td>
			<td align="right">#lsNumberFormat(Capacity,",.__")#</td>
			<td align="right">#UoMDescription#</td>
		</tr>
	</cfoutput>
</table>

<cfset ajaxonload("doHighlight")>


