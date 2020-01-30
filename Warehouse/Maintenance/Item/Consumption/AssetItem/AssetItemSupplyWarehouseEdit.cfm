<cf_screentop height="100%" 
	   scroll="Yes" 
	   html="Yes" 
	   label="Asset Supply by Warehouse" 
	   option="Maintain Asset Supplies by Warehouse" 
	   layout="webdialog" 
	   bannerheight="50"
	   user="no">
	   
<cfquery name="warehouse" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	W.*,
			SW.Warehouse as Selected
	FROM 	Warehouse W
			LEFT OUTER JOIN AssetItemSupplyWarehouse SW
				ON SW.Warehouse = W.Warehouse
				<cfif url.itemno neq "">
					AND 	SW.AssetId = '#url.itemno#'
				</cfif>
				AND 	SW.SupplyItemNo = '#url.supply#'
				AND		SW.SupplyItemUoM = '#url.uom#'
	WHERE	W.Mission IN 
			(
				SELECT 	Mission 
				FROM 	AssetItem 
				<cfif url.itemno neq "">
					WHERE AssetId = '#url.itemNo#'
				</cfif>
			)
	AND     W.Operational = 1
	ORDER BY W.City, W.Warehousename
</cfquery>

<table class="hide">
	<tr><td><iframe name="processSupplyWarehouse" id="processSupplyWarehouse" frameborder="0"></iframe></td></tr>
</table>

<cfform action="#session.root#/warehouse/maintenance/item/Consumption/AssetItem/AssetItemSupplyWarehouseSubmit.cfm?itemno=#url.itemno#&supply=#url.supply#&uom=#url.uom#" name="frmSupplyWarehouse" method="POST" target="processSupplyWarehouse">

<table width="90%" align="center">
	<tr><td height="5"></td></tr>
		<cfoutput query="warehouse" group="city">
			<tr>
				<td class="labellarge">#City#</td>
			</tr>
			<tr><td class="line"></td></tr>
			<tr>
				<td>
					<table width="95%" align="center">
						<tr>
							<cfset vCols = 3>
							<cfset vCont = 0>
							<cfoutput>
								<td width="#100/vCols#%" style="padding-left:6px" class="labelmedium">
									<input type="Checkbox" name="wh_#trim(warehouse)#" id="wh_#trim(warehouse)#" <cfif selected neq "">checked</cfif>> <label for="wh_#trim(warehouse)#">#warehouseName#</label>
								</td>
								<cfset vCont = vCont + 1>
								<cfif vCols eq vCont>
									<cfset vCont = 0>
									</tr>
									<tr>
								</cfif>
							</cfoutput>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td height="8"></td></tr>
		</cfoutput>
		<tr><td height="5"></td></tr>
		<tr>
			<td class="line"></td>
		</tr>
		<tr><td height="5"></td></tr>
		<tr>
			<td align="center" height="30">
				<input type="Submit" name="save" id="save" value="  Save  " class="button10s" style="width:150px;height:24">
			</td>
		</tr>
</table>
</cfform>

