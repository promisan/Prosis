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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="form.ReceiptRemarks"     default="">
<cfparam name="Form.ReceiptReference1"  default="">
<cfparam name="Form.ReceiptReference2"  default="">
<cfparam name="Form.ReceiptReference3"  default="">
<cfparam name="Form.ReceiptReference4"  default="">
<cfparam name="Form.Description"        default="">

<cfif Len(Form.ReceiptRemarks) gt 200>
   	 <cf_message message = "You may not enter remarks that exceed 200 characters."
      return = "back">
   	  <cfabort>
</cfif>

<cftransaction>
  		
    <cfset dateValue = "">
	<CF_DateConvert Value="#Form.ReceiptDate#">
	<cfset dte = dateValue>
								
	<cfquery name="Header" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     UPDATE Receipt
			 SET    PackingSlipNo     = '#Form.PackingSlipNo#',
			        ReceiptReference1 = '#Form.ReceiptReference1#', 
				    ReceiptReference2 = '#Form.ReceiptReference2#',
				    ReceiptReference3 = '#Form.ReceiptReference3#',
				    ReceiptReference4 = '#Form.ReceiptReference4#',
				    ReceiptDate       = #dte#,
				    ReceiptRemarks    = '#Form.ReceiptRemarks#'
			 WHERE  ReceiptNo         = '#URL.ID#'	
    </cfquery>
				
	<cfquery name="InsertAction" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ReceiptAction 
				 (ReceiptId, 
				  ActionStatus, 
				  ActionDate, 
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName) 
		SELECT  ReceiptId, 
			        '1', 
					'#DateFormat(Now(),CLIENT.dateSQL)#', 
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#'
		FROM    PurchaseLineReceipt
		WHERE   ActionStatus = '0'
		AND     ReceiptNo    = '#URL.ID#'	
	</cfquery>
	
	<!--- clear the receipt line and then also post the warehouse transaction --->
	
	<cfquery name="Update" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE PurchaseLineReceipt
		 SET    ActionStatus  = '1',
		        PackingSlipNo = '#Form.PackingslipNo#'
		 WHERE  ActionStatus  = '0'
		 AND    ReceiptNo     = '#URL.ID#'	
    </cfquery>
	
	<!--- record the receipt in warehouse module, 
	  and make a GL booking as well. --->
	
	<cf_verifyOperational 
	    datasource = "AppsPurchase" 
	    module     = "Warehouse" 
		Warning    = "No">
	
	<cfif Operational eq "1">
		
		<cfquery name="Line" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT R.*, 
			        P.PurchaseNo,
			        P.Currency as PurchaseCurrency, 
					T.InvoiceWorkFlow,
					L.OrgUnit, 
					H.OrgUnitVendor,
					L.Mission,
					L.WorkOrderId
			 FROM   PurchaseLineReceipt R, 
			        PurchaseLine P,
					Purchase H,
					Ref_OrderType T,
			        RequisitionLine L
			 WHERE  ReceiptNo = '#URL.ID#'	
			 AND    R.RequisitionNo = P.RequisitionNo 
			 AND    R.RequisitionNo = L.RequisitionNo
			 AND    H.OrderType     = T.Code
			 AND    P.PurchaseNo    = H.PurchaseNo
		</cfquery>	 
		
		<cfloop query="Line">
		
			<cfif WarehouseItemNo neq "" and ReceiptWarehouse neq "0">
			
			        <!--- receipt = warehouse item, get GL-account from warehouse ---> 
					
					<cfif Warehouse eq "">
					
						<cfquery name="WarehouseSel" 
						   datasource="AppsPurchase" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
							   SELECT   *
							   FROM     Materials.dbo.Warehouse
							   WHERE    Mission  = '#Mission#'
							   ORDER BY WarehouseDefault DESC
						</cfquery>
						
						<cfset whs = WarehouseSel.Warehouse>
						
					<cfelse>	
					
						<cfset whs = Warehouse>
					
					</cfif>
				
					<cfquery name="Item" 
					   datasource="AppsPurchase" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						   SELECT *
						   FROM   Materials.dbo.Item I, 
						          Materials.dbo.ItemUoM U
						   WHERE  I.ItemNo = U.ItemNo
						   AND    I.ItemNo  = '#WarehouseItemNo#'
						   AND    U.UoM      = '#WarehouseUoM#'
					</cfquery>
					
					<cfif Item.recordcount eq "0">
					
						  	 <cf_message message = "Problem Item/UoM does not exist">
							 <cfabort>
						 					
					<cfelse>
				    								
						<cfquery name="ClearPriorEntry" 
						   datasource="AppsPurchase" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
							   DELETE FROM Materials.dbo.ItemTransaction 
							   WHERE ReceiptId  = '#ReceiptId#'
						</cfquery>
						
						<cfquery name="GLStock" 
						   datasource="AppsPurchase" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
							   SELECT * FROM Materials.dbo.Ref_CategoryGLedger 
							   WHERE Area     = 'Stock'
							   AND   Category = '#Item.Category#'
							   AND   GLAccount IN (SELECT GLAccount 
							                       FROM Accounting.dbo.Ref_Account) 
						</cfquery>
						
						<cfif GLStock.recordcount eq "0">
						    
						  	 <cf_message message = "ITEM CATEGORY MAINTENANCE: A -Stock- GL account for Item Category: #Item.Category# was not defined.">
							 <cfabort>
						
						</cfif>												
						
						<cfquery name="GLPrice" 
						   datasource="AppsPurchase" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						   SELECT * 
						   FROM   Materials.dbo.Ref_CategoryGLedger 
						   WHERE  Area     = 'PriceChange'
						   AND    Category = '#Item.Category#'
						   AND   GLAccount IN (SELECT GLAccount 
						                       FROM Accounting.dbo.Ref_Account)
						</cfquery>
						
						<cfif GLPrice.recordcount eq "0">
						    
						  	 <cf_message message = "ITEM CATEGORY MAINTENANCE: A -Price change- GL account for Item Category: #Item.Category# was not defined.">
							 <cfabort>
						
						</cfif>		
						
						<cfif InvoiceWorkFlow neq "9">
						
							<cfquery name="GLReceipt" 
							   datasource="AppsPurchase" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
							   SELECT * 
							   FROM   Materials.dbo.Ref_CategoryGLedger 
							   WHERE  Area     = 'Receipt'
							   AND    Category = '#Item.Category#'
							    AND   GLAccount IN (SELECT GLAccount 
							                       FROM Accounting.dbo.Ref_Account)
							</cfquery>
							
							<cfif GLReceipt.recordcount eq "0">
							    
							  	 <cf_message message = "ITEM CATEGORY MAINTENANCE: A Receipt GL account for Item Category: #Item.Category# was not defined.">
								 <cfabort>
							
							</cfif>			
							
						<cfelse>
						
							<cfif WorkOrderid neq "">
							
							     <!--- internal workorder --->
							
							     <cfquery name="GLReceipt" 
								   datasource="AppsPurchase" 
								   username="#SESSION.login#" 
								   password="#SESSION.dbpw#">
								     SELECT * 
								     FROM   WorkOrder.dbo.WorkOrderGLedger R
								     WHERE  Area     = 'Production'
								     AND    WorkOrderId = '#workorderid#'
								     AND    GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account WHERE GLAccount = R.GLAccount)
								</cfquery>						
							
							<cfelse>
						
								<cfquery name="GLReceipt" 
								   datasource="AppsPurchase" 
								   username="#SESSION.login#" 
								   password="#SESSION.dbpw#">
								     SELECT * 
								     FROM   Materials.dbo.Ref_CategoryGLedger R
								     WHERE  Area     = 'Production'
								     AND    Category = '#Item.Category#'
								     AND    GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account WHERE GLAccount = R.GLAccount)
								</cfquery>
							
							</cfif>
							
							<cfif GLReceipt.recordcount eq "0" and operational eq "1">
						    
							  	 <cf_message message = "Production contra-account for #Item.Category# does not exist">
								 <cfabort>
						
							</cfif>					
												
						</cfif>			
						
						<!--- capture contra account - inkopen --->
						<cfquery name="ReceiptContraAccount" 
					     datasource="AppsPurchase" 
			    		 username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
			    		 UPDATE PurchaseLineReceipt
						 SET    GLAccountReceipt = '#GLReceipt.GLAccount#' 
						 WHERE  ReceiptId        = '#ReceiptId#'	
						</cfquery>	
					
						<!--- register a stock and GL transaction --->						
						<cfset price = ReceiptAmountCost/ReceiptWarehouse>	
																		
						<!--- the transaction valuation is in principle the curr/
						                                     price you paid --->		
						<cfset curr  = currency>			
						<cfset cost  = price>
												
						<!--- apply a different cost price in case of warehouse items --->
						
						<!--- Item.ItemClass eq "Supply --->
																		
						<cfif Item.ValuationCode eq "Manual">	
						    
							<!--- activate only the standard costing here --->	
							<cfset curr = APPLICATION.BaseCurrency>				
							<cfset cost = Item.StandardCost>	
							
						<cfelseif WarehousePrice neq "">
						
							<!--- activate only the receipt defined standard cost --->	
							<cfset curr = WarehouseCurrency>	
						    <cfset cost = WarehousePrice>	
																																			
						</cfif>	
													
						<cfif WarehouseTaskId neq "">
						
							<!--- capture contra account - inkopen --->
							
							<cfquery name="Task" 
						     datasource="AppsPurchase" 
				    		 username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
				    		 SELECT  * 
							 FROM    Materials.dbo.RequestTask
							 WHERE   TaskId = '#WarehouseTaskId#'						 
							</cfquery>	
							
							<cfset taskreq  = "#Task.RequestId#">
							<cfset taskser  = "#Task.TaskSerialNo#">					
						
						<cfelse>
						
							<cfset taskreq  = "">
							<cfset taskser  = "">
												
						</cfif>
						
						<cfif TransactionLot eq "">
							<cfset lot = "0">
						<cfelse>
							<cfset lot = TransactionLot>
						</cfif>
						
					   <!--- we create the lot --->
												
					   <cfinvoke component = "Service.Process.Materials.Lot"  
						   method                 = "addlot" 
						   datasource             = "AppsPurchase"
						   mission                = "#Mission#" 
						   transactionlot         = "#Lot#"
						   TransactionLotDate     = "#dateFormat(now(), CLIENT.DateFormatShow)#"
						   OrgUnitVendor          = "#OrgUnitVendor#"
						   returnvariable         = "result">		
											
					  <cfquery name="Details" 
					     datasource="AppsPurchase" 
			    		 username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
							 SELECT * 
							 FROM   PurchaseLineReceiptDetail
							 WHERE  ReceiptId = '#Receiptid#'
							 AND    StorageId is not NULL
					  </cfquery>	 
					
					  <cfif details.recordcount gte "1">   
					  
					  	<cfquery name="Warehouse"
						    datasource="AppsPurchase" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
								SELECT * 
								FROM   Materials.dbo.Warehouse
								WHERE  Warehouse = '#whs#' 
						</cfquery>
						   
						<cfquery name="DetailLines" 
						    datasource="AppsPurchase" 
				    		username="#SESSION.login#" 
						    password="#SESSION.dbpw#">					
								SELECT  *
								FROM    PurchaseLineReceiptDetail
								WHERE   ReceiptId = '#Receiptid#'
								AND     QuantityAccepted <> '0'
						</cfquery>	
						
						<cfloop query="detailLines"> 
						
						    <cfif storageid eq "">
							
							   <!--- take the default --->
							   <cfset loc = Warehouse.LocationReceipt>
							   
							   <cfquery name="CheckLoc" 
							    datasource="AppsPurchase" 
					    		username="#SESSION.login#" 
							    password="#SESSION.dbpw#">					
									SELECT  *
									FROM    Materials.dbo.WarehouseLocation
									WHERE   Warehouse = '#whs#'
									AND     Location  = '#loc#'										
							    </cfquery>	
							
							<cfelse>
						
								<cfquery name="CheckLoc" 
							    datasource="AppsPurchase" 
					    		username="#SESSION.login#" 
							    password="#SESSION.dbpw#">					
									SELECT  *
									FROM    Materials.dbo.WarehouseLocation
									WHERE   StorageId = '#StorageId#'										
							    </cfquery>	
								
								<cfif checkloc.recordcount eq "1">
								
									<cfset loc = CheckLoc.Location>
								
								<cfelse>
								
									<cfset loc = Warehouse.LocationReceipt>
								
								</cfif>
							
							</cfif>																	
						
							<cf_StockTransact 
					            DataSource                = "AppsPurchase" 
					            TransactionType           = "1"
								TransactionSource         = "PurchaseSeries"
								ItemNo                    = "#Line.WarehouseItemNo#" 
								Warehouse                 = "#whs#" 
								Location                  = "#loc#"
								Mission                   = "#Line.Mission#"
								TransactionUoM            = "#Line.WarehouseUoM#"
								TransactionCategory       = "Receipt"
								TransactionCurrency       = "#curr#"
								TransactionCostPrice      = "#cost#"							
								TransactionQuantity       = "#QuantityAccepted#"
								TransactionLot            = "#lot#" 
								TransactionDate           = "#dateFormat(Line.DeliveryDate, CLIENT.DateFormatShow)#"
								TransactionReference      = "#ContainerName#"
								TransactionId             = "#TransactionId#"
								ReceiptId                 = "#Line.Receiptid#"
								RequestId                 = "#taskreq#"
								WorkOrderId               = "#Line.workorderid#"
								WorkOrderLine             = "#Line.workorderline#"
								RequirementId             = "#Line.RequirementId#"
								TaskSerialNo              = "#taskser#"
								ReceiptCostPrice          = "#cost#"
								ReceiptCurrency           = "#curr#"
								ReceiptPrice              = "#price#"
								ReferenceId               = "#Line.ReceiptId#"
								ActionStatus              = "1"   <!--- set status as cleared --->
								OrgUnit                   = "#Line.OrgUnit#"
								Remarks                   = "Receipt detail #ReceiptLineNo# #ContainerName#"
								GLTransactionNo           = "#Line.PurchaseNo#"
								GLTransactionSourceNo     = "#Line.ReceiptNo#"
								GLCurrency                = "#Line.PurchaseCurrency#"
								GLAccountDebit            = "#GLStock.GLAccount#"
								GLAccountDiff             = "#GLPrice.GLAccount#"
								GLAccountCredit           = "#GLReceipt.GLAccount#">							
						
						</cfloop>						
						
					  <cfelse>	  					  					  
																	
						<cf_StockTransact 
				            DataSource            = "AppsPurchase" 
				            TransactionType       = "1"
							TransactionSource     = "PurchaseSeries"
							ItemNo                = "#WarehouseItemNo#" 
							Warehouse             = "#whs#" 
							Mission               = "#Mission#"
							TransactionUoM        = "#WarehouseUoM#"
							TransactionCategory   = "Receipt"
							TransactionCurrency   = "#curr#"
							TransactionCostPrice  = "#cost#"							
							TransactionQuantity   = "#ReceiptWarehouse#"
							TransactionLot        = "#lot#" 
							TransactionDate       = "#dateFormat(Line.DeliveryDate, CLIENT.DateFormatShow)#"												
							ReceiptId             = "#Receiptid#"
							RequestId             = "#taskreq#"
							WorkOrderId           = "#workorderid#"
							WorkOrderLine         = "#workorderline#"
							RequirementId         = "#RequirementId#"
							TaskSerialNo          = "#taskser#"
							ReceiptCostPrice      = "#cost#"
							ReceiptCurrency       = "#curr#"
							ReceiptPrice          = "#price#"
							ReferenceId           = "#ReceiptId#"
							OrgUnit               = "#OrgUnit#"
							ActionStatus              = "1"   <!--- set status as cleared --->
							Remarks               = "Receipt"
							GLTransactionNo       = "#Line.PurchaseNo#"
							GLTransactionSourceNo = "#Line.ReceiptNo#"
							GLCurrency            = "#Line.PurchaseCurrency#"
							GLAccountDebit        = "#GLStock.GLAccount#"
							GLAccountDiff         = "#GLPrice.GLAccount#"
							GLAccountCredit       = "#GLReceipt.GLAccount#">
							
						</cfif>	
							
					</cfif>		
						
			<cfelse>					
			
			<!--- no warehouse and GL transaction, just book cost upon receipt of invoice --->
						
			</cfif>
				
		</cfloop>	
		
	</cfif>		
	
</cftransaction>

<script language="JavaScript">
	 parent.window.close()
	 try { parent.opener.history.go() } catch(e) {}
</script>
	



