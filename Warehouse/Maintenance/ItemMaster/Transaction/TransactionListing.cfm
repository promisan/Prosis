
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#_ItemTransaction_item"> 

<cfoutput>
	<cfsavecontent variable="data">
					
		SELECT 'Active' as ClassMode,*
		FROM  ItemTransaction TD
		WHERE      TD.Mission    = '#URL.Mission#'	
		AND        TD.ItemNo     = '#URL.ItemNo#'  
		UNION
		SELECT 'Denied',*
		FROM  ItemTransactionDeny TD
		WHERE      TD.Mission    = '#URL.Mission#'	
		AND        TD.ItemNo     = '#URL.ItemNo#'  		
				
 	</cfsavecontent>
</cfoutput>	
		
	
<cfoutput>
	<cfsavecontent variable="sqlbody">	
		
		FROM       (#preservesinglequotes(data)#) as T 
		           INNER JOIN Warehouse W ON T.Warehouse = W.Warehouse 
				   INNER JOIN WarehouseLocation L ON T.Warehouse = L.Warehouse AND T.Location = L.Location 
				   INNER JOIN Ref_TransactionType R ON T.TransactionType = R.TransactionType 
				   INNER JOIN ItemUoM I ON T.ItemNo = I.ItemNo AND T.TransactionUoM = I.UoM 
				   LEFT OUTER JOIN WarehouseBatch B ON T.TransactionBatchNo = B.BatchNo	
	
    </cfsavecontent>
</cfoutput>

<cfset url.webapp = "backoffice">
		
<!--- get the records to be shown by saving them in a temp table for showing --->
	
<cfquery name="SearchResult"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT     T.TransactionId, 
	           T.ClassMode,
	           T.Mission, 
			   T.Warehouse, 
			   W.WarehouseName,
			   L.Description as LocationDescription,
			   T.TransactionType, 
			   B.BatchClass,
			   B.ActionStatus as BatchStatus,
			   
			   (SELECT Description FROM Ref_WarehouseBatchClass WHERE Code = B.BatchClass) as BatchClassName,
			   
			   R.Description, 
			   T.TransactionDate, 
			   T.ItemNo, 
			   T.ItemDescription, 
			   T.ItemCategory, 
			   T.ItemPrecision,
               T.Location, 
			   T.TransactionQuantity, 
			   T.TransactionUoM, 
			   I.UOMDescription, 
			   T.TransactionUoMMultiplier, 
			   T.TransactionQuantityBase, 
			   T.TransactionCostPrice, 
               T.TransactionValue, 
			   T.ReceiptId, 	
			   
			   ( SELECT PurchaseNo 
			     FROM   Purchase.dbo.PurchaseLine sp, Purchase.dbo.PurchaseLineReceipt sM
				 WHERE  ReceiptId = T.ReceiptId
				 AND    sM.RequisitionNo = sP.RequisitionNo ) as PurchaseNo,  
			   
			   T.TransactionBatchNo, 
			   
			   <!--- Hanno, provision to support a more custom on-th-fly presentation 18/10/2016
			   based on the class we can code different values for the reference here over
			   time  --->
			   
			   <cf_verifyOperational module="Workorder">	 

			   <cfif ModuleEnabled eq "1">	 
			   
			   (CASE WHEN (SELECT BatchClass
						   FROM   WarehouseBatch
						   WHERE  BatchNo = T.TransactionBatchNo) = 'WOMedical' 
						   
				     THEN (SELECT CustomerName
					       FROM   WorkOrder.dbo.WorkOrder sW INNER JOIN WorkOrder.dbo.Customer sC ON SW.CustomerId = SC.CustomerId
						   WHERE  WorkOrderId = T.WorkOrderid)
							
				     WHEN (SELECT BatchClass
						   FROM   WarehouseBatch
						   WHERE  BatchNo = T.TransactionBatchNo) = '' 
						   
				     THEN (SELECT CustomerName
					        FROM   WorkOrder.dbo.WorkOrder sW INNER JOIN WorkOrder.dbo.Customer sC ON SW.CustomerId = SC.CustomerId
							WHERE  WorkOrderId = T.WorkOrderid)		
					   
					  ELSE '' END) as TransactionReference,		
					  
			   <cfelse>
				
					'' as TransactionReference,
				
				</cfif>		
			 
			         			   
			   T.RequestId, 
			   T.WorkOrderId,
			   T.WorkOrderLine,
			   T.OrgUnit, 
			   T.OrgUnitCode, 
			   T.OrgUnitName, 
			   T.Remarks, 
			   T.ActionStatus,
			   T.GLAccountDebit,  
               T.GLAccountCredit,
               T.OfficerLastName AS Officer,
			   T.Created
	INTO userquery.dbo.#SESSION.acc#_ItemTransaction_item		   
	#preservesingleQuotes(sqlbody)#		
	
</cfquery>
		
<cfinclude template="TransactionListingContent.cfm">	