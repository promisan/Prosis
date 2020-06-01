
<cf_DropTable dbName="AppsTransaction"  tblName="tmpReceipt#URL.Warehouse#_#SESSION.acc#"> 

<cfparam name="client.programcode" default="">
<cfparam name="url.programcode"    default="#client.programcode#">

<cfset client.programcode = url.programcode>

<cftransaction>

	<!--- we take only receipt transaction which in this process wil be set to 0 
	with a negative receipt --->

	<cfquery name="getPendingReceipt"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		 SELECT *
		 INTO      userTransaction.dbo.tmpReceipt#URL.Warehouse#_#SESSION.acc#	
		 FROM (
		
			SELECT    T.ItemNo,
			          T.TransactionUoM,
					  T.TransactionLot,
			          T.Location,
			          T.ReceiptId, 
					  
					  <!--- correction to prevent that you ignore internal transfers from this location --->
					  
					  (SELECT SUM(ROUND(TransactionQuantity,2))
					   FROM   ItemTransaction
					   WHERE  Warehouse      = '#URL.Warehouse#'
					   AND    ItemNo         = T.ItemNo
					   AND    TransactionUoM = T.TransactionUoM
					   AND    Location       = T.Location
					   AND    TransactionLot = T.TransactionLot) as QuantityPending,
					   
					  (SELECT SUM(TransactionValue)
					   FROM   ItemTransaction
					   WHERE  Warehouse      = '#URL.Warehouse#'
					   AND    ItemNo         = T.ItemNo
					   AND    TransactionUoM = T.TransactionUoM
					   AND    Location       = T.Location
					   AND    TransactionLot = T.TransactionLot) as ValuePending							        
					  
				  
					  
			FROM      ItemTransaction T 			
			WHERE     T.Mission    = '#URL.Mission#' 	
			AND       T.Warehouse  = '#URL.Warehouse#'
				
			<!--- only take only receipt transactions --->
			AND       T.ReceiptId IN (SELECT ReceiptId 
			                          FROM   Purchase.dbo.PurchaseLineReceipt P 
									  WHERE  P.ReceiptId = T.ReceiptId)
			
			<!--- does not exist in the table yet 						  
			AND       T.ReceiptId NOT IN (SELECT Receiptid 
			                              FROM   userQuery.dbo.Receipt#URL.Warehouse#_#SESSION.acc# S
										  WHERE  S.ReceiptId = T.ReceiptId)	--->					  
									  
			<!--- from the designated receipt location 
			AND       T.Location = '#selloc#' 
			--->
				
			<!--- only take only receipt supply transactions --->
			AND       T.ItemNo IN (SELECT ItemNo 
			                       FROM   Item I
								   WHERE  I.ItemNo = T.ItemNo
								   AND    I.ItemClass = 'Supply'
								   <cfif url.programcode neq "">
								   AND    I.ProgramCode = '#url.programcode#' 
								   </cfif>
								   )
						
			GROUP BY  T.ItemNo,
			          T.TransactionUoM,
					  T.TransactionLot,
					  T.Location,
					  T.ReceiptId
					  
			) as D		  
						 
			WHERE  QuantityPending <> 0	
	  
	</cfquery>
	
	
	
	<!--- add new receipt records --->
	
	<cfquery name="insertreceipts"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO userTransaction.dbo.Receipt#URL.Warehouse#_#SESSION.acc#
			
					(Mission,
					 Warehouse,
					 TransactionLot,
					 Category,
					 CategoryDescription,
					 ItemNo,
					 ItemDescription,
					 ItemPrecision,
					 UoM,
					 UoMDescription,
					 ItemBarcode,
					 StandardCost,
					 ValuationCode,			 
					 ReceiptId,
					 ReceiptNo,
					 ReceiptDeliveryDateEnd,
					 Location,	
					 LocationDescription,		
					 Quantity,
					 Amount,
					 TransferQuantity,
					 Selected)
			
			SELECT    '#url.mission#',
			          '#url.warehouse#', 	
					  T.TransactionLot,          
					  I.Category,
					  C.Description,
					  I.ItemNo, 
					  I.ItemDescription, 
					  I.ItemPrecision,
					  T.TransactionUoM, 
					  U.UoMDescription,
					  U.ItemBarcode,
					  U.StandardCost, 
					  I.ValuationCode,			 
					  T.ReceiptId,
					  R.ReceiptNo,
					  R.DeliveryDateEnd,
					  T.Location,	
					  WL.Description,		 
					  T.QuantityPending, 
					  T.ValuePending,
					  T.QuantityPending,
					  '0'
			FROM      userTransaction.dbo.tmpReceipt#URL.Warehouse#_#SESSION.acc# T 
					  INNER JOIN Item I ON T.ItemNo = I.ItemNo 
					  INNER JOIN ItemUoM U 
					  	ON    T.ItemNo         = U.ItemNo 
						AND   T.TransactionUoM = U.UoM
					  INNER JOIN Ref_Category C
					    ON    I.Category      = C.Category
					  INNER JOIN WarehouseLocation WL
					    ON    WL.Warehouse = '#url.warehouse#'
						AND   T.Location     = WL.Location
					  INNER JOIN Purchase.dbo.PurchaseLineReceipt R
					    ON    T.ReceiptId = R.ReceiptId
			   
			WHERE     1=1
			
							
			<!---
			<cfif URL.Fnd neq "">
				AND   (I.ItemNo LIKE '%#URL.fnd#%' OR I.ItemDescription LIKE '%#URL.fnd#%')
			</cfif> 
			--->
				
			<!--- does not exist in the destination table yet --->						  
			AND       T.ReceiptId NOT IN (SELECT Receiptid 
			                              FROM   userTransaction.dbo.Receipt#URL.Warehouse#_#SESSION.acc# D
										  WHERE  D.ReceiptId = T.ReceiptId)						  
									  
			<!--- from the designated receipt location 
			AND       T.Location = '#selloc#' 
			--->
						  
	</cfquery>
	
	<!--- update records --->
	
	<cfquery name="updateReceipt"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			UPDATE userTransaction.dbo.Receipt#URL.Warehouse#_#SESSION.acc#
			SET    Quantity = T.QuantityPending,
			       Amount   = T.ValuePending
			FROM   userTransaction.dbo.Receipt#URL.Warehouse#_#SESSION.acc# D,
				   userTransaction.dbo.tmpReceipt#URL.Warehouse#_#SESSION.acc# T	   
			WHERE  D.Location       = T.Location
			AND    D.ItemNo         = T.ItemNo
			AND    D.UoM            = T.TransactionUoM
			AND    D.TransactionLot = T.TransactionLot
			AND    D.ReceiptId      = T.ReceiptId	
			
	</cfquery>
	
		
	<cfquery name="updateTransferQuantity"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			UPDATE userTransaction.dbo.Receipt#URL.Warehouse#_#SESSION.acc#
			SET    TransferQuantity = T.QuantityPending
			FROM   userTransaction.dbo.Receipt#URL.Warehouse#_#SESSION.acc# D,
				   userTransaction.dbo.tmpReceipt#URL.Warehouse#_#SESSION.acc# T	   
			WHERE  D.Location       = T.Location
			AND    D.ItemNo         = T.ItemNo
			AND    D.UoM            = T.TransactionUoM
			AND    D.TransactionLot = T.TransactionLot
			AND    D.ReceiptId      = T.ReceiptId	
			AND	   D.Selected		= '0'
			
	</cfquery>	
	
		
	<!--- clear receipts --->
	
	<cfquery name="deleterecords"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			DELETE  userTransaction.dbo.Receipt#URL.Warehouse#_#SESSION.acc#
			FROM    userTransaction.dbo.Receipt#URL.Warehouse#_#SESSION.acc# D
			WHERE   D.ReceiptId NOT IN (
			                            SELECT Receiptid 
			                            FROM   userTransaction.dbo.tmpReceipt#URL.Warehouse#_#SESSION.acc# S
									    WHERE  S.ReceiptId = D.ReceiptId
									   )	
									   	
	</cfquery>
		

</cftransaction>

<CF_DropTable dbName="AppsTransaction"  tblName="tmpReceipt#URL.Warehouse#_#SESSION.acc#">

	