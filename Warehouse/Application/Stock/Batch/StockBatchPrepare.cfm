
<cfparam name="URL.Fnd"               default="">
	
	<CF_DropTable dbName="AppsQuery"  tblName="StockBatch_#SESSION.acc#"> 
		
	<cfquery name="Create"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		CREATE TABLE dbo.StockBatch_#SESSION.acc# (
			[BatchNo] [int] NULL ,
			[BatchReference] [varchar] (30) NULL ,
			[TransactionType] [varchar] (2) NULL ,
			[Description] [varchar] (100) NULL ,
			[DeliveryMode] [bit] NULL,
			[Category] [varchar] (100) NULL ,
			[LocationDescription] [varchar] (100) NULL ,
			[BatchDescription] [varchar] (80)  NULL ,
			[TransactionDate] [datetime] NULL ,
			[ActionStatus] [varchar] (2) NULL ,
			[ContraWarehouse] [varchar] (60)  NULL ,
			[CustomerId] [uniqueidentifier] NULL ,
			[CustomerName] [varchar] (100) NULL ,
			[Quantity] [int] NULL ,
			[Lines]    [int] NULL ,
			[Cleared]  [int] NULL ,
			[Amount]   [float] NULL ,
			[OfficerUserId] [varchar] (20) NULL ,
			[OfficerLastName] [varchar] (40) NULL ,
			[OfficerFirstName] [varchar] (30) NULL ,
			[Created] [datetime] NULL ,
			[Detail] [varchar] (1) NULL )
	</cfquery>
	
	<!--- main records --->
	
	<cfif url.status eq "9">
	     <cfset suff = "Deny">
	<cfelse>
	     <cfset suff = "">  
	</cfif>
			
	<cfquery name="getData"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
	INSERT INTO userQuery.dbo.StockBatch_#SESSION.acc#
	
	SELECT     B.BatchNo, 
	           B.BatchReference,
	           R.TransactionType, 
			   R.Description, 	
			   B.DeliveryMode,	
			   	
			   (SELECT  Description FROM Ref_Category WHERE Category = B.Category),   			   
			   
			   (SELECT  Description FROM WarehouseLocation WHERE warehouse = '#URL.Warehouse#' AND Location = B.Location),	
			   
			   B.BatchDescription, 
			   			   		   
			   CONVERT(VARCHAR(10),B.TransactionDate,126),  
					   			   
			   <!---			   
			   (SELECT TOP 1 CONVERT(VARCHAR(10),TransactionDate,126) FROM ItemTransaction#suff# WHERE TransactionBatchNo = B.BatchNo ORDER BY TransactionDate DESC ) as TransactionDate,				   
			   --->
			   
			   B.ActionStatus,		
			   
			   (SELECT  TOP 1 TW.WarehouseName
			   FROM    ItemTransaction AS T WITH (NOLOCK) INNER JOIN Warehouse AS TW ON T.Warehouse = TW.Warehouse
			   WHERE   T.TransactionBatchNo = B.BatchNo AND T.Warehouse <> B.Warehouse) as ContraWarehouse,
			   
			   B.CustomerId,
			   
			   (SELECT CustomerName FROM Customer WHERE CustomerId = B.CustomerId),			   
			  
			   (SELECT  SUM(TransactionQuantity) FROM ItemTransaction#suff# WITH (NOLOCK) WHERE TransactionBatchNo = B.BatchNo) as Quantity,			   			    
			   (SELECT  count(*)                 FROM ItemTransaction#suff# WITH (NOLOCK) WHERE TransactionBatchNo = B.BatchNo) as Lines,	
			   (SELECT  count(*)                 FROM ItemTransaction#suff# WITH (NOLOCK) WHERE TransactionBatchNo = B.BatchNo and ActionStatus='1') as Cleared,				  			   	   
			   (SELECT  SUM(TransactionValue)    FROM ItemTransaction#suff# WITH (NOLOCK) WHERE TransactionBatchNo = B.BatchNo) as Amount,
			 
          	   B.OfficerUserId, 
			   B.OfficerLastName, 
               B.OfficerFirstName,
			   B.Created,
			   '0' 
			   
     FROM      WarehouseBatch B WITH (NOLOCK) INNER JOIN
               Ref_TransactionType R ON B.TransactionType = R.TransactionType 
	 WHERE     (B.Warehouse     = '#URL.Warehouse#' OR B.BatchWarehouse = '#url.warehouse#')			
	 AND       B.ActionStatus  = '#URL.Status#' 
	
	 AND       B.BatchNo IN (SELECT TransactionBatchNo 
	                         FROM   ItemTransaction#suff# WITH (NOLOCK) 
							 WHERE  TransactionBatchNo = B.BatchNo)
						 
		 
	</cfquery>
				
	<!--- grouping records 
	
	<cfswitch expression = "#URL.Group#">
	
	     <cfcase value = "TransactionDate">
		 
		 --->
		 
			<cfquery name="Grouping"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO userQuery.dbo.StockBatch_#SESSION.acc#
					(TransactionDate,Detail)
			SELECT DISTINCT  CONVERT(VARCHAR(10),B.TransactionDate,126),'1'
			FROM      WarehouseBatch B WITH (NOLOCK) INNER JOIN
                      Ref_TransactionType R ON B.TransactionType = R.TransactionType INNER JOIN
                      ItemTransaction#suff# I WITH (NOLOCK) ON B.BatchNo = I.TransactionBatchNo
	        WHERE     B.Warehouse = '#URL.Warehouse#'				
			AND       B.ActionStatus  = '#URL.Status#'
			AND       (R.Description LIKE '%#URL.fnd#%' or B.BatchNo LIKE '%#URL.fnd#%')
      	  </cfquery>
		  
		  <!---
		 </cfcase>	
					
	</cfswitch>
	
	--->	
	