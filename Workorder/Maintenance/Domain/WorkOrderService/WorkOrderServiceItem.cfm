<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
	
	<tr class="labelmedium2 line">
		<td></td>
		<td><cf_tl id="Barcode"></td>
		<td><cf_tl id="Item"></td>
		<td><cf_tl id="UoM"></td>
	</tr>
	
	<cfoutput query="GetItems">
		<tr class="navigation_row labelmedium2 line">
			<td width="1%" style="padding-right:5px;">
				<cf_img icon="delete" onclick="if (confirm('Do you want to remove this item ?')) { _cf_loadingtexthtml='';ptoken.navigate('WorkOrderService/WorkOrderServiceItemPurge.cfm?servicedomain=#url.id1#&reference=#reference#&itemNo=#itemno#&uom=#uom#','purgeitemsubmit'); }">
			</td>
			<td>#ItemBarcode#</td>
			<td>[#ItemNo#] #ItemDescription#</td>
			<td>[#UoM#] #UoMDescription#</td>
		</tr>
	</cfoutput>
	
	<tr><td id="purgeitemsubmit"></td></tr>

</table>

<cfset AjaxOnLoad("doHighlight")>
