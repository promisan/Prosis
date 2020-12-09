
<cfparam name="url.selected" default="">

 <cfquery name="Transaction"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   userTransaction.dbo.Transfer#URL.Whs#_#SESSION.acc#
		WHERE  TransactionId = '#URL.Id#'
 </cfquery>
 
 <cfquery name="qWarehouse"
        datasource="AppsMaterials"
        username="#SESSION.login#"
        password="#SESSION.dbpw#">
        SELECT *
        FROM   Warehouse
        WHERE  Warehouse = '#url.warehouse#'
</cfquery>    
 
<cfoutput>

<cfif conversion eq "0">		
 	 
	 <cfquery name="Default"
             datasource="AppsMaterials"
             username="#SESSION.login#"
             password="#SESSION.dbpw#">
             SELECT   Location
             FROM     ItemWarehouseLocation
             WHERE    Warehouse = '#url.warehouse#'
			 AND      ItemNo = '#Transaction.ItemNo#'
			 AND      Location != '#Transaction.Location#'
			  AND   Location NOT IN (SELECT LocationReceipt 
			                        FROM   Warehouse 
									WHERE  Warehouse = '#url.warehouse#') 
			 AND      Operational = 1
			 ORDER BY PickingOrder
     </cfquery>   
	 
	 <!--- we get the locations and but show the location that have stock for this item first --->
	                     
     <cfquery name="Proposed"
         datasource="AppsMaterials"
         username="#SESSION.login#"
         password="#SESSION.dbpw#">
		 
		  SELECT TOP 1 *			

		   FROM (
	
				SELECT 	 				 
						 IW.*, 						 
						 I.ItemPrecision,
						 I.ValuationCode,
						 WL.StorageCode,
						 WL.Description,
									 
						 (	SELECT ROUND(SUM(TransactionQuantity),5)
							FROM   ItemTransaction 
							WHERE  Warehouse       = IW.Warehouse
							AND    Location        = IW.Location
							AND    ItemNo          = IW.ItemNo
							AND	   TransactionUoM  = IW.UoM								
						 ) as OnHand 	
						 					
				FROM     ItemWarehouseLocation IW 						 
						 INNER JOIN WarehouseLocation WL ON IW.Warehouse = WL.Warehouse AND IW.Location = WL.Location						 
						 INNER JOIN Item I ON IW.ItemNo = I.ItemNo
				WHERE    IW.Warehouse = '#url.warehouse#'
				AND      IW.ItemNo   = '#Transaction.ItemNo#'
				AND      IW.UoM      = '#Transaction.UnitOfMeasure#'
				AND      IW.Operational = 1				
				AND      IW.Location != '#Transaction.Location#'	  
				-- AND      SaleMode       = '2'			 
			
			  ) as XL
						
		     ORDER BY  PickingOrder, OnHand	DESC	
			             
     </cfquery>	  	 
		 	 
	 <cfif Proposed.recordcount gte "1">
		 
		 <cfquery name="Update"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				UPDATE userTransaction.dbo.Transfer#URL.whs#_#SESSION.acc#		
				SET    TransferLocation  = '#Proposed.Location#'
				WHERE  TransactionId = '#URL.id#' 				
		</cfquery>
	 
	 </cfif>
	 
	 <cfif url.selected neq "">	
	 	<cfset def = url.selected>
	 <cfelseif Proposed.Location neq "">	 		 
	 	<cfset def = Proposed.location>	 	
	 <cfelse>	 	 
	 	<cfset def = qWarehouse.LocationReceipt>
	 </cfif>
	 
	 <cfquery name="Location"
         datasource="AppsMaterials"
         username="#SESSION.login#"
         password="#SESSION.dbpw#">
		 
			  SELECT *			 
		      FROM   WarehouseLocation D
		      WHERE  Warehouse = '#url.warehouse#'
	          <!--- AND   Location != '#url.Location#' --->
	          AND    Operational = 1
	          <!--- Note Hanno only location that have the same item as the transfer item also defined in its stock,
		              maybe that is a bit too strong --->
	   	      AND    Location != '#Transaction.Location#'	  
					 
			  <!--- transfer to receipt location by default is not good.
			  AND   Location NOT IN (SELECT LocationReceipt 
			                         FROM   Warehouse 
									 WHERE  Warehouse = '#url.warehouse#') 
			  --->						
				  
	          <cfif qWarehouse.ModeSetItem eq "Location">
	          AND    Location IN (SELECT Location
					              FROM   ItemWarehouseLocation
					              WHERE  ItemNo    = '#Transaction.ItemNo#'
					              AND    Warehouse = D.Warehouse
					              AND    Location  = D.Location)
	          </cfif>
			 
	 </cfquery>		 
	 	 	 	 		 	   
	 <select name     = "transferlocation#url.id#" 
	         id       = "transferlocation#url.id#" 
			 class    = "regularxl"
			 style    = "width:300px"
	         onChange = "trfsave('#url.TransactionId#',document.getElementById('transferwarehouse#url.id#').value,this.value,'','','',document.getElementById('transferquantity#url.id#').value,document.getElementById('transfermemo#url.id#').value,document.getElementById('itemuomid#url.id#').value,document.getElementById('transaction#url.id#_date').value,document.getElementById('transaction#url.id#_hour').value,document.getElementById('transaction#url.id#_minute').value)">
		
		<cfloop query="Location">
			<option value="#Location#" <cfif def eq Location>selected</cfif>>#StorageCode# <cfif storagecode neq description>#Description#</cfif></option>
		</cfloop>
		
	 </select>	

<cfelse>
		
	 <cfquery name="Item"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Item
		WHERE  ItemNo = '#Transaction.ItemNo#'
	 </cfquery>	 
	 
 	<cfquery name="Location"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT *
		FROM  WarehouseLocation D
		WHERE Warehouse = '#url.warehouse#'
		
		<!--- convert only items that are very similar and belong to the same item category	--->
		
		 AND    Location IN (SELECT Location
					         FROM   ItemWarehouseLocation
					         WHERE  ItemNo    IN (SELECT ItemNo 
							                      FROM Item 
												  WHERE Category = '#item.Category#' 
												  AND CategoryItem = '#item.CategoryItem#')
					         AND    Warehouse = D.Warehouse
					         AND    Location  = D.Location
							 AND    Operational = 1)		   
						   
		AND   Operational = 1
	</cfquery>	
	
	<cfif Location.recordcount eq "0">
	
		<cfquery name="Location"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT *
			FROM   WarehouseLocation D
			WHERE  Warehouse = '#url.warehouse#'					   
			AND    Operational = 1
		</cfquery>		
	
	</cfif>
	
	 <cfset link = "ptoken.navigate('#SESSION.root#/warehouse/application/stock/Transfer/StockTransferItem.cfm?conversion=#conversion#&id=#url.id#&whs=#url.whs#&warehouse=#url.warehouse#&location='+this.value,'itembox#url.id#')">		
	 	 
	 <select name  = "transferlocation#url.id#" 
	     id        = "transferlocation#url.id#" 
		 class     = "regularxl"
		 style     = "width:200px"		 
	     onChange  = "#link#;trfsave('#url.TransactionId#',document.getElementById('transferwarehouse#url.id#').value,this.value,'','','',document.getElementById('transferquantity#url.id#').value,document.getElementById('transfermemo#url.id#').value,document.getElementById('itemuomid#url.id#').value,document.getElementById('transaction#url.id#_date').value,document.getElementById('transaction#url.id#_hour').value,document.getElementById('transaction#url.id#_minute').value);">	  
		
		<cfif Location.recordcount neq "1">
	    	<option value="" selected>--<cf_tl id="Select">--</option>
		</cfif>	 
		
		<cfloop query="Location">
			<option value="#Location#" <cfif url.selected eq Location>selected</cfif>>#StorageCode# #Description#</option>
		</cfloop>
		
	 </select>	
	 
	  <cfif Location.recordcount eq "1">
		 
		 <cfquery name="Update"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				UPDATE userTransaction.dbo.Transfer#URL.whs#_#SESSION.acc#		
				SET    TransferLocation  = '#Location.Location#'
				WHERE  TransactionId = '#URL.id#' 				
		</cfquery>
	 
	 </cfif>
	 
	 <!---
	 
	 <cfif Location.recordcount eq "1">
	 
		 <script>
		 	trfsave('#url.TransactionId#',document.getElementById('transferwarehouse#url.id#').value,'#location.location#','','','',document.getElementById('transferquantity#url.id#').value,document.getElementById('transfermemo#url.id#').value,'',document.getElementById('transaction#url.id#_date').value,document.getElementById('transaction#url.id#_hour').value,document.getElementById('transaction#url.id#_minute').value)
		 </script>
	 
	 </cfif>
	 
	 --->
	 
	 <script>
	 	try {
			element = document.getElementById('itembox#url.id#');
			if (element)
				ptoken.navigate('#SESSION.root#/warehouse/application/stock/Transfer/StockTransferItem.cfm?conversion=#conversion#&id=#url.id#&whs=#url.whs#&warehouse=#url.warehouse#&location=#location.location#', 'itembox#url.id#')
		}
		catch(ex){}	
	 </script>
 
</cfif>

</cfoutput> 