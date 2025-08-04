<!--
    Copyright © 2025 Promisan

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

<cfquery name="getWL" 
     datasource="AppsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *
	 FROM       WarehouseLocation 
	 WHERE		Warehouse = '#url.warehouse#'
	 AND       	Location = '#url.location#'		
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
	 			I.ItemLocationId,
	 			I.ItemNo,
				(SELECT ItemDescription FROM Item WHERE ItemNo = I.ItemNo) as ItemDescription,
				I.UoM,
				(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = I.ItemNo AND UoM = I.UoM) as UoMDescription,
	 			(SELECT WarehouseName FROM Warehouse WHERE Warehouse = WL.Warehouse) as WarehouseName
	 FROM       WarehouseLocation WL
	 			INNER JOIN Warehouse W
						ON WL.Warehouse = W.Warehouse
	 			INNER JOIN ItemWarehouseLocation I
					ON 		WL.Warehouse = I.Warehouse
					AND     WL.Location = I.Location
	 <!--- WITHIN THE SAME CONDITIONS --->
	 WHERE		WL.StorageShape = '#getWL.StorageShape#'
	 AND		WL.StorageWidth = '#getWL.StorageWidth#'
	 AND		WL.StorageHeight = '#getWL.StorageHeight#'
	 AND		WL.StorageDepth = '#getWL.StorageDepth#'
	 AND		I.HighestStock = #getItem.HighestStock#
	 AND		I.StrappingIncrementMode = '#getItem.StrappingIncrementMode#'
	 AND		I.StrappingScale = #getItem.StrappingScale#
	 AND		I.StrappingIncrement = #getItem.StrappingIncrement#
 	 AND		I.ItemNo = '#url.itemNo#'
	 AND		I.UoM = '#url.uom#'
	 <!--- WITHIN THE SAME MISSION --->
	 AND		W.Mission = '#qWarehouse.Mission#'
	 <!--- AND NOT THE SAME ITEMLOCATION --->
	 AND		I.ItemLocationId != '#getItem.ItemLocationId#'
	 <!--- AND WITH A STRAPPING TABLE DEFINED --->
	 AND		I.ItemLocationId IN 
	 			(
					SELECT 	AIl.ItemLocationId
					FROM	ItemWarehouseLocationStrapping ASt
							INNER JOIN ItemWarehouseLocation AIl 
								ON ASt.Warehouse = AIl.Warehouse
								AND	ASt.Location = AIl.Location
								AND	ASt.ItemNo = AIl.ItemNo
								AND	ASt.UoM = AIl.UoM
					WHERE		ASt.Warehouse = I.Warehouse
					AND       	ASt.Location = I.Location
					AND			ASt.ItemNo = I.ItemNo
					AND			ASt.UoM = I.UoM
				)
</cfquery>

<cfquery name="Strapping" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT 	*
		 FROM      	ItemWarehouseLocationStrapping
		 WHERE		Warehouse = '#url.warehouse#'
		 AND       	Location = '#url.location#'		
		 AND		ItemNo = '#url.itemNo#'
		 AND		UoM = '#url.UoM#'
</cfquery>

<cf_screentop 
			height="100%" 
			scroll="no" 
			html="Yes" 
			label="Reference Table" 
			option="Copy Strapping Reference Table for #getItem.ItemDescription#" 
			layout="webapp" 
			banner="yellow" 
			user="no">

<cfform name="frmStrappingCopy" action="../LocationItemStrapping/StrappingListCopySubmit.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#&height=#url.height#">			

<table width="90%" align="center" cellspacing="0" class="formpadding">

	<tr><td height="5"></td></tr>
	
	<cfoutput>
	<tr>
		<td width="26%" class="labelit"><cf_tl id="Item">:</td>
		<td class="labelit">#getItem.ItemDescription#</td>
	</tr>
	<tr>
		<td class="labelit"><cf_tl id="UoM">:</td>
		<td class="labelit">#getItem.UoMDescription#</td>
	</tr>
	<tr>
		<td class="labelit"><cf_tl id="Capacity">:</td>
		<td class="labelit">#lsNumberFormat(getItem.HighestStock,",")# #getItem.UoMDescription#s</td>
	</tr>
	<tr>
		<td class="labelit"><cf_tl id="Shape">:</td>
		<td class="labelit">#getWL.StorageShape#</td>
	</tr>
	<tr>
		<td class="labelit"><cf_tl id="Width">:</td>
		<td class="labelit">#getWL.StorageWidth#</td>
	</tr>
	<tr>
		<td class="labelit"><cf_tl id="Height">:</td>
		<td class="labelit">#getWL.StorageHeight#</td>
	</tr>
	<tr>
		<td class="labelit"><cf_tl id="Depth">:</td>
		<td class="labelit">#getWL.StorageDepth#</td>
	</tr>
	<tr>
		<td class="labelit"><cf_tl id="Strapping Mode">:</td>
		<td class="labelit">#getItem.StrappingIncrementMode#</td>
	</tr>
	<tr>
		<td class="labelit"><cf_tl id="Strapping Scale">:</td>
		<td class="labelit">#getItem.StrappingScale#</td>
	</tr>
	<tr>
		<td class="labelit"><cf_tl id="Strapping Increment">:</td>
		<td class="labelit">#getItem.StrappingIncrement#</td>
	</tr>
	</cfoutput>
	<tr><td height="10"></td></tr>
	<tr>
		<td colspan="2">
			<table width="90%" align="center">
				<cfif getLocations.recordCount eq 0>
					<tr>
						<td height="30" valign="middle" align="center"><font color="808080">[<cf_tl id="No strapping tables defined for these criteria">]</b></font></td>
					</tr>
				</cfif>
				<cfoutput query="getLocations">
					<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor='FFFFFF'" bgcolor="FFFFFF">
						<td>
							<cfinput type="Radio" name="StrappingTable" value="#ItemLocationId#" required="Yes" message="Please, select a valid strapping table.">
							&nbsp;
							<a title="View Strapping Table Detail" href="javascript: viewStrappingTable('#warehouse#','#location#','#itemNo#','#UoM#','#getWL.StorageHeight#');">
								<font color="0080FF">
									#WarehouseName# / #Description#
								</font>
							</a>
						</td>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
	<cfif getLocations.recordCount gt 0>
	<tr><td height="10"></td></tr>
	<tr><td height="1" class="line"></td></tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td align="center" colspan="2">
			<cfoutput>
			<cf_tl id="Save" var="vSave">
			<input type="submit" value="  #vSave# " name="save" ID="save" class="button10g" onclick="if (confirm('This action will replace all previous values.\nDo you want to continue ?')) { return true; } else { return false;}">
			</cfoutput>
		</td>
	</tr>
	</cfif>	
	
</table>

</cfform>