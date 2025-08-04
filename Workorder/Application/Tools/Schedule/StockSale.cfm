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

<cf_droptable dbname="AppsWorkOrder" full="1" tblname="skWorkOrderSale">

<!--- ------------------------------------------------------------------------- --->
<!--- workorder sale shipping status and stock on hand for sales item in entity --->
<!--- ------------------------------------------------------------------------- --->

<cfquery name="StockOnSale" 
datasource="AppsWorkOrder">
	
	SELECT     Mission, 
	           CustomerName, 
	           Reference,
	           WorkOrderId, 
			   ItemNo, 
			   ItemBarCode, 
			   ItemDescription, 
			   UoMDescription, 
			   UoMCode, 
			   SUM(OnOrder) AS OnOrder, 
			   SUM(Shipped) AS Shipped, 
	
			   (SELECT     Round(ISNULL(SUM(TransactionQuantity), 0), 2) AS Shipped
			    FROM          Materials.dbo.ItemTransaction
			    WHERE      Mission = subtable.Mission AND ItemNo = subtable.ItemNo and TransactionUoM = subtable.UoM) AS OnHand,
	
			   Currency,
			   ROUND(SUM(SalePayable),0) as SalePayable,
			   0 as SaleInvoiced   <!--- pending make sure we take matching currency --->
			   
	INTO       skWorkOrderSale			   
	
	FROM       (
	
			SELECT     W.Mission, 
			           W.Currency, 
					   C.CustomerName, 
					   W.Reference, 
					   W.WorkOrderId, 
					   WLI.WorkOrderItemId, 
					   WLI.ItemNo, 
					   U.ItemBarCode, 
					   I.ItemDescription, 
					   U.UoMDescription, 
	                   U.UoMCode, 
					   WLI.UoM, 
					   ROUND(WLI.Quantity,2) AS OnOrder, 
					   SaleAmountIncome, 
					   SaleAmountTax, 
					   SalePayable,
	
	                  (SELECT  ISNULL(SUM(TransactionQuantity * - 1), 0) AS Shipped
	                   FROM    Materials.dbo.ItemTransaction
	                   WHERE   TransactionType IN ('2', '3') 
					   AND     Mission = W.Mission 
					   AND     RequirementId = WLI.WorkOrderItemId) AS Shipped
	                           
	
	        FROM      WorkOrder W INNER JOIN
	                  WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
	                  WorkOrderLineItem WLI ON WL.WorkOrderId = WLI.WorkOrderId AND WL.WorkOrderLine = WLI.WorkOrderLine INNER JOIN
	                  Ref_ServiceItemDomainClass R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code INNER JOIN
	                  Customer C ON W.CustomerId = C.CustomerId INNER JOIN
	                  Materials.dbo.Item I ON WLI.ItemNo = I.ItemNo INNER JOIN
	                  Materials.dbo.ItemUoM U ON WLI.ItemNo = U.ItemNo AND WLI.UoM = U.UoM
	
	        WHERE     W.ActionStatus <= '3' 
			AND       WL.Operational = 1 
			AND       WLI.ActionStatus < '3' 
			AND       R.PointerSale = 1
	
	) subtable

	GROUP BY Mission,CustomerName, Currency, Reference, WorkOrderId, ItemNo, UoM, ItemBarCode, UoMDescription, UoMCode, ItemDescription 
	ORDER BY Mission, WorkOrderId

</cfquery>
