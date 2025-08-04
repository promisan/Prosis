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

<!--- control list data content --->

<cfquery name="getWarehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	  *
	FROM   	  Warehouse
	WHERE  	  Warehouse = '#url.warehouse#'							
</cfquery>		

<cfparam name="url.filterwarehouse"   default="1">	<!--- enforce the warehouse --->
<cfparam name="url.location"          default="">	
<cfparam name="Form.TransactionLot"   default="">		
<cfparam name="Form.Location"         default="#url.location#">		
<cfparam name="Form.Category"         default="">	

<cfparam name="url.mode"              default="item">		
	
<cfoutput>	

	<cfsavecontent variable="reserved">
	     (
	   SELECT   ISNULL(SUM(TransactionQuantity),0)
	   FROM     ItemTransaction
	   WHERE    Mission         = '#getWarehouse.mission#'
	    AND     Warehouse       = S.Warehouse 
	    AND     Location        = S.Location 
	    AND     ItemNo          = S.ItemNo 
	    AND     TransactionUoM  = S.UoM		
		AND     WorkOrderid is not NULL
		<cfif Form.TransactionLot neq "">
		AND     TransactionLot  = '#Form.TransactionLot#'
		</cfif>			
	 	  )
	</cfsavecontent>
	
	<cfsavecontent variable="onhand">
	     (
	   SELECT   ISNULL(SUM(TransactionQuantity),0)
	   FROM     ItemTransaction
	   WHERE    Mission         = '#getWarehouse.mission#'
	    AND     Warehouse       = S.Warehouse 
	    AND     Location        = S.Location 
	    AND     ItemNo          = S.ItemNo 
	    AND     TransactionUoM  = S.UoM		
		AND     WorkOrderid is NULL
		<cfif Form.TransactionLot neq "">
		AND     TransactionLot  = '#Form.TransactionLot#'
		</cfif>	
	 	  )
	</cfsavecontent>
	
	<cfsavecontent variable="onhandpending">
	     (
	   SELECT   ISNULL(SUM(TransactionQuantity),0)
	   FROM     ItemTransaction
	   WHERE    Mission         = '#getWarehouse.mission#'
	    AND     Warehouse       = S.Warehouse 
	    AND     Location        = S.Location 
	    AND     ItemNo          = S.ItemNo 
	    AND     TransactionUoM  = S.UoM	
		AND     ActionStatus    = '0'
		<cfif Form.TransactionLot neq "">
		AND     TransactionLot  = '#Form.TransactionLot#'
		</cfif>	
	 	  )
	</cfsavecontent>

</cfoutput>

<cfinvoke component  = "Service.Access"  
	   method            = "RoleAccess" 
	   mission           = "#url.mission#" 	  
	   anyUnit           = "No"
	   role              = "'WhsPick'"
	   parameter         = "#url.systemfunctionid#"
	   accesslevel       = "'0','1','2'"
	   returnvariable    = "globalmission">	
	   
<cfif globalmission neq "Granted">	

	<!--- check access on the level of the mission --->
			
	<cfinvoke component  = "Service.Access"  
	   method            = "RoleAccessList" 
	   role              = "'WhsPick'"
	   mission           = "#url.mission#" 	  		  
	   parameter         = "#url.systemfunctionid#"
	   accesslevel       = "'0','1','2'"
	   returnvariable    = "accesslist">	
		   
	<cfif accessList.recordcount eq "0">
	
		<table width="100%" border="0" height="100%" cellspacing="0" cellpadding="0" align="center">
			   <tr><td align="center" style="padding-top:70;" valign="top" class="labelmedium"><i>
			    <font color="FF0000">
				<cf_tl id="You have <b>NOT</b> been granted any access to this inquiry function" class="Message">
				</font>
				</td>
			   </tr>
		</table>	
		<cfabort>
	
	</cfif>		 
		   
</cfif>		   

<!--- get the stock per warehourse or per warehouse locations on the ItemWarehouseLocation level --->

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#_OnHand"> 

