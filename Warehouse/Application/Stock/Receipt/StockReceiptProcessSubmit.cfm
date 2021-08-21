
<cfset url.whs = url.warehouse>
<cfset url.mis = url.mission>

<cfquery name="Parameter" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT   TOP 1 *
   FROM     WarehouseBatch
   ORDER BY BatchNo DESC
</cfquery>

<cfif Parameter.recordcount eq "0">
	<cfset batchNo = 10000>
<cfelse>
	<cfset BatchNo = Parameter.BatchNo+1>
	<cfif BatchNo lt 10000>
	     <cfset BatchNo = 10000+BatchNo>
	</cfif>
</cfif>	

<cfparam name="url.loc"          default="">
<cfparam name="url.stockorderid" default="">

<cf_tl id="Accounting information is not available." var="1" class="Message">
<cfset msg1="#lt_text#">

<cf_tl id="Operation not allowed." var="1" class="Message">
<cfset msg2="#lt_text#">	

<!--- define the content of the transactions recorded for transfer and/or conversion, the conversion and transfer transactions
will be put into different batches as they could have different process flows as each is handled as a different type --->

<cfloop index="actiontype" list="Transfer">

	<cfset url.tpe = "8">
		
	<cfquery name="getBatch"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   DISTINCT TransferWarehouse, TransferLocation 				 
		FROM     Receipt#URL.Whs#_#SESSION.acc# S		
		WHERE   (TransferItemNo = ItemNo OR TransferItemNo IS NULL)
		<!--- validate the location --->
		AND     TransferLocation IN (SELECT Location 
		                             FROM   Materials.dbo.WarehouseLocation 
									 WHERE  Warehouse = S.TransferWarehouse) 
		AND     TransferQuantity IS NOT NULL
		AND		TransferQuantity > 0
	</cfquery>		
	
	<cfloop query="getBatch">
		 
		<cfquery name="Lines"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *, 
			
			         (SELECT EntityClass 
					  FROM   Materials.dbo.ItemWarehouseLocationTransaction
					  WHERE  Warehouse = S.Warehouse
					  AND    Location  = S.Location
					  AND    ItemNo    = S.ItemNo
					  AND    UoM       = S.UoM
					  AND    TransactionType = '#url.tpe#') as EntityClass
					 
			FROM     Receipt#URL.Whs#_#SESSION.acc# S			
			WHERE    (TransferItemNo = ItemNo OR TransferItemNo IS NULL)			
			AND      TransferWarehouse = '#transferWarehouse#'
			AND      TransferLocation  = '#transferLocation#'	
			AND      TransferQuantity IS NOT NULL		
			AND		 TransferQuantity > 0
		</cfquery>		
		
		<cfif Lines.recordcount gte "1">
				
			<cftransaction>
			
				<cf_assignid>
				<cfset batchid = rowguid>
			
				<cfquery name="Insert" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO  WarehouseBatch
					   ( BatchId,
					     Mission,
					     Warehouse, 
						 BatchWarehouse,
						 Location,
					     BatchNo, 		
						 BatchClass,				
					     BatchDescription, 
					     TransactionDate,
					     TransactionType, 
					     OfficerUserId, 
					     OfficerLastName, 
					     OfficerFirstName )
				VALUES ('#batchid#',
				        '#url.mis#',
				        '#Lines.TransferWarehouse#', <!--- processing warehouse --->
						'#URL.Whs#',   <!--- originating warehouse --->
						'#Lines.TransferLocation#',
				        '#batchNo#',						
						'RctDistr',
						'Receipt Distribution',
						'#dateFormat(now(), client.dateSQL)#',
						'#url.tpe#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#')
				</cfquery>	
									
				<cfloop query="Lines">
					
					  <cf_verifyOperational 
				         datasource= "AppsMaterials"
				         module    = "Accounting" 
						 Warning   = "No">
				  
					  <cfif Operational eq "1"> 
					  
							<cfquery name="AccountStock"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
							    SELECT  GLAccount
								FROM    Ref_CategoryGLedger
								WHERE   Category = '#Category#' 
								AND     Area     = 'Stock'
							</cfquery>	
									
							<cfquery name="AccountTask"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
							    SELECT  GLAccount
								FROM    Ref_CategoryGLedger
								WHERE   Category = '#Category#' 
								AND     Area     = 'Variance'
							</cfquery>	
														
							<cfif AccountStock.recordcount lt "0" or AccountTask.Recordcount lt "0">
											
								<cf_alert message = "#msg1# #msg2#"
								  return = "no">
								  
								<cfabort>		
									 				
							</cfif>				
											
					   <cfset debit  = AccountStock.GLAccount>
					   <cfset credit = AccountTask.GLAccount>			 
					   
					   <cfset qty = -1*TransferQuantity>			   
					   
					   <cf_assignid>
					   
					   <!--- FROM location --->					   
					   				  				  
					   <cf_StockTransact 
					        TransactionId          = "#rowguid#"
						    DataSource             = "AppsMaterials" 
						    TransactionType        = "#url.tpe#"
							TransactionSource      = "WarehouseSeries"
							GLTransactionSourceId  = "#batchid#"
							ItemNo                 = "#ItemNo#" 
							Mission                = "#url.mis#" 
							Warehouse              = "#Warehouse#" 
							TransactionLot         = "#TransactionLot#"
							Location               = "#Location#"
							TransactionCurrency    = "#APPLICATION.BaseCurrency#"
							TransactionQuantity    = "#qty#"
							TransactionUoM         = "#UoM#"						
							ReceiptId              = "#ReceiptId#"
							TransactionDate        = "#dateFormat(now(), CLIENT.DateFormatShow)#"
							TransactionTimeZone    = "Yes"
							TransactionBatchNo     = "#batchno#"
							Remarks                = "#TransferMemo#"							
							Shipping               = "Yes"  							
							GLTransactionNo        = "#batchNo#"
							GLCurrency             = "#APPLICATION.BaseCurrency#"
							GLAccountDebit         = "#credit#"
							GLAccountCredit        = "#debit#">	
							
						 <!--- TO location --->	
							 
						 <cfif TransferItemNo neq "">
								<cfset ToItemNo = TransferItemNo>
								<cfset ToUoM    = TransferUoM>
						 <cfelse>
								<cfset ToItemNo = ItemNo>
								<cfset ToUoM    = UoM>		    
						 </cfif>	
							
					     <!---	TO location --->
							
					     <cf_StockTransact 
						    ParentTransactionId    = "#rowguid#"
						    DataSource             = "AppsMaterials" 
						    TransactionType        = "#url.tpe#"
							TransactionSource      = "WarehouseSeries"
							GLTransactionSourceId  = "#batchid#"
							ItemNo                 = "#ToItemNo#" 
							Mission                = "#url.mis#" 
							Warehouse              = "#TransferWarehouse#" 
							TransactionLot         = "#TransactionLot#"
							Location               = "#TransferLocation#"
							TransactionCurrency    = "#APPLICATION.BaseCurrency#"
							TransactionQuantity    = "#TransferQuantity#"
							TransactionUoM         = "#ToUoM#"											
							TransactionDate        = "#dateFormat(now(), CLIENT.DateFormatShow)#"
							TransactionTimeZone    = "Yes"
							TransactionBatchNo     = "#batchno#"
							Remarks                = "#TransferMemo#"
							GLTransactionNo        = "#batchNo#"
							GLCurrency             = "#APPLICATION.BaseCurrency#"
							GLAccountDebit         = "#debit#"
							GLAccountCredit        = "#credit#">	
							
							<!--- removed ReceiptId  = "#ReceiptId#" --->		
							
					  <cfelse>
					  	
							<cfset qty = -1*TransferQuantity>	
							
							<cf_assignid>
							
							 <!--- FROM location --->
						  
						   	<cf_StockTransact 
							    TransactionId          = "#rowguid#"
							    DataSource             = "AppsMaterials" 
							    TransactionType        = "#url.tpe#"
								TransactionSource      = "WarehouseSeries"
								GLTransactionSourceId  = "#batchid#"
								ItemNo                 = "#ItemNo#" 
								Mission                = "#url.mis#" 
								Warehouse              = "#Warehouse#" 
								TransactionLot         = "#TransactionLot#"
								Location               = "#Location#"
								TransactionCurrency    = "#APPLICATION.BaseCurrency#"
								TransactionQuantity    = "#qty#"
								TransactionUoM         = "#UnitOfMeasure#"							
								ReceiptId              = "#ReceiptId#"
								TransactionDate        = "#dateFormat(now(), CLIENT.DateFormatShow)#"
								TransactionTimeZone    = "Yes"
								TransactionBatchNo     = "#batchno#"
								Remarks                = "#TransferMemo#">	
								
							 <!--- TO location --->	
							 
							 <cfif TransferItemNo neq "">
							 		<cfset ToItemNo = TransferItemNo>
									<cfset ToUoM    = TransferUoM>
							 <cfelse>
							 		<cfset ToItemNo = ItemNo>
									<cfset ToUoM    = UnitOfmeasure>		    
							 </cfif>
								
							 <cf_StockTransact 
							    ParentTransactionId    = "#rowguid#"
							    DataSource             = "AppsMaterials" 
							    TransactionType        = "#url.tpe#"
								TransactionSource      = "WarehouseSeries"
								GLTransactionSourceId  = "#batchid#"
								ItemNo                 = "#ToItemNo#" 
								Mission                = "#url.mis#" 
								Warehouse              = "#TransferWarehouse#" 
								TransactionLot         = "#TransactionLot#"
								Location               = "#TransferLocation#"
								TransactionCurrency    = "#APPLICATION.BaseCurrency#"
								TransactionQuantity    = "#TransferQuantity#"
								TransactionUoM         = "#ToUoM#"
								TransactionCostPrice   = "#StandardCost#"											
								TransactionDate        = "#dateFormat(now(), CLIENT.DateFormatShow)#"
								TransactionTimeZone    = "Yes"
								TransactionBatchNo     = "#batchno#"
								Remarks                = "#TransferMemo#">		
								
								<!--- removed ReceiptId  = "#ReceiptId#" --->						
						
					  </cfif>
					  		
				</cfloop>	
				
			</cftransaction>
			
			<cfloop query="Lines">		
		
				<cfif entityclass neq "">
				
					  <cfquery name="get" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
						SELECT * 
						FROM   Item 
						WHERE  ItemNo = '#itemno#'
					  </cfquery>
								
				      <cfset link = "Warehouse/Application/Stock/Batch/BatchView.cfm?mission=#Warehouse.Mission#&batchno=#batchno#">
								
					  <cf_ActionListing 
						    EntityCode       = "WhsTransaction"
							EntityClass      = "#EntityClass#"
							EntityGroup      = ""
							EntityStatus     = ""
							Mission          = "#Mission#"															
							ObjectReference  = "#ActionType# #warehouse.warehousename#"
							ObjectReference2 = "#get.ItemDescription#" 											   
							ObjectKey4       = "#rowguid#"
							ObjectURL        = "#link#"
							Show             = "No">				
				
				</cfif>
			
			</cfloop>
		
		</cfif>
		
	</cfloop>	
	
</cfloop>

<cfquery name="resetTempTableSelection"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE 	Receipt#URL.Whs#_#SESSION.acc#
		SET		Selected = '0',
				TransferQuantity = Quantity
</cfquery>

<cf_tl id="Transfer has been submitted" var="1">
<cfset vMessage1 = "#lt_text#">
<cf_tl id="Stock on hand balances have been adjusted" var="1">
<cfset vMessage2 = "#lt_text#">

<cfoutput>
	
	<script language="JavaScript">
        alert('#vMessage1#. #vMessage2#.');
		document.getElementById('menu2').className = 'regular';
		document.getElementById('menu1').className = 'highlight';
		ptoken.navigate('#SESSION.root#/warehouse/application/stock/receipt/StockReceiptViewPending.cfm?mission=#url.mission#&warehouse=#url.warehouse#','contentbox1');
	</script>	
		
</cfoutput>


	