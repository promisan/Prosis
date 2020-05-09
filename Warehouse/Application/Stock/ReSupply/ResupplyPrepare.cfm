
<cfparam name="URL.Mission"     default = "">
<cfparam name="URL.Warehouse"   default = "Main">
<cfparam name="URL.Category"    default = "">
<cfparam name="URL.ItemNo"      default = "">
<cfparam name="URL.Mode"        default = "undefined">
<cfparam name="URL.Restocking"  default = "Procurement">


<!--- main warehouse 
	a. select mission
	b. define items on requisition (Materials.dbo.Request)
	c. define item on hand (Materials.dbo.ItemTransaction)
	d. define items on order (Purchase.dbo.RequisitionLine if not 9, if a PurchaseLine take purchase line -/- receiptLine quantities), 
	e. economical stock, compare with min-max)
	f. if needed, define quantity that >= to maximum stock (multiple of the Item.ReorderQuantity)
--->


<cfparam name="Form.ProgramCode"       default="">
<cfparam name="Form.Category"          default="">
<cfparam name="Form.CategoryItem"      default="">
<cfparam name="Form.Filter"            default="">
<cfparam name="Form.RestockingSelect"  default="">
<cfparam name="Form.RefreshContent"    default="0">

<cfif url.restocking eq "undefined">

	<cfset url.restocking = Form.RestockingSelect>

</cfif>

<cf_droptable dbname="AppsQuery" tblname="tmp#SESSION.acc#ItemOnHand">
<cf_droptable dbname="AppsQuery" tblname="tmp#SESSION.acc#ItemOnOrder">
<cf_droptable dbname="AppsQuery" tblname="tmp#SESSION.acc#ItemReceipt">

<head>
  <meta charset="UTF-8">
</head>

<cfset createtable = "0">

<cftry>

	<cfset dest = "userTransaction.dbo.StockResupply#URL.Warehouse#_#SESSION.acc#">

	<cfquery name="check" 
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT Created FROM #dest#
	</cfquery>	
	
	<cfquery name="check" 
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE #dest#
			SET Operational = 0
	</cfquery>	
	
	<cfcatch>
		
		<cfset createtable = "1">
		<cf_droptable dbname="AppsTransaction" tblname="StockResupply#URL.Warehouse#_#SESSION.acc#">
		
	</cfcatch>	

</cftry>