<cftransaction isolation="read_uncommitted">

    <!---
	<cfif url.mode eq "item">
	--->
				    
		<cfquery name="getDataInMemory" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 		
						
			SELECT *
						
			INTO userQuery.dbo.#SESSION.acc#_OnHand	
						
			FROM (	
					
			 SELECT    newid() as ListingKey,
			           C.Category,
			 		   C.Description as CategoryDescription,
			           S.*,	           
			           I.ItemDescription,
					   I.ItemNoExternal,
				       I.ParentItemNo,
					   I.ItemPrecision,
				       (SELECT ItemDescription FROM Item IP WHERE IP.ItemNo = I.ParentItemNo) as ParentItemName,					   

					   P.WarehouseName,
					   (CASE WHEN W.Description != W.StorageCode THEN W.Description + ' - '+W.StorageCode ELSE W.Description END) AS Description, 	
					   U.ItemBarCode,		   
					   U.UoMDescription,
					   
					   (SELECT CategoryItemName
					    FROM   Ref_CategoryItem CI 
						WHERE  CI.Category = I.Category 
						AND    CI.CategoryItem = I.CategoryItem) as CategoryItemName,
					   
						(SELECT Count(1)
					    FROM   ItemImage 
						WHERE  ItemNo = S.ItemNo) as Pictures,		
						
						<!---
						(SELECT ISNULL(MinimumStock,1)
	    			    FROM ItemWarehouse IW 
		    			WHERE IW.ItemNo = T.ItemNo and IW.UoM = T.TransactionUoM and IW.Warehouse = S.Warehouse) as MinimumStock,		
						
						
						(SELECT ISNULL(MaximumStock,1)
	    			    FROM ItemWarehouse IW 
		    			WHERE IW.ItemNo = T.ItemNo and IW.UoM = T.TransactionUoM and IW.Warehouse = S.Warehouse) as MaximumStock,	
						
						--->					   
					   
					   #preservesinglequotes(reserved)# AS Reserved, 
					   					   
					   #preservesinglequotes(onhand)#   AS OnHand, 
					   
					   <!---
		               #preservesinglequotes(onhandpending)# AS OnHandPending,  
					   --->
					  				
					   (SELECT   SUM(TransactionValue)
		                FROM     ItemTransaction 
						WHERE    Mission         = '#getWarehouse.mission#'
		                AND      Warehouse       = S.Warehouse 
					    AND      Location        = S.Location 
					    AND      ItemNo          = S.ItemNo 
					    AND      TransactionUoM  = S.UoM		
						AND      WorkOrderid is NULL  <!--- pure onhand stock --->		
						<cfif Form.TransactionLot neq "">
						AND      TransactionLot  = '#Form.TransactionLot#'
						</cfif>	
						) AS OnHandValue,					 
							 
						(CASE  WHEN MinimumStock > #preservesinglequotes(onhand)#  THEN 'Replenish'
		                       WHEN MinimumStock = #preservesinglequotes(onhand)#  THEN 'Alert'
						  ELSE 'Good' END) as Status				         		   
			    
			 FROM      ItemWarehouseLocation S   
			           INNER JOIN Item I              ON S.ItemNo    = I.ItemNo 
					   INNER JOIN ItemUoM U           ON I.ItemNo    = U.ItemNo AND S.UoM = U.UoM 
					   INNER JOIN WarehouseLocation W ON S.Warehouse = W.Warehouse AND S.Location = W.Location 
					   INNER JOIN Warehouse P         ON P.Warehouse = S.Warehouse
					   INNER JOIN Ref_Category C      ON C.Category  = I.Category					  
					   	
			 WHERE     P.Mission = '#url.mission#'
			 
			 AND       I.ItemClass = 'Supply'	
			 
			 <!--- not needed here
			 AND       C.StockControlMode = 'Stock'
			 --->
						 	 
			 <cfif url.filterwarehouse eq "1">			 
			 AND       P.Warehouse = '#url.warehouse#'	 			 			 
			 <cfelse>
			 		   
				<cfif globalmission neq "granted">				
				 AND       P.MissionOrgUnitId IN (					   
					                  SELECT DISTINCT MissionOrgUnitId 
					                  FROM   Organization.dbo.Organization 
									  WHERE  OrgUnit IN (#quotedvalueList(accesslist.orgunit)#) )						
				</cfif>
				
			</cfif>
				
			<!--- ------------------------------------------- --->
			<!--- this is from the lot enabled inquiry screen --->
			<!--- ------------------------------------------- --->
			 
			<cfif form.location neq "">		 	 
			 AND       S.Location  = '#form.location#'			 		 
			</cfif>	
			 
			<cfif form.category neq "">	 	 	 
			 AND       S.ItemNo IN (SELECT ItemNo 
			                        FROM   Item 
									WHERE  Category = '#Form.Category#')				 
			</cfif>	
			 
			<cfif form.Transactionlot neq "">	
			 
			 <!--- only items that have this lot somehow --->
			 AND      EXISTS  (SELECT  'X'
			                   FROM    ItemTransaction
							   WHERE   Warehouse      = S.Warehouse 
						       AND     Location       = S.Location 
						       AND     ItemNo         = S.ItemNo 
						       AND     TransactionUoM = S.UoM
							   AND     TransactionLot = '#Form.TransactionLot#'	)
			 
			 </cfif>
			 
			 ) as B			 		 
			 			 
			 WHERE OnHand <> 0	
			 
			 --condition									 
		
		</cfquery>	
						
	 <!--- change by query above as that one is more flexible  
				
	<cfelse>	
					
			<cfquery name="getDataInMemory" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
			
			SELECT *
			INTO 	   userQuery.dbo.#SESSION.acc#_OnHand	
			FROM (					
		
			 SELECT    newid() as ListingKey,
			           I.Category,
			 		   C.Description as CategoryDescription,
			           T.ItemNo,	
					   I.ItemNoExternal,
					   I.ItemPrecision,
				       I.ParentItemNo,
				       (SELECT ItemDescription FROM Item IP WHERE IP.ItemNo = I.ParentItemNo) as ParentItemName,			           
			 		   T.TransactionLot,          
			           I.ItemDescription,
					   P.WarehouseName,
					   (CASE WHEN W.Description != W.StorageCode THEN W.Description + ' - '+W.StorageCode ELSE W.Description END) AS Description, 						  
					   U.ItemBarCode,		   
					   U.UoMDescription,
					   
					   (SELECT CategoryItemName
					    FROM   Ref_CategoryItem CI 
						WHERE  CI.Category = I.Category 
						AND    CI.CategoryItem = I.CategoryItem) as CategoryItemName,
						
						(SELECT Count(1)
					    FROM   ItemImage 
						WHERE  ItemNo = T.ItemNo) as Pictures,			
						
						(SELECT ISNULL(MinimumStock,1)
	    			    FROM ItemWarehouse IW 
		    			WHERE IW.ItemNo = T.ItemNo and IW.UoM = T.TransactionUoM and IW.Warehouse = W.Warehouse) as MinimumStock,		
						
						(SELECT ISNULL(MaximumStock,1)
	    			    FROM ItemWarehouse IW 
		    			WHERE IW.ItemNo = T.ItemNo and IW.UoM = T.TransactionUoM and IW.Warehouse = W.Warehouse) as MaximumStock,						
					   
					   SUM(TransactionQuantity) as OnHand,
					   SUM(TransactionValue)    as OnHandValue	 
			 
			 FROM      ItemTransaction T 	 	         
			           INNER JOIN Item I         ON T.ItemNo = I.ItemNo 
					   INNER JOIN ItemUoM U      ON I.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM 
					   INNER JOIN WarehouseLocation W ON T.Warehouse = W.Warehouse AND T.Location = W.Location 
					   INNER JOIN Warehouse P    ON P.Warehouse = T.Warehouse
					   INNER JOIN Ref_Category C ON C.Category = I.Category 
			
			 WHERE     T.Mission = '#url.mission#'
	
			 <!--- not needed here, we can roll up for inquiry
			 AND       C.StockControlMode = 'Stock'
			 --->
			 
			 AND       I.ItemClass = 'Supply'				 
						 	 
			 <cfif url.filterwarehouse eq "1">
			 			 
			 AND       P.Warehouse = '#url.warehouse#'	 
			 
			 <cfelse>
			 		   
				<cfif globalmission neq "granted">
				
				 AND       P.MissionOrgUnitId IN
						
						           (					   
					                  SELECT DISTINCT MissionOrgUnitId 
					                  FROM   Organization.dbo.Organization
									  WHERE  OrgUnit IN (#quotedvalueList(accesslist.orgunit)#) 						 																			  
								   )	
					
				</cfif>
				
			</cfif>
				
			<!--- ------------------------------------------- --->
			<!--- this is from the lot enabled inquiry screen --->
			<!--- ------------------------------------------- --->
			 
			<cfif form.location neq "">		 	 
			 AND       T.Location  = '#form.location#'			 		 
			</cfif>	
			 
			<cfif form.category neq "">	 	 	 
			 AND       T.ItemNo IN (SELECT ItemNo 
			                        FROM   Item 
									WHERE  Category = '#Form.Category#')				 
			</cfif>	
			 
			<cfif form.Transactionlot neq "">	
			 
			 <!--- only items that have this lot somehow --->
			 AND      EXISTS  (
			 				   SELECT  'X'
			                   FROM    ItemTransaction 
							   WHERE   Warehouse      = T.Warehouse 
						       AND     Location       = T.Location 
						       AND     ItemNo         = T.ItemNo 
						       AND     TransactionUoM = T.UoM
							   AND     TransactionLot = '#Form.TransactionLot#'					   
							   )
			 
			 
			 </cfif>
			 
			 GROUP BY 
			       I.Category,
			       C.Description,
				   I.CategoryItem,
			       T.ItemNo,	
				   I.ItemNoExternal,
				   I.ItemPrecision,
			 	   T.TransactionLot,          
			       I.ItemDescription,
				   P.WarehouseName,
				   W.Warehouse,
				   W.Description,
				   W.StorageCode,  	
				   U.ItemBarCode,		
				   T.TransactionUoM,   
				   U.UoMDescription,
				   I.ParentItemNo
				   
			) as B	   
				   			
			 <!---	removed in order to show --->
			 WHERE Onhand <> 0	
						 			
		</cfquery>
			
	</cfif>	
	
	--->	
		
</cftransaction>

<cfinclude template="ListingDataContent.cfm">					
	