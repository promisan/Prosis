
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
	
	<cfsavecontent variable="onhand">
	     (
	   SELECT   SUM(TransactionQuantity)
	   FROM     ItemTransaction
	   WHERE    Mission         = '#getWarehouse.mission#'
	    AND     Warehouse       = S.Warehouse 
	    AND     Location        = S.Location 
	    AND     ItemNo          = S.ItemNo 
	    AND     TransactionUoM  = S.UoM		
		<cfif Form.TransactionLot neq "">
		AND     TransactionLot  = '#Form.TransactionLot#'
		</cfif>	
	 	  )
	</cfsavecontent>
	
	<cfsavecontent variable="onhandpending">
	     (
	   SELECT   SUM(TransactionQuantity)
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

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#_Diversity"> 

<cftransaction isolation="read_uncommitted">
					
		<cfquery name="getDataInMemory" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
					
		 SELECT    newid() as ListingKey,
		           I.Category,
		 		   C.Description as CategoryDescription,
		           T.ItemNo,	
				   I.ItemNoExternal,
				   I.ItemPrecision,
			       I.ParentItemNo,
				   
    			   (SELECT ItemDescription 
	    			    FROM Item IP 
		    			WHERE IP.ItemNo = I.ParentItemNo) as ParentItemName,	
						
					(SELECT ISNULL(MinReorderQuantity,1)
	    			    FROM ItemWarehouse IW 
		    			WHERE IW.ItemNo = T.ItemNo and IW.UoM = T.TransactionUoM and IW.Warehouse = '#url.warehouse#') as ReorderQuantity,		
						
					(SELECT ISNULL(MinimumStock,1)
	    			    FROM ItemWarehouse IW 
		    			WHERE IW.ItemNo = T.ItemNo and IW.UoM = T.TransactionUoM and IW.Warehouse = '#url.warehouse#') as MinimumStock,		
						
					(SELECT ISNULL(MaximumStock,1)
	    			    FROM ItemWarehouse IW 
		    			WHERE IW.ItemNo = T.ItemNo and IW.UoM = T.TransactionUoM and IW.Warehouse = '#url.warehouse#') as MaximumStock,	
					
					CASE WHEN  (SELECT     TOP (1) TransactionDate
			                     FROM       ItemTransaction
	    		                 WHERE      Mission = '#url.mission#' 
								 AND        ItemNo = T .ItemNo 
								 AND        TransactionUoM = T .TransactionUoM 
								 AND        TransactionType = '2'
	    		                 ORDER BY   TransactionDate DESC) IS NULL THEN '01/01/1900' 
						 
					 ELSE     (SELECT    TOP (1) TransactionDate
                               FROM     ItemTransaction AS IT
                               WHERE    Mission = '#url.mission#' 
							   AND      ItemNo = T .ItemNo 
							   AND      TransactionUoM = T .TransactionUoM 
							   AND      TransactionType = '2'
                               ORDER BY TransactionDate DESC) END as LastSale,				
								           
		 		   T.TransactionLot,          
		           I.ItemDescription,
				   P.WarehouseName,
				   <!---
				   W.Description + ' - '+W.StorageCode AS Description, 	
				   --->
				   U.ItemBarCode,		   
				   U.UoMDescription,
				   
				   (SELECT  CategoryItemName
				    FROM    Ref_CategoryItem CI 
					WHERE   CI.Category = I.Category 
					AND     CI.CategoryItem = I.CategoryItem) as CategoryItemName,
					
					(SELECT Count(1)
				    FROM   ItemImage 
					WHERE  ItemNo = T.ItemNo) as Pictures,						
				   
				   COUNT(TransactionBatchNo)  as Batches,
				   MAX(TransactionDate)       as LastTransaction,
				   SUM(TransactionQuantity)   as OnHand				   			  
				   					 			          		   
		 INTO 	   userQuery.dbo.#SESSION.acc#_Diversity	   
		 
		 FROM      ItemTransaction T 	 	         
		           INNER JOIN Item I              ON T.ItemNo = I.ItemNo 
				   INNER JOIN ItemUoM U           ON I.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM 
				   <!---
				   INNER JOIN WarehouseLocation W ON T.Warehouse = W.Warehouse AND T.Location = W.Location 
				   --->
				   INNER JOIN Warehouse P         ON P.Warehouse = T.Warehouse
				   INNER JOIN Ref_Category C      ON C.Category = I.Category 
		
		 WHERE     T.Mission = '#url.mission#'

		 <!--- not needed here, we can roll up for inquiry
		 AND       C.StockControlMode = 'Stock'
		 --->
		 
		 AND       I.ItemClass = 'Supply'		
		 
		 AND       P.Warehouse = '#url.warehouse#'
		 
		 AND       I.Operational = 1
		
		 <!---			 	 
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
		--->
			
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
		 
		 GROUP BY I.Category,
		          C.Description,
			      I.CategoryItem,
		          T.ItemNo,	
			      I.ItemNoExternal,
			      I.ItemPrecision,
		 	      T.TransactionLot,          
		          I.ItemDescription,
			      P.WarehouseName,
				  <!--- 
			      W.Description,
			      W.StorageCode,  	
				  --->
				  T.TransactionUoM,
			      U.ItemBarCode,		   
			      U.UoMDescription,
			      I.ParentItemNo
			   			
		 <!---	removed in order to show 
		 HAVING SUM(TransactionQuantity) > 0	
		 --->
		
		 ORDER BY I.Category, T.ItemNo, I.ParentItemNo 
		
		 			
	</cfquery>		

</cftransaction>

<cfinclude template="ListingDataContent.cfm">					
	