<cfif createtable eq "1">
	
	<cfquery name="Create" 
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		CREATE TABLE dbo.StockResupply#URL.Warehouse#_#SESSION.acc# (
		    [ItemNo]             [varchar] (20) NULL ,
			[Category]           [varchar] (20) NULL ,
			[CategoryItem]       [varchar] (50) NULL ,
			[ItemDescription]    [nvarchar] (200)  NULL ,
			[ItemDescriptionExternal] [nvarchar] (200)  NULL ,
			[Currency]           [varchar] (4)  NULL ,
			[Price]              [float] NULL ,
			[StandardCost]       [float] NULL ,
			[ItemPrecision]      [int] NULL ,
			[UoM]                [varchar] (20)  NULL ,
			[UoMDescription]     [varchar] (50) NULL ,
			[UoMMultiplier]      [float] NULL ,
			[ItemBarCode]        [varchar] (20) NULL,
			[Warehouse]          [varchar] (20)  NULL ,
			[Mission]            [varchar] (30)  NULL ,
			[MissionOrgUnitId]   [uniqueidentifier] NULL ,
			[ProgramCode]        [varchar] (20)  NULL , 
			[ItemMaster]         [varchar] (20)  NULL ,
			[hasVendor]          [smallint] NULL ,
			[hasOccurence]       [smallint] NULL ,
			[ReorderAutomatic]   [bit] NULL ,
			[MinimumStock]       [float] NULL ,
			[MaximumStock]       [float] NULL ,
			[MinReorderQuantity] [float] NULL ,
					
			[OnHand]             [float] NULL CONSTRAINT [DF_.StockResupply#URL.Warehouse#_#SESSION.acc#_1] DEFAULT (0) ,	
			
			<!--- external replenish --->
			[Requested]          [float] NULL CONSTRAINT [DF_.StockResupply#URL.Warehouse#_#SESSION.acc#_2] DEFAULT (0) ,				
			[OnOrder]            [float] NULL CONSTRAINT [DF_.StockResupply#URL.Warehouse#_#SESSION.acc#_3] DEFAULT (0) ,
			
			<!--- internal replenish --->
			[InternalDraft]      [float] NULL CONSTRAINT [DF_.StockResupply#URL.Warehouse#_#SESSION.acc#_9] DEFAULT (0) ,	
			[InternalRequested]  [float] NULL CONSTRAINT [DF_.StockResupply#URL.Warehouse#_#SESSION.acc#_7] DEFAULT (0) ,	
			
			<!--- requested or earmarked --->
			[Reserved]           [float] NULL CONSTRAINT [DF_.StockResupply#URL.Warehouse#_#SESSION.acc#_Reserved] DEFAULT (0) ,
			[Fulfilled]          [float] NULL CONSTRAINT [DF_.StockResupply#URL.Warehouse#_#SESSION.acc#_0] DEFAULT (0) ,	
			[Earmarked]          [float] NULL CONSTRAINT [DF_.StockResupply#URL.Warehouse#_#SESSION.acc#_8] DEFAULT (0) ,
			[Forecasted]         [float] NULL CONSTRAINT [DF_.StockResupply#URL.Warehouse#_#SESSION.acc#_9b] DEFAULT (0) ,
						
			[EconomicStock]      [float] NULL CONSTRAINT [DF_.StockResupply#URL.Warehouse#_#SESSION.acc#_4] DEFAULT (0),
			[ToBeRequested]      [float] NULL CONSTRAINT [DF_.StockResupply#URL.Warehouse#_#SESSION.acc#_5] DEFAULT (0),
			
			[Selected]           [bit] NULL ,
			[Operational]        [bit] NULL ,
			[OfficerUserid]      [varchar] (20) NULL ,
			[OfficerLastName]    [varchar] (40) NULL ,
			[OfficerFirstName]   [varchar] (30) NULL ,
			[Created]            [datetime] NOT NULL CONSTRAINT [DF_.StockResupply#URL.Warehouse#_#SESSION.acc#_11]  DEFAULT (getdate()),
			[LineNo]             [int] IDENTITY (1, 1) NOT NULL) 
			
	</cfquery>
	
	<cfquery name="CreateIndex" 
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		CREATE  INDEX [Item] 
		   ON dbo.StockResupply#URL.Warehouse#_#SESSION.acc#([ItemNo],[UoM],[Warehouse]) ON [PRIMARY]
	</cfquery>		
	
</cfif>	

<cfquery name="check" 
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 Created FROM #dest#
</cfquery>	

<cfif check.created lt now()-1 or form.refreshContent eq "1">
	
	<!--- freshly populate items --->	
	
	<cfquery name="clear" 
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM #dest#
	</cfquery>	
	
	<cfquery name="Item" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO #dest# 
			        (ItemNo,
					 Category,
					 CategoryItem,
					 ItemDescription,
					 ItemDescriptionExternal,
					 Currency,
					 Price,
					 StandardCost,
					 ItemPrecision,
					 UoM,
					 UoMDescription,
					 UoMMultiplier,
					 ItemBarCode,
				     Warehouse,
					 Mission,
					 MissionOrgUnitId,
					 ProgramCode,
					 ItemMaster,
					 hasVendor,
					 hasOccurence,
					 ReorderAutomatic,
				     MinimumStock,
					 MaximumStock,
					 MinReorderQuantity,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,
					 Selected,
					 Operational)
			SELECT    I.ItemNo, 
			          I.Category,
			          I.CategoryItem,	
					  I.ItemDescription,
					  I.ItemDescriptionExternal,	
					  '#Application.BaseCurrency#',
					  U.StandardCost,		  		       
					  U.StandardCost,
					  I.ItemPrecision,
					  U.UoM, 
					  U.UoMDescription,
					  U.UoMMultiplier,
					  U.ItemBarCode,
					  W.Warehouse,
					  Whs.Mission,
					  Whs.MissionOrgUnitId,
					  I.ProgramCode,
					  I.ItemMaster,
					  
					 (    SELECT    count(*)
						  FROM      ItemVendor 
						  WHERE     ItemNo = U.ItemNo 
						  AND       UoM    = U.UoM) as hasVendor,	
						  
					  (   SELECT    DISTINCT WarehouseItemNo
						  FROM      Purchase.dbo.RequisitionLine 
						  WHERE     WarehouseItemNo = U.ItemNo 
						  AND       WarehouseUoM    = U.UoM
						  <!--- UNION [workorder] --->
						  UNION
						  SELECT    DISTINCT ItemNo
						  FROM      ItemTransaction 
						  WHERE     ItemNo = U.ItemNo 
						  AND       TransactionUoM    = U.UoM
						  ) as hasOccurence,				
					  				  
					  W.ReorderAutomatic,
					  W.MinimumStock,
					  W.MaximumStock,
					  W.MinReorderQuantity,
					  I.OfficerUserId,
					  I.OfficerLastName,
					  I.OfficerFirstName,
					  '0' as Selected,
					  '1'
					  
			FROM      #CLIENT.LanPrefix#Item I, 
					  ItemUoM U,
			          ItemWarehouse W, 
					  Warehouse Whs, 
					  #CLIENT.LanPrefix#Ref_Category R,
					  Purchase.dbo.ItemMaster M
					  
			WHERE     I.ItemNo        = U.ItemNo
			AND       U.ItemNo        = W.ItemNo
			AND       U.Uom           = W.UoM
			AND       M.Code          = I.ItemMaster
			AND       W.Warehouse     = '#URL.Warehouse#' 
			AND       W.Warehouse     = Whs.Warehouse
			AND       I.ItemNo        = U.ItemNo
			AND       I.Category      = R.Category
			
			AND       I.Operational   = 1
			AND       W.Operational   = 1
			
			AND       W.Restocking    = '#URL.Restocking#'  
			
			AND       I.ItemClass     = 'Supply' <!--- only supply items --->	
															
	</cfquery>
		
</cfif>		

	<cfquery name="clear" 
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE #dest# 
		SET    Operational = 0
	</cfquery>	

	<cfquery name="Update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
		UPDATE #dest# 
		SET    Operational = 1
		
		<!--- valid in the selection --->
		
		WHERE ItemNo IN (	

	        SELECT    I.ItemNo
			FROM      #CLIENT.LanPrefix#Item I, 
					  ItemUoM U,
			          ItemWarehouse W, 
					  Warehouse Whs, 
					  #CLIENT.LanPrefix#Ref_Category R
					  
			WHERE     I.ItemNo        = U.ItemNo
			AND       U.ItemNo        = W.ItemNo
			AND       U.Uom           = W.UoM
			AND       W.Warehouse     = '#URL.Warehouse#' 
			AND       W.Warehouse     = Whs.Warehouse
			AND       I.ItemNo        = U.ItemNo
			AND       I.Category      = R.Category
			
			AND       I.Operational   = 1
			AND       W.Operational   = 1
			
			AND       W.Restocking    = '#URL.Restocking#'  
			
			AND       I.ItemClass     = 'Supply' <!--- only supply items --->	
			
			<cfif URL.ItemNo neq "">
			AND       I.ItemNo        = '#URL.Item#' 
			<cfelseif Form.Category neq "">
			AND       R.Category      IN (#preserveSingleQuotes(Form.Category)#)  	
			</cfif>
			
			<cfif Form.CategoryItem neq "">
			AND       I.CategoryItem IN (#preserveSingleQuotes(Form.CategoryItem)#)  
			</cfif>
			
			<cfif Form.ProgramCode neq "">
			AND       I.ProgramCode IN (#preserveSingleQuotes(Form.ProgramCode)#)  
			</cfif>
			
			<cfif Form.filter neq "">				
			AND      (I.ItemDescription        LIKE '%#form.filter#%' 
			      or I.ItemDescriptionExternal LIKE N'%#form.filter#%' 
				  or I.ItemNoExternal          LIKE '%#form.filter#%' 
				  or U.ItemBarCode             LIKE '%#form.filter#%'
				  or U.UoMDescription          LIKE '%#form.filter#%'
				  or I.OfficerLastName         LIKE '%#form.filter#%')
			</cfif>
							
			)
							
	</cfquery>
		
			

<!--- capture for next time --->

<cfset resupply.category    = form.category>
<cfset resupply.programcode = form.programcode>

<cfset session.mysupply = resupply>

<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    TOP 1 ItemNo
	FROM      #dest#	
</cfquery>

<!--- we start reviewing the CURRENT stock content to reflect accurate stock values --->

<cfif get.recordcount gt "0" and url.mode neq "filter">

<!--- ON HAND --->

<cfquery name="OnHand" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    ItemNo,
	          TransactionUoM as UoM, 
			  Warehouse, 
			  SUM(TransactionQuantity) AS Total
	INTO      userQuery.dbo.tmp#SESSION.acc#ItemOnHand
	FROM      ItemTransaction
	WHERE     Warehouse = '#URL.Warehouse#' 
	AND       ItemNo IN (SELECT    ItemNo
						 FROM      #dest#)
	GROUP BY  ItemNo, TransactionUoM, Warehouse
</cfquery>

<cfquery name="UpdateBalance" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE    #dest#
	SET       OnHand      = R.Total
	FROM      #dest# I, tmp#SESSION.acc#ItemOnHand R
	WHERE     I.ItemNo    = R.ItemNo
	AND       I.UoM       = R.UoM
	AND       I.Warehouse = R.Warehouse
</cfquery>

<!--- 2. TO RECEIVE --->

<!--- 2.1 on replenish order to main warehouse --->

<cfquery name="DraftToMainWarehouse" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    UPDATE    #dest#
	SET       InternalDraft = R.Requested 
	FROM      #dest# I, 
	
			 (
			
			  SELECT  ItemNo, 
					UoM, 
					ShipToWarehouse, 
					SUM(RequestedQuantity) as Requested
					
			  FROM    (
	
				  SELECT    ItemNo, 
				            UoM, 
					 	    ShipToWarehouse, 
						    RequestedQuantity		
				  FROM      Request V
				  WHERE     Warehouse      != '#URL.Warehouse#' 
	        	  AND       ShipToWarehouse = '#URL.warehouse#'				  
				  AND       Status IN ('i')				
				  AND       RequestType = 'Warehouse' <!--- exclude intra warehouse resupply requests : TO BE REVIEWED --->
				  			  
			  ) as myTable
			 
			 GROUP BY  ItemNo, UoM, ShipToWarehouse			 
			 
			 ) as R
		 
	WHERE     I.ItemNo    = R.ItemNo
	AND       I.UoM       = R.UoM
	AND       I.Warehouse = R.ShipToWarehouse	 
						 
</cfquery>

<cfquery name="OrderToMainWarehouse" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    UPDATE    #dest#
	SET       InternalRequested = R.Ordered - R.Fullfilled
	FROM      #dest# I, 
	
			 (
			
			  SELECT  ItemNo, 
					UoM, 
					ShipToWarehouse, 
					SUM(RequestedQuantity) as Ordered,
					SUM(Fullfilled) as Fullfilled
					
			  FROM    (
	
				  SELECT    ItemNo, 
				            UoM, 
					 	    ShipToWarehouse, 
						    RequestedQuantity,
							 (SELECT ISNULL(SUM(TransactionQuantity),0)
							  FROM   ItemTransaction T
							  WHERE  T.RequestId = V.RequestId
							  AND    T.Warehouse = '#url.warehouse#'
							  AND    T.TransactionQuantity > 0) as Fullfilled				
				  FROM      Request V
				  WHERE     Warehouse      != '#URL.Warehouse#' 
	        	  AND       ShipToWarehouse = '#URL.warehouse#'				  
				  AND       Status IN ('2','2b')
				  <!---
				  AND       (Status < '3'  or Status = '2b' or Status = 'i')
				  --->
				  AND       RequestType = 'Warehouse' <!--- exclude intra warehouse resupply requests : TO BE REVIEWED --->
				  			  
			  ) as myTable
			 
			 GROUP BY  ItemNo, UoM, ShipToWarehouse			 
			 
			 ) as R
		 
	WHERE     I.ItemNo    = R.ItemNo
	AND       I.UoM       = R.UoM
	AND       I.Warehouse = R.ShipToWarehouse	 
			 
</cfquery>

<!--- 2.2 on procurement request --->

<cfquery name="OnProcurementRequest" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE    #dest#
	SET       Requested = R.Total
	FROM      #dest# I, 
	
			  (
			    SELECT    WarehouseItemNo as ItemNo, 
				          WarehouseUoM as WarehouseUoM, 
						  Warehouse, 
						  SUM(RequestQuantity) AS Total	
				FROM      Purchase.dbo.RequisitionLine
				WHERE     Mission         = '#URL.Mission#'
				AND       Warehouse       = '#url.warehouse#'				
				AND       ActionStatus >= '1' AND  ActionStatus < '3'
				GROUP BY  WarehouseItemNo, WarehouseUoM, Warehouse  ) as R	
	
	WHERE     I.ItemNo    = R.ItemNo
	AND       I.UoM       = R.WarehouseUoM
	AND       I.Warehouse = R.Warehouse 
	
</cfquery>

<!--- 2.3 on procurement order, AN ISSE TO ADDRESS is that posting of the receipt might not have occurred yet as this
is a batch !!!!!!!!!!!!  --->

<cfquery name="OnProcurementOrder" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE    #dest#
	SET       OnOrder = R.OnOrder - R.OnOrderReceipt
	FROM      #dest# I, 
	
	        (
			 SELECT  ItemNo, 
			         UoM, 
				 	 Warehouse, 
					 SUM(OnOrder) AS OnOrder,
					 SUM(OnOrderReceipt) as OnOrderReceipt
					 
			 FROM	(
				 
					 SELECT   R.WarehouseItemNo as ItemNo, 
					          R.WarehouseUoM as UoM, 
							  R.Warehouse, 					  
							  OrderQuantity*OrderMultiplier AS OnOrder,
							  
							  (SELECT ISNULL(SUM(ReceiptQuantity*ReceiptMultiplier),0) 
							   FROM   Purchase.dbo.PurchaseLineReceipt PLR
							   WHERE  RequisitionNo = P.RequisitionNo
							   AND    PLR.ActionStatus != '9') as OnOrderReceipt 
						
					FROM      Purchase.dbo.RequisitionLine R, 
					          Purchase.dbo.PurchaseLine P
					WHERE     R.Mission         = '#URL.Mission#'
					AND       R.Warehouse       = '#url.warehouse#'
					AND       R.RequisitionNo   = P.RequisitionNo					
					AND       R.ActionStatus    = '3'   <!--- on purchase order --->
					AND       P.ActionStatus    != '9'  <!--- not cancelled --->
					AND       P.DeliveryStatus  != '3'  <!--- set as fully delivered, then we ignore it ---> 
			
			        ) as MyTable
			   		
			GROUP BY  ItemNo, UoM, Warehouse ) as R
			
	WHERE     I.ItemNo    = R.ItemNo
	AND       I.UoM       = R.UoM
	AND       I.Warehouse = R.Warehouse
	
</cfquery>

<cfquery name="CorrectBalance" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE    #dest#
	SET       OnOrder = 0
	WHERE     OnOrder < 0
</cfquery>

<!--- 3. TO ISSUE --->

<!--- 3.1 item on request from users / customers --->

<cfquery name="RequestedCustomer" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    UPDATE  #dest#
	SET     Reserved  = R.Requested,
	        Fulfilled = R.Fullfilled
			
	FROM    #dest# I, 
	
	        (
			
			SELECT  ItemNo, 
					UoM, 
					Warehouse, 
					SUM(RequestedQuantity) as Requested,
					SUM(Fullfilled) as Fullfilled
					
			FROM    (
			
			         SELECT    ItemNo, 
					           UoM, 
							   Warehouse, 
							   RequestedQuantity,
							   
							   (SELECT ISNULL(SUM(TransactionQuantity*-1),0)
							    FROM   ItemTransaction T
								WHERE  T.RequestId = V.RequestId
								AND    T.Warehouse = '#url.warehouse#'
								AND    T.TransactionQuantity < 0) as Fullfilled							   
							   
					 FROM      Request V
					 WHERE     Warehouse = '#URL.Warehouse#' 					 
					 AND       Status IN ('2','2b')
					 <!---
					 AND       (Status < '3' or Status = '2b' or Status = 'i')           <!--- status 3 is fully received --->
					 --->
					 <!--- AND       ShipToWarehouse is NULL --->
					 AND       RequestType IN ('Pickticket','Warehouse') 
					 		
					 ) as myTable
			 
			 GROUP BY  ItemNo, UoM, Warehouse			 
			 
			 ) as R
			 		 
	WHERE    I.ItemNo    = R.ItemNo
	AND      I.UoM       = R.UoM
	AND      I.Warehouse = R.Warehouse	 
	 
</cfquery>


<!--- 3.2. earmarked from workorder 

Deduct stock on hand for an item with has been earmarked to a workorder/line and thus is no longer
free stock

--->


<!--- 3.3 To be consumed based on forecasted workorder requirements 

deduct stock on hand, that based on a sales forecast is no longer to be counted on as free, 
this is pending, the raw materials company seemed to be a good candidate, but also Fomtex
in which the flattened BOM for a sales item, allows you to anticipate shortages in Raw materials

--->

<!--- 4. Economic --->

<cfquery name="UpdateEconomicStock" 
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE    #dest#
	SET       EconomicStock = OnHand+InternalRequested+Requested+OnOrder-(Reserved-fulfilled)-Earmarked 
</cfquery>

<cfif createtable eq "1">
	
	<cfquery name="UpdateRequest1" 
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE    #dest#
		SET       ToBeRequested = MaximumStock-EconomicStock
		
		UPDATE    #dest#
		SET       ToBeRequested = 0
		WHERE     ToBeRequested < 0
		
		UPDATE    #dest# 
		SET       ToBeRequested = ceiling(ToBeRequested/MinReorderQuantity)*MinReorderQuantity
		WHERE     ToBeRequested < MinReorderQuantity 
		AND       MinimumStock <= Maximumstock and MaximumStock >= 0	
		AND       MinReorderQuantity > 0 
		
		UPDATE    #dest#
		SET       ToBeRequested = InternalDraft
		WHERE     InternalDraft != '0'
		
	</cfquery>
		
</cfif>	

</cfif>

<cf_droptable dbname="AppsQuery" tblname="tmp#SESSION.acc#ItemReserve">
<cf_droptable dbname="AppsQuery" tblname="tmp#SESSION.acc#ItemFulfilled">
<cf_droptable dbname="AppsQuery" tblname="tmp#SESSION.acc#ItemOnHand">


<cfinclude template="ResupplyListing.cfm">

<script>
	 Prosis.busy('no')
</script>
		