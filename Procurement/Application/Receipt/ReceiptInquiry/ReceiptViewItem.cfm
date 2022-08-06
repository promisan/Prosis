

<!--- shows in dialog upcoming receipts for an item --->

<cfquery name="get" 
     datasource="AppsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT *
	 FROM Warehouse
	 WHERE Warehouse = '#url.warehouse#'
</cfquery>	 

<cfquery name="InTransit" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">

		SELECT   PLR.ReceiptNo, R.Period, R.ReceiptDate, R.Created, PLR.Warehouse, PLR.WarehouseItemNo, PLR.WarehouseUoM, 
		         PLR.WarehouseCurrency, PLR.WarehousePrice, PLR.ReceiptMultiplier, PLR.ReceiptWarehouse, 
		         PLR.TransactionLot, PLR.ReceiptAmountCost, PLR.ReceiptAmountTax, PLR.ReceiptAmount
		FROM     PurchaseLineReceipt AS PLR INNER JOIN
		         Receipt AS R ON PLR.ReceiptNo = R.ReceiptNo
		WHERE    PLR.ActionStatus = '0' 
		<!--- Check if ReceiptId does not exists in ItemTransaction --->
		AND      R.Mission           = '#get.mission#' 
		AND      PLR.Warehouse       = '#url.warehouse#'
		AND      PLR.WarehouseItemNo = '#url.itemNo#' 
		AND      PLR.WarehouseUoM    = '#url.uom#'
		ORDER BY PLR.ReceiptNo DESC

</cfquery>

<table width="100%">

	<cfoutput>
	
	<tr class="labelmedium fixlengthlist line fixrow">
	    <td><cf_tl id="ReceiptNo"></td>
		<td><cf_tl id="Started"></td>
		<td><cf_tl id="ETA"></td>	
		<td><cf_tl id="Currency"></td>
		<td align="right"><cf_tl id="CostPrice"></td>	
		<td align="right"><cf_tl id="In Transit"></td>
	</tr>
	
	<cfloop query="InTransit">
		
		<tr class="labelmedium fixlengthlist line">
		    <td><a href="javascript:receipt('#receiptNo#','receipt')">#receiptNo#</a></td>
			<td>#dateformat(ReceiptDate,client.dateformatshow)#</td>
			<td>#dateformat(ReceiptDate,client.dateformatshow)#</td>	
			<td>#warehouseCurrency#</td>
			<td align="right">#numberformat(WarehousePrice,',.__')#</td>	
			<td align="right">#numberformat(ReceiptWarehouse,',.__')#</td>
		</tr>
	
	</cfloop>
	
	</cfoutput>
	
</table>






