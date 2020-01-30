<cfquery name="Drop"
	datasource="AppsQuery">
      if exists (select * from dbo.sysobjects 
	             where id = object_id(N'[dbo].[vwWorkOrderSaleItem]') 
            	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwWorkOrderSaleItem]
	</cfquery>
	
	
<!--- additional dimension like accountparent, accountgroup --->
 
<cfquery name="Dataset" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
	CREATE VIEW dbo.vwWorkOrderSaleItem
	
	AS		
	
	SELECT      W.Mission             as Entity_dim, 
	              
				C.CustomerName        as Customer_dim,
				 				  
				YEAR(W.OrderDate)     as OrderYear_dim, 
				MONTH(W.OrderDate)    as OrderMonth_dim, 
				
                WL.OrgUnitImplementer as SalesOffice_dim, (SELECT OrgUnitName FROM Organization.dbo.Organization WHERE OrgUnit = WL.OrgUnitImplementer) as SalesOffice_nme,
				WL.PersonNo           as SalesPerson_dim, (SELECT LastName FROM Employee.dbo.Person WHERE Personno = WL.PersonNo) as SalesPerson_nme, 
				WL.Source             as Source_dim, 
				W.ServiceItem         as Service_dim, S.Description as Service_nme, 
				W.ActionStatus        as Status_dim, 
				WLI.ItemNo            as Item_dim, I.ItemDescription as Item_nme, 
				I.Category            as Category_dim, 				
				U.UoMDescription as UoM_dim,
                  
                WLI.Currency as Currency_dim, 
								  
				W.Reference, 
				WLI.Quantity, 		
				W.OrderDate, 		  
				WLI.SaleAmountIncome, WLI.SaleAmountTax, ROUND(WLI.SalePayable, 2) AS SaleAmount, 
				Billed.BilledAmount, Billed.BilledTax, Billed.Billed,			
				WLI.WorkOrderItemId as FactTableId
				  
	FROM        WorkOrder.dbo.WorkOrder AS W 
				INNER JOIN WorkOrder.dbo.WorkOrderLine AS WL             ON W.WorkOrderId = WL.WorkOrderId 				
				INNER JOIN WorkOrder.dbo.Ref_ServiceItemDomainClass AS R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code 
				INNER JOIN WorkOrder.dbo.ServiceItem S                   ON W.ServiceItem    = S.Code 
				INNER JOIN WorkOrder.dbo.Customer C                      ON W.CustomerId     = C.CustomerId 
				INNER JOIN WorkOrder.dbo.WorkOrderLineItem AS WLI        ON WL.WorkOrderId   = WLI.WorkOrderId AND WL.WorkOrderLine = WLI.WorkOrderLine
				INNER JOIN Materials.dbo.Item I ON WLI.ItemNo = I.ItemNo 
				INNER JOIN Materials.dbo.ItemUoM U ON WLI.ItemNo = U.ItemNo AND WLI.UoM = U.UoM 
				
				LEFT OUTER JOIN
				
                    (SELECT        BI.RequirementId, 
             					   ROUND(SUM(BIS.SalesAmount), 2) AS BilledAmount, 
						           ROUND(SUM(BIS.SalesTax), 2) AS BilledTax, 
								   ROUND(SUM(BIS.SalesTotal), 2) AS Billed
                      FROM         Materials.dbo.ItemTransaction AS BI 
					               INNER JOIN Materials.dbo.ItemTransactionShipping AS BIS ON BI.TransactionId = BIS.TransactionId
                      WHERE        BI.TransactionType IN ('2', '3') 
					  AND EXISTS  ( SELECT  'X' AS Expr1
                                    FROM    Accounting.dbo.TransactionHeader AS H
                                    WHERE   Journal         = BIS.Journal 
								 	AND     JournalSerialNo = BIS.JournalSerialNo 
									AND     ActionStatus <> '9' 
									AND     RecordStatus <> '9'
									)					
				    GROUP BY     BI.RequirementId
					) AS Billed 
					
					ON WLI.WorkOrderItemId = Billed.RequirementId
					
	WHERE        R.PointerSale = 1
		
</cfquery>

<!---
	
	
	
	
	
	SELECT     H.Mission               as Entity_dim, 
	           H.Journal               as Journal_dim, J.Description AS Journal_nme, 
			   L.GLAccount             as Account_dim, L.GLAccount+' '+R.Description AS Account_nme, 	
			   R.AccountClass          as AccountClass_dim,
			   RG.AccountGroup         as AccountGroup_dim, RG.AccountGroup+' '+RG.Description AS AccountGroup_nme, RG.ListingOrder as AccountGroup_ord,
			   RP.AccountParent        as AccountParent_dim, RP.AccountParent+' '+RP.Description AS AccountParent_nme,		   
			   L.Fund                  as Fund_dim,
			   L.OrgUnit               as Center_dim, O.HierarchyCode as Center_ord, O.OrgUnitName as Center_nme,
			   L.ProgramCode           as Program_dim, P.ProgramName AS Program_nme, 
			   H.AccountPeriod         as PeriodFiscal_dim, 			   	   
			   H.TransactionPeriod     as PeriodTransactionFiscal_dim,   
			   L.TransactionPeriod     as PeriodTransactionEconomic_dim,             
			   L.Currency              as Currency_dim, 
               L.OfficerUserId         as Officer_dim, L.OfficerFirstName + ' ' + L.OfficerLastName AS Officer_nme, 
			   H.TransactionSource     as Source_dim,
			   H.TransactionCategory   as Category_dim,		
			   J.GLCategory			   as TransactionMode_dim,	
			   L.TransactionDate, 
			   L.JournalTransactionNo,
			   L.Reference,		
			   round((L.AmountDebit-AmountCredit),2) as Amount,	   
			   round(L.AmountDebit,2) as AmountDebit, 
               round(L.AmountCredit,2) as AmountCredit, 
			   round((L.AmountBaseDebit-AmountBaseCredit),2) as AmountBase,	
			   round(L.AmountBaseDebit,2) as AmountBaseDebit, 
			   round(L.AmountBaseCredit,2) as AmountBaseCredit, 
			   L.TransactionType, 
			   L.TransactionLineId AS FactTableid
			   
	FROM       Accounting.dbo.TransactionHeader AS H INNER JOIN
               Accounting.dbo.TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
               Accounting.dbo.Ref_Account AS R ON L.GLAccount = R.GLAccount INNER JOIN
			   Accounting.dbo.Ref_AccountGroup AS RG ON R.AccountGroup = RG.AccountGroup INNER JOIN
			   Accounting.dbo.Ref_AccountParent AS RP ON RG.AccountParent = RP.AccountParent INNER JOIN			 
               Accounting.dbo.Journal J ON H.Journal = J.Journal LEFT OUTER JOIN
               Program.dbo.Program AS P ON L.ProgramCode = P.ProgramCode LEFT OUTER JOIN
               Organization.dbo.Organization AS O ON O.OrguNit = L.OrgUnit
	WHERE      H.ActionStatus IN ('0','1')
	AND        H.RecordStatus != '9'
	
	--->	