	
<CF_DropTable dbName="AppsQuery"  tblName="ItemReceipt_#SESSION.acc#"> 

<!--- build the query of the receipts --->

<cfoutput>
<cfsavecontent variable="sqlbody">
	FROM       PurchaseLineReceipt R INNER JOIN
	           PurchaseLine PL ON R.RequisitionNo = PL.RequisitionNo INNER JOIN
	           Purchase P ON PL.PurchaseNo = P.PurchaseNo INNER JOIN
	           Organization.dbo.Organization Org ON P.OrgUnitVendor = Org.OrgUnit INNER JOIN 
			   Materials.dbo.Warehouse W ON R.Warehouse = W.Warehouse INNER JOIN
               Materials.dbo.ItemUoM I ON R.WarehouseItemNo = I.ItemNo AND R.WarehouseUoM = I.UoM INNER JOIN
			   Status S ON Status = R.ActionStatus
	WHERE      P.Mission = '#URL.Mission#'
	AND        StatusClass = 'Receipt'
	AND        R.Warehouse IN (SELECT  Warehouse
	                           FROM    Materials.dbo.Warehouse
	                           WHERE   Mission = '#URL.Mission#')
	AND        R.WarehouseItemNo = '#URL.ItemNo#'	
	AND        R.ActionStatus IN ('0','1','2')
</cfsavecontent>
</cfoutput>
		
<!--- retrieve the receipt RI records for this item and warehouse records --->

<cfquery name="SearchResult"
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
	SELECT     R.Warehouse, 
	           W.WarehouseName,
			   R.WarehouseItemNo, 
			   R.WarehouseUoM,
			   R.TransactionLot,
			   I.UOMDescription, 
			   P.PurchaseNo, 
			   R.ReceiptId, 
			   R.DeliveryDate, 
			   R.ReceiptNo, 
			   S.Description as StatusDescription,
			   Org.OrgUnitName AS VendorName, 
			   Org.OrgUnit AS VendorUnit,
			   R.ReceiptWarehouse, 
			   R.ReceiptAmountBaseCost, 
			   R.ReceiptAmountBaseTax, 
			   R.ReceiptAmountBase
	INTO userQuery.dbo.ItemReceipt_#SESSION.acc#		   
	#preservesingleQuotes(sqlbody)#		   
</cfquery>	

<cfinclude template="ReceiptListingContent.cfm">
	