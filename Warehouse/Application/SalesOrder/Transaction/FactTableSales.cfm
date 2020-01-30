
<!--- fact table --->



<!--- control list data content --->

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
	
</cfif>		   

<cf_verifyOperational module = "WorkOrder" Warning   = "No">	

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_Sales">

<cfquery name="getUnit" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   
	SELECT T.Mission as Mission_dim,
			W.Warehouse as Warehouse_dim,
			W.WarehouseName as Warehouse_nme,
			C.Category as Category_dim,
			C.Description as Category_nme,
			SC.CategoryItemName as SubCategory_dim,
			SC.CategoryItemOrder as SubCategory_ord,
			CU.CustomerId as Customer_dim,
			CU.CustomerName as Customer_nme,
			I.ItemNo as Item_dim,
			I.ItemDescription as Item_nme,
			U.UoMDescription as Unit,
			Year(T.TransactionDate) as Year_dim,
			Month(T.TransactionDate) as Month_dim,
			CASE Month(T.TransactionDate)
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
			END AS Month_nme,
			Month(T.TransactionDate) as Month_ord,
			datediff(yy,CU.CustomerDOB,getdate()) as CustomerAge_dim,
			
			CU.CustomerDOB,
			CU.Reference,
			CU.PhoneNumber,
			CU.eMailAddress,
	
			(T.TransactionQuantity * (-1)) as TransactionQuantity,
			(T.TransactionValue * (-1)) as TransactionValue,
			S.SalesBaseAmount AS Sale, 
			S.SalesBaseAmount + T.TransactionValue AS GrossMargin
	
	  INTO  UserQuery.dbo.#SESSION.acc#_Sales
	
	  FROM  ItemTransaction T
		    INNER JOIN ItemTransactionShipping S ON T.TransactionId = S.TransactionId 
			INNER JOIN dbo.Warehouse W ON T.Warehouse = W.Warehouse
			INNER JOIN WarehouseBatch WB ON T.TransactionBatchNo = WB.BatchNo 
			INNER JOIN dbo.Item I ON T.ItemNo = I.ItemNo
			INNER JOIN dbo.Ref_Category C ON T.ItemCategory = C.Category
			INNER JOIN Ref_CategoryItem SC ON SC.Category = I.Category AND SC.CategoryItem = I.CategoryItem
			INNER JOIN dbo.Customer CU ON CU.CustomerId = T.CustomerId	
			INNER JOIN dbo.ItemUoM U ON U.ItemNo = I.ItemNo AND U.UoM = T.TransactionUoM
	  WHERE  T.TransactionType='2'
	  AND    T.Mission = '#url.mission#'
	  
	  <cfif globalmission neq "granted">
			
			 AND       P.MissionOrgUnitId IN
					
					           (					   
				                  SELECT DISTINCT MissionOrgUnitId 
				                  FROM   Organization.dbo.Organization
								  WHERE  OrgUnit IN (#quotedvalueList(accesslist.orgunit)#) 						 																			  
							   )	
				
			</cfif>
			
		<cfif client.trafilter eq "">	
		AND 1 = 0
		<cfelse>
  	    AND  WB.BatchNo IN (#preserveSingleQuotes(client.trafilter)#)		
		</cfif>
	 	  
	  <cfif operational eq "9999">
		
		UNION ALL	
		
		SELECT T.Mission as Mission_dim,
			W.Warehouse as Warehouse_dim,
			W.WarehouseName as Warehouse_nme,
			C.Category as Category_dim,
			C.Description as Category_nme,
			SC.CategoryItemName as SubCategory_dim,
			SC.CategoryItemOrder as SubCategory_ord,
			CU.CustomerId as Customer_dim,
			CU.CustomerName as Customer_nme,
			I.ItemNo as Item_dim,
			I.ItemDescription as Item_nme,
			U.UoMDescription as Unit,
			Year(T.TransactionDate) as Year_dim,
			Month(T.TransactionDate) as Month_dim,
			CASE Month(T.TransactionDate)
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
			END AS Month_nme,
			Month(T.TransactionDate) as Month_ord,
			datediff(yy,CU.Created,getdate()) as CustomerAge_dim,
			
			CU.Created,
			CU.Reference,
			CU.PhoneNumber,
			CU.eMailAddress,
	
			(T.TransactionQuantity * (-1)) as TransactionQuantity,
			(T.TransactionValue * (-1)) as TransactionValue,
			S.SalesBaseAmount AS Sale, 
			S.SalesBaseAmount + T.TransactionValue AS GrossMargin
	
		
	  FROM  ItemTransaction T
		    INNER JOIN ItemTransactionShipping S ON T.TransactionId = S.TransactionId 
			INNER JOIN dbo.Warehouse W ON T.Warehouse = W.Warehouse
			INNER JOIN WarehouseBatch WB ON T.TransactionBatchNo = WB.BatchNo 
			INNER JOIN dbo.Item I ON T.ItemNo = I.ItemNo
			INNER JOIN dbo.Ref_Category C ON T.ItemCategory = C.Category
			INNER JOIN Ref_CategoryItem SC ON SC.Category = I.Category AND SC.CategoryItem = I.CategoryItem
			INNER JOIN WorkOrder.dbo.WorkOrder Wo ON T.WorkOrderId = Wo.WorkOrderId 	  
	        INNER JOIN WorkOrder.dbo.Customer CU ON Wo.CustomerId = CU.CustomerId 			
			INNER JOIN dbo.ItemUoM U ON U.ItemNo = I.ItemNo AND U.UoM = T.TransactionUoM
	  WHERE  T.TransactionType IN ('2','3')
	  AND    T.Mission = '#url.mission#'
	  
	  		<cfif globalmission neq "granted">
			
			 AND       P.MissionOrgUnitId IN
					
					           (					   
				                  SELECT DISTINCT MissionOrgUnitId 
				                  FROM   Organization.dbo.Organization
								  WHERE  OrgUnit IN (#quotedvalueList(accesslist.orgunit)#) 						 																			  
							   )	
				
			</cfif>
			
	 <cfif client.trafilter eq "">	
		AND 1 = 0
		<cfelse>
  	    AND  WB.BatchNo IN (#preserveSingleQuotes(client.trafilter)#)		
		</cfif>
	    
      </cfif>
 
  </cfquery>	
      
  <cfset client.table1_ds = "#SESSION.acc#_Sales">