

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

		SELECT   PLR.ReceiptNo, 
		         R.Period, 
				 PLR.RequisitionNo,
				 R.ReceiptDate, R.Created, PLR.Warehouse, PLR.WarehouseItemNo, PLR.WarehouseUoM, 
		         PLR.WarehouseCurrency, PLR.WarehousePrice, PLR.ReceiptMultiplier, PLR.ReceiptWarehouse, 
		         PLR.TransactionLot, PLR.ReceiptAmountCost, PLR.ReceiptAmountTax, PLR.ReceiptAmount
		FROM     PurchaseLineReceipt AS PLR INNER JOIN
		         Receipt AS R ON PLR.ReceiptNo = R.ReceiptNo
		WHERE    PLR.ActionStatus = '0' 
		<!--- Check if ReceiptId does not exists in ItemTransaction --->
		AND      R.Mission           = '#get.mission#' 
		AND      PLR.Warehouse       = '#url.warehouse#'
		AND      PLR.WarehouseItemNo = '#url.itemNo#' 
		<!---
		AND      PLR.WarehouseUoM    = '#url.uom#'
		--->
		ORDER BY PLR.ReceiptNo DESC
		
		
</cfquery>



<!--- get price fileds --->


   


<table width="100%">

	<cfoutput>
	
		<tr class="labelmedium2 fixlengthlist line fixrow">
		    <td><cf_tl id="ReceiptNo"></td>
			<td><cf_tl id="Started"></td>			
			<td align="right"><cf_tl id="In Transit">##</td>
			<td></td>
			<td align="right"><cf_tl id="FOB"></td>	
			<td align="right"><cf_tl id="Transit Cost"></td>	
			<td align="right"><cf_tl id="Est Price"></td>
			<td align="right"><cf_tl id="ETA"></td>		
		</tr>
	
		<cfloop query="InTransit">	
						
			<cfquery name="Line" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			
					SELECT   *
					FROM     PurchaseLine
					WHERE    RequisitionNo = '#requisitionno#'
							
			</cfquery>
			
			<tr class="labelmedium2 fixlengthlist line">
			
			    <td><a href="javascript:receipt('#receiptNo#','receipt')">#receiptNo#</a></td>
				<td>#dateformat(ReceiptDate,client.dateformatshow)#</td>				
				<td align="right">#numberformat(ReceiptWarehouse,',.__')#</td>											
				<td align="right">#Line.Currency#</td>				
				<td align="right">#numberformat(ReceiptAmountCost/ReceiptWarehouse,',.__')#</td>
				
				<cfset cost = ReceiptAmountCost>
				
				<cftry>
										
				<cfquery name="Additional" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					SELECT     SUM(CAST(OOI.DocumentItemValue as Numeric)) as Cost
					FROM       Ref_EntityDocument AS R INNER JOIN
				               OrganizationObjectInformation AS OOI ON R.DocumentId = OOI.DocumentId INNER JOIN
				               OrganizationObject AS OO ON OOI.ObjectId = OO.ObjectId
					WHERE      R.EntityCode = 'ProcReceipt' 
					AND        R.ObjectUsage = 'Price' 
					AND        OO.ObjectKeyValue1 = '#ReceiptNo#'
				</cfquery>	
				
				<cfcatch>
				
				<cfparam name="additional.cost" default=""> 
				
				</cfcatch>
				
				</cftry>
				
				<cfif additional.cost eq "">
				
					<td align="right">n/a</td>	
					<td align="right">n/a</td>
	
				<cfelse>
				
					<cfset cost = (cost + additional.cost)/ReceiptWarehouse>		
					<td align="right">#numberformat(cost,',.__')#</td>	
					
					<cfquery name="Margin" 
					  datasource="AppsOrganization" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						SELECT     TOP 1 CAST(OOI.DocumentItemValue as Float) as Margin
						FROM       Ref_EntityDocument AS R INNER JOIN
					               OrganizationObjectInformation AS OOI ON R.DocumentId = OOI.DocumentId INNER JOIN
					               OrganizationObject AS OO ON OOI.ObjectId = OO.ObjectId
						WHERE      R.EntityCode = 'ProcReceipt' 
						AND        R.ObjectUsage = 'Margin' 
						AND        OO.ObjectKeyValue1 = '#ReceiptNo#'
					</cfquery>	
					
					<cfif Margin.recordcount eq "0">
					
					  <td align="right">n/a</td>
					
					<cfelse>
					
					  <cfset price = cost + (cost * margin.margin)> 
					  <td align="right">#numberformat(price,',.__')#</td>	
					
					</cfif>
								
				</cfif>	
				
				<cfquery name="ETA" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					SELECT     TOP 1 OOI.DocumentItemValue as ETA
					FROM       Ref_EntityDocument AS R INNER JOIN
				               OrganizationObjectInformation AS OOI ON R.DocumentId = OOI.DocumentId INNER JOIN
				               OrganizationObject AS OO ON OOI.ObjectId = OO.ObjectId
					WHERE      R.EntityCode = 'ProcReceipt' 
					AND        OO.Operational = 1
					AND        R.ObjectUsage = 'ETA' 
					AND        OO.ObjectKeyValue1 = '#ReceiptNo#'
				</cfquery>	
				
				<cfif ETA.recordcount eq "1">
				
				<td align="right">#dateformat(ETA.ETA,'#client.dateformatshow#')#</td>	
				
				<cfelse>
				
				<td align="right">n/a</td>
				
				</cfif>
				
					
			</tr>
		
		</cfloop>
	
	</cfoutput>
	
</table>