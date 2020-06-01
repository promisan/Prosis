
<!--- control list data content --->

<cfquery name="Param" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	  *
	FROM   	  Ref_ParameterMission
	WHERE  	  Mission = '#url.Mission#'							
</cfquery>		

<cfquery name="getWarehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	  *
	FROM   	  Warehouse
	WHERE  	  Warehouse = '#url.warehouse#'							
</cfquery>		

<cfparam name="url.filterwarehouse"   default="0">	
<cfparam name="url.location"          default="">	
<cfparam name="Form.TransactionLot"   default="">		
<cfparam name="Form.Location"         default="#url.location#">		
<cfparam name="Form.Category"         default="">				
	
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

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#_OnHandTransaction"> 
    
	<cfquery name="getDataInMemory" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 		
		
		SELECT     T.TransactionId,
		           T.Warehouse, 
		           T.Location, 
				   W.WarehouseName, 
				   WL.Description AS LocationName, 
				   R.Category, 
				   R.Description AS CategoryName, 
				   T.ItemNo, 
				   T.ItemDescription, 
				   U.UoMDescription,
                   T.TransactionDate, 
				   T.TransactionLot, 
				   T.TransactionReference, 
				   T.TransactionQuantity,
                          (SELECT     ISNULL(SUM(TransactionQuantity*-1), 0)
                            FROM          ItemTransaction
                            WHERE      TransactionidOrigin = T.TransactionId) AS QuantityUsed,
							
							T.TransactionQuantity +   (SELECT     ISNULL(SUM(TransactionQuantity), 0)
                            FROM          ItemTransaction
                            WHERE      TransactionidOrigin = T.TransactionId) AS QuantityOnHand
		
		INTO 	   userQuery.dbo.#SESSION.acc#_OnHandTransaction	
							
		FROM       ItemTransaction T INNER JOIN
                   Warehouse W ON T.Warehouse = W.Warehouse INNER JOIN
                   WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location INNER JOIN
                   Ref_Category R ON T.ItemCategory = R.Category INNER JOIN
				   ItemUoM U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM	
				   
		WHERE      T.Mission = '#url.mission#'
		
		AND        R.StockControlMode = 'Individual'
		
		AND        T.TransactionIdOrigin IS NULL
					
		<cfif url.filterwarehouse eq "1">
		 
		 AND       T.Warehouse = '#url.warehouse#'	 
		 
		<cfelse>
		 		   
			<cfif globalmission neq "granted">
			
			 AND       W.MissionOrgUnitId IN
					
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
		AND    T.TransactionLot = '#Form.TransactionLot#'					 
		 </cfif>	
		
		GROUP BY   T.TransactionId,
		           T.ItemNo, 
		           T.ItemDescription, 
				   U.UoMDescription,
				   T.TransactionDate, 
				   T.TransactionReference, 
				   T.TransactionQuantity, 
				   T.TransactionId, 
				   T.Warehouse, 
				   T.Location, 
				   T.TransactionLot, 
                   W.WarehouseName, 
				   WL.Description, 
				   R.Category, 
				   R.Description
					  
		HAVING     (T.TransactionQuantity >
                          (SELECT    ISNULL(SUM(TransactionQuantity * - 1), 0)
                            FROM     ItemTransaction
                            WHERE    TransactionidOrigin = T.TransactionId))
		
		
		<!---
	
		 SELECT    S.*,	           
		           I.ItemDescription,
				   P.WarehouseName,
				   W.Description + ' - '+W.StorageCode AS Description, 	
				   U.ItemBarCode,		   
				   U.UoMDescription,
				   
				   #preservesinglequotes(onhand)# AS OnHand, 
	               #preservesinglequotes(onhandpending)# AS OnHandPending,  
				  				
				   (SELECT   SUM(TransactionValue)
	                FROM     ItemTransaction
					WHERE    Mission        = '#getWarehouse.mission#'
	                AND      Warehouse      = S.Warehouse 
				    AND      Location       = S.Location 
				    AND      ItemNo         = S.ItemNo 
				    AND      TransactionUoM = S.UoM				
					<cfif Form.TransactionLot neq "">
					AND     TransactionLot = '#Form.TransactionLot#'
					</cfif>	
					) AS OnHandValue,					 
						 
					(CASE  WHEN MinimumStock > #preservesinglequotes(onhand)#  THEN 'Replenish'
	                       WHEN MinimumStock = #preservesinglequotes(onhand)#  THEN 'Alert'
					  ELSE 'Good' END) as Status				  
		          		   
		 INTO 	   userQuery.dbo.#SESSION.acc#_OnHand			   
		 FROM      ItemWarehouseLocation S 
		           INNER JOIN Item I ON S.ItemNo = I.ItemNo 
				   INNER JOIN ItemUoM U ON I.ItemNo = U.ItemNo AND S.UoM = U.UoM 
				   INNER JOIN WarehouseLocation W ON S.Warehouse = W.Warehouse AND S.Location = W.Location 
				   INNER JOIN Warehouse P ON P.Warehouse = S.Warehouse
				   INNER JOIN Ref_Category C ON C.Category = I.Category
		
		 WHERE     P.Mission = '#url.mission#'
		 AND       C.StockControlMode = 'Stock'
		 	 
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
		 AND       S.Location  = '#form.location#'			 		 
		</cfif>	
		 
		<cfif form.category neq "">	 	 	 
		 AND       S.ItemNo IN (SELECT ItemNo 
		                        FROM   Item 
								WHERE  Category = '#Form.Category#')				 
		</cfif>	
		 
		<cfif form.Transactionlot neq "">	
		 
		 <!--- only items that have this lot somehow --->
		 AND      EXISTS  (
		 				   SELECT  'X'
		                   FROM    ItemTransaction
						   WHERE   Warehouse      = S.Warehouse 
					       AND     Location       = S.Location 
					       AND     ItemNo         = S.ItemNo 
					       AND     TransactionUoM = S.UoM
						   AND     TransactionLot = '#Form.TransactionLot#'					   
						   )
		 
		 </cfif>
		 
		 --->
		 
	
	</cfquery>	 
	

<table width="99%" align="center" style="height:100%;" class="formpadding">	
	<tr>
		<td align="right" height="100%">		
		   <cfinclude template="ListingDataContent.cfm">					
		</td>
	</tr>					
</table>
