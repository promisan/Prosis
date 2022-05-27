
<!--- wf script for posting receipts --->

<cfquery name="get" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	     	  
		 SELECT *
		 FROM   PurchaseLineReceipt
		 WHERE  ReceiptNo = '#Object.ObjectKeyValue1#'	
</cfquery>		
	
<cfset vReceiptNo = Replace(Object.ObjectKeyValue1,"-","","all")>

<cfquery name="Update" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     UPDATE PurchaseLineReceipt
		 SET    ActionStatus  = '1'
		 WHERE  ActionStatus  = '0'
		 AND    ReceiptNo     = '#Object.ObjectKeyValue1#'	
</cfquery>

<!--- record the receipt in warehouse module and make a GL booking as well --->

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
			        PL.PurchaseNo,
			        PL.Currency as PurchaseCurrency, 
					T.InvoiceWorkFlow,
					P.OrgUnitVendor,
					L.OrgUnit, 
					L.Mission,
					L.WorkOrderId
			 FROM   PurchaseLineReceipt R, 
			        PurchaseLine PL,
					Purchase P,
					Ref_OrderType T,
			        RequisitionLine L
			 WHERE  ReceiptNo       = '#Object.ObjectKeyValue1#'	
			 AND    R.RequisitionNo = PL.RequisitionNo 
			 AND    P.OrderType     = T.Code
			 AND    P.PurchaseNo    = PL.PurchaseNo
			 AND    R.RequisitionNo = L.RequisitionNo  
			 AND    R.ActionStatus != '9'
			 AND    PL.ActionStatus != '9'
			 
	</cfquery>	 
		
	<!--- ---------------------------------------------------------------------- --->
	<!--- define overhead costs in USD dollars as it can have several currencies --->
	<!--- ---------------------------------------------------------------------- --->
		
	<cfquery name="Overhead" 
		 datasource="AppsLedger" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 	 
		    SELECT    SUM(L.AmountBaseDebit-L.AmountBaseCredit) as Amount  <!--- define the amount to be activated into the receipt --->
	                 
		    FROM      TransactionHeader H INNER JOIN
	                  TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
	                  Ref_Account R ON L.GLAccount = R.GLAccount
					   
			WHERE     H.Mission              = '#Line.mission#'	
		    AND       H.TransactionSource    = 'ReceiptSeries'
		    AND       H.TransactionSourceNo  = '#Object.ObjectKeyValue1#'	
			AND       H.TransactionSourceId IS NULL <!--- cost reflected on the lines --->										
		    AND       H.ActionStatus        <> '9' 	
			AND       L.TransactionSerialNo != '0'  
			AND       R.TaxAccount           = '0'		
			
			<!--- we should also verify if the posting is indeed on the purchases account --->
					
   </cfquery>	
   
   <cfset overheadpercentage = "0">
   <cfset overheadvolrate    = "0">
   
   <cfif Overhead.Amount neq "">
     
   		<!-- we loop through the lines to get the total --->
		
		<cfset vol = 0>
		<cfset tot = 0>
		<cfset tpc = 0>
		
		<cfloop query = "line">		
												
			<cfquery name="Item" 
				   datasource="AppsPurchase" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   SELECT *
				   FROM   Materials.dbo.Item I, 
				          Materials.dbo.ItemUoM U
				   WHERE  I.ItemNo = U.ItemNo
				   AND    I.ItemNo  = '#WarehouseItemNo#'
				   AND    U.UoM     = '#WarehouseUoM#' 
			</cfquery>	
			
			<cfset vol = vol + ReceiptVolume>
			<cfset tpc = tpc + ReceiptAmountBaseCost>			
			
			<cfif Item.ValuationCode eq "Manual">	
			
				<cf_exchangeRate datasource="appsMaterials"
					EffectiveDate = "#dateFormat(Line.DeliveryDate, CLIENT.DateFormatShow)#"
			        CurrencyFrom  = "#APPLICATION.BASECURRENCY#"
					CurrencyTo    = "#APPLICATION.BASECURRENCY#"> 	 
							
				<cfquery name="ItemMission" 
				   datasource="AppsPurchase" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					   SELECT *
					   FROM   Materials.dbo.ItemUoMMission 
					   WHERE  ItemNo  = '#WarehouseItemNo#'
					   AND    UoM     = '#WarehouseUoM#'
					   AND    Mission = '#Mission#'
				</cfquery>
				
				<cfif ItemMission.StandardCost neq "">
					<cfset tot = tot + ((ItemMission.StandardCost/exc) * receiptwarehouse)>	
				<cfelse>									
					<cfset tot = tot + ((Item.StandardCost/exc) * receiptwarehouse)>	
				</cfif>							
		
            <cfelseif WarehouseCurrency neq currency and WarehousePrice neq "">
			
				<cf_exchangeRate datasource="appsMaterials"
					EffectiveDate    = "#dateFormat(Line.DeliveryDate, CLIENT.DateFormatShow)#"
			        CurrencyFrom     = "#WarehouseCurrency#"
					CurrencyTo       = "#Application.BaseCurrency#"> 	
										
				<cfset tot = tot + (warehouseprice/exc) * receiptwarehouse>									
			
			<cfelse>
			
				<cfset tot = tot + ReceiptAmountBaseCost>
				
			</cfif> 			
		
		</cfloop>
		
		<!--- we check if volume was supplied --->
		<cfif vol neq "0">   
	   	    <cfset overheadvolrate = Overhead.Amount / vol> <!--- rate per volume to be added ---> 
		</cfif>
		
	    <cfset overheadpercentage  = Overhead.Amount / tot>
		<cfset overheadpercprice   = Overhead.Amount / tpc>
						 		 	   
   </cfif>
   
   <!--- 
   
   		Routine to consume BOM materials and activate the costs as part of the received items.   

	   Hanno : This scenario is relevant if you outsource production, but provide the items to produce it with to be take from your stock, in that case
   when you receive the items the price will not contain the raw materials simply because you provide the raw materials for it which requires you to 
   activate them instead of consumption 
   
   --->	   
      
   <cfset singleResourceOrder = "0">
  
   <cfif get.WorkOrderId neq "">
	   
	   <cf_verifyOperational 
	    datasource = "AppsPurchase" 
	    module     = "WorkOrder" 
		Warning    = "No">
		
	  <cfif Operational eq "1">	
	  
	  	<!--- we check if the BOM items are not the same accross workorderitem lines otherwise
		we do not know what to deduct upon receipt of the workorderlineitem --->
		
		<cfset singleResourceOrder = "1">
		
	    <cfquery name="qBOMFinishedProducts" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			SELECT     WLI.WorkOrderItemId, 
			           WLIR.ResourceItemNo, 
					   WLIR.ResourceUoM, 
					   WLI.Quantity,
					   ROUND(WLI.Quantity / WLIR.Quantity, 3) AS Ratio
			FROM       WorkOrder.dbo.WorkOrderLineItem AS WLI INNER JOIN
                       WorkOrder.dbo.WorkOrderLineItemResource AS WLIR ON WLI.WorkOrderItemId = WLIR.WorkOrderItemId
			WHERE      WLI.WorkOrderId = '#get.WorkorderId#' 
			AND        WLI.WorkOrderLine = '#get.WorkorderLine#'	
					
		</cfquery>		

		<!---
		
		<cfloop query="qBOMFinishedProducts">
		
		<!--- cherck if the same resource exists under a different wokrorderline as well --->
		
		    <cfquery name="checkItem" dbtype="query">
				SELECT     *
				FROM       qBOMFinishedProducts	   
				WHERE      ResourceItemNo   = '#ResourceItemNo#'
				AND        ResourceUoM      = '#ResourceUoM#'
				AND        Ratio           != '#Ratio#'
				AND        WorkOrderItemId != '#workorderItemId#'
			</cfquery>
	
			<cfif checkItem.recordcount gte "1">
				<cfset singleResourceOrder = "0">
			</cfif>
				
		</cfloop>
		
		--->
	
		<cfquery name="getWo" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   WorkOrder.dbo.WorkOrder
				WHERE  WorkOrderId = '#get.WorkorderId#'
		</cfquery>
	
		<cfquery name="WorkLine" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     WorkOrderLine WL LEFT OUTER JOIN
	                     Ref_ServiceItemDomainClass R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code
				WHERE    WL.WorkOrderId   = '#get.WorkorderId#' 
				AND      WL.WorkOrderLine = '#get.WorkorderLine#'
		</cfquery>	
		
		<!--- no support for workorderline with more than 1 item to be sold for now at least the issue
		is if different items to be sold use the same BOM items we have a potential issuem so the first
		step is to check if different lines use different BOM items and then it will be fine. 
		
		--->
		<!--- activation ---->
		<cfset RawMatOverheadPerc 			= "0">
		<cfset RawMatOverheadPercPrice 		= "0">		
		
		<cfif SingleResourceOrder eq "1">
		
				<!--- 
	   
	 		   b. we check if it has earmarked stock  
			   c. we determine the pending for consumption
			   d. we apply the consumption but take its value to be added to the activation
	   
			       for overhead percentage
				   for overhead price 
	   
			   --->
		
				<!--- no we are going to define if the item received should tigger a consumption transaction hereto we			
				need to define the level of consumption needed and the earmarking for it
				
				ATTENTION: Ronmell, you need to test that once you consume the earmarking goes lower, i can't test that here)
				
				--->			
												
				<cfquery name="BOMItems" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT 		*  
									-- CONSUMED -> check the code as you need to add some conditions so it will be the same as for the interface 
									-- Ronmell: added the portion of the validation of the other conditions as from BOMStockOnHand
									
									,ABS(ISNULL((	SELECT SUM(TransactionQuantity) 
													FROM   Materials.dbo.ItemTransaction as IT1 
													WHERE  IT1.ItemNo 	        	= PostTable.ResourceItemNo 
													AND    IT1.TransactionUoM 	    = PostTable.ResourceUoM
													AND    IT1.WorkOrderId 	        = PostTable.WorkOrderId
													AND    IT1.WorkOrderLine 	    = PostTable.WorkOrderLine
													AND    IT1.TransactionType      = '2'
													AND    IT1.Warehouse		    = PostTable.Warehouse
													AND    IT1.Location		        = PostTable.Location
													AND    IT1.TransactionLot	    = PostTable.TransactionLot
													AND    IT1.TransactionReference = PostTable.TransactionReference
													<cfif WorkLine.PointerStock eq "1">									
									  				AND    IT1.RequirementId       = PostTable.ResourceId	
													<cfelse>				
									  				<!--- same item as required --->
									  					AND    IT1.ItemNo          = PostTable.ResourceItemNo 
						              					AND    IT1.TransactionUoM  = PostTable.ResourceUoM								 
													</cfif> 				
												),0)) as Consumed  <!--- determine already consumed for this workorder --->
	
									,ROUND((SELECT ISNULL(SUM(CalculatedConsumption),0) AS CalculatedConsumption
			                       			FROM    (SELECT   WL1.WorkOrderId, 
										                      WL1.WorkOrderLine, 
															  WLI1.WorkOrderItemId, 
															  WLI1.ItemNo, 
															  WLI1.UoM, 
															  WLI1.Quantity AS QuantityRequested,			
															  WLIR1.ResourceItemNo, 
															  WLIR1.ResourceUoM, 
					                	                      WLIR1.Quantity AS QuantityNeed,
					                    	                  (SELECT  ISNULL(SUM(TransactionQuantity), 0)
					                        	               FROM    Materials.dbo.ItemTransaction
					                            	           WHERE   RequirementId = PostTable.WorkOrderItemId 
															   AND     TransactionType NOT IN ('2','3')) / WLI1.Quantity * WLIR1.Quantity AS CalculatedConsumption	
															   	 
						                       		FROM  	WorkORder.dbo.WorkOrder W1 INNER JOIN
					    	                              	WorkORder.dbo.WorkOrderLine WL1 ON W1.WorkOrderId = WL1.WorkOrderId INNER JOIN
					                                      	WorkORder.dbo.WorkOrderLineItem WLI1 ON PostTable.WorkOrderId = WLI1.WorkOrderId 
														  	AND WL1.WorkOrderLine = WLI1.WorkOrderLine INNER JOIN
					                                      	WorkOrder.dbo.WorkOrderLineItemResource WLIR1 ON PostTable.WorkOrderItemId = WLIR1.WorkOrderItemId
					        	               		WHERE   WL1.WorkOrderId   = PostTable.WorkOrderId
											   		AND     WL1.WorkorderLine = PostTable.WorkOrderLine
											   	) as FP
									 		WHERE   FP.WorkorderId    = PostTable.WorkorderId
									    	AND     FP.WorkorderLine  = PostTable.WorkOrderLine
									    	AND     FP.ResourceItemNo = PostTable.ResourceItemNo
									    	AND     FP.ResourceUoM    = PostTable.ResourceUoM
											
								), ISNULL((SELECT ItemPrecision FROM MAterials.dbo.Item WHERE ItemNo = PostTable.ResourceItemNo),2)) as ConsRatio
								
								   <!--- detemine to-be calculated consumption based on the final items already received to get
								   a proper start situation --->
								
								
						FROM (	SELECT 	W.Mission, 
										WL.WorkOrderId,
							            WL.WorkOrderLine, 
										WLI.WorkOrderItemId,
										WLI.ItemNo,
										WLI.UoM, 
										WLI.Currency, 
										
										SUM(WLI.Quantity) as Quantity, 								
										
										WLR.ResourceItemNo, 
										
										WLR.Quantity 			as QtyRequired, 
										
										WLR.Price 				as ResourceItemPrice, 
										WLR.Amount, 
										WLR.ResourceId, 
										WLR.ResourceUoM, 
										PL.PurchaseNo,
										PLR.ReceiptNo,																
										PLR.DeliveryDate,
										PLR.ReceiptId, 
										PLR.Currency 			as ReceiptCurrency,
										PLR.ReceiptAmount,
										PLR.ReceiptQuantity,
										IT.Warehouse,
										IT.Location,
										IT.TransactionLot,
										IT.TransactionReference,		
										ISNULL(SUM(IT.TransactionQuantity),0) as Earmarked
										
							FROM 		WorkOrder.dbo.WorkOrder as W 
							            INNER JOIN WorkOrder.dbo.WorkOrderLine as WL          ON W.WorkOrderId     = WL.WorkorderId			
										<!--- single item workorder --->					
										INNER JOIN WorkOrder.dbo.WorkOrderLineItem as WLI     ON WLI.WorkOrderId   = W.WorkOrderId       AND WLI.WorkOrderLine = WL.WorkOrderLine										
										INNER JOIN WorkOrder.dbo.WorkOrderLineResource as WLR ON WLR.WorkOrderId   = WL.WorkOrderId      AND WLR.WorkOrderLine = WL.WorkOrderLine										
										INNER JOIN Purchase.dbo.PurchaseLineReceipt as PLR    ON PLR.RequirementId = WLI.WorkOrderItemId AND PLR.ReceiptNo  = '#Object.ObjectKeyValue1#'										
										INNER JOIN Purchase.dbo.PurchaseLine as PL            ON PL.RequisitionNo  = PLR.RequisitionNo
										INNER JOIN WorkOrder.dbo.WorkOrderLineItemResource as WLIR on WLIR.WorkOrderItemId = WLI.WorkOrderItemId
										INNER JOIN  Materials.dbo.Item I on WLIR.ResourceItemNo = I.ItemNo AND I.Category='MP'
										<!---
										INNER JOIN WorkOrder.dbo.WorkOrderLineItemResource as WLIR on WLIR.WorkOrderItemId = WLI.WorkOrderItemId AND WLI.ItemNo = PLR.ReceiptItemNo		
										AND WLIR.ResourceItemNo =  IT.ItemNo								
										--->
										INNER JOIN Materials.dbo.ItemTransaction as IT 
													ON  IT.ItemNo		    = WLR.ResourceItemNo 
													AND IT.TransactionUoM	= WLR.ResourceUoM
													AND	IT.WorkOrderId		= W.WorkOrderId
													AND IT.WorkOrderLine	= WL.WorkOrderLine
													AND	IT.RequirementId	= WLR.ResourceId
													
													AND    (
						     									(IT.ActionStatus   = '1' AND IT.TransactionType NOT IN ('2','8')) OR
						     									(IT.ActionStatus  IN ('0','1') AND IT.TransactionType IN ('2','8'))
																
						   								   )
															   
							GROUP BY 	W.Mission, 
								        WL.WorkOrderId,
								        WL.WorkOrderLine, 
										WLI.WorkOrderItemId,
										WLI.ItemNo,
										WLI.UoM, 
										WLI.Currency, 							
										WLR.ResourceItemNo, 
										WLR.Quantity, 
										WLR.Price, 
										WLR.Amount, 
										WLR.ResourceId, 
										WLR.ResourceUoM, 
										PL.PurchaseNo,
										PLR.ReceiptNo,																
										PLR.DeliveryDate,
										PLR.ReceiptId, 
										PLR.Currency,
										PLR.ReceiptAmount,
										PLR.ReceiptQuantity,
										IT.Warehouse,
										IT.Location,
										IT.TransactionLot,
										IT.TransactionReference
											
							) as PostTable  <!--- contains the earmarked quantities to be used for posting in conjunction with the already consumed stuff --->
							
				</cfquery>  
								<!--- b. we check if it has earmarked stock   --->
				<cfset notEarmarked ="no">
				
				<cfinclude template= "AutoConsumptionBatch.cfm">
				
				<!---- Getting Quantities and Required ---->
				
				<cfquery name = "qReceipts" dbtype="query">
					SELECT DISTINCT WorkOrderItemId,ResourceItemNo,ResourceUoM
					FROM BOMItems
				</cfquery>										
				
				<CF_DropTable dbName="AppsTransaction" 
	              tblName="BOMItemsDetails_#SESSION.acc#_#batchNo#_#vReceiptNo#"> 

				<cfquery name="CreateTable"
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				CREATE TABLE UserTransaction.dbo.BOMItemsDetails_#SESSION.acc#_#batchNo#_#vReceiptNo# (
				    ResourceItemNo varchar (20) NULL,
					ResourceUom varchar (10) NULL,
					QTYRequired float NULL,
					ReceiptQuantity float NULL) 
				</cfquery>						
				
				<cfloop query="qReceipts">
				
					<cfquery name="qFirstLine" dbtype="query">	
						SELECT  * 
						FROM BOMItems
						WHERE ResourceItemNo = '#qReceipts.ResourceItemNo#'
						AND ResourceUoM    = '#qReceipts.ResourceUoM#'
					</cfquery>					
				
					<cfquery name="qCheckSummary"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">					
						SELECT * 
						FROM   UserTransaction.dbo.BOMItemsDetails_#SESSION.acc#_#batchNo#_#vReceiptNo# 
						WHERE  ResourceItemNo = '#qReceipts.ResourceItemNo#'
						AND    ResourceUom    = '#qReceipts.ResourceUoM#'
					</cfquery>				
				
					<cfquery name="qRQuantity"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">						
						 SELECT SUM(PLR.ReceiptQuantity) Total
			             FROM   Purchase.dbo.PurchaseLineReceipt PLR
			             WHERE  PLR.RequisitionNo in (SELECT RequisitionNo from purchase.dbo.RequisitionLine RL where RL.WorkorderId =  '#get.WorkorderId#' ) 
			             AND    PLR.RequirementId = '#qReceipts.WorkOrderItemId#'
						 AND    PLR.ActionStatus != '9'
						 AND    PLR.receiptNo = '#Object.ObjectKeyValue1#'		
						 AND EXISTS ( SELECT 'X' 
									  FROM   WorkOrder.dbo.WorkOrderLineItemResource
									  WHERE  WorkOrderItemId = PLR.RequirementId
									  AND    ResourceItemNo    = '#qReceipts.ResourceItemNo#'
									  AND    ResourceUoM       = '#qReceipts.ResourceUoM#' )		
					</cfquery>
				
					<cfif qRQuantity.Total neq "">
					
						<cfif qCheckSummary.recordcount eq 0>
						
							<cfquery name="qInsertSummary"
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">					
								INSERT INTO UserTransaction.dbo.BOMItemsDetails_#SESSION.acc#_#batchNo#_#vReceiptNo# (ResourceItemNo,ResourceUom,QTYRequired,ReceiptQuantity)
								VALUES ('#qReceipts.ResourceItemNo#','#qReceipts.ResourceUoM#','#qFirstLine.QtyRequired#','#qRQuantity.Total#')
							</cfquery>
							
						<cfelse>
						
							<cfquery name="qInsertSummary"
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">					
								INSERT INTO UserTransaction.dbo.BOMItemsDetails_#SESSION.acc#_#batchNo#_#vReceiptNo# (ResourceItemNo,ResourceUom,QTYRequired,ReceiptQuantity)
								VALUES ('#qReceipts.ResourceItemNo#','#qReceipts.ResourceUoM#',0,'#qRQuantity.Total#')
							</cfquery>	
												
						</cfif>
						
					</cfif>
				
				</cfloop>
				
				<CF_DropTable dbName="AppsTransaction" 
	              tblName="BOMItems_#SESSION.acc#_#batchNo#_#vReceiptNo#"> 				
				
				<cfquery name="qCreateBomSummary"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">					
						SELECT   ResourceItemNo,
						         ResourceUoM,
								 SUM(QTYRequired) as QTYRequired, 
								 SUM(ReceiptQuantity) as ReceiptQuantity
						INTO     UserTransaction.dbo.BOMItems_#SESSION.acc#_#batchNo#_#vReceiptNo# 
						FROM     UserTransaction.dbo.BOMItemsDetails_#SESSION.acc#_#batchNo#_#vReceiptNo# 
						GROUP BY ResourceItemNo,ResourceUoM
					</cfquery>						
				
				<!---- Getting earmarked and consumed ---->
				
				<CF_DropTable dbName="AppsTransaction" 
	              tblName="Lot_#SESSION.acc#_#batchNo#_#vReceiptNo#"> 

				<cfquery name="CreateTable"
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				CREATE TABLE UserTransaction.dbo.Lot_#SESSION.acc#_#batchNo#_#vReceiptNo# (
							TransactionLot varchar(20),
						    ResourceItemNo varchar (20) NULL,
							ResourceUom varchar (10) NULL,
							Earmarked float NULL,
							Consumed float NULL) 
				</cfquery>			  
				
				<cfset vEarmarked = 0>
				<cfset vConsumed = 0>
				
				<cfquery name = "qLots" dbtype="query">
					SELECT DISTINCT TransactionLot,ResourceItemNo,ResourceUoM
					FROM BOMItems
				</cfquery>												
				
				<cfloop query="qLots">
				
					<cfquery name="qFirstLine"  dbtype="query">	
						SELECT  * 
						FROM    BOMItems
						WHERE   TransactionLot = '#qLots.TransactionLot#'
						AND     ResourceItemNo   = '#qLots.ResourceItemNo#'
						AND     ResourceUoM      = '#qLots.ResourceUoM#'
					</cfquery>					
				
					<cfquery name="qInsertSummary"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">					
						INSERT INTO UserTransaction.dbo.Lot_#SESSION.acc#_#batchNo#_#vReceiptNo# (TransactionLot,ResourceItemNo,ResourceUom,Earmarked,Consumed)
						VALUES ('#qLots.TransactionLot#','#qLots.ResourceItemNo#','#qLots.ResourceUom#','#qFirstLine.Earmarked#','#qFirstLine.Consumed#')
					</cfquery>				
				
				</cfloop>

				<!--- Starting calculation ---->
				
				<cfquery name="qCheckBOMItems"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				
					SELECT  ResourceItemNo, 
							ResourceUom, 
							SUM(QTYRequired) AS QTYRequired, 
							SUM(ReceiptQuantity) AS ReceiptQuantity 
					FROM UserTransaction.dbo.BOMItems_#SESSION.acc#_#batchNo#_#vReceiptNo#
					GROUP BY ResourceItemNo, ResourceUom
				</cfquery>				

				<CF_DropTable dbName="AppsTransaction" 
	              tblName="ReceiptPost_#SESSION.acc#_#batchNo#_#vReceiptNo#"> 

				<cfquery name="CreateTable"
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				CREATE TABLE UserTransaction.dbo.ReceiptPost_#SESSION.acc#_#batchNo#_#vReceiptNo# (
				    [ResourceItemNo] [varchar] (20) NULL,
					[ResourceUom] [varchar] (10) NULL,
					[QTYtoConsume] [float] NULL) 
				</cfquery>					

				<cfloop query="qCheckBOMItems">
					
					<cfquery name = "qRawMaterials" dbtype="query">
						SELECT SUM(Quantity) as Quantity
						FROM   qBOMFinishedProducts
						WHERE  ResourceItemNo = '#qCheckBOMItems.ResourceItemNo#'
			   			AND    ResourceUoM 	 = '#qCheckBOMItems.ResourceUom#'
					</cfquery>					
					
					<cfif qRawMaterials.Quantity neq "">				
				
						<cfset ConsFactor = qCheckBOMItems.QTYRequired*qCheckBOMItems.ReceiptQuantity/qRawMaterials.Quantity>					
	
						<cfquery name = "qLotSummary" 
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">						
							SELECT SUM(Earmarked) as Earmarked,
								   SUM(Consumed) as Consumed	
							FROM   UserTransaction.dbo.Lot_#SESSION.acc#_#batchNo#_#vReceiptNo#
							WHERE  ResourceItemNo = '#qCheckBOMItems.ResourceItemNo#'
				   			AND    ResourceUoM 	  = '#qCheckBOMItems.ResourceUom#'
						</cfquery>			
						
						<cfset QTYtoConsume =	0>
						<cfif (ConsFactor gt qLotSummary.Earmarked)>
							<cfset QTYtoConsume =	qLotSummary.Earmarked>
						<cfelse>
							<cfset QTYtoConsume =	ConsFactor>
						</cfif>								
	
						<cfif QTYtoConsume gt ( qLotSummary.Earmarked + qLotSummary.Consumed)>
							<cf_tl id="Not enough quantity was earmarked. Item: #qCheckBOMItems.ResourceItemNo#/#qCheckBOMItems.ResourceUom# Required: #QTYtoConsume# Earmarked: #qLotSummary.Earmarked#" var="1">
							<cf_message message = "#lt_text#">
							<cfabort>
						</cfif>						
					
						<cfquery name="qCheckInsert"
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
							SELECT * 
							FROM   UserTransaction.dbo.ReceiptPost_#SESSION.acc#_#batchNo#_#vReceiptNo#
							WHERE  ResourceItemNo = '#qCheckBOMItems.ResourceItemNo#'
				   			AND    ResourceUoM    = '#qCheckBOMItems.ResourceUom#'		
						</cfquery>				
	
						<cfif qCheckInsert.recordcount eq 0>
							<cfquery name="qInsert"
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">					
							INSERT INTO UserTransaction.dbo.ReceiptPost_#SESSION.acc#_#batchNo#_#vReceiptNo# (ResourceItemNo,ResourceUom,QTYtoConsume)
							VALUES ('#qCheckBOMItems.ResourceItemNo#','#qCheckBOMItems.ResourceUom#','#QTYtoConsume#')
							</cfquery>
						</cfif>		
					
					</cfif>	
					
				</cfloop>
				
				<!--- determining the overhead percentage on the items received that have BOM in it --->
				
				<!---- We do the issuance ---->
				<cfloop query="qLots">
				
					<cfquery name="qCheck" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">						
						SELECT * 
						FROM   UserTransaction.dbo.BOMItems_#SESSION.acc#_#batchNo#_#vReceiptNo#
						WHERE  ResourceItemNo = '#qLots.ResourceItemNo#'
						AND    ResourceUoM    = '#qLots.ResourceUom#'
					</cfquery>				
			
					<cfif qCheck.recordcount neq 0>
					
								<cfquery name="qDetails" dbtype="query" >
									SELECT * 
									FROM   BomItems
									WHERE  TransactionLot = '#qLots.TransactionLot#'
									AND    ResourceItemNo = '#qLots.ResourceItemNo#'
									AND    ResourceUoM    = '#qLots.ResourceUom#'
								</cfquery>			
			
								<cfquery name="qGetConsumption"
								datasource="AppsLedger" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">					
									SELECT QTYtoConsume 
									FROM   UserTransaction.dbo.ReceiptPost_#SESSION.acc#_#batchNo#_#vReceiptNo#
									WHERE  ResourceItemNo = '#qLots.ResourceItemNo#'
									AND    ResourceUoM    = '#qLots.ResourceUom#'
								</cfquery>				
																
								<cfquery name = "qGetSummary"
									datasource="AppsLedger" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">						
									SELECT SUM(Earmarked) as Earmarked,
										   SUM(Consumed) as Consumed	
									FROM   UserTransaction.dbo.Lot_#SESSION.acc#_#batchNo#_#vReceiptNo#
									WHERE  ResourceItemNo = '#qLots.ResourceItemNo#'
						   			AND    ResourceUoM 	 = '#qLots.ResourceUom#'
									AND    TransactionLot   = '#qLots.TransactionLot#'
								</cfquery>				
															
								<cfquery name="CreditAcc" 
								datasource="AppsPurchase" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT   * 
									FROM	 Materials.dbo.Ref_CategoryGledger as CAT 
									         INNER JOIN Materials.dbo.Item as I ON I.Category = CAT.Category
									WHERE    Area 		= 'Stock'
									AND      I.ItemNo 	= '#qLots.ResourceItemNo#'
								</cfquery>
								
								<cfquery name="DebitAcc" 
								datasource="AppsPurchase" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT   * 
									FROM	 Materials.dbo.Ref_CategoryGledger as CAT INNER JOIN Materials.dbo.Item as I ON I.Category = CAT.Category
									WHERE    Area 	  = 'COGS'
									AND      I.ItemNo = '#qLots.ResourceItemNo#'    
								</cfquery>
				
									<cfquery name="warehouseOrgUnit" 
									datasource="AppsPurchase" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT 	TOP 1 		ORG.*
										FROM 	Organization.dbo.Organization  as ORG INNER JOIN 
										        Materials.dbo.Warehouse as WA ON ORG.MissionOrgUnitId =  WA.MissionOrgUnitId
										WHERE   WA.Warehouse ='#qDetails.Warehouse#' 
									</cfquery>
									
									<!--- issue the stockTransaction --->
									<cfif qGetConsumption.QTYtoConsume gt qGetSummary.Earmarked>
										<cfset QTYtoConsume =	qGetSummary.Earmarked>						
									<cfelse>
										<cfset QTYtoConsume =	qGetConsumption.QTYtoConsume>						
									</cfif>
										
									<cfif QTYtoConsume neq "">
									
										<cfif QTYtoConsume neq 0 >
																									
												<cf_StockTransact 
										            DataSource                = "AppsPurchase" 
										            TransactionType           = "2" <!--- consumption --->
													TransactionSource         = "PurchaseSeries"
													ItemNo                    = "#qLots.ResourceItemNo#" 
													Warehouse                 = "#qDetails.Warehouse#" 
													Location                  = "#qDetails.Location#"
													Mission                   = "#qDetails.Mission#"
													TransactionUoM            = "#qLots.ResourceUoM#"
													TransactionCategory       = "Receipt"
													TransactionCurrency       = "#qDetails.Currency#"
													TransactionBatchNo		  = "#batchNo#"							
													TransactionQuantity       = "#QTYtoConsume * -1#"
													TransactionLot            = "#qDetails.TransactionLot#" 
													TransactionDate           = "#dateFormat(qDetails.DeliveryDate, CLIENT.DateFormatShow)#"
													TransactionReference      = "#qDetails.TransactionReference#"
													WorkOrderId               = "#qDetails.workorderid#"
													WorkOrderLine             = "#qDetails.workorderline#"
													RequirementId             = "#qDetails.ResourceId#"
													ReceiptCurrency           = "#qDetails.ReceiptCurrency#"     
													ReferenceId               = "#qDetails.WorkOrderItemId#"
													ActionStatus              = "1"   <!--- set status as cleared --->
													OrgUnit                   = "#warehouseOrgUnit.OrgUnit#"
													Remarks                   = "Receipt detail"
													GLTransactionNo           = "#qDetails.PurchaseNo#"
													GLTransactionSourceNo     = "#qDetails.ReceiptNo#"
													GLCurrency                = "#qDetails.Currency#"
													GLAccountDebit            = "#DebitAcc.GLAccount#"
													GLAccountCredit           = "#CreditAcc.GLAccount#">
													
													<cfquery name="qUpdate"
													datasource="AppsLedger" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">					
														UPDATE UserTransaction.dbo.ReceiptPost_#SESSION.acc#_#batchNo#_#vReceiptNo# 
														SET QTYtoConsume = QTYtoConsume - '#QTYtoConsume#'
														WHERE 
														 	ResourceItemNo = '#qLots.ResourceItemNo#'
															AND 
															ResourceUoM    = '#qLots.ResourceUom#'
													</cfquery>									
										</cfif>	
										</cfif>
										
							</cfif>				
					</cfloop>			
								
	
			<cfelse>
				<!----
				<cf_tl id="Please note that workorder items with BOM that is shared accross other items of the same workorder are not allowed, Please contact your administrator" var="1">
				<cf_message message = "#lt_text#">
				<cfabort>
				---->
			</cfif>
	
		<cfif SingleResourceOrder eq "1">
		
				<cfquery name="getOverHead" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			  		SELECT  SUM(TransactionValue) as BOMConsumption
					FROM    Materials.dbo.ItemTransaction
					WHERE   TransactionBatchNo = '#batchNo#'
				</cfquery>
				
				<cfif getOverHead.recordCount gte 1>
				    <cfif getOverHead.BOMConsumption neq "" and Get.ReceiptAmount neq "" >
						<cfset RawMatOverheadPercPrice = (getOverHead.BOMConsumption*-1)/Get.ReceiptAmount>
						<!--- activatation over the receipt price --->			
						<cfset overheadpercentage 	   = round(RawMatOverheadPercPrice * 1000)/1000>
					</cfif>
				</cfif>
			
				<cfset overheadPercPrice 		   = 0 > <!--- price didn't change, cost did --->
	    </cfif>
		
	  </cfif> <!--- operational --->
	
   </cfif>		
      
   <cfloop query="Line">
   
   		<!--- obtain added line costs like we do for DAI --->
		
		<cfquery name="relatedCost" 
		   datasource="AppsPurchase" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			SELECT    SUM(AmountCost/#ReceiptWarehouse#) AS Amount
			FROM      PurchaseLineReceiptCost
			WHERE     ReceiptId = '#ReceiptId#'
			
		</cfquery>
		
		<cfquery name="InsertAction" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     INSERT INTO ReceiptAction ( 
							  ReceiptId, 
							  ActionStatus, 
							  ActionDate, 
							  OfficerUserId, 
							  OfficerLastName, 
							  OfficerFirstName ) 			  
					 SELECT ReceiptId, 
					        '1', 
							'#DateFormat(Now(),CLIENT.dateSQL)#', 
							'#SESSION.acc#', 
							'#SESSION.last#', 
							'#SESSION.first#'
					 FROM   PurchaseLineReceipt
					 WHERE  ActionStatus = '0'
				     AND    ReceiptId = '#receiptid#'	
					 
			</cfquery>
		
		<cfif relatedCost.amount eq "">
		
			<cfset relcost = 0>
		<cfelse>
		
			<cfset relcost = relatedCost.Amount>
		
		</cfif>	
	
		<!--- check if item is a warehouse stock item and if we have quantity to be recorded --->
	
		<cfif WarehouseItemNo neq "" and WarehouseUoM neq "" and ReceiptWarehouse neq "0">
		
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
				
				<cfquery name="ItemMission" 
				   datasource="AppsPurchase" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   SELECT *
				   FROM   Materials.dbo.ItemUoMMission 
				   WHERE  ItemNo  = '#WarehouseItemNo#'
				   AND    UoM     = '#WarehouseUoM#'
				   AND    Mission = '#Mission#'
				</cfquery>
			
				<cfquery name="Item" 
				   datasource="AppsPurchase" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   SELECT *
				   FROM   Materials.dbo.Item I, 
				          Materials.dbo.ItemUoM U
				   WHERE  I.ItemNo = U.ItemNo
				   AND    I.ItemNo  = '#WarehouseItemNo#'
				   AND    U.UoM     = '#WarehouseUoM#'
				</cfquery>				
				
				<cfif Item.recordcount eq "0">
				
					 <cf_tl id="Problem Item/UoM does not exist" var="1">
					 <cf_message message = "#lt_text#">
					 <cfabort>
					 					
				<cfelse>								
									
					<!--- the transaction valuation is in principle the curr/price you paid --->		
					
					<!--- to be checked with RONMELL 206/2019 --->																														
					<!--- added as the new price is higher and also booked on the contra-account 
																									
					<cfif SingleResourceOrder eq "1">
					
						<cfif overheadpercentage eq "0">							
							<cfset cost = cost + relcost>							
						<cfelse>																		
					    	<cfset cost = cost + relcost + (cost * overheadpercentage)>																											
							<!--- add the cost of the added line cost which is set by line --->							
						</cfif>	
						
					</cfif>	
					
					--->
					
					<!--- the FOB price of the stock --->		
					<cfset stockcostprice = ReceiptAmountBaseCost/ReceiptWarehouse>		
											
					<!--- apply a different cost price in case of warehouse items --->										
																	
					<cfif Item.ValuationCode eq "Manual">	
					
					    <!--- activate only the standard costing here --->	
						<cfset curr = APPLICATION.BaseCurrency>	
						
						<cfif ItemMission.StandardCost neq "">
							<cfset cost = ItemMission.StandardCost>	
						<cfelse>									
							<cfset cost = Item.StandardCost>	
						</cfif>	
						
						<cfif overheadpercentage eq "0">	
							<cfset cost = cost + relcost>
						<cfelse>
						   <cfif overheadvolrate neq "0">
							    <!--- line receipt volumne * rate divided by stock items in receipt --->
							    <cfset volcharge = receiptvolume * overheadvolrate / receiptwarehouse> 
						        <cfset cost      = cost + relcost + volcharge>																								
							<cfelse>
							    <cfset cost    = cost + relcost + (cost * overheadpercentage)>												
							</cfif>			
						</cfif>		
																								
					<cfelseif WarehousePrice gt "0">					
																
						<!--- ------------------------------------------------------ --->			
						<!--- ---we have an overruling warehouse activation price--- --->
						<!--- ------------------------------------------------------ --->	
						
						<cfset curr = WarehouseCurrency>	
					    						
						<cfif curr eq APPLICATION.BaseCurrency>								
							<cfset cost = WarehousePrice>								
						<cfelseif Currency eq curr>						
							
							<!--- we take the exchange rate found in the receipt --->						
							<cfset cost = warehousePrice / ExchangeRate>		
											
						<cfelse>
												
							<cf_exchangeRate datasource="appsMaterials"
							EffectiveDate = "#dateFormat(Line.DeliveryDate, CLIENT.DateFormatShow)#"
					        CurrencyFrom  = "#curr#"
							CurrencyTo    = "#APPLICATION.BaseCurrency#"> 		
							
						    <cfset cost = warehousePrice / exc>
							
						</cfif>	
																		
						<cfif overheadpercentage eq "0">	
							<cfset cost = cost + relcost>							
						<cfelse>
						
						 	<cfif overheadvolrate neq "0">
							    <!--- line receipt volumne * rate divided by stock items in receipt --->
							    <cfset volcharge = receiptvolume * overheadvolrate / receiptwarehouse> 
						        <cfset cost      = cost + relcost + volcharge>	
								<!---							
								<cfoutput>i:#line.WarehouseItemNo#--v:#receiptvolume#-r:-#overheadvolrate#--w:--#receiptwarehouse#=====#volcharge#</cfoutput>								
								--->
							<cfelse>
							    <cfset cost    = cost + relcost + (cost * overheadpercentage)>												
							</cfif>				
						   											
						</cfif>	
						
					<cfelse>
					
						<cfset curr  = currency>		
					
						<!--- the price of stock as it will be activated per item --->										
						<cfset stockcostprice = ReceiptAmountBaseCost/ReceiptWarehouse>												
						<cfset cost = stockcostprice>						
																						
						<cfif overheadpercentage eq "0">						
							<cfset cost = cost + relcost>						
						<cfelse>									
						    <cfif overheadvolrate neq "0">
							    <!--- line receipt volumne * rate divided by stock items in receipt --->
							    <cfset volcharge = receiptvolume * overheadvolrate / receiptwarehouse> 
						        <cfset cost      = cost + relcost + volcharge>													
								
							<cfelse>
							    <cfset cost    = cost + relcost + (cost * overheadpercentage)>												
							</cfif>	
						</cfif>							
																																														
					</cfif>											

					<cfset cost  = round(cost*10000)/10000>										
					<cfset price = ReceiptAmountCost/ReceiptWarehouse>
					
					<!--- express receipt price in the currency of the stock cost 
					   which can be different via line 251 or 268  --->			
					
					<cfif APPLICATION.BaseCurrency neq currency and exchangerate neq "">
					
							<cfset price    =  price / exchangerate>	
					
					<cfelseif APPLICATION.BaseCurrency neq currency>
					
							<cf_exchangeRate datasource="appsMaterials"
								EffectiveDate = "#dateFormat(Line.DeliveryDate, CLIENT.DateFormatShow)#"
						        CurrencyFrom  = "#currency#"
								CurrencyTo    = "#APPLICATION.BaseCurrency#"> 		
					
							<cfset price    =  price / exc>								
							
					<cfelse>
					
							<cfset price    = price>		
					
					</cfif> 	
					
					<cfif overheadpercentage eq "0">	
						<cfset price = price + relcost>
					<cfelse>
					
						 <cfif overheadvolrate neq "0">
						    <!--- line receipt volumne * rate divided by stock items in receipt --->
						    <cfset volcharge = receiptvolume * overheadvolrate / receiptwarehouse> 
						    <cfset price   = price + relcost + volcharge>
						<cfelse>
						    <cfset price   = price + relcost + (price * overheadpercentage)>												
						</cfif>		
					   					
					</cfif>															
										
					<!--- check if the receipt has changed in item, uom, warehouse lot, quantity or value otherwise 
					  no action will be taken --->
					
					<cfquery name="getTransaction" 
					   datasource="AppsPurchase" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					   				   
					    SELECT     Warehouse,
						           TransactionLot, 
								   ItemNo, 
								   TransactionUoM, 
								   TransactionCostPrice, 
								   ReceiptCostPrice, 
								   ROUND(SUM(TransactionQuantity), 3) AS Quantity,
								   count(*) as Lines
								   
						FROM       Materials.dbo.ItemTransaction
						
					    WHERE      ReceiptId = '#ReceiptId#'
						
						GROUP BY   TransactionLot,
						           ItemNo, 
								   TransactionUoM, 
								   Warehouse, 
								   ReceiptCostPrice, 
								   TransactionCostPrice
				      
				    </cfquery>		
										
					<!--- base currency compare --->
				    <cfset cst = ReceiptAmountBaseCost/ReceiptWarehouse>											   
																								
					<cfif getTransaction.Quantity         			 neq ReceiptWarehouse 					   
						   or getTransaction.TransactionLot          neq TransactionLot
						   or getTransaction.ItemNo                  neq WarehouseItemNo
						   
						   <!--- calculated cost price is different from the past cost value price --->
						   or abs(getTransaction.TransactionCostPrice-stockcostprice) gte 0.00
						   
						   or getTransaction.TransactionUoM          neq WarehouseUoM 
						   or getTransaction.Warehouse               neq Warehouse>		
						   
						<!--- check if the receipt has been sourced already --->   					 	  		 
					
						<cfquery name="getIssues" 
						   datasource="AppsPurchase" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						  
						   SELECT * 
						   FROM   Materials.dbo.ItemTransactionValuation V
						   WHERE  TransactionId IN (SELECT TransactionId 
						                            FROM   Materials.dbo.ItemTransaction 
												    WHERE  TransactionId = V.TransactionId
						  						    AND    ReceiptId  = '#ReceiptId#')
													
						   AND    DistributionTransactionId NOT IN 
						                     	   (SELECT TransactionId 
						                            FROM    Materials.dbo.ItemTransaction 
												    WHERE   TransactionId = V.DistributionTransactionId
						  						    AND     ReceiptId  = '#ReceiptId#')		
																	  						    
						  						    					   
						</cfquery>						
						
						<cfif getIssues.recordcount gte "1">
												
						    <!--- receipt was sourced now check if new record has a higher quantity 
										or different price --->
										
							<cfif getTransaction.TransactionLot        neq TransactionLot
								  or getTransaction.ItemNo             neq WarehouseItemNo								  								   
								  or getTransaction.TransactionUoM     neq WarehouseUoM 
								  or getTransaction.Warehouse          neq Warehouse
								  or getTransaction.Quantity           gt ReceiptWarehouse>					
								  
								<cf_message message = "This receipt may no longer be posted as it has been partially consumed. <br>Please contact your administrator (1)" return="No">						 						 
								<cfabort>
						
							<cfelseif (abs(getTransaction.TransactionCostPrice-stockcostprice) gte 0.00 
							           and getTransaction.Quantity eq ReceiptWarehouse)>	
																												
								 <cfinvoke component = "Service.Process.Materials.Stock"  
									   method              = "correctItemValuation" 
									   receiptid           = "#ReceiptId#"
									   receiptCostCurrency = "#APPLICATION.BaseCurrency#"
									   receiptCostPrice    = "#cost#"								   								  
									   receiptCurrency     = "#curr#"									   
									   receiptPrice        = "#price#"
									   GLCurrency          = "#Line.PurchaseCurrency#">		
								
								 <!---
								 apply a correction and let it go
								 <cf_message message = "#ReceiptId# -----#stockcostprice# #cost#---- #getTransaction.TransactionCostPrice# - #stockcostprice#" return="No">						 						 									   
								 <cfabort>					
								 --->
								   
							<cfelseif (abs(getTransaction.TransactionCostPrice-stockcostprice) gte 0.00 
							        and getTransaction.Quantity lt ReceiptWarehouse 
									and getTransaction.Lines eq "1")>	
									
								 <cfinvoke component = "Service.Process.Materials.Stock"  
									   method              = "correctItemValuation" 
									   receiptid           = "#ReceiptId#"		
									   receiptCostCurrency = "#APPLICATION.BaseCurrency#"	
									   receiptCostPrice    = "#cost#"					   								  
									   receiptCurrency     = "#curr#"									   
									   receiptPrice        = "#price#"
									   GLCurrency          = "#Line.PurchaseCurrency#">											 
								
								   <!--- 	
								   apply a correction and let it go  
								   <cfabort>
								   --->
								   
							 <cfelse>							 
								  
							 	  <cf_message message = "This receipt may no longer be posted as it has been partially consumed. <br>Please contact your administrator (2)" return="No">						 						 
								   <cfabort>							 
							 
							 </cfif>	   	   							        
							     							
						<cfelse>							
																									
							<cfquery name="getListToClear" 
							   datasource="AppsPurchase" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
							   SELECT   TransactionId FROM Materials.dbo.ItemTransaction 
							   WHERE    ReceiptId  = '#ReceiptId#'
							</cfquery>
							
							<cfloop query="getListToClear">
							
								<!--- this will also remove the financials transactions / ledger --->
					    								
								<cfquery name="ClearPriorReceiptEntry" 
								   datasource="AppsPurchase" 
								   username="#SESSION.login#" 
								   password="#SESSION.dbpw#">
								   DELETE FROM Materials.dbo.ItemTransaction 
								   WHERE  TransactionId  = '#TransactionId#'
								</cfquery>
							
							</cfloop>
											
							<cfquery name="GLStock" 
							   datasource="AppsPurchase" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
								   SELECT * 
								   FROM   Materials.dbo.Ref_CategoryGLedger R
								   WHERE  Area     = 'Stock'
								   AND    Category = '#Item.Category#'
								   AND    GLAccount IN (SELECT GLAccount 
								                        FROM   Accounting.dbo.Ref_Account 
														WHERE  GLAccount = R.GLAccount)
							</cfquery>					
							
							<cf_verifyOperational 
							    datasource = "AppsPurchase" 
							    module     = "Accounting" 
								Warning    = "No">
							
							<cfif GLStock.recordcount eq "0" and operational eq "1">
							    
							  	 <cf_message message = "Stock account for #Item.Category# does not exist">
								 <cfabort>
							
							</cfif>												
							
							<cfquery name="GLCOGS" 
							   datasource="AppsPurchase" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
							   SELECT * 
							   FROM   Materials.dbo.Ref_CategoryGLedger R
							   WHERE  Area     = 'COGS'
							   AND    Category = '#Item.Category#'
							   AND    GLAccount IN (SELECT GLAccount 
							                        FROM   Accounting.dbo.Ref_Account 
													WHERE  GLAccount = R.GLAccount)
							</cfquery>
							
							<cf_verifyOperational 
							    datasource = "AppsPurchase" 
							    module     = "Accounting" 
								Warning    = "No">
							
							<cfif GLCOGS.recordcount eq "0" and operational eq "1">
							    
							  	 <cf_message message = "COGS GL account for Item category #Item.Category# was not set">
								 <cfabort>
							
							</cfif>			
							
							<cfquery name="GLPrice" 
							   datasource="AppsPurchase" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
							   SELECT * 
							   FROM   Materials.dbo.Ref_CategoryGLedger R
							   WHERE  Area     = 'PriceChange'
							   AND    Category = '#Item.Category#'
							   AND    GLAccount IN (SELECT GLAccount 
							                        FROM   Accounting.dbo.Ref_Account 
													WHERE  GLAccount = R.GLAccount)
							</cfquery>
							
							<cfif GLPrice.recordcount eq "0" and operational eq "1">
							    
							  	 <cf_message message = "-Price change- GL account for #Item.Category# does not exist">
								 <cfabort>
							
							</cfif>		
							
							<!--- 
							
							Hanno amended 27/12/2013 to allow receipts without invoicing, like an internal generation, 
							which means that instead of the	contra-booking for purchases and invoice matching we book the receipt against the manufactorung
							account and/or check if the requisition is for a workorder which has a manufacturing account
							defined in that case we take this one (Hicosa)
																	
							--->
							
							<cfif InvoiceWorkFlow neq "9">
							
								<cfquery name="GLReceipt" 
								   datasource="AppsPurchase" 
								   username="#SESSION.login#" 
								   password="#SESSION.dbpw#">
								     SELECT * 
								     FROM   Materials.dbo.Ref_CategoryGLedger R
								     WHERE  Area     = 'Receipt'
								     AND    Category = '#Item.Category#'
								     AND    GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account WHERE GLAccount = R.GLAccount)
								</cfquery>
								
								<cfif GLReceipt.recordcount eq "0" and operational eq "1">
							    
							  	 <cf_message message = "Accounts Payable Contra-account for #Item.Category# does not exist">
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
									     WHERE  Area        = 'Production'
									     AND    WorkOrderId = '#workorderid#'
									     AND    GLAccount IN (SELECT GLAccount 
										                      FROM   Accounting.dbo.Ref_Account 
															  WHERE  GLAccount = R.GLAccount)
									</cfquery>						
								
								<cfelse>
							
									<cfquery name="GLReceipt" 
									   datasource="AppsPurchase" 
									   username="#SESSION.login#" 
									   password="#SESSION.dbpw#">
									     SELECT * 
									     FROM   Materials.dbo.Ref_CategoryGLedger R
									     WHERE  Area      = 'Receipt'
									     AND    Category  = '#Item.Category#'
									     AND    GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account WHERE GLAccount = R.GLAccount)
									</cfquery>
								
								</cfif>
								
								<cfif GLReceipt.recordcount eq "0" and operational eq "1">
							    
								  	 <cf_message message = "Accounts Payable Contra-account for #Item.Category# does not exist">
									 <cfabort>
							
								</cfif>							
							
							</cfif>								
							
							<!--- capture contra account - inkopen/purchases --->
							
							<cfquery name="ReceiptContraAccount" 
						     datasource="AppsPurchase" 
				    		 username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
				    		 	UPDATE PurchaseLineReceipt
								SET    GLAccountReceipt = '#GLReceipt.GLAccount#' 
								WHERE  ReceiptId        = '#ReceiptId#'	
							</cfquery>																	
							
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
								
								<cfset taskreq  = Task.RequestId>
								<cfset taskser  = Task.TaskSerialNo>					
							
							<cfelse>
							
								<cfset taskreq  = "">
								<cfset taskser  = "">
													
							</cfif>
							
							<cfset cost = round(cost*1000)/1000>
												
											
							<!--- check if we have detailed receipts --->
							
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
								
								<!--- we create the lot --->
														
								<cfinvoke component = "Service.Process.Materials.Lot"  
									  method                 = "addlot" 
									  datasource             = "AppsPurchase"
									  mission                = "#Line.Mission#" 
									  transactionlot         = "#Line.TransactionLot#"
									  TransactionLotDate     = "#dateFormat(now(), CLIENT.DateFormatShow)#"
									  OrgUnitVendor          = "#Line.OrgUnitVendor#"
									  returnvariable         = "result">						
															
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
											TransactionCurrency       = "#APPLICATION.BaseCurrency#"
											TransactionCostPrice      = "#cost#"							
											TransactionQuantity       = "#QuantityAccepted#"
											TransactionLot            = "#Line.TransactionLot#" 
											TransactionDate           = "#dateFormat(Line.DeliveryDate, CLIENT.DateFormatShow)#"
											TransactionReference      = "#ContainerName#"
											TransactionId             = "#TransactionId#"
											ReceiptId                 = "#Line.Receiptid#"
											WorkOrderId               = "#Line.workorderid#"
											WorkOrderLine             = "#Line.workorderline#"
											RequirementId             = "#Line.RequirementId#"
											RequestId                 = "#taskreq#"
											TaskSerialNo              = "#taskser#"
											ReceiptCurrency           = "#APPLICATION.BaseCurrency#"     <!--- "#Line.currency#" 27/10/2016 --->
											ReceiptCostPrice          = "#stockcostprice#"											
											ReceiptPrice              = "#price#"
											ReferenceId               = "#Line.ReceiptId#"
											ActionStatus              = "1"   <!--- set status as cleared --->
											OrgUnit                   = "#Line.OrgUnit#"
											Remarks                   = "Receipt detail #ReceiptLineNo# #ContainerName#"
											GLTransactionNo           = "#Line.PurchaseNo#"
											GLTransactionSourceNo     = "#Line.ReceiptNo#"
											GLCurrency                = "#APPLICATION.BaseCurrency#"
											GLAccountDebit            = "#GLStock.GLAccount#"
											GLAccountDiff             = "#GLPrice.GLAccount#"
											GLAccountCredit           = "#GLReceipt.GLAccount#">	
											
											<!--- we set the sale price if the item has no prices set for 
											the warehouse of this entity --->
											
											<cfinvoke component = "Service.Process.Materials.Item"  
											   method           = "createItemUoMPrice" 
											   mission          = "#Line.Mission#" 
											   ItemNo           = "#Line.WarehouseItemNo#" 
											   UoM              = "#Line.WarehouseUoM#"
											   DateEffective    = "#dateFormat(Line.DeliveryDate, CLIENT.DateFormatShow)#"
											   Cost             = "#cost#"									   
											   datasource       = "AppsPurchase">	 							  
									  
										  <cfif checkloc.Distribution eq "8">						  
										  
										      <!--- direct issuance of the stock to the location as defined by the storage location --->								
										  
											  <cf_StockTransact 
									            DataSource            = "AppsPurchase" 
									            TransactionType       = "2"
												TransactionSource     = "PurchaseSeries"
												ItemNo                = "#Line.WarehouseItemNo#" 
												Warehouse             = "#whs#" 
												Location              = "#loc#"
												Mission               = "#Line.Mission#"
												AssetId               = "#checkloc.assetid#"
												TransactionUoM        = "#Line.WarehouseUoM#"
												TransactionCategory   = "Receipt"
												TransactionCurrency   = "#curr#"
												TransactionCostPrice  = "#cost#"							
												TransactionQuantity   = "#-QuantityAccepted#"
												TransactionLot        = "#Line.TransactionLot#" 
												TransactionDate       = "#dateFormat(Line.DeliveryDate, CLIENT.DateFormatShow)#"
												ReceiptId             = "#Line.Receiptid#"
												WorkOrderId           = "#Line.workorderid#"
												WorkOrderLine         = "#Line.workorderline#"
												RequirementId         = "#Line.RequirementId#"
												RequestId             = "#taskreq#"
												TaskSerialNo          = "#taskser#"									
												ActionStatus          = "1"  <!--- set status as cleared --->
												OrgUnit               = "#Line.OrgUnit#"
												Remarks               = "Direct Issue detail #ReceiptLineNo# #ContainerName#"
												GLTransactionNo       = "#Line.PurchaseNo#"
												GLTransactionSourceNo = "#Line.ReceiptNo#"
												GLCurrency            = "#APPLICATION.BaseCurrency#"
												GLAccountDebit        = "#GLCOGS.GLAccount#"
												GLAccountDiff         = "#GLPrice.GLAccount#"
												GLAccountCredit       = "#GLStock.GLAccount#">		
										  
										  </cfif>								  
									 													
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
									TransactionCurrency   = "#APPLICATION.BaseCurrency#"
									TransactionCostPrice  = "#cost#"							
									TransactionQuantity   = "#ReceiptWarehouse#"
									TransactionLot        = "#TransactionLot#" 
									TransactionDate       = "#dateFormat(Line.DeliveryDate, CLIENT.DateFormatShow)#"
									ReceiptId             = "#ReceiptId#"
									WorkOrderId           = "#workorderid#"
									WorkOrderLine         = "#workorderline#"
									RequirementId         = "#RequirementId#"
									RequestId             = "#taskreq#"
									TaskSerialNo          = "#taskser#"
									ReceiptCurrency       = "#APPLICATION.BaseCurrency#"
									ReceiptCostPrice      = "#stockcostprice#"									
									ReceiptPrice          = "#price#"
									ReferenceId           = "#ReceiptId#"
									GLTransactionSourceNo = "#Line.ReceiptNo#"
									ActionStatus          = "1"
									OrgUnit               = "#OrgUnit#"
									Remarks               = "Receipt"
									GLTransactionNo       = "#Line.PurchaseNo#"
									GLCurrency            = "#APPLICATION.BaseCurrency#"
									GLAccountDebit        = "#GLStock.GLAccount#"
									GLAccountDiff         = "#GLPrice.GLAccount#"
									GLAccountCredit       = "#GLReceipt.GLAccount#">
									
									<!--- we set the sale price if the item has no prices set for 
									the warehouse of this entity --->				
									
									<cfinvoke component = "Service.Process.Materials.Item"  
									   method           = "createItemUoMPrice" 
									   mission          = "#Mission#" 
									   ItemNo           = "#WarehouseItemNo#" 
									   UoM              = "#WarehouseUoM#"
									   DateEffective    = "#dateFormat(Line.DeliveryDate, CLIENT.DateFormatShow)#"
									   Cost             = "#cost#"									   
									   datasource       = "AppsPurchase">	
									
															
							</cfif>	
							
							<cfif taskreq neq "">
								<cf_setRequestStatus requestid="#taskreq#">				
							</cfif>
							
						</cfif>
				
				     </cfif>
				
				</cfif>
					
		<cfelse>					
		
			<!--- --------------------------------------------------------------------------- --->
			<!--- no warehouse and GL transaction, just book cost upon posting of the invoice --->
			<!--- --------------------------------------------------------------------------- --->
					
		</cfif>
			
   </cfloop>	
	
</cfif>		

<script>
	parent.history.go()	
</script>


