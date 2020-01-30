
<!--- Hanno : pending precision --->

<!---
<cftransaction action="BEGIN">
--->

<!--- step 1 of 8 remove deactivated items from warehouse & location, this will NOT affect the ItemTransaction table --->

<cfquery name="CheckLocation" 
datasource="AppsMaterials">
	DELETE ItemWarehouse
	FROM   ItemWarehouse IM
	WHERE  ItemNo IN (
	                   SELECT ItemNo 
	                   FROM   Item 				 
			 		   WHERE  ItemNo = IM.ItemNo
					   AND    Operational = 0
					 )
</cfquery>

<!--- step 2 of 8 apply precision levels, which we need to be cautious as it would affect financials --->

<cfquery name="CheckLocation" 
   datasource="AppsMaterials">
	UPDATE  ItemTransaction
	SET     TransactionQuantity  = ROUND(TransactionQuantity, I.ItemPrecision),
	
	        TransactionCostprice = ROUND(TransactionCostPrice, 2),
			TransactionValue     = ROUND(TransactionValue, 2)
			
	FROM    ItemTransaction T, Item I
	WHERE   T.ItemNo = I.ItemNo
	AND     T.ItemPrecision <> I.ItemPrecision
</cfquery>

<!--- step 3 of 8 --->

<!--- ---------------------------------------------- --->
<!--- populate ItemWarehouse for enabled items 
               for that mission                      --->
<!--- ---------------------------------------------- --->		

<!--- 11/9/2016 : adjust for WarehouseCategory is
			pending -------------------------------- --->

<cfquery name="PopulateItemBasedOnMission" 
    datasource="AppsMaterials">
	INSERT INTO ItemWarehouse
	(ItemNo, UoM, Warehouse, OfficerUserId, OfficerLastName, OfficerFirstName)
	
	SELECT DISTINCT T.ItemNo, 
			        T.UoM,
			        W.Warehouse, 		   
				    '#SESSION.acc#',
				    '#SESSION.last#',
				    '#SESSION.first#'	
	FROM   Item I 
	       INNER JOIN ItemUoMMission T ON I.ItemNo = T.ItemNo 
		   INNER JOIN Warehouse W      ON T.Mission = W.Mission
		   
	WHERE  I.Operational    = 1 
	  AND  W.Operational    = 1 
	  AND  T.Operational    = 1
	  AND  I.ItemClass      = 'Supply'
	  
	  AND  I.ItemNo NOT IN (SELECT ItemNo
	                        FROM   ItemWarehouse 
							WHERE  ItemNo    = T.ItemNo
							AND    UoM       = T.UoM
							AND    Warehouse = W.Warehouse)
           
</cfquery>

<!--- ---------------------------------------------- --->
<!--- poipulate ItemWarehouse for actual transaction 
               for that warehouse found              --->
<!--- ---------------------------------------------- --->		

<cfquery name="PopulateBasedOnTransactions" 
    datasource="AppsMaterials">
	INSERT INTO ItemWarehouse
	(ItemNo, UoM, Warehouse, OfficerUserId, OfficerLastName, OfficerFirstName)
	
	SELECT DISTINCT T.ItemNo, 
			        T.TransactionUoM,
			        T.Warehouse, 		   
				    '#SESSION.acc#',
				    '#SESSION.last#',
				    '#SESSION.first#'	
	FROM   Item I INNER JOIN
           ItemTransaction T ON I.ItemNo = T.ItemNo 	
	WHERE  I.Operational    = 1 
	  AND  I.ItemClass   = 'Supply'
	  AND  I.ItemNo NOT IN (SELECT ItemNo
	                        FROM   ItemWarehouse 
							WHERE  ItemNo    = T.ItemNo
							AND    UoM       = T.TransactionUoM
							AND    Warehouse = T.Warehouse)
           
</cfquery>

<!--- step 4 of 8 Ensure all locations of operational items that have a transaction
in itemtransaction are reflected in WarehouseLocation --->

<!--- maybe it would be good to limit this for items that actually have a stock
a active stock on-hand level --------------------------------------------------- --->
 

