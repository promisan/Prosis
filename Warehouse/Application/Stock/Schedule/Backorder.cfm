
<cfparam name="URL.Mission" default="">
<cfparam name="URL.Warehouse" default="">

<cfquery name="Warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT Warehouse,ItemNo,UoM 
	FROM   Request 
	WHERE  Status    = '2b'	
	<cfif url.mission neq "">	
	AND    Mission = '#url.mission#' 
	</cfif>
	<cfif url.warehouse neq "">	
	AND    Warehouse = '#url.warehouse#'
	</cfif>
</cfquery>		
	
<cfloop query="Warehouse">	 

	<cfquery name="Stock" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   SUM(T.TransactionQuantity) AS QuantityOnHand
		FROM     ItemTransaction T 
		WHERE    T.Warehouse       = '#Warehouse#'
		AND      T.ItemNo          = '#ItemNo#'
		AND      T.TransactionUoM  = '#UoM#' 		
	</cfquery>
	
	<cfif stock.QuantityOnHand gt "0">
		
		<!--- check if item exists for warehouse --->
		
		<cfquery name="Check" 
		   datasource="appsMaterials" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   SELECT * 
		   FROM  ItemWarehouse 
		   WHERE ItemNo  = '#ItemNo#' 
		   AND   Warehouse = '#Warehouse#'
		   AND   UoM       = '#UoM#'
		</cfquery>
		
		<cfif Check.recordCount is 0>
		
		   <cfquery name="Insert" 
		   datasource="appsMaterials" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   INSERT 
		   INTO    ItemWarehouse 
		          (ItemNo, Warehouse,UoM,Destination, ReStocking, OfficerUserId, OfficerLastName, OfficerFirstName)
		   VALUES ('#ItemNo#', 
		           '#Warehouse#', 
				   '#UoM#',
		           'Distribution', 
				   'Procurement', 
				   '#SESSION.acc#', 
				   '#SESSION.last#', 
				   '#SESSION.first#')
		   </cfquery>
		
		</cfif>
			
		<!--- check if item exists for location --->
		
		<cfset itm = ItemNo>
		<cfset whs = Warehouse>
		
		<cfquery name="StockLoc" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   Location,TransactionUoM as UoM,
		         SUM(T.TransactionQuantity) AS QuantityOnHand
		FROM     ItemTransaction T 
		WHERE    T.Warehouse       = '#Warehouse#'
		AND      T.ItemNo          = '#ItemNo#'
		AND      T.TransactionUoM  = '#UoM#'
		GROUP BY T.Location, TransactionUoM   
   	    </cfquery>
		
		<cfloop query="stockLoc">
		
			<cfquery name="Check" 
			   datasource="appsMaterials" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT * 
			   FROM   ItemWarehouseLocation 
			   WHERE  ItemNo    = '#itm#'
			   AND    Warehouse = '#whs#'
			   AND    Location  = '#Location#'
			   AND    UoM       = '#UoM#'
			</cfquery>
			
			<cfif Check.recordCount is 0>
			
				<cfquery name="GetItem" 
				   datasource="appsMaterials" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   SELECT * 
				   FROM   Item
				   WHERE  ItemNo    = '#itm#'
				</cfquery>			
			
				<cfif GetItem.ItemClass eq "Supply">
					   <cfquery name="Insert" 
					   datasource="appsMaterials" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					   INSERT 
					   INTO    ItemWarehouseLocation 
					          (ItemNo, Warehouse,Location, UoM,OfficerUserId, OfficerLastName, OfficerFirstName)
					   VALUES ('#itm#', 
					           '#whs#', 
					           '#Location#', 
							   '#uom#',
							   '#SESSION.acc#', 
							   '#SESSION.last#', 
							   '#SESSION.first#')
					   </cfquery>
				</cfif>
			</cfif>
		
		</cfloop>
		
		<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE   Request
				SET      Status = '2'
				WHERE    Warehouse = '#Warehouse#'  
				AND      ItemNo    = '#ItemNo#'
				AND      UoM       = '#UoM#'
				AND      Status    = '2b'		
		</cfquery>
				
	</cfif>	
		
</cfloop>		

