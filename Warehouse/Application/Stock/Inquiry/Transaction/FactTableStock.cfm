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
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Stock"> 	
<cfset client.table1_ds = "#SESSION.acc#Stock">

<cfparam name="client.trafilter"  default="">
<cfparam name="client.selectedid" default="">
 			  
<!--- distribution fact table --->
			             
<cfquery name="FactTable" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   
   SELECT   NEWID() AS FactTableId, 
   
		 <!---  T.Warehouse AS Facility_dim,  W.WarehouseName AS Facility_nme, --->		 
		 <!---  W.WarehouseClass as FacilityClass_dim, WC.Description as FacilityClass_nme, --->
         <!---   			
			W.City AS Region_dim, --->
						
			T.ItemCategory as ProductClass_dim,  C.Description AS ProductClass_nme, 
			
			T.ItemNo AS Product_dim, T.ItemDescription AS Product_nme,
			
			
			<!---
			UoM.UoMDescription AS UoMName_dim, 
			--->
			
			T.TransactionType AS Transaction_dim, TT.Description AS Transaction_nme, 
			
			T.Location as Storage_dim,  WL.Description AS Storage_nme, 
            
			WL.LocationClass as StorageClass_dim, WLC.Description AS StorageClass_nme, 
			
			T.BillingMode as BillingMode_dim,
			
		    ISNULL(ORT.OrgUnitCode,'na') AS UnitBranch_dim, 
		    ISNULL(ORT.OrgUnitName,'na') AS UnitBranch_nme,
						
            ISNULL(O.OrgUnitCode, 'na')  AS Unit_dim, 
			ISNULL(O.OrgUnitName, 'na')  AS Unit_nme, 			
						
			ISNULL(AII.ItemNo, 'na')          AS AssetItem_dim, 
            ISNULL(AII.ItemDescription, 'na') AS AssetItem_nme, 
			
			ISNULL(AIC.Category, 'na')      AS AssetClass_dim, 
            ISNULL(AIC.Description, 'na') AS AssetClass_nme, 
									   
			ISNULL(M.Code, 'na')      AS AssetMake_dim, 
			ISNULL(M.Description, '') AS AssetMake_nme, 
			
			ISNULL(PR.ProgramCode, 'na')  AS Purpose_dim, 			
			ISNULL(PR.ProgramName, 'na')  AS Purpose_nme, 
			
			
			CAST(Month(T.TransactionDate) as VARCHAR) as DateYear_dim, 
			CAST(Month(T.TransactionDate) as VARCHAR) as DateMonth_dim, 	
					
						
			T.TransactionQuantity*-1 as Quantity,            
			T.TransactionValue*-1 as Amount,
			
			<!--- attributes --->
			
			AI.AssetBarCode,
			AI.AssetDecalNo,
			CAST(AI.AssetSerialNo as VARCHAR) as AssetSerialNo,
			CAST(T.TransactionBatchNo as VARCHAR) as TransactionBatchNo,
			T.TransactionDate,
			T.TransactionReference as Document,
			T.OfficerLastName
			
	INTO    userquery.dbo.#SESSION.acc#Stock		
	
	<!--- this query is a life query from sktable --->
	
	FROM    ItemTransaction T INNER JOIN
            Warehouse W ON T.Warehouse = W.Warehouse INNER JOIN
            Ref_WarehouseClass WC ON W.WarehouseClass = WC.Code INNER JOIN
            Ref_TransactionType TT ON T.TransactionType = TT.TransactionType INNER JOIN
            Ref_Category C ON T.ItemCategory = C.Category INNER JOIN
            WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location INNER JOIN
            Ref_WarehouseLocationClass WLC ON WL.LocationClass = WLC.Code INNER JOIN
            ItemUoM UoM ON T.ItemNo = UoM.ItemNo AND T.TransactionUoM = UoM.UoM LEFT OUTER JOIN
            Organization.dbo.Organization O INNER JOIN
            Organization.dbo.Organization ORT ON O.Mission = ORT.Mission AND O.MandateNo = ORT.MandateNo AND O.HierarchyRootUnit = ORT.OrgUnitCode ON 
            T.OrgUnit = O.OrgUnit LEFT OUTER JOIN
            Program.dbo.Program PR ON T.ProgramCode = PR.ProgramCode LEFT OUTER JOIN
            Ref_Make M INNER JOIN
            Item AII INNER JOIN
            AssetItem AI ON AII.ItemNo = AI.ItemNo ON M.Code = AI.Make ON T.AssetId = AI.AssetId LEFT OUTER JOIN
			Ref_Category AIC ON AII.Category = AIC.Category		
				
	<!--- ---dont touch- --->		
	WHERE   T.TransactionId IN (SELECT TransactionId FROM userQuery.dbo.#SESSION.acc#_ItemTransaction WHERE transactionId = T.TransactionId)	 
	<!--- end dont touch --->
	
</cfquery>