<cfquery name="PopulateItemWarehouseLocation" 
    datasource="AppsMaterials">
	INSERT INTO ItemWarehouseLocation
	(ItemNo, UoM, Warehouse, Location,PickingOrder,OfficerUserId, OfficerLastName, OfficerFirstName)
	
	SELECT DISTINCT T.ItemNo, 
			        T.TransactionUoM,
			        T.Warehouse, 	
					T.Location,	   
					'9',
				    '#SESSION.acc#',
				    '#SESSION.last#',
				    '#SESSION.first#'	
					
	FROM   Item I INNER JOIN
           ItemTransaction T ON I.ItemNo = T.ItemNo 	
		   
	WHERE  I.Operational    = 1 
	  AND  I.ItemClass   = 'Supply'
	  AND  I.ItemNo NOT IN (SELECT ItemNo
	                        FROM   ItemWarehouseLocation 
							WHERE  ItemNo    = T.ItemNo
							AND    UoM       = T.TransactionUoM
							AND    Warehouse = T.Warehouse
							AND    Location  = T.Location)
	 
	 <!--- only if operational for this location --->						
	 
	 AND   I.ItemNo     IN (SELECT ItemNo
	                        FROM   ItemWarehouse
							WHERE  ItemNo    = T.ItemNo
							AND    UoM       = T.TransactionUoM
							AND    Warehouse = T.Warehouse
							AND    Operational = 1)		
											
	 AND  (T.Location != '' OR T.Location is not NULL)						
           
</cfquery>

<!--- step 7 of 9 : was overtaking by the function that generates economic stock on the fly --->

<!--- step 8 of 9 : see 7 / 9 --->

<!--- miscellaneous 9 of 9 --->

<!--- A. OLD ensure that each item has a warehouse record --->

<!--- B. reinstated 2/9/2016 NEW I doubt this is needed anymore as we have different missions with each a warehouse. Not each item is carried in each mission by default
._whs record 

<cf_droptable dbname="AppsMaterials" tblname="#SESSION.acc#WhsCheck_tmp">

<cfquery name="Select" 
datasource="AppsMaterials">
SELECT   Item.ItemNo, 
         Item.ItemDescription, 
		 Item.Category, 
		 Item.Destination, 
		 Item.StatusOperational, 
         w.ItemNo AS selected
INTO     #SESSION.acc#WhsCheck_tmp					  
FROM     Item LEFT OUTER JOIN
         ItemWarehouse W ON Item.ItemNo = w.ItemNo AND Item.PrimaryWarehouse = w.Warehouse
WHERE    Item.Operational = '1'
</cfquery>

<cfquery name="Update" 
datasource="AppsMaterials">
INSERT INTO ItemWarehouse
       (ItemNo, Warehouse, Destination, OfficerUserId, Created, LastUpdatedBy, LastUpdated)
SELECT ItemNo, PrimaryWarehouse, Destination, '#SESSION.acc#', '#DateFormat(now(), CLIENT.DateSQL)#', '#SESSION.acc#', '#DateFormat(now(), CLIENT.DateSQL)#'
FROM   #SESSION.acc#WhsCheck_tmp T
WHERE  selected is null 
</cfquery>

<cf_droptable dbname="AppsMaterials" tblname="#SESSION.acc#WhsCheck_tmp">

<!--- C.ensure that each item, with a default warehouse has at least one location record --->

<cfquery name="Select" 
datasource="AppsMaterials">
SELECT   Item.ItemNo,
         Item.PrimaryWarehouse, 
		 Loc.ItemNo AS Selected, 
		 Warehouse.DefaultLocation
INTO     #SESSION.acc#WhsCheck_tmp
FROM     Item INNER JOIN
         Warehouse ON Item.PrimaryWarehouse = Warehouse.Warehouse LEFT OUTER JOIN
         ItemWarehouseLocation Loc ON Item.ItemNo = Loc.ItemNo AND Item.PrimaryWarehouse = Loc.Warehouse
WHERE    Item.StatusOperational = 1
</cfquery>

<cfquery name="Update" 
datasource="AppsMaterials">
INSERT INTO ItemWarehouseLocation
         (ItemNo, Warehouse, Location, UserName, Created, LastUpdatedBy, LastUpdated)
SELECT   ItemNo, PrimaryWarehouse, DefaultLocation, '#SESSION.acc#', '#DateFormat(now(), CLIENT.DateSQL)#', '#SESSION.acc#', '#DateFormat(now(), CLIENT.DateSQL)#'
FROM     #SESSION.acc#WhsCheck_tmp T
WHERE    selected is null 
</cfquery>

<cf_droptable dbname="AppsMaterials" tblname="#SESSION.acc#WhsCheck_tmp">

--->

<!---
</cftransaction>
--->

<cf_tl id="Stock level" var="1">
<cfset msg1="#lt_text#">

<cf_tl id="integrity has been completed." var="1">
<cfset msg2="#lt_text#">

<cf_message status="Notification" message = "#msg1# #msg2#" return = "back">
 

