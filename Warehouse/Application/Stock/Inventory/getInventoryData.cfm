
<!--- get location data --->
<cfparam name ="URL.parentItemNo" default="">
<cfparam name ="URL.earmark"      default="">

<cfquery name="Status"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc#
	SET    Status        = '9'
	WHERE  Warehouse     = '#URL.Warehouse#' 
	AND    Location      = '#URL.Location#' 
	AND    Category      = '#url.category#'
	AND    Categoryitem  = '#url.categoryitem#'
	AND    Status       != '9' 
</cfquery>

<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Warehouse
	WHERE  Warehouse = '#url.Warehouse#'	
</cfquery>

<cfquery name="parameter" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#get.Mission#'	
</cfquery>

<cftransaction isolation="read_uncommitted">

<cfif Parameter.LotManagement eq "0">

		<cfquery name="LocData"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		INSERT INTO  userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc#
			       (TransactionIdOrigin,Warehouse,
				    Location,
					ItemNo,
					ItemNoExternal,
					ParentItemNo,
					ItemDescription,
					ItemPrecision,
					ItemLocationId,
					RequirementId,
					StandardCost,
					Classification,
					Category,
					CategoryItem,
					CategoryItemName,
					UoM,
					ItemBarCode,

					UoMDescription,												
					Metric,
					LocationLinked,
					Strapping,
					OnHand,
					Counted,
					ActualStock,
					Status)
				
		SELECT    NULL as TransactionIdOrigin,
		          L.Warehouse, 
		          L.Location,
				  L.ItemNo, 
				  I.ItemNoExternal,
				  I.ParentItemNo,
				  I.ItemDescription, 
				  I.ItemPrecision, 
				  L.ItemLocationId,		
				  '00000000-0000-0000-0000-000000000000',  
				  U.StandardCost,
				  I.Classification, 
				  I.Category,
				  CI.CategoryItem,
				  CI.CategoryItemName,
				  U.UoM, 
				  U.ItemBarCode,
				  U.UoMDescription,					
				  INV.Metric,
				  
				  ( SELECT   count(*) 
				    FROM     ItemWarehouseLocation 
				    WHERE    Warehouse = L.Warehouse 
				    AND      Location  = L.Location
				    AND      ItemNo    = L.ItemNo
				    AND      UoM       = L.UoM) as LocationLinked,
					
				  ( SELECT   count(*)
					FROM     ItemWarehouseLocationStrapping 
					WHERE    Warehouse = L.Warehouse
					AND      Location  = L.Location
					AND      ItemNo    = L.ItemNo
					AND      UoM       = L.UoM ) as Strapping,		
						   
				  ( SELECT ISNULL(SUM(T.TransactionQuantity),0)
				    FROM   ItemTransaction T 
				    WHERE  Warehouse = L.Warehouse 
				    AND    Location  = L.Location
				    AND    ItemNo    = L.ItemNo
				    AND    TransactionUoM = L.UoM					
					AND    TransactionDate <= #dte#)  AS OnHand, 
					
				  INV.Counted,
				  INV.ActualStock,
				  '1'
				  
		FROM      ItemUoM U INNER JOIN
	              Item I ON U.ItemNo = I.ItemNo INNER JOIN             
	              ItemWarehouseLocation L ON U.ItemNo = L.ItemNo and U.UoM = L.UoM LEFT OUTER JOIN
			      userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc# INV 
				  			ON  L.Warehouse = INV.Warehouse 
							AND L.Location  = INV.Location 
							AND L.ItemNo    = INV.ItemNo 
							AND L.UoM       = INV.UoM 
							
							INNER JOIN  Ref_CategoryItem CI ON I.Category = CI.Category AND I.CategoryItem = CI.CategoryItem INNER JOIN
				  Ref_Category C ON I.Category = C.Category  INNER JOIN
				  WarehouseLocation WL ON WL.Warehouse = L.Warehouse and WL.Location = L.Location 
		
		WHERE 	  L.Warehouse    = '#URL.Warehouse#'
		AND       L.Location     = '#URL.Location#'		
		AND       I.Category     = '#url.category#'
		AND       I.Categoryitem = '#url.categoryitem#'	
		<cfif URL.parentItemNo neq "">
			AND I.ParentItemNo = '#URL.parentItemNo#'
		</cfif>	
				
		AND       EXISTS (
		
				    SELECT 'X'
				    FROM   ItemTransaction T 
				    WHERE  Warehouse      = L.Warehouse 
				    AND    Location       = L.Location
				    AND    ItemNo         = L.ItemNo
				    AND    TransactionUoM = L.UoM) 
					
					
		AND       L.Operational  = 1	 	
		AND       WL.Operational = 1
		
		<!--- exclude in case the mode is not stock for individual items --->
		AND       C.StockControlMode = 'Stock' 	
							
		</cfquery>
		
<cfelse>

		
		<cfsavecontent variable="vwItemTransaction">
		
		<cfoutput>	    
					
		<cfif Parameter.EarmarkManagement eq "1">		
		
				    <!--- sale order --->
					SELECT       T.Mission,T.Warehouse, T.Location, T.ItemNo, T.TransactionUoM, T.TransactionLot, T.TransactionDate, T.TransactionId, 
					             T.RequirementId, W.Reference, WLI.WorkOrderId, WLI.WorkOrderLine, 
			                     'Sale' AS Class, T.TransactionQuantity		
								 						 
					FROM         WorkOrder.dbo.WorkOrder AS W INNER JOIN
					             WorkOrder.dbo.WorkOrderLineItem AS WLI ON W.WorkOrderId = WLI.WorkOrderId INNER JOIN
					             ItemTransaction AS T ON WLI.WorkOrderItemId = T.RequirementId
					WHERE        T.Warehouse   = '#url.warehouse#'
					AND          T.Mission     = '#get.Mission#'				    
				    AND          T.Location    = '#url.Location#'			 
								  
					UNION
					
					<!--- bom order --->
					SELECT       T.Mission,T.Warehouse, T.Location, T.ItemNo, T.TransactionUoM, T.TransactionLot,T.TransactionDate, T.TransactionId, 
					             T.RequirementId, W.Reference, WLI.WorkOrderId, WLI.WorkOrderLine, 
					             'BOM' AS Class, T.TransactionQuantity		
								 						  
					FROM         WorkOrder.dbo.WorkOrder AS W INNER JOIN
					             WorkOrder.dbo.WorkOrderLineResource AS WLI ON W.WorkOrderId = WLI.WorkOrderId INNER JOIN
					             ItemTransaction AS T ON WLI.ResourceId = T.RequirementId
					WHERE        T.Warehouse   = '#url.warehouse#'
					AND          T.Mission     = '#get.Mission#'				    
				    AND          T.Location    = '#url.Location#'			 
											
					UNION
					
					<!--- unlinked transaction --->
					SELECT       Mission,Warehouse, Location, ItemNo, TransactionUoM, TransactionLot, TransactionDate, TransactionId,
					             '00000000-0000-0000-0000-000000000000' as RequirementId, '' AS Expr1, NULL AS WorkOrderId, NULL AS WorkOrderLine, 
					             'Onhand' AS Class, TransactionQuantity								 
								 
					FROM         ItemTransaction AS T
					WHERE        T.Warehouse   = '#url.warehouse#'
					AND          T.Mission     = '#get.Mission#'				  
				    AND          T.Location    = '#url.Location#'			 
								  
					AND          NOT EXISTS  ( SELECT    'X'
					                           FROM      WorkOrder.dbo.WorkOrderLineResource
											   WHERE     ResourceId = T.RequirementId )		
											   										   
					AND   		 NOT EXISTS  ( SELECT    'X'
					                           FROM      WorkOrder.dbo.WorkOrderLineItem
											   WHERE     WorkOrderItemId = T.RequirementId)
					
					UNION
					
					SELECT        Mission,Warehouse, Location, ItemNo, TransactionUoM, TransactionLot, TransactionDate,TransactionId, 
					              '00000000-0000-0000-0000-0000000000000' as RequirementId, '' AS Expr1, NULL AS WorkOrderId, NULL AS WorkOrderLine, 
					              'Onhand' AS Class, TransactionQuantity
					FROM          ItemTransaction AS T
					WHERE         T.Warehouse   = '#url.warehouse#'
					AND           T.Mission     = '#get.Mission#'				   
				    AND           T.Location    = '#url.Location#'			 
								  
					AND           RequirementId IS NULL
									
											
			<cfelse>
			
				SELECT        Mission,
				              Warehouse, 
				              Location, 
							  ItemNo, 
							  TransactionUoM, 
							  TransactionLot, 
							  TransactionId, 
							  TransactionDate,
							  '00000000-0000-0000-0000-000000000000' as RequirementId, 
							  '' AS Expr1, 
							  NULL AS WorkOrderId, 
							  NULL AS WorkOrderLine, 
				              'Onhand' AS Class, 
							  TransactionQuantity
				FROM          ItemTransaction
				WHERE         Warehouse = '#url.warehouse#'
			
			</cfif>
						
			</cfoutput>
			
		</cfsavecontent>
			
		<cfsavecontent variable="getStock">
		
			<cfoutput>			
			
				   NULL as TransactionIdOrigin,
				   L.Warehouse, 
		           L.TransactionLot, 
				   NULL as TransactionReference,
				   L.Location, 
				   L.ItemNo, 
				   I.ItemNoExternal,
				   
				   L.Class,
				   L.WorkOrderId,
				   L.WorkOrderLine,
				   L.RequirementId,
				   
				   I.ItemDescription, 
				   I.ItemPrecision, 
				   S.ItemLocationId, 
				   U.StandardCost, 
				   I.Classification, 
				   I.Category, 
	               CI.CategoryItem, 
				   CI.CategoryItemName, 
				   U.UoM, 
				   U.ItemBarCode, 
				   U.UoMDescription, 
				   ROUND(SUM(L.TransactionQuantity),4) AS OnHand, 
				   INV.Metric, 
				   '1',						   
				   							  
					( SELECT   count(*)
					  FROM     ItemWarehouseLocationStrapping 
					  WHERE    Warehouse = L.Warehouse
					  AND      Location  = L.Location
					  AND      ItemNo    = L.ItemNo
					  AND      UoM       = U.UoM ) as Strapping,										  							
				   
				   INV.Counted, 
				   INV.ActualStock, 
	               '1'
							   
				   FROM       ItemUoM U 
				   			  INNER JOIN Item I ON U.ItemNo = I.ItemNo 
							  INNER JOIN (#preserveSingleQuotes(vwItemTransaction)#) as L ON U.ItemNo = L.ItemNo AND U.UoM = L.TransactionUoM 
							  
							  LEFT OUTER JOIN  userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc# INV 
							         ON  L.Warehouse      = INV.Warehouse 
									 AND L.Location       = INV.Location 
									 AND L.ItemNo         = INV.ItemNo 
									 AND L.TransactionUoM = INV.UoM 
									 AND L.TransactionLot = INV.TransactionLot 
									 AND L.RequirementId  = INV.RequirementId
							  INNER JOIN Ref_Category     C       ON I.Category = C.Category  
							  INNER JOIN Ref_CategoryItem CI      ON I.Category = CI.Category AND I.CategoryItem = CI.CategoryItem 
							  INNER JOIN ItemWarehouseLocation S  ON L.Warehouse      = S.Warehouse 
																 AND L.Location       = S.Location 
																 AND L.ItemNo         = S.ItemNo 
																 AND L.TransactionUoM = S.UoM 
							  INNER JOIN WarehouseLocation WL ON WL.Warehouse = L.Warehouse and WL.Location = L.Location 
							   
				   WHERE 	  L.Mission       = '#get.Mission#'
				   AND        L.Warehouse     = '#url.Warehouse#'
				   AND        L.Location      = '#url.Location#'
				   AND        I.Category      = '#url.category#'
				   AND        I.Categoryitem  = '#url.categoryitem#'
				   AND        L.TransactionDate <= #dte#
				   AND        S.Operational   = 1	
				   AND        WL.Operational  = 1 			
				   <cfif URL.parentItemNo neq "">
				   AND        I.ParentItemNo = '#URL.parentItemNo#'
				   </cfif>	
									
				   <!--- exclude in case the mode is not stock for individual items --->				
				   AND        C.StockControlMode = 'Stock'
		
				   GROUP BY   L.Warehouse, 
					           L.Location,
							   L.ItemNo, 
							   I.ItemNoExternal,
							   L.Class,
							   L.WorkOrderId,
							   L.WorkOrderLine,
							   L.RequirementId,
							   I.ItemDescription,
							   I.ItemPrecision, 
							   S.ItemLocationId, 
							   U.StandardCost, 
							   I.Classification, 
							   I.Category, 
							   CI.CategoryItem, 
		                       CI.CategoryItemName, 
							   U.UoM, 
							   U.ItemBarCode, 
							   U.UoMDescription, 
							   INV.Metric, 
							   INV.Counted, 
							   INV.ActualStock, 
							   S.ItemLocationId, 
							   L.TransactionLot 
							   							   
			</cfoutput>			   
		
		</cfsavecontent>
		
		<cfsavecontent variable="getIndividual">
		
				<cfoutput>
		
			           L.TransactionId as transactionidOrigin, 
			           L.Warehouse, 
					   L.TransactionLot, 
					   L.TransactionReference, 
					   L.Location, 
					   L.ItemNo, 
					   I.ItemNoExternal,
					   'Individual',
					   L.WorkOrderId,
					   L.WorkOrderLine,
					   L.RequirementId,
					   
					   I.ItemDescription, 
					   I.ItemPrecision, 
					   S.ItemLocationId, U.StandardCost, I.Classification, 
	                   I.Category, CI.CategoryItem, CI.CategoryItemName, U.UoM, U.ItemBarCode, U.UoMDescription, 
					   
					   (L.TransactionQuantity + (SELECT   ISNULL(SUM(TransactionQuantity), 0)
					                             FROM     ItemTransaction
	                				             WHERE    TransactionIdOrigin = L.TransactionId  
												 AND      TransactionDate <= #dte#)) AS OnHand, 															
						INV.Metric, 
						'0' AS Expr1,
						'0' AS Expr3, 
						INV.Counted, 
						INV.ActualStock, 
						'1' AS Expr2
						 
			FROM        ItemUoM U 
						INNER JOIN      Item I ON U.ItemNo = I.ItemNo 
						INNER JOIN      ItemTransaction L ON U.ItemNo = L.ItemNo AND U.UoM = L.TransactionUoM 
						LEFT OUTER JOIN userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc# INV ON L.TransactionId = INV.TransactionIdOrigin 
						INNER JOIN      Ref_Category C ON I.Category = C.Category 
						INNER JOIN      Ref_CategoryItem CI ON I.Category = CI.Category AND I.CategoryItem = CI.CategoryItem 
						INNER JOIN      ItemWarehouseLocation S ON L.Warehouse = S.Warehouse AND L.Location = S.Location AND L.ItemNo = S.ItemNo AND L.TransactionUoM = S.UoM 
						INNER JOIN      WarehouseLocation WL ON WL.Warehouse = L.Warehouse AND WL.Location = L.Location
			
			 WHERE 	    L.Mission = '#get.Mission#'
		     AND        L.Warehouse     = '#url.Warehouse#'
			 AND        L.Location      = '#url.Location#'
			 AND        I.Category      = '#url.category#'
			 AND        I.Categoryitem  = '#url.categoryitem#'
			 AND        L.TransactionDate <= #dte#
			 AND        S.Operational   = 1	
			 AND        WL.Operational  = 1 	
			<cfif URL.parentItemNo neq "">
				AND I.ParentItemNo = '#URL.parentItemNo#'
			</cfif>							 	
			
			 AND        C.StockControlMode = 'Individual' 
			 
			 AND        L.TransactionIdOrigin IS NULL 
			 
			 <!--- ----------------------------------------------------------------- --->
			 <!--- added provision for Fomtex where the used for a while an old mode --->
			 <!--- ----------------------------------------------------------------- --->
			 
			 AND        L.TransactionReference NOT IN
                             (SELECT    sT.TransactionReference
                               FROM     ItemTransaction AS sT INNER JOIN
                                        Ref_Category AS sR ON sT.ItemCategory = sR.Category
                               WHERE    sR.StockControlMode = 'Individual' 
							   AND      sT.Mission = '#get.Mission#'
                               GROUP BY sT.TransactionReference
                               HAVING   (ABS(SUM(sT.TransactionQuantity)) < 0.02)) 
							   
			 <!--- ----------------------------------------------------------------- --->				   
			 
			 </cfoutput>
					
		</cfsavecontent>
								
		<cfquery name="LocData"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			INSERT INTO  userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc#
			
					       (TransactionIdOrigin,
						    Warehouse,
						    TransactionLot,
							TransactionReference,
						    Location,							
							ItemNo,
							ItemNoExternal,
							ReservationClass,
							WorkOrderId,
							WorkOrderLine,
							RequirementId,
							
							ItemDescription,
							ItemPrecision,
							ItemLocationId,
							StandardCost,
							Classification,
							Category,
							CategoryItem,
							CategoryItemName,
							UoM,
							ItemBarCode,
							UoMDescription,
							OnHand,
							Metric,
							LocationLinked,
							Strapping,
							Counted,
							ActualStock,
							Status)
								
				SELECT     #preservesingleQuotes(getStock)#
				
				<!--- 20/10/2014 Hanno we only take items with a stock or items without stockremove but recently movements 
			      in ItemTransaction over the last 30 days --->						   
				  
				HAVING 	   SUM(round(L.TransactionQuantity,3)) <> 0		
																				  
				UNION				 
				
				SELECT     #preservesingleQuotes(getStock)#		
				
				 <!--- no provision for earmaked stuff --->
				 
						
				<!--- 20/10/2014 Hanno we only take items with a stock or items without stockremove but recently movements 
			      in ItemTransaction over the last 30 days --->
						   
				HAVING 	   L.ItemNo IN (SELECT DISTINCT ItemNo 
		                                FROM   ItemTransaction
									    WHERE  Warehouse      = '#url.warehouse#' 
									    AND    ItemNo         = L.ItemNo
									    AND    TransactionUoM = U.UoM
									    AND    TransactionDate > getdate()-30 )	AND L.WorkOrderId is NULL
																  
											  
				UNION     <!--- individual stock --->
				
				SELECT     #preservesingleQuotes(getIndividual)#
				
				AND        abs(L.TransactionQuantity -
	                           (SELECT    abs(ISNULL(SUM(TransactionQuantity), 0))
	                            FROM      ItemTransaction
	                            WHERE     TransactionIdOrigin = L.TransactionId)) > 0.02														  			 	   
																									   
				</cfquery>	
				
				<!---
				<cfoutput>query ins: #cfquery.executiontime#</cfoutput>
				--->
												
</cfif>		

</cftransaction>

<cftry>
	
	<cfquery name="Clean"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc#
		WHERE  Warehouse = '#URL.Warehouse#'
		AND    Location  = '#URL.Location#'
		AND    Status = '9'
	</cfquery>
	
	<cfquery name="Clean"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc#
		WHERE  Warehouse = '#URL.Warehouse#'
		AND    Location  = '#URL.Location#'
		AND    WorkOrderId is not NULL
		AND    OnHand = 0
	</cfquery>

	<cfcatch></cfcatch>
	
</cftry>	

<!---
<cfoutput>query del: #cfquery.executiontime#</cfoutput>
--->


