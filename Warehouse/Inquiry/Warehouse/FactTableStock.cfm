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

<!--- dont touch --->
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#StockInquiry"> 	
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#SalesInquiry"> 	

<cfset client.table1_ds = "#SESSION.acc#StockInquiry">
<cfset client.table2_ds = "#SESSION.acc#SalesInquiry">
 			  
<!--- distribution fact table --->
			             
<cfquery name="FactTable" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   
   SELECT   RecordId AS FactTableId, 
   
   			<!--- Mission as Mission_dim --->
   
		    Warehouse AS Facility_dim,  WarehouseName AS Facility_nme, 		 			
						
		    WarehouseClass as FacilityClass_dim, WarehouseClassName as FacilityClass_nme, WarehouseClassName as FacilityClass_ord,             			
			WarehouseCity AS FacilityRegion_dim, 
					
			<!---			
			ItemCategory as ProductClass_dim,  ItemCategoryName AS ProductClass_nme, 			
			ItemNo AS Product_dim, ItemDescription AS Product_nme,
			ItemUoMDescription AS UoMName_dim, 
			--->
			
			TransactionType AS Transaction_dim, TransactionTypeName AS Transaction_nme, 
			
			TransactionClass as TransactionClass_dim,
			
			Location as Storage_dim,  LocationName AS Storage_nme, LocationName AS Storage_ord,             
			LocationClass as StorageClass_dim, LocationClassName AS StorageClass_nme,  LocationClassName AS StorageClass_ord,
						
			BillingMode as BillingMode_dim,
			
		    BranchCode    AS UnitBranch_dim, BranchName AS UnitBranch_nme, BranchName AS UnitBranch_ord,						
            OrgUnitCode   AS Unit_dim, OrgUnitName AS Unit_nme, 				
			RequestReference as Request_dim,
			AssetCategory AS AssetClass_dim, AssetCategory AS AssetClass_nme, 								
			AssetItemNo   AS AssetItem_dim, AssetItemName AS AssetItem_nme, AssetItemName AS AssetItem_ord, 			   
			Make          AS AssetMake_dim, MakeName AS AssetMake_nme, MakeName AS AssetMake_ord,			
			ProgramCode   AS Purchase_dim, ProgramName   AS Purpose_nme, 
			
			CAST(TransactionYear as VARCHAR) as DateYear_dim, 
			CAST(TransactionMonth as VARCHAR) as DateMonth_dim, 			
						
			<!--- cells --->			
			Records as Transactions,TransactionQuantity as Quantity, TransactionValue as Amount,
						
			<!--- attributes --->	
					
			Make
			
	INTO    userquery.dbo.#SESSION.acc#StockInquiry		
	
	<!--- this query is a life query from sktable --->
	
	FROM    skItemTransaction
				
	<!--- ---dont touch- --->		
	WHERE   Mission = '#url.mission#'
	AND     ItemNo = '#url.itemno#'
	AND     ItemUoM = '#url.UoM#'	
	<!--- end dont touch --->
	
</cfquery>

<!--- external billing fact table --->
	             
<cfquery name="FactTable" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   
   SELECT   TransactionId AS FactTableId, 
   
   			<!--- Mission as Mission_dim --->
   
		    Warehouse AS Facility_dim,  WarehouseName AS Facility_nme, 						 
		    WarehouseClass as FacilityClass_dim, WarehouseClassName as FacilityClass_nme, WarehouseClassName as FacilityClass_ord, 			            			
			WarehouseCity AS FacilityRegion_dim, 				
				
			<!---		
			ItemCategory as ProductClass_dim, ItemCategoryName AS ProductClass_nme, 			
			ItemNo AS Product_dim, ItemDescription AS Product_nme,
			--->
			
			<!---
			ItemUoMDescription AS UoMName_dim, 
			--->
			
			
			TransactionType AS TransactionType_dim, TransactionTypeName AS TransactionType_nme, 
			
			<!---
			Location as Storage_dim,  LocationName AS Storage_nme, LocationName AS Storage_ord, 
			--->
            			
			LocationClass as StorageClass_dim, LocationClassName AS StorageClass_nme,  LocationClassName AS StorageClass_ord,			
			
			GeoLocationName as geoLocation_dim, 

			<!---
			BillingMode as BillingMode_dim,
			--->
			
			BranchCode    AS UnitBranch_dim, BranchName AS UnitBranch_nme, BranchName AS UnitBranch_ord,						
            OrgUnitCode   AS Unit_dim, OrgUnitName AS Unit_nme, 				
			AssetCategory AS AssetClass_dim, AssetCategory AS AssetClass_nme, 			
							
			AssetItemNo   AS AssetItem_dim, AssetItemName AS AssetItem_nme, AssetItemName AS AssetItem_ord, 			   			
			Make          AS AssetMake_dim, MakeName AS AssetMake_nme, MakeName AS AssetMake_ord,	
				
			ProgramCode   AS Purpose_dim, ProgramName AS Purpose_nme, 
					
			CAST(TransactionYear as VARCHAR) as DateYear_dim, 
			CAST(TransactionMonth as VARCHAR) as DateMonth_dim, 
			DATENAME(month,TransactionDate) as DateMonth_nme,
			
			<!--- COGS --->
				
			TransactionQuantity,            
			TransactionValue,
					
			<!--- Sales --->
			
			SalesCurrency, 
			SalesPriceVariable, 
			SalesPriceFixed, 
			SalesPrice, 
			SalesAmount, 
			SalesTax, 
			SalesTotal,
			
			<!--- attributes --->
		    TransactionDate,
		    TransactionDocument AS ReceiptNo, 
			PersonNo, LastName, FirstName, IndexNo, PersonID, 
			AssetItemNo, AssetItemName, Make,
			InvoiceNo,
			InvoiceDate						
			
	INTO    userquery.dbo.#SESSION.acc#SalesInquiry		
	
	<!--- this query is a life query from sktable --->
	
	FROM    skItemTransactionShipping
				
	<!--- ---dont touch- --->		
	WHERE   Mission = '#url.mission#'
	AND     ItemNo  = '#url.itemno#'
	AND     ItemUoM = '#url.UoM#'	
	
	<!--- end dont touch --->
	
</cfquery>
  
<cfset client.table1_ds = "#SESSION.acc#StockInquiry">
<cfset client.table2_ds = "#SESSION.acc#SalesInquiry">





