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
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_Request">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_Distribution">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_Consumption">

<!--- ---------------------------------------------------- --->
<!--- Note Dev create a fact table, this in the future has to come from an skTable that is refreshed daily to
improve performance, the sktable should go into appsOLAP --->
<!--- ---------------------------------------------------- --->

<cfoutput>

<cfsavecontent variable="access">
		
         SELECT DISTINCT Warehouse 
         FROM   Request R
		 WHERE  Mission = '#url.mission#'
		 
		 AND    (
		            R.OrgUnit  IN (
			                       SELECT OrgUnit 
			                       FROM   Organization.dbo.OrganizationAuthorization 
								   WHERE  UserAccount = '#SESSION.acc#'
								   AND    Role = 'WhsRequester'											   
							   )
				    OR 
					R.Mission  IN (
						           SELECT Mission 
			                       FROM   Organization.dbo.OrganizationAuthorization 
								   WHERE  UserAccount = '#SESSION.acc#'
								   AND    Role        = 'WhsRequester'		
								   AND    Mission     = '#url.mission#'				   
								   AND    (OrgUnit is NULL or OrgUnit = 0)
		        )   
		   )
			   
</cfsavecontent>

</cfoutput>

<cfquery name="request" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	
	SELECT	newId() AS FactTableId, 
			
			<!--- warehouse --->
			R.Warehouse as DirectedTo_dim, W.WarehouseName as DirectedTo_nme,
			
			<!--- unit requester --->
			R.OrgUnit as Unit_dim, 
			(SELECT TOP 1 OrgUnitName 
			 FROM   Organization.dbo.Organization 
			 WHERE  OrgUnit = R.OrgUnit AND Mission = R.Mission) as Unit_nme,
			
			<!--- facility --->
			T.ShipToWarehouse as Facility_dim, 
			ISNULL(WT.WarehouseName,'Not Confirmed') as Facility_nme, 
			<!--- facility location --->
			T.ShipToLocation as Storage_dim, 
			ISNULL(WLT.Description,'Not Confirmed') as Storage_nme, 
			<!--- facility location class --->
			WLT.LocationClass as StorageClass_dim,
			WLCT.Description as StorageClass_nme,
			
			<!--- item --->
			R.ItemNo as Item_dim, 
			I.ItemDescription as Item_nme, 
			R.UoM as UoM_dim,
			U.UoMDescription as UoM_nme,
				
			<!--- request status --->			
			R.Status as Status_dim, 
			(SELECT Description
			 FROM  Status
			 WHERE Class = 'Request'
			 AND   Status = R.Status) as Status_nme,
						
			<!--- requested time --->
			DatePart(year, R.RequestDate) as Year_dim,
			
				CASE DatePart(month, R.RequestDate) 
					WHEN 1 THEN 'January'
					WHEN 2 THEN 'February'
					WHEN 3 THEN 'March'
					WHEN 4 THEN 'April'
					WHEN 5 THEN 'May'
					WHEN 6 THEN 'June'
					WHEN 7 THEN 'July'
					WHEN 8 THEN 'August'
					WHEN 9 THEN 'September'
					WHEN 10 THEN 'October'
					WHEN 11 THEN 'November'
					WHEN 12 THEN 'December'
				END as Month_dim,
				
			DatePart(month, R.RequestDate) as Month_ord,	
			
			<!--- metrics --->		
			R.RequestedQuantityBase as QtyRequested,			
			(
				SELECT	ISNULL(SUM(TransactionQuantity),0)
				FROM	ItemTransaction
				WHERE	RequestId = R.RequestId
			) AS QtyShipped,
			
			<!--- attributes --->
			R.Reference as RequestNo,
			R.OfficerLastName as Requester,
			R.RequestType,
			R.Remarks 
			
	INTO 	UserQuery.dbo.#SESSION.acc#_Request
	
	FROM	Request AS R
			INNER JOIN RequestTask T 
				ON R.RequestId = T.RequestId
			INNER JOIN Warehouse W
				ON R.Warehouse = W.Warehouse
			INNER JOIN Item I
				ON R.ItemNo = I.ItemNo
			INNER JOIN ItemUoM U
				ON R.ItemNo = U.ItemNo
				AND R.UoM = U.UoM
			LEFT OUTER JOIN Warehouse WT
				ON R.ShipToWarehouse = WT.Warehouse
			LEFT OUTER JOIN WarehouseLocation WLT
				ON T.ShipToWarehouse = WLT.Warehouse
				AND T.ShipToLocation = WLT.Location
			LEFT JOIN Ref_WarehouseLocationClass WLCT
				ON WLCT.Code = WLT.LocationClass
				
	WHERE	R.Mission = '#url.mission#'
	AND		R.Status <> '9'	
	
	<cfif getAdministrator(url.mission) eq "1">	
		<!--- no filtering --->
    <cfelse>				
		AND   R.Warehouse IN ( #preservesinglequotes(access)# )								   				
	</cfif>
	
</cfquery>	

<cfquery name="distribution" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	
	   SELECT       NEWID() AS FactTableId, 
	   
                    W.Warehouse AS Facility_dim, 
					W.WarehouseName AS Facility_nme, 
                  
				    T.Location AS Storage_dim, 
					WL.Description AS Storage_nme, 
				  
				    WL.LocationClass AS StorageClass_dim, 
					WLC.Description AS StorageClass_nme, 
                				  
				    T.OrgUnitCode as Unit_dim, 
					T.OrgUnitName as Unit_nme,
				  
				    T.ItemNo AS SupplyItem_dim, 
					T.ItemDescription AS SupplyItem_nme, 
					
					<!--- removed as we take the base quantity which is corrected for the UoM 
					T.TransactionUoM AS SupplyItemUoM_dim, 
					U.UoMDescription AS SupplyItemUoM_nme, 
					--->
				  				
				    AI.ItemNo AS AssetItem_dim, AI.ItemDescription AS AssetItem_nme, 
				  
				    AC.Category AS AssetCategory_dim, AC.Description AS AssetCategory_nme,
                  
				         (SELECT     TopicValue
                           FROM          AssetItemTopic
                           WHERE      (AssetId = T.AssetId) AND (Topic = '205')) AS UNType_dim, 
						   				  
				    A.Make AS Make_dim,
                 				 
				    <!--- not needed for now 
				    T.TransactionType AS TransactionType_dim,
					TT.Description AS TransactionType_nme, 
					--->
				   
				    DATEPART(year, T.TransactionDate) AS Year_dim, 
									
						CASE DatePart(month, T.TransactionDate) 
							WHEN 1 THEN 'January'
							WHEN 2 THEN 'February'
							WHEN 3 THEN 'March'
							WHEN 4 THEN 'April'
							WHEN 5 THEN 'May'
							WHEN 6 THEN 'June'
							WHEN 7 THEN 'July'
							WHEN 8 THEN 'August'
							WHEN 9 THEN 'September'
							WHEN 10 THEN 'October'
							WHEN 11 THEN 'November'
							WHEN 12 THEN 'December'
						END as Month_dim,
				  					  
                    DATEPART(month, T.TransactionDate) AS Month_ord, 
					  
				    T.AssetId, 
				    A.SerialNo AS AssetSerialNo, 				   
                    A.Model AS AssetModel, 				  
				    A.AssetBarCode, 	
					
					COUNT(*) AS Transactions,		
					<!---  
                    SUM(T.TransactionQuantity * - 1) AS Quantity,
					--->
					SUM(T.TransactionQuantityBase * - 1) AS QuantityBase
		
		INTO    	userQuery.dbo.#SESSION.acc#_Distribution   
		
		FROM        ItemTransaction AS T 
		            <!---
					INNER JOIN ItemUoM AS U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM 
					--->
					INNER JOIN Warehouse AS W ON T.Warehouse = W.Warehouse 
					INNER JOIN WarehouseLocation AS WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location 
					INNER JOIN Ref_WarehouseLocationClass AS WLC ON WL.LocationClass = WLC.Code 
					INNER JOIN AssetItem AS A ON T.AssetId = A.AssetId 
					INNER JOIN Item AS AI ON A.ItemNo = AI.ItemNo 
					INNER JOIN Ref_Category AS AC ON AI.Category = AC.Category 
					INNER JOIN Ref_TransactionType AS TT ON T.TransactionType = TT.TransactionType AND TT.TransactionClass = 'Distribution' 
							  
		WHERE       T.Mission = '#url.mission#'
		
				<cfif getAdministrator(url.mission) eq "1">	
						<!--- no filtering --->
			    <cfelse>			
				AND   T.Warehouse IN ( #preservesinglequotes(access)# )								   				
				</cfif>
				
		GROUP BY    W.Warehouse,
		            W.WarehouseName, 
				    T.Location, 
					WL.Description, 
					T.OrgUnitCode, 
					T.OrgUnitName,
				    WL.LocationClass, 
					WLC.Description, 
					
					T.ItemNo, 
					T.ItemDescription,	
					
					<!---
					T.TransactionUoM,
					U.UoMDescription,
					--->
					
		  	        AI.ItemNo, 
					AI.ItemDescription, 
		            AC.Category, 
					AC.Description,				
		          	  
					T.AssetId,
				    A.Make,          				 
				    T.TransactionType, 
					TT.Description, 			 				  
				    DATEPART(year, T.TransactionDate), 
					DATEPART(month, T.TransactionDate), 
		  	        A.AssetId, 
				    A.SerialNo, 				   
		            A.Model, 				  
					A.AssetBarCode					
				
</cfquery>	

<!--- Below, by dev dev, Promisan b.v. : see my comments 24/9/2011 --->

<!---
<cfinclude template = "Consumption.cfm">
--->

<cfquery name="Consumption" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	
		SELECT NEWID() AS FactTableId, 
			   AssetItemNo as Item_dim,
			   I.ItemDescription as Item_nme,
			   
			   SupplyItemNo as Supply_dim,
			   I2.ItemDescription as Supply_nme,
			  
			   AssetCategory as Category_dim,
			  
			   O.OrgUnit as OrgUnit_dim,
			   O.OrgUnitName as OrgUnit_nme,
			  
			   OperationYear AS Year_dim, 
			    CASE OperationMonth 
					WHEN 1 THEN 'January' 
					WHEN 2 THEN 'February' 
					WHEN 3 THEN 'March' 
					WHEN 4 THEN 'April' 
					WHEN 5 THEN 'May' 
					WHEN 6 THEN 'June' 
					WHEN 7 THEN 'July' 
					WHEN 8 THEN 'August' 
					WHEN 9 THEN 'September' 
					WHEN 10 THEN 'October' 
					WHEN 11 THEN 'November' 
					WHEN 12 THEN 'December' END 
				AS Month_dim,
		        OperationMonth AS Month_ord, 		
				
				Metric,
				MetricSupplyTarget,
				AVG(MetricQuantity) as MetricQuantity,
				AVG(SupplyQuantityActual) as SupplyQuantityActual,
				AVG(SupplyQuantityPlanned) as SupplyQuantityPlanned,
				AVG(QuantityDiscrepancy) as QuantityDiscrepancy
				
	INTO  	 userQuery.dbo.#SESSION.acc#_Consumption	
	FROM 	 skAssetItemConsumption S INNER JOIN Item I 
		ON   I.ItemNo = S.AssetItemNo INNER JOIN Item I2
		ON   I2.ItemNo = S.SupplyItemNo INNER JOIN Organization.dbo.Organization O
		ON   S.OrgUnit = O.OrgUnit
	WHERE    S.Mission = '#URL.Mission#' 
	GROUP BY AssetItemNo,
		     SupplyItemNo,
			 AssetCategory,
			 O.OrgUnit,
			 OrgUnitName,
		     OperationYear, 
		     OperationMonth, 
			 Metric,
			 MetricSupplyTarget,
			 I.ItemDescription,
			 I2.ItemDescription
	ORDER BY OperationYear, OperationMonth		

</cfquery>	

<cfset client.table1_ds = "#SESSION.acc#_Request">
<cfset client.table2_ds = "#SESSION.acc#_Distribution">
<cfset client.table3_ds = "#SESSION.acc#_Consumption">

