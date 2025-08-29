<!--
    Copyright © 2025 Promisan B.V.

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
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#_WorkOrder_item"> 
			
<!--- get the records to be shown by saving them in a temp table for showing --->


	
<cfquery name="SearchResult"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT     T.Warehouse, 
	           W.WarehouseName,
	           T.TransactionUoM, 
			   ItemUoM.UoMDescription, 
			   WL.Reference, 
			   WO.Reference AS WorkorderReference, 
			   WO.OrderDate,
			   T.TransactionLot, 			   
			   WL.WorkOrderLine, 			   
               WL.WorkOrderId, 
			   WL.WorkOrderLineId, 
			   WL.ServiceDomainClass,
			   SUM(T.TransactionQuantity) AS OnHand, 
			   SUM(T.TransactionValue) AS Value
	
	INTO       userquery.dbo.#SESSION.acc#_WorkOrder_item			   
	FROM       ItemTransaction T INNER JOIN 
			   Warehouse W ON W.Warehouse = T.Warehouse INNER JOIN
               ItemUoM ON T.ItemNo = ItemUoM.ItemNo AND T.TransactionUoM = ItemUoM.UoM AND T.ItemNo = ItemUoM.ItemNo AND 
               T.TransactionUoM = ItemUoM.UoM INNER JOIN
               WorkOrder.dbo.WorkOrderLine WL ON T.WorkOrderId = WL.WorkOrderId AND T.WorkOrderLine = WL.WorkOrderLine INNER JOIN
               WorkOrder.dbo.WorkOrder WO ON WL.WorkOrderId = WO.WorkOrderId
			   
	WHERE     T.ItemNo = '#URL.ItemNo#'
	AND       T.Mission = '#URL.Mission#'
	
    GROUP BY   T.Warehouse, 
	           W.WarehouseName,
	           T.TransactionUoM, 
			   WL.Reference, 
			   WO.Reference, 			   
			   WL.WorkOrderLine, 
			   WL.WorkOrderId, 
			   WL.WorkOrderLineId,
	           WO.OrderDate,
			   WL.ServiceDomainClass,
			   T.TransactionLot, 
			   ItemUoM.UoMDescription
			   
	HAVING 	 ROUND(SUM(T.TransactionQuantity),1) <> 0
		
</cfquery>


	
<cfinclude template="WorkOrderListingContent.cfm">	