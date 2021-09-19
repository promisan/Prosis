
	
	<CF_DropTable dbName="AppsQuery"  tblName="StockBatch_#SESSION.acc#"> 
		
	<cfquery name="Create"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		CREATE TABLE dbo.StockBatch_#SESSION.acc# (
			[BatchNo]                 [int] NULL ,
			[BatchReference]          [varchar] (50) NULL ,
			[TransactionType]         [varchar] (2) NULL ,
			[Description]             [varchar] (100) NULL ,
			[DeliveryMode]            [bit] NULL,
			[Category]                [varchar] (100) NULL ,
			[LocationDescription]     [varchar] (100) NULL ,
			[BatchDescription]        [varchar] (80)  NULL ,
			[TransactionDate]         [date] NULL ,
			[TransactionStatusDate]   [date] NULL ,
			[ActionStatus]            [varchar] (2) NULL ,
			[ContraWarehouse]         [varchar] (60)  NULL ,
			[CustomerId]              [uniqueidentifier] NULL ,
			[CustomerName]            [varchar] (100) NULL ,
			[Quantity]                [int] NULL ,
			[Lines]                   [int] NULL ,
			[Cleared]                 [int] NULL ,
			[Amount]                  [float] NULL ,
			[OfficerUserId]           [varchar] (20) NULL ,
			[OfficerLastName]         [varchar] (40) NULL ,
			[OfficerFirstName]        [varchar] (30) NULL ,
			[Created]                 [datetime] NULL ,			
			[ProcessStatus]           [varchar] (20) NULL )
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
	
	SELECT *, CASE WHEN Lines > Cleared THEN '0' ELSE '1' END as Status
	
	FROM (
	
		SELECT     B.BatchNo, 
		           B.BatchReference,
		           R.TransactionType, 
				   R.Description, 	
				   B.DeliveryMode,	
				   	
				   (SELECT  Description FROM Ref_Category WHERE Category = B.Category) as A,   					   
				   (SELECT  Description FROM WarehouseLocation WHERE warehouse = '#URL.Warehouse#' AND Location = B.Location) as B,	
				   
				   B.BatchDescription, 
				   
				   B.TransactionDate,
				   			   		   
				   (CASE WHEN B.ActionOfficerDate is NULL THEN B.TransactionDate ELSE B.ActionOfficerDate END) as ActionOfficerDate,
				  	 			   
				   <!---			   
				   (SELECT TOP 1 CONVERT(VARCHAR(10),TransactionDate,126) FROM ItemTransaction#suff# WHERE TransactionBatchNo = B.BatchNo ORDER BY TransactionDate DESC ) as TransactionDate,				   
				   --->
				   
				   B.ActionStatus,		
				   
				   (ISNULL((SELECT  TOP 1 TW.WarehouseName
				    FROM    ItemTransaction AS T WITH (NOLOCK) INNER JOIN Warehouse AS TW ON T.Warehouse = TW.Warehouse
				    WHERE   T.TransactionBatchNo = B.BatchNo AND T.Warehouse <> '#url.warehouse#'),'- Internal -')) as ContraWarehouse,
				   
				  				   
				   B.CustomerId,
				   
				   (SELECT CustomerName FROM Customer WHERE CustomerId = B.CustomerId) as C,			   
				  
				   (SELECT  SUM(TransactionQuantity) FROM ItemTransaction#suff# WITH (NOLOCK) WHERE TransactionBatchNo = B.BatchNo) as Quantity,			   			    
				   (SELECT  count(*)                 FROM ItemTransaction#suff# WITH (NOLOCK) WHERE TransactionBatchNo = B.BatchNo) as Lines,	
				   (SELECT  count(*)                 FROM ItemTransaction#suff# WITH (NOLOCK) WHERE TransactionBatchNo = B.BatchNo and ActionStatus='1') as Cleared,				  			   	   
				   (SELECT  SUM(TransactionValue)    FROM ItemTransaction#suff# WITH (NOLOCK) WHERE TransactionBatchNo = B.BatchNo) as Amount,
				 
	          	   B.OfficerUserId, 
				   B.OfficerLastName, 
	               B.OfficerFirstName,
				   B.Created
				   			   
	     FROM      WarehouseBatch B WITH (NOLOCK) INNER JOIN
	               Ref_TransactionType R ON B.TransactionType = R.TransactionType 
		 WHERE     (B.Warehouse     = '#URL.Warehouse#' OR B.BatchWarehouse = '#url.warehouse#')			
		 AND       B.ActionStatus  = '#URL.Status#' 
		
		 AND       B.BatchNo IN (SELECT TransactionBatchNo 
		                         FROM   ItemTransaction#suff# WITH (NOLOCK) 
								 WHERE  TransactionBatchNo = B.BatchNo)
						 
	 ) as B
	 
	 WHERE 1=1 	 
	 
	</cfquery>
		
	
	
	