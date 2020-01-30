<cfquery name="GetItems" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT 	WOSI.*,
				I.ItemDescription,
				U.UoMDescription,
				U.ItemBarcode
		FROM 	WorkOrderServiceItem WOSI
				INNER JOIN Materials.dbo.Item I
					ON WOSI.ItemNo = I.ItemNo
				INNER JOIN Materials.dbo.ItemUoM U
					ON WOSI.ItemNo = U.ItemNo
					AND WOSI.UoM = U.UoM
		WHERE	WOSI.ServiceDomain = '#url.id1#'
		AND		WOSI.Reference = '#url.id2#'
		ORDER BY U.ItemBarcode ASC
	
</cfquery>

<table width="95%" align="center" class="navigation_table">
	
	<tr>
		<td></td>
		<td class="labelit"><cf_tl id="Barcode"></td>
		<td class="labelit"><cf_tl id="Item"></td>
		<td class="labelit"><cf_tl id="UoM"></td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr><td class="line" colspan="4"></td></tr>
	<tr><td height="5"></td></tr>

	<cfoutput query="GetItems">
		<tr class="navigation_row">
			<td class="labelit" width="1%" style="padding-right:5px;">
				<cf_img icon="delete" onclick="if (confirm('Do you want to remove this item ?')) { _cf_loadingtexthtml='';ptoken.navigate('WorkOrderService/WorkOrderServiceItemPurge.cfm?servicedomain=#url.id1#&reference=#reference#&itemNo=#itemno#&uom=#uom#','purgeitemsubmit'); }">
			</td>
			<td class="labelit">#ItemBarcode#</td>
			<td class="labelit">[#ItemNo#] #ItemDescription#</td>
			<td class="labelit">[#UoM#] #UoMDescription#</td>
		</tr>
	</cfoutput>
	
	<tr><td id="purgeitemsubmit"></td></tr>

</table>

<cfset AjaxOnLoad("doHighlight")>
