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
<cfquery name="getItem" 
     datasource="AppsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *,
	 			(SELECT ItemDescription FROM Item WHERE ItemNo = '#url.itemNo#') as ItemDescription,
				(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = '#url.itemNo#' AND UoM = '#url.uom#') as UoMDescription
	 FROM       ItemWarehouseLocation 
	 WHERE		Warehouse = '#url.warehouse#'
	 AND       	Location = '#url.location#'		
	 AND		ItemNo = '#url.itemNo#'
	 AND		UoM = '#url.UoM#'
</cfquery>

<cfquery name="LocationClass" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		SELECT	*
		FROM  	Ref_WarehouseLocationClass
		WHERE	Code = '#url.locationclass#'
</cfquery>

<cfquery name="qWarehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		SELECT	*
		FROM  	Warehouse
		WHERE	Warehouse = '#url.warehouse#'
</cfquery>

<cfquery name="getLocations" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		 SELECT     WL.*,
		 			W.WarehouseName,
		 			I.ItemLocationId,
		 			I.ItemNo,
					(SELECT ItemDescription FROM Item WHERE ItemNo = I.ItemNo) as ItemDescription,
					I.UoM,
					(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = I.ItemNo AND UoM = I.UoM) as UoMDescription
		 FROM       WarehouseLocation WL
		 			INNER JOIN Warehouse W
						ON WL.Warehouse = W.Warehouse
		 			INNER JOIN ItemWarehouseLocation I
						ON 		WL.Warehouse = I.Warehouse
						AND     WL.Location = I.Location
		 <!--- WITHIN THE SAME CONDITIONS --->
		 WHERE		WL.LocationClass = '#url.locationclass#'
		 AND		I.ItemNo = '#url.itemNo#'
		 AND		I.UoM = '#url.uom#'
		 <!--- WITHIN THE SAME MISSION --->
		 AND		W.Mission = '#qWarehouse.Mission#'
		 <!--- AND NOT THE SAME ITEMLOCATION --->
		 AND		I.ItemLocationId != '#getItem.ItemLocationId#'
		 
		 ORDER BY WarehouseName, StorageCode
</cfquery>

<cf_tl id="Acceptable Variance Definition" var="vTitle">
<cf_tl id="Copy to locations" var="vTitle2">

<cf_screentop 
	height="100%" 
	scroll="No" 
	html="Yes" 
	label="#vTitle#" 
	option="#vTitle2#" 
	layout="webapp" 
	banner="yellow" 
	user="no">

<cf_divscroll>
<cfform name="frmLossCopy" action="../LocationItemLosses/AcceptableLossesCopySubmit.cfm?itemLocationId=#getItem.ItemLocationId#&warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#&locationClass=#url.locationClass#&mission=#qWarehouse.Mission#">
	<table width="90%" align="center" cellspacing="0" class="formpadding">
		<tr><td height="10"></td></tr>
		<cfoutput>
		<tr>
			<td width="30%"><cf_tl id="Location Type">:</td>
			<td>#LocationClass.Description#</td>
		</tr>
		<tr>
			<td><cf_tl id="Item">:</td>
			<td>#getItem.ItemDescription#</td>
		</tr>
		<tr>
			<td><cf_tl id="UoM">:</td>
			<td>#getItem.UoMDescription#</td>
		</tr>
		</cfoutput>
		<tr><td height="10"></td></tr>
		<tr><td class="line" colspan="2"></td></tr>
		<tr>
			<td colspan="2">
				<table width="100%" align="center">
					<cfif getLocations.recordCount eq 0>
						<tr>
							<td height="30" valign="middle" align="center" colspan="2"><font color="808080"><b>[<cf_tl id="No losses definitions for these criteria">]</b></font></td>
						</tr>
						<tr><td class="line" colspan="2"></td></tr>
					</cfif>
					<cfoutput query="getLocations" group="warehouse">
						<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="">
							<td width="30%" valign="top" style="padding-top:3px; padding-left:5px;">#WarehouseName#</td>
							<td>
								<table>
									<cfoutput>
									<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="">
										<td width="20"></td>
										<td>
											<cfset vItemLocationId = replace(ItemLocationId,"-","","ALL")>
											<input type="Checkbox" name="LossDefinition_#vItemLocationId#" id="LossDefinition_#vItemLocationId#">
											&nbsp;
											<cf_tl id="View loss definition detail for this location" var="1">
											<a title="#lt_text#" href="javascript: viewLossDefinition('#warehouse#','#location#','#itemNo#','#UoM#','#url.locationclass#');">
												<font color="0080FF">
													<cfif storageCode eq ""><i>[No barcode]</i><cfelse>#StorageCode#</cfif> - #Description# [#location#]
												</font>
											</a>
										</td>
									</tr>
									</cfoutput>
								</table>
							</td>
						</tr>
						<tr><td height="5"></td></tr>
						<tr><td class="line" colspan="2"></td></tr>
						<tr><td height="10"></td></tr>
					</cfoutput>
				</table>
			</td>
		</tr>
		<cfif getLocations.recordCount gt 0>
		<tr><td height="10"></td></tr>
		<tr><td height="1" bgcolor="C0C0C0" colspan="2"></td></tr>
		<tr><td height="5"></td></tr>
		<tr>
			<td align="center" colspan="2">
			<cfoutput>
				<cf_tl id = "Copy to Selected Locations" var ="1">
				<cf_button 
					type		= "submit"
					mode        = "silver"
					label       = "#lt_text#" 
					onClick     = "if (confirm('This action will replace the previous loss definition for the selected locations.\n\nDo you want to continue ?')) { return true; } else { return false;}"					
					id          = "save"
					width       = "190px" 					
					color       = "636334"
					fontsize    = "11px">
			</cfoutput>	
			</td>
		</tr>
		<tr><td height="10"></td></tr>
		</cfif>	
		
	</table>
</cfform>
</cf_divscroll>