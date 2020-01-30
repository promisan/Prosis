<!--- return submit 
	a. Create a 3 transaction negative for the warehouse and referecne to the receipt.
	b. deduct the receipt quantity of the RI
--->

<cfquery name="getReceipts" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT    I.TransactionId, I.ReceiptId
		FROM      ItemTransaction I INNER JOIN
                  Purchase.dbo.PurchaseLineReceipt R ON I.ReceiptId = R.ReceiptId 
		WHERE     I.Warehouse = '#url.warehouse#'
		AND       TransactionType = '1' <!--- receipt --->
		AND       EXISTS
                          (SELECT     'X'
                            FROM      (SELECT    ItemNo, TransactionUoM, TransactionLot
                                       FROM      ItemTransaction
                                       WHERE     Mission = '#url.mission#'
                                       GROUP BY  ItemNo, TransactionUoM, TransactionLot
                                       HAVING    SUM(TransactionQuantity) > 0) 
										   
									   AS Sub
                            WHERE      sub.ItemNo = I.ItemNo AND sub.TransactionUoM = I.TransactionUoM AND sub.TransactionLot = I.TransactionLot) AND (R.InvoiceIdMatched IS NULL)
		ORDER BY I.Warehouse, I.ItemNo
		
</cfquery>

<cfloop query="getReceipts">
	
	<cftransaction>

	<cfparam name="form.loc_#left(transactionid,8)#" default="">
	<cfset stg = evaluate("form.loc_#left(transactionid,8)#")>	
	<cfset tot = 0>

	<cfloop index="loc" list="#stg#">
	
		<cfparam name="form.loc_#left(transactionid,8)#_#left(loc,8)#" default="">
			
		<cfset qty = evaluate("Form.loc_#left(transactionid,8)#_#left(loc,8)#")>
		
		<cfif qty neq "">
		
			<cfset tot = tot+qty>
			
			<cfquery name="location" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">					
					SELECT   *
					FROM     WarehouseLocation
					WHERE    StorageId = '#loc#'							
			</cfquery>	
									
			<cfquery name="get" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">					
					SELECT   *
					FROM     ItemTransaction 
					WHERE    TransactionId = '#TransactionId#'							
			</cfquery>
			
			<!--- recheck if we indeed have stock indeed on this item/uom/lot/loc/whs otherwise we skip --->
									
			<cfquery name="Check" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT      ISNULL(SUM(TransactionQuantity),0) AS OnHand
					FROM        ItemTransaction  
					WHERE       Mission        = '#get.mission#' 
					AND         Warehouse      = '#Location.Warehouse#'
					AND         Location       = '#Location.Location#' 
					AND         ItemNo         = '#get.itemno#' 
					AND         TransactionUoM = '#get.TransactionUoM#' 
					AND         TransactionLot = '#get.TransactionLot#'				
			</cfquery>
			
			<cfif Check.OnHand gte qty>
						
				<!--- recheck if the receipt is not becoming negative, then we skipp --->
							
				<cfquery name="Receipt" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">					
						SELECT * 
						FROM   Purchase.dbo.PurchaseLineReceipt								    
						WHERE  ReceiptId = '#ReceiptId#'							
				</cfquery>
				
				<cfif Receipt.ReceiptWarehouse gte qty>
				
					<!--- return transaction of a receipt --->
					
					<cf_StockTransact 
			            DataSource                = "AppsMaterials" 
			            TransactionType           = "3"
						TransactionSource         = "WarehouseSeries"
						ItemNo                    = "#get.ItemNo#" 
						Warehouse                 = "#Location.Warehouse#" 
						Location                  = "#Location.Location#"
						Mission                   = "#get.Mission#"
						TransactionUoM            = "#get.TransactionUoM#"
						TransactionCategory       = "Receipt"										
						TransactionQuantity       = "#qty*-1#"
						TransactionLot            = "#get.TransactionLot#" 
						TransactionDate           = "#dateFormat(now(), CLIENT.DateFormatShow)#"
						TransactionReference      = ""
						ReceiptId                 = "#get.Receiptid#"
						RequestId                 = "#get.RequestId#"
						WorkOrderId               = "#get.workorderid#"
						WorkOrderLine             = "#get.workorderline#"
						RequirementId             = "#get.RequirementId#"
						TaskSerialNo              = "#get.TaskSerialNo#"								
						ReferenceId               = "#get.ReceiptId#"
						ActionStatus              = "1"   <!--- set status as cleared --->
						OrgUnit                   = "#get.OrgUnit#"
						Remarks                   = "Return"	
						GLAccountDebit            = "#get.GLAccountCredit#"				
						GLAccountCredit           = "#get.GLAccountDebit#">							
											
					<!--- adjust the consignment receipt --->
					
					<cfquery name="Line" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">					
							SELECT * 
							FROM   Purchase.dbo.PurchaseLineReceipt							
							WHERE  ReceiptId = '#ReceiptId#'												
					</cfquery>
					
					<cfset rcpt = Line.ReceiptQuantity - qty/Line.ReceiptMultiplier>										
					<cfset dis  = Line.ReceiptDiscount*100> 					
					<cfset damt = Line.ReceiptPrice*rcpt*((100-dis)/100)>
					
					<cfif Line.TaxIncluded eq "1">
							
						 	<cfset cost = damt*(1/(1+Line.ReceiptTax))>
							<cfset tax  = damt*(Line.ReceiptTax/(1+Line.ReceiptTax))>
							<cfset cost = round(cost*1000)/1000>				  
							<cfset tax  = round(tax*1000)/1000>
							  					
					<cfelse>

						  	<cfset cost = round(damt*1000)/1000>
							<cfset tax  = damt*Line.ReceiptTax>

					</cfif>
							
					<!--- 31/12/2011 
					added provision to not take tax if the purchase line does not have tax either --->
												
					<cfset costB = round((cost/Line.ExchangeRate)*1000)>
					<cfset costB = costB/1000>
					<cfset taxb  = round((tax/Line.ExchangeRate)*1000)>
					<cfset taxB  = taxB/1000>					
									
					<cfquery name="set" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">					
							UPDATE Purchase.dbo.PurchaseLineReceipt
							SET    ReceiptQuantity       = '#rcpt#',				    
							       ReceiptAmountCost     = '#cost#',
								   ReceiptAmountTax      = '#tax#',
								   ReceiptAmountBaseCost = '#costb#',
								   ReceiptAmountBaseTax  = '#taxb#'
							WHERE  ReceiptId = '#ReceiptId#'												
					</cfquery>
					
				</cfif>	
				
			</cfif>	
				
		</cfif>			

	</cfloop>
			
	</cftransaction>	
	
</cfloop>

<cfoutput>
<script>
   stockreturn('','#url.systemfunctionid#')
</script>
</cfoutput>