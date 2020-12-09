
<cfquery name="get"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   * 
	FROM     ItemUoM 
	WHERE    ItemNo  = '#url.itemno#'		
	AND      UoM     = '#url.uom#'
</cfquery>

<cfquery name="Item"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    * 
	FROM      Item
	WHERE     ItemNo  = '#url.itemno#'			
</cfquery>

<cfquery name="qOffer"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">						
	SELECT    IVO.OfferMinimumQuantity 
	FROM      ItemVendor IV INNER JOIN 
		      ItemVendorOffer IVO ON IV.ItemNo = IVO.ItemNo
	WHERE     IV.ItemNo    = '#Get.ItemNo#'
	AND       IV.UoM       = '#Get.UoM#'
	AND       IV.Preferred = '1'
	ORDER BY  DateEffective DESC
</cfquery>

<cfquery name="ItemList" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	   SELECT *,
		CASE WHEN Warehouse = '#URL.Warehouse#' THEN 0 ELSE 1 END AS Type 
			
	   FROM (
	
			SELECT 	 W.Mission AS Mission, 
			         W.WarehouseName, 					 
					 IW.*, 
					 WL.Description as LocationName,
					 I.ItemPrecision,
					 I.ValuationCode,
					 U.UoMDescription,	
					 U.UoMMultiplier,		 
					 U.ItemBarCode,					 
					 (	SELECT ROUND(SUM(TransactionQuantity),5)
						FROM   ItemTransaction 
						WHERE  Warehouse       = IW.Warehouse
						AND    Location        = IW.Location
						AND    ItemNo          = U.ItemNo
						AND	   TransactionUoM  = U.UoM								
					 ) as OnHand 						
			FROM     ItemWarehouseLocation IW 
					 INNER JOIN Warehouse W ON IW.Warehouse = W.Warehouse 
					 INNER JOIN WarehouseLocation WL ON IW.Warehouse = WL.Warehouse AND IW.Location = WL.Location
					 INNER JOIN ItemUoM U ON IW.ItemNo = U.ItemNo AND IW.UoM = U.UoM
					 INNER JOIN Item I ON IW.ItemNo = I.ItemNo
			WHERE    W.Warehouse = '#url.warehouse#'
			AND      IW.ItemNo   = '#Get.Itemno#'
			AND      IW.UoM      = '#Get.UoM#'
			AND      IW.Operational = 1
			AND      W.Operational  = 1
			-- AND      SaleMode       = '2'			 
			
			
		) as XL
		
		WHERE OnHand > 0
				
		ORDER BY  Type, Warehouse, PickingOrder, OnHand		
</cfquery>
		
<table width="100%">
	<tr><td style="width:100%;padding:5px">
	
	<table width="100%">
	
		<cfoutput>
						
		<tr class="labelmedium">
			
			<td align="left" colspan="3" style="font-size:16px">#get.ItemBarcode# #item.ItemDescription# #item.ItemNo#</td>			
			<td align="right" style="font-size:16px"></td>			
		</tr>

		<tr class="labelmedium line">
			
			<td colspan="3" style="font-size:16px">
				<cf_tl id="Minimum Quantity">
			</td>
			<td align="right" style="font-size:16px">
				<cfif qOffer.recordcount neq 0>#qOffer.OfferMinimumQuantity#</cfif>		
			</td>						
		</tr>
				
		</cfoutput>
				
		<cfoutput query="ItemList" group="Warehouse">
										
				<tr class="labelmedium">					
					<td colspan="4" style="padding-top:10px;font-size:20px;padding-left:10px"><b>#WarehouseName#</td>					
				</tr>
								
				<cfoutput group="Location">
				
					<tr class="line labelmedium">					
						<td colspan="4" style="font-size:16px;padding-left:24px">#Location# #LocationName#</td>					
					</tr>
				
				<cfoutput>
							
					<tr class="labelmedium">						
						<td colspan="1" style="padding-left:40px" align="left">#UoMDescription# (*#UOMMultiplier#)</td>						
						<td width="10%" align="right">#numberformat(OnHand,",.__")#</td>																			
					</tr>
				
				</cfoutput>
				
				</cfoutput>
				
			</cfoutput>
			
	</table>
	
	</td></tr>
	
</table>	
