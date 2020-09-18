
<cfparam name="Attributes.DataSource"               default="appsMaterials">
<cfparam name="Attributes.TransactionCurrency"      default="#APPLICATION.BaseCurrency#">

<cfif Attributes.TransactionCurrency eq "default">
   <cfset Attributes.TransactionCurrency = APPLICATION.BaseCurrency>
</cfif>

<cfparam name="Attributes.TransactionClass"         default="Stock">

<!--- destination --->

<cfparam name="Attributes.WorkorderId"              default = "">
<cfparam name="Attributes.WorkorderLine"            default = "">
<cfparam name="Attributes.RequirementId"            default = "">
<cfparam name="Attributes.BillingUnit"              default = "">
<cfparam name="Attributes.ProgramCode"              default = "">
<cfparam name="Attributes.Mission"                  default = "">
<cfparam name="Attributes.TransactionLot"           default = "0">

<cfif Attributes.TransactionLot eq "">
	<cfset Attributes.TransactionLot = "0">
</cfif>

<cfparam name="Attributes.AssetId"                  default = "">
<cfparam name="Attributes.CustomerId"               default = "">
<cfparam name="Attributes.OrgUnit"                  default = "">
<cfparam name="Attributes.LocationId"               default = "">
<cfparam name="Attributes.PersonNo"                 default = "">
<cfparam name="Attributes.BillingMode"              default = "">
<cfparam name="Attributes.TaxCode"                  default = "00">
<cfparam name="Attributes.ActionStatus"             default = "0">

<cfparam name="Attributes.TransactionReference"     default = "">
<cfparam name="Attributes.TransactionType"          default = "">

<cfparam name="Attributes.TransactionSource"        default = "PurchaseSeries">
<cfparam name="Attributes.GLTransactionSourceId"    default="">
<cfparam name="Attributes.GLTransactionSourceNo"    default="">
<cfparam name="Attributes.TransactionCategory"      default = "Inventory">
<cfparam name="Attributes.ItemNo"                   default = "">
<cfparam name="Attributes.SalesPrice"               default = "">
<cfparam name="Attributes.SalesPersonNo"            default = "">

<cfparam name="Attributes.TransactionId"            default = "">
<cfparam name="Attributes.TransactionIdOrigin"      default = ""> <!--- only used for the individual stock mode --->
<cfparam name="Attributes.ParentTransactionId"      default = "">

<cfparam name="Attributes.TransactionBatchNo"       default="">
<cfparam name="Attributes.TransactionDate"          default="#DateFormat(now(), CLIENT.DateFormatShow)#">
<cfparam name="Attributes.TransactionTime"          default="#TimeFormat(now(), 'HH:MM')#">
<cfparam name="Attributes.TransactionTimeZone"      default="No">
<cfparam name="Attributes.TransactionLocalTime"     default="No">

<cfparam name="Attributes.DetailLineNo"             default = "">

<!--- sometimes we pass 0 for the orgunit if it comes from a table --->
<cfif attributes.orgunit eq "0">
	 <cfset attributes.orgunit = "">
</cfif>

<cfif Attributes.TransactionId eq "">
	<cf_assignId>
	<cfset Attributes.TransactionId = rowguid>
</cfif>

<cfparam name="Attributes.Ledger"                   default="Yes">

<cfquery name="Item"
    datasource="#Attributes.DataSource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT * 
	FROM   Materials.dbo.Item 
	WHERE  ItemNo = '#Attributes.ItemNo#'
</cfquery>

<!--- ------------------------------------------------- ---> 
<!--- Hanno 15/9 better to enforce this accounting----- --->
<!--- ------------------------------------------------- --->

<cf_verifyOperational 
         datasource= "#Attributes.DataSource#"
         module    = "Accounting" 
		 Warning   = "No">
		 
<cfif Operational eq "1"> 
			
	<cfquery name="Curr" 
	     datasource="#Attributes.DataSource#" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT     TOP 1 *
	     FROM       Accounting.dbo.CurrencyExchange
	     WHERE      Currency      = '#Attributes.TransactionCurrency#'
	     AND        EffectiveDate <= '#dateformat(Attributes.TransactionDate,client.DateSQL)#'
	     ORDER BY   EffectiveDate DESC
	</cfquery>
		   		
	<cfif Curr.recordcount eq "0">
						
		<cf_waitEnd> 
							
		<cf_message message = "Exchange rate has not been recorded. Operation not allowed." return = "back">
		<cfabort>
	  
	</cfif>  

</cfif>

<!--- ------------------------------------------------------------------ --->
<!--- 1/1 create a stock item Transaction record------------------------ --->
<!--- ------------------------------------------------------------------ --->

<cfparam name="Attributes.Warehouse" default="">

<cfquery name="Warehouse"
    datasource="#Attributes.DataSource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT * 
		FROM   Materials.dbo.Warehouse
		WHERE  Warehouse = '#Attributes.Warehouse#' 
</cfquery>

<cfif attributes.mission eq "">

	<cfset Attributes.mission = warehouse.mission>

</cfif>

<cfif attributes.locationId eq "">
	  <cfset attributes.locationid = warehouse.LocationId>
</cfif>

<cfif Attributes.TransactionType neq "7" and Attributes.TransactionType neq "8">

    <cfquery name="TrackingCount"
      datasource="#Attributes.DataSource#" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
		SELECT   COUNT(*) as Total
		FROM     Materials.dbo.ItemTransaction WITH (NOLOCK)
		WHERE    ItemNo  = '#Attributes.ItemNo#'
		AND      Mission = '#Warehouse.Mission#'
		AND      TransactionType NOT IN ('7','8')
    </cfquery>

    
    <cfset count = (TrackingCount.total+1)/20>
    <cfset trackingNo = fix(count)+1>
    
	<cfquery name="setTrackingUoM"
	datasource="#Attributes.DataSource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE  Materials.dbo.Item
		SET     ItemTrackingNo = '#trackingno#'
		WHERE   ItemNo = '#Attributes.ItemNo#' 		
	</cfquery>	
  
<cfelse>

	<cfset trackingNo = "">

</cfif>

<cfquery name="ItemUoM"
	datasource="#Attributes.DataSource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT     *
	FROM       Materials.dbo.ItemUoM
	WHERE      ItemNo = '#Attributes.ItemNo#' 
	ORDER BY   UoMMultiplier
</cfquery>	

<cfparam name="Attributes.Location"              default="#Warehouse.LocationReceipt#">
<cfparam name="Attributes.TransactionQuantity"   default="1">
<cfparam name="Attributes.ActionStatus"          default="0">
<cfparam name="Attributes.TransactionMetric"     default="0">
<cfparam name="Attributes.TransactionUoM"        default="#ItemUoM.UOM#">
<cfparam name="Attributes.TransactionCostPrice"  default="">
<cfparam name="Attributes.ReceiptCostPrice"      default="">
<cfparam name="Attributes.ReceiptPrice"          default="">
<cfparam name="Attributes.ReceiptCurrency"       default="#APPLICATION.BaseCurrency#">

<!--- correction of the transaction quantity in case of stock which is individual  --->

<cfif attributes.TransactionIdOrigin neq "">

	<cfquery name="OnHand"
	    datasource="#Attributes.DataSource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT   ISNULL(SUM(TransactionQuantity),0) as Quantity
		FROM     ItemTransaction
		WHERE    (TransactionId = '#attributes.transactionidOrigin#' 
		          OR TransactionIdOrigin = '#attributes.transactionidOrigin#')		
	</cfquery>
	
	<cfset diff =  - Attributes.TransactionQuantity>
	
	<cfif diff lt "1" and OnHand.Quantity gt "0">
	
		<cfset Attributes.TransactionQuantity = OnHand.Quantity>
		
	<cfelseif OnHand.Quantity lt "0" and diff gte "0">
	
		<cfset Attributes.TransactionQuantity = "0">	
		
	</cfif> 
		
<cfelse>	
	
	<cfquery name="OnHand" 
	   datasource="#Attributes.DataSource#" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   SELECT ISNULL(SUM(TransactionQuantity),0) as Quantity
		   FROM   Materials.dbo.ItemTransaction
		   WHERE  Mission         = '#Attributes.Mission#'
		   AND    Warehouse       = '#Attributes.Warehouse#'
		   AND    Location        = '#Attributes.Location#'
		   AND    ItemNo          = '#Attributes.ItemNo#'
		   AND    TransactionUoM  = '#Attributes.TransactionUoM#'
		   AND    TransactionLot  = '#Attributes.TransactionLot#'		   
	</cfquery>
		
</cfif>

<cfquery name="WarehouseLocation"
    datasource="#Attributes.DataSource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   * 
	FROM     Materials.dbo.WarehouseLocation
	WHERE    Warehouse = '#Attributes.Warehouse#' 
	AND      Location  = '#Attributes.Location#'
</cfquery>

<cfif warehouseLocation.Operational eq "0">

		<cf_waitEnd> 
							
		<cf_message 
		  message = "Storage location #Attributes.Warehouse#-#Attributes.Location# is no longer operational. Operation is not supported."
		  return = "back">
		<cfabort>
		
</cfif>

<!--- pass the value in case of a transfer --->

<cfif Attributes.ParentTransactionId neq "">
	
	<cfquery name="getPrior"
		datasource="#Attributes.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Materials.dbo.ItemTransaction
		WHERE   TransactionId = '#Attributes.ParentTransactionid#' 	
	</cfquery>	

	<!--- base currency --->
	<cfset TransactionCostPrice             = "#getPrior.TransactionCostPrice#">
	<cfset ReceiptCostPrice                 = "#getPrior.TransactionCostPrice#">
	<cfset ReceiptPrice                     = "#getPrior.TransactionCostPrice#">
	<cfset Attributes.TransactionCostPrice  = "#getPrior.TransactionCostPrice#">
	<cfset Attributes.ReceiptCostPrice      = "#getPrior.TransactionCostPrice#">
	<cfset Attributes.ReceiptPrice          = "#getPrior.TransactionCostPrice#">
	
</cfif>	

<cfquery name="ItemUoM"
	datasource="#Attributes.DataSource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT  *
	FROM    Materials.dbo.ItemUoM
	WHERE   ItemNo = '#Attributes.ItemNo#' 
	AND     UoM    = '#Attributes.TransactionUoM#' 
</cfquery>	

<cfif Attributes.TransactionCostPrice eq "">

	<cfquery name="ItemUoMMission"
	datasource="#Attributes.DataSource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT  *
	FROM    Materials.dbo.ItemUoMMission
	WHERE   ItemNo  = '#Attributes.ItemNo#' 
	AND     UoM     = '#Attributes.TransactionUoM#' 
	AND     Mission = '#Attributes.Mission#'
	</cfquery>	
	
	<cfif ItemUoMMission.StandardCost gt "0">
	
		<!--- in base currency --->
		<cfset TransactionCostPrice             = "#ItemUoMMission.StandardCost#">
		<cfset ReceiptCostPrice                 = "#ItemUoMMission.StandardCost#">
		<cfset ReceiptPrice                     = "#ItemUoMMission.StandardCost#">
		
		<cfset Attributes.TransactionCostPrice  = "#ItemUoMMission.StandardCost#">
		<cfset Attributes.ReceiptCostPrice      = "#ItemUoMMission.StandardCost#">
		<cfset Attributes.ReceiptPriceCurrency  = "#ItemUoMMission.StandardCost#">
		<cfset Attributes.ReceiptPrice          = "#ItemUoMMission.StandardCost#">
	
	<cfelse>
			
		<!--- in base currency --->
		<cfset TransactionCostPrice             = "#ItemUoM.StandardCost#">
		<cfset ReceiptCostPrice                 = "#ItemUoM.StandardCost#">
		<cfset ReceiptPrice                     = "#ItemUoM.StandardCost#">
		
		<cfset Attributes.TransactionCostPrice  = "#ItemUoM.StandardCost#">
		<cfset Attributes.ReceiptCostPrice      = "#ItemUoM.StandardCost#">
		<cfset Attributes.ReceiptPriceCurrency  = "#ItemUoM.StandardCost#">
		<cfset Attributes.ReceiptPrice          = "#ItemUoM.StandardCost#">
		
	</cfif>	
		
<cfelse>

	<cfset transactioncostprice = replace(Attributes.TransactionCostPrice,',','',"ALL")>

    <!--- Financials is enabled, so we bring this back into the currency of the journal driven by the currency  --->	
	
	<cfif Operational eq "1"> 
	    <!--- if passed originally in a currency (receipt) it is now to be express in USD --->
		<cfset TransactionCostPrice                = "#ROUND(transactioncostprice*10000/curr.exchangeRate)/10000#">
	<cfelse>
	    <!--- ------------------------------------------------------------- --->
	    <!--- this should not be enabled anymore we always have accouynting --->
	  	<cfset TransactionCostPrice                = "#ROUND(transactioncostprice*1000)/1000#">
	</cfif>	
	
	<!--- track the determined cost price --->		
	<cfif Attributes.ReceiptCostPrice eq "">	
		<cfset Attributes.ReceiptCostPrice         = "#TransactionCostPrice#">				
	<cfelse>		
		<cfif Operational eq "1"> 
			<cfset Attributes.ReceiptCostPrice     = "#round(Attributes.ReceiptCostPrice*10000/curr.exchangeRate)/10000#">
		<cfelse>
		  	<cfset Attributes.ReceiptCostPrice     = "#round(Attributes.ReceiptCostPrice)#">
		</cfif>			
	</cfif>		
	
	<!--- track the receipt price --->		
	<cfif Attributes.ReceiptPrice eq "">	
		
		<cfset Attributes.ReceiptPriceCurrency     = "#TransactionCostPrice#">
		<cfset Attributes.ReceiptPrice             = "#TransactionCostPrice#">			
		
	<cfelse>	
	
		<cfset Attributes.ReceiptPriceCurrency     = "#Attributes.ReceiptPrice#">
	
		<cfif Operational eq "1"> 
		
			<cfquery name="rcurr" 
		     datasource="#Attributes.DataSource#" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     	 SELECT    TOP 1 *
			     FROM      Accounting.dbo.CurrencyExchange
			     WHERE     Currency = '#Attributes.ReceiptCurrency#'
			     AND       EffectiveDate <= '#dateformat(Attributes.TransactionDate,client.DateSQL)#'
		    	 ORDER BY  EffectiveDate DESC
			</cfquery>
			
			<cfset Attributes.ReceiptPrice          = "#round(Attributes.ReceiptPrice*10000/rcurr.exchangeRate)/10000#">
			
		<cfelse>
		
		  	<cfset Attributes.ReceiptPrice          = "#round(Attributes.ReceiptPrice)#">
			
		</cfif>		
	</cfif>		
	
</cfif>	

<cfset dateValue = "">
<CF_DateConvert Value="#Attributes.TransactionDate#">
<cfset dte = dateValue>

<!--- prevent out-of-range transactions --->

<cfif dte lt "01/01/1999">
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#DateFormat(now(), CLIENT.DateFormatShow)#">
	<cfset dte = dateValue>
  
</cfif>

<cfif dte gt now()+10>

	<cfset dateValue = "">
	<CF_DateConvert Value="#DateFormat(now(), CLIENT.DateFormatShow)#">
	<cfset dte = dateValue>

</cfif>

<cfset dte = DateAdd("h","#TimeFormat(Attributes.TransactionTime, 'HH')#", dte)>
<cfset dte = DateAdd("n","#TimeFormat(Attributes.TransactionTime, 'MM')#", dte)>

<cfif attributes.TransactionTimeZone eq "Yes">
	
	<!--- ---------------------------------------------- --->
	<!--- express the passed date/time in the local time --->
	<!--- ---------------------------------------------- --->
	
	<cfquery name="Param"
	    datasource="#Attributes.DataSource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT * 
		FROM   System.dbo.Parameter 	
	</cfquery>
	
	<!--- database server timezone --->
	
	<cfquery name="WarehouseZone"
	    datasource="#Attributes.DataSource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT   TOP 1 * 
		FROM     Materials.dbo.WarehouseTimeZone
		WHERE    Warehouse = '#attributes.Warehouse#'
		AND      DateEffective <= #dte# 
		ORDER BY DateEffective DESC 	
	</cfquery>
	
	<!--- if server is in brindisi +1 the time in Guatemala -7 = 8 hours earlier --->
	
	<cfif WarehouseZone.recordcount eq "1">
	
		<cfset correction = (Param.DatabaseServerTimeZone - WarehouseZone.TimeZone)*-1>	
		<cfset timezone   = WarehouseZone.TimeZone>
		<cfset dte = DateAdd("h",correction,dte)>
		
	<cfelse>
	   
		<cfset timezone   = Param.DatabaseServerTimeZone>
	</cfif>		
			
<cfelseif attributes.TransactionLocalTime eq "Yes">

	<!--- ---------------------------------------------- --->
	<!--- is already expressed in the local time-------- --->
	<!--- ---------------------------------------------- --->	

	<!--- database server timezone --->
	
	<cfquery name="WarehouseZone"
	    datasource="#Attributes.DataSource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT   TOP 1 * 
		FROM     Materials.dbo.WarehouseTimeZone
		WHERE    Warehouse = '#attributes.Warehouse#'
		AND      DateEffective <= #dte# 
		ORDER BY DateEffective DESC 	
	</cfquery>
	
	<cfif WarehouseZone.recordcount eq "1">		
		<cfset timezone   = WarehouseZone.TimeZone>
	<cfelse>
		<cfset timezone   = "0">
	</cfif>			
	
<cfelse>

	<!--- ---------------------------------------------- --->
	<!--- is expressed in the server time -------------- --->
	<!--- ---------------------------------------------- --->	

	<cfquery name="Param"
	    datasource="#Attributes.DataSource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT * 
		FROM   System.dbo.Parameter 	
	</cfquery>

	<cfset timezone   = Param.DatabaseServerTimeZone>
		
</cfif>

<cfparam name="Attributes.OrgUnit" default="">

<cfif Attributes.OrgUnit neq "" and Attributes.OrgUnit neq "0">

	<!--- define the current orgunit code determining the mandate and today's date --->
	
	<cfquery name="Org"
	    datasource="#Attributes.DataSource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT    Unit.OrgUnit, Unit.OrgUnitCode, Unit.OrgUnitName
		FROM      Organization.dbo.Organization O INNER JOIN
                  Organization.dbo.Organization Unit ON O.Mission = Unit.Mission AND O.OrgUnitCode = Unit.OrgUnitCode INNER JOIN
                  Organization.dbo.Ref_Mandate R ON Unit.Mission = R.Mission AND Unit.MandateNo = R.MandateNo
		WHERE     O.OrgUnit = '#Attributes.OrgUnit#' 
		<!---
		AND       R.DateEffective  <= GETDATE() 
		AND       R.DateExpiration >= GETDATE()
		--->
	</cfquery>
	
	<cfif Org.Recordcount eq "0">

    	<cf_message message="Stock transaction cannot be completed since the orgunit does not have an active occurence [#Attributes.OrgUnit#]. Operation aborted.">
		<cfabort>

	</cfif>
	
</cfif>

<cfparam name="Attributes.ReceiptId"              default="{00000000-0000-0000-0000-000000000000}">
<cfparam name="Attributes.RequestId"              default="">
<cfparam name="Attributes.TaskSerialNo"           default="">

<cfparam name="Attributes.OrgUnitOwner"           default="0">
<cfparam name="Attributes.Remarks"                default="">

<cfparam name="Attributes.Shipping"               default="No">
<cfparam name="Attributes.ShippingTrigger"        default="">

<cfif Attributes.ReceiptId neq "" and Attributes.ReceiptId neq "{00000000-0000-0000-0000-000000000000}" and attributes.TransactionType neq "1">

	<!--- 6/4/2105  inherit here --->
								
		<cfquery name="getReceipt" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">					
				SELECT  *
				FROM    ItemTransaction 
				WHERE   ReceiptId = '#Attributes.ReceiptId#'							
				AND     TransactionType = '1'
		</cfquery>
		
		<cfset attributes.receiptPrice     = getReceipt.ReceiptPrice>
		<cfset attributes.ReceiptCostPrice = getReceipt.ReceiptCostPrice>	

</cfif>

<cfif Item.recordcount eq "0" or Warehouse.Recordcount eq "0">

    <cf_message message="Stock transaction can NOT be completed [Item:<cfif Item.recordcount eq '0'>Not determined<cfelse>OK</cfif> | Warehouse:<cfif Warehouse.Recordcount eq '0'>not determined<cfelse>OK</cfif>]. Operation aborted">
	<cfabort>

</cfif>


<!--- ------------------------------------- --->
<!--- --1/4 check if item exists mission--- --->
<!--- ------------------------------------- --->

<cfquery name="Check" 
   datasource="#Attributes.DataSource#" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT * 
   FROM   Materials.dbo.ItemUoMMission 
   WHERE  ItemNo    = '#Attributes.ItemNo#'
   AND    UoM       = '#Attributes.TransactionUoM#'
   AND    Mission   = '#Attributes.Mission#'
</cfquery>

<cfif Check.recordCount is 0>

   <cfquery name="Insert" 
   datasource="#Attributes.DataSource#" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   INSERT INTO    Materials.dbo.ItemUoMMission 
	          (ItemNo,
			   UoM,
			   Mission,
			   StandardCost,			   
			   OfficerUserId,
			   OfficerLastName,
			   OfficerFirstName)
	   VALUES ('#Attributes.ItemNo#', 
	           '#Attributes.TransactionUoM#',
	           '#Attributes.Mission#', 
	           '#ItemUoM.StandardCost#', 			  
			   '#SESSION.acc#', 
			   '#SESSION.last#', 
			   '#SESSION.first#')
   </cfquery>

</cfif>

<!--- ------------------------------------- --->
<!--- --1/4 check if item exists warehouse- --->
<!--- ------------------------------------- --->

<cfquery name="Check" 
   datasource="#Attributes.DataSource#" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT * 
   FROM   Materials.dbo.ItemWarehouse 
   WHERE  ItemNo    = '#Attributes.ItemNo#'
   AND    UoM       = '#Attributes.TransactionUoM#'
   AND    Warehouse = '#Attributes.Warehouse#'
</cfquery>

<cfif Check.recordCount is 0>

   <cfquery name="Insert" 
   datasource="#Attributes.DataSource#" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   INSERT INTO    Materials.dbo.ItemWarehouse 
	          (ItemNo,
			   UoM,
			   Warehouse,
			   Destination,
			   ReStocking,
			   OfficerUserId,
			   OfficerLastName,
			   OfficerFirstName)
	   VALUES ('#Attributes.ItemNo#', 
	           '#Attributes.TransactionUoM#',
	           '#Attributes.Warehouse#', 
	           'Distribution', 
			   'Procurement', 
			   '#SESSION.acc#', 
			   '#SESSION.last#', 
			   '#SESSION.first#')
   </cfquery>

</cfif>

<!--- ------------------------------------- --->
<!--- --2/4 check if item exists location-- --->
<!--- ------------------------------------- --->

<cfquery name="Check" 
   datasource="#Attributes.DataSource#" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   Materials.dbo.ItemWarehouseLocation 
	   WHERE  ItemNo    = '#Attributes.ItemNo#'
	   AND    UoM       = '#Attributes.TransactionUoM#'
	   AND    Warehouse = '#Attributes.Warehouse#'
	   AND    Location  = '#Attributes.Location#'
</cfquery>

<cfif Check.recordCount is 0>

   <cfquery name="getWarehouseLocation" 
  	   datasource="#Attributes.DataSource#" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   Materials.dbo.WarehouseLocation
	   WHERE  Warehouse = '#Attributes.Warehouse#'
	   AND    Location  = '#Attributes.Location#' 	  
   </cfquery>
   
   <cfif getWarehouseLocation.recordcount eq "0">
   
	   	<cf_message message="Invalid receipt location (#Attributes.Location#) for warehouse : #Attributes.Warehouse#.">
		<cfabort>
   
   <cfelseif item.ItemClass eq "Supply">

	   <cfquery name="Insert" 
		   datasource="#Attributes.DataSource#" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   INSERT INTO Materials.dbo.ItemWarehouseLocation 
		          (ItemNo,
				   Uom,
				   Warehouse,
				   Location,
				   OfficerUserId,
				   OfficerLastName,
				   OfficerFirstName)
		   VALUES ('#Attributes.ItemNo#', 
		           '#Attributes.TransactionUoM#',
		           '#Attributes.Warehouse#', 
		           '#Attributes.Location#', 
				   '#SESSION.acc#', 
				   '#SESSION.last#', 
				   '#SESSION.first#')
	   </cfquery>
   
   </cfif>

</cfif>

<!--- --------------------------------------------- --->
<!--- --- 3/4 check  mission lot reference exists-- --->
<!--- --------------------------------------------- --->

<cfif Attributes.transactionLot eq "">
    <CFSET Attributes.transactionLot = "0">
</cfif>

<cfif Attributes.transactionLot neq "0">
	
	<!--- check if lot exists --->
	
	<cfquery name="getLot" 
	   datasource="#Attributes.DataSource#" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   SELECT * 
		   FROM   Materials.dbo.ProductionLot 
		   WHERE  Mission         = '#Attributes.Mission#'
		   AND    TransactionLot  = '#Attributes.TransactionLot#'
	</cfquery>
	
	<cfif getLot.recordcount eq "0">
		
		<cfquery name="Insert" 
		   datasource="#Attributes.DataSource#" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   INSERT INTO Materials.dbo.ProductionLot
			   (Mission,
			    TransactionLot,
				TransactionLotDate,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName)
		   VALUES
			   ('#Warehouse.Mission#',
			    '#Attributes.TransactionLot#',
				#dte#,
				'#session.acc#',
				'#session.last#',
				'#session.first#')
		</cfquery>	
			
	</cfif>
	
	<cfquery name="getLot" 
	   datasource="#Attributes.DataSource#" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   SELECT * 
		   FROM   Materials.dbo.ProductionLot 
		   WHERE  Mission         = '#Attributes.Mission#'
		   AND    TransactionLot  = '#Attributes.TransactionLot#'
	</cfquery>

	<!--- check if item/lot exisit --->

	<cfif getLot.recordcount eq "1" and Attributes.transactionLot neq "0">
	
			<cfquery name="Check" 
			   datasource="#Attributes.DataSource#" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				   SELECT * 
				   FROM   Materials.dbo.ItemUoMMissionLot 
				   WHERE  ItemNo         = '#Attributes.ItemNo#'
				   AND    UoM            = '#Attributes.TransactionUoM#'
				   AND    Mission        = '#Warehouse.Mission#'
				   AND    TransactionLot = '#Attributes.TransactionLot#'
			</cfquery>
			
			<cfif Check.recordCount is 0>
			
				<cfinvoke component    = "Service.Process.Materials.Item"  
		              method           = "getBarCode"                                   
		              ItemNo           = "#Attributes.ItemNo#"
		              UoM              = "#Attributes.TransactionUoM#"
		              Mission          = "#Warehouse.Mission#"
		              Lot              = "#Attributes.TransactionLot#"
		              DataSource       = "#Attributes.DataSource#"
					  returnvariable   = "strBarCode">
		
			   <cfquery name="Insert" 
			   	   datasource="#Attributes.DataSource#" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   INSERT INTO Materials.dbo.ItemUomMissionLot 
				          (ItemNo,
						   UoM,
						   Mission,
						   TransactionLot,	
						   ItemBarCode,		 
						   OfficerUserId,
						   OfficerLastName,
						   OfficerFirstName)
				   VALUES ('#Attributes.ItemNo#', 
				           '#Attributes.TransactionUoM#',
				           '#Attributes.Mission#', 
				           '#Attributes.TransactionLot#', 
						   '#strBarCode#',			  
						   '#SESSION.acc#', 
						   '#SESSION.last#', 
						   '#SESSION.first#')
			   </cfquery>
			
			</cfif>
			
	</cfif>	
	
</cfif>	

<!--- ------------------------------------- --->
<!--- --4/4--check if location exists------ --->
<!--- ------------------------------------- --->

<cfquery name="Check" 
   datasource="#Attributes.DataSource#" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT   * 
	   FROM     Materials.dbo.WarehouseLocation 
	   WHERE    Warehouse = '#Attributes.Warehouse#'
	   AND      Location  = '#Attributes.Location#'
</cfquery>

<cfif Check.recordCount is 0>

   <cfquery name="Insert" 
   datasource="#Attributes.DataSource#" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   
	   INSERT INTO Materials.dbo.WarehouseLocation
		          (Warehouse,
				   Location, 
				   OfficerUserId, 
				   OfficerLastName, 
				   OfficerFirstName)
				   
	   VALUES ('#Attributes.Warehouse#',
	           '#Attributes.Location#',
			   '#SESSION.acc#',
			   '#SESSION.last#',
			   '#SESSION.first#')
			   
   </cfquery>
   
</cfif>

<cfquery name="getLocation" 
   datasource="#Attributes.DataSource#" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   Materials.dbo.WarehouseLocation 
	   WHERE  Warehouse = '#Attributes.Warehouse#'
	   AND    Location  = '#Attributes.Location#'
</cfquery>

<cfif attributes.billingmode eq "">
  <cfset attributes.billingmode = GetLocation.BillingMode>
</cfif>

<!--- -------- WAS converted to base currency for warehouse transaction on line 58  ------- --->

<cfset tot    = round(Attributes.TransactionQuantity*(TransactionCostPrice)*1000)/1000>

<!--- ------ GL is always done in the currency of the transaction to be posted first 
                                                and THEN reverted to the base currency---- --->

<cfset totGL  = round(Attributes.TransactionQuantity*(Attributes.TransactionCostPrice*1000))/1000>

<cfif Attributes.TransactionType neq "1" or Attributes.ReceiptId eq "{00000000-0000-0000-0000-000000000000}">
 
    <!--- distribution, COGS, Variances and also direct receipt etc. --->
	<cfset totCredit   = totGL>
	<cfset priceDiff   = 0>
	
<cfelse>

    <!--- Purchase receipt amount to be paid for, so we have price differences between stock value and receipt  --->
	<cfset totCredit   = round(Attributes.TransactionQuantity*(Attributes.ReceiptPriceCurrency*1000))/1000>
	
	<!--- added 1/4/2012 to cater for change of currency of the received item versus the PO line which drives the journal --->	
	<cf_exchangeRate datasource    = "#Attributes.DataSource#" 
	                 EffectiveDate = "#Attributes.TransactionDate#"
                     currencyFrom  = "#attributes.ReceiptCurrency#"
                     currencyTo    = "#attributes.TransactionCurrency#">
					
	<!--- the value of the stock --->				 
	<cfset totCredit = round(totCredit*1000/exc)/1000>		

	<!--- GL exchange rate difference booking of stock and receipt; which will usually be very small --->
	<cfset priceDiff   = totCredit - totGL>	
	<cfset pricediff = round(pricediff*1000)/1000>

	<!--- added 3/25/2015 --->
	<cfif abs(priceDiff) lt 0.04>
	
		<cfset totCredit = totGL>
		<cfset priceDiff = "0">	
		
	</cfif>
	
	<!---
	<cfoutput>	
		Purchases : #attributes.ReceiptCurrency# #Attributes.ReceiptPrice# -> #totCredit#
		Stock : #attributes.TransactionCurrency# -> #totGL#
		Price : #pricediff#
	</cfoutput>
	--->
	
</cfif>
		
<cfparam name="Attributes.ReferenceId"            default="#attributes.TransactionId#">
<cfparam name="Attributes.GLTransaction"          default="1">
<cfparam name="Attributes.GLCurrency"             default="#attributes.transactionCurrency#">
<cfparam name="Attributes.GLTransactionNo"        default="#Attributes.TransactionBatchNo#">

<cfparam name="Attributes.GLAccountDebit"         default="">
<cfparam name="Attributes.GLAccountCredit"        default="">
<cfparam name="Attributes.GLAccountDiff"          default="">

<!--- ----------------------------------------------------------------------- --->
<!--- ------------------- record transaction -------------------------------- --->
<!--- ----------------------------------------------------------------------- --->

<cfquery name="get" 
   datasource="#Attributes.DataSource#" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT * 
   FROM   Materials.dbo.ItemTransaction 
   WHERE  TransactionId = '#attributes.transactionid#'
</cfquery>

<cfif get.recordcount eq "0">

	<cfquery name="Insert" 
	   datasource="#Attributes.DataSource#" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   INSERT INTO Materials.dbo.ItemTransaction 
				(TransactionId,
				 <cfif attributes.TransactionIdOrigin neq "">
				 TransactionIdOrigin,
				 </cfif>
				 TransactionType, 
				 TransactionTimeZone,
				 TransactionDate, 
				 TransactionLot,
				 ItemNo, 
				 ActionStatus,
				 Mission,
				 Location, 
				 BillingMode,
				 Warehouse, 
				 <cfif attributes.workorderid neq "">
				 WorkOrderId,
				 WorkorderLine,
				 <cfif attributes.RequirementId neq "">
					 RequirementId,
				 </cfif>
				 </cfif>
				 <cfif attributes.billingunit neq "">
				 BillingUnit,
				 </cfif>
				 <cfif attributes.programcode neq "">
				 ProgramCode,
				 </cfif>
				 <cfif attributes.assetid neq "">
				 AssetId,
				 </cfif>	
				 <cfif attributes.Customerid neq "">
				 CustomerId,
				 </cfif>	
				 <cfif attributes.LocationId neq "">
				 TransactionLocationId,
				 </cfif>			
				 <cfif attributes.personno neq "">
				 PersonNo,
				 </cfif>
				 <cfif attributes.transactionMetric neq "">
				 TransactionMetric,
				 </cfif>
				 TransactionReference,
				 TransactionUoM, 
				 TransactionOnHand,
				 TransactionQuantity, 			 
				 TransactionCostPrice, 
				 TransactionValue,
				 TransactionUoMMultiplier,
				 
				 <cfif TrackingNo neq "">
				 ItemTrackingNo,
				 </cfif>
				 
				 <cfif Attributes.TransactionBatchNo neq "">
					 TransactionBatchNo,
				 </cfif>
				 <cfif Attributes.ReceiptId neq "" and Attributes.ReceiptId neq "{00000000-0000-0000-0000-000000000000}">
					 ReceiptId,
					 ReceiptCostPrice,		<!--- this is price as it is recorded in the receipt line as opposed to the activated price --->	
					 ReceiptPrice,
				 <cfelseif Attributes.transactionQuantity gt 0>
				 	 ReceiptCostPrice,			
					 ReceiptPrice,
				 </cfif>
				 <cfif Attributes.OrgUnit neq "" and Attributes.OrgUnit neq "0">
					 OrgUnit,
					 OrgUnitCode,
					 OrgUnitName,
				 </cfif>
				 <cfif Attributes.RequestId neq "">
				 	RequestId,
				 </cfif>
				 <cfif Attributes.TaskSerialNo neq "">
				    TaskSerialNo,
				 </cfif>
				 <cfif Attributes.Ledger eq "Yes">		
				 GLAccountDebit, 
				 GLAccountCredit,
				 </cfif>
				 <cfif attributes.ParentTransactionId neq "">
				 ParentTransactionId,
				 </cfif>
				 Remarks,		 			 
				 ItemDescription, 
				 ItemCategory, 
				 ItemPrecision,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
			 
			VALUES 
			
				(
				 '#Attributes.TransactionId#',
				 <cfif attributes.TransactionIdOrigin neq "">
				 '#Attributes.TransactionIdOrigin#',
				 </cfif>
				 '#Attributes.TransactionType#', 
				 '#timezone#',
				 #dte#, 
				 <cfif Attributes.TransactionLot neq "0"> 
				 '#Attributes.TransactionLot#',
				 <cfelse>
				 '0',
				 </cfif>
				 '#Attributes.ItemNo#', 
				 '#Attributes.ActionStatus#',
				 '#Warehouse.Mission#',
				 '#Attributes.Location#', 
				 <!--- added field --->
				 '#Attributes.BillingMode#',
				 '#Attributes.Warehouse#',		 
				 <cfif attributes.workorderid neq "">
					 '#Attributes.WorkOrderId#',
					 '#attributes.WorkOrderLine#',	
					 <cfif attributes.RequirementId neq "">
						 '#attributes.RequirementId#',
					 </cfif>	 
				 </cfif>
				 <cfif attributes.billingunit neq "">
				 '#attributes.billingunit#',
				 </cfif>
				 <cfif attributes.programcode neq "">
				 '#attributes.programcode#',
				 </cfif>
				 <cfif attributes.assetid neq "">
				 '#attributes.AssetId#',
				 </cfif>	
				  <cfif attributes.Customerid neq "">
				 '#attributes.CustomerId#',
				 </cfif>	
				 <cfif attributes.LocationId neq "">
				 '#attributes.Locationid#',
				 </cfif>			
				 <cfif attributes.personno neq "">
				     '#attributes.PersonNo#',
				 </cfif>	
				 <cfif attributes.transactionMetric neq "">
				     '#attributes.TransactionMetric#',
				 </cfif>	
				 '#Attributes.TransactionReference#',
				 '#Attributes.TransactionUoM#', 
				 '#Onhand.Quantity#',
				 '#Attributes.TransactionQuantity#', 
				 '#TransactionCostPrice#', 
				 '#tot#',		 
				 '#ItemUoM.UOMMultiplier#',
				 <cfif TrackingNo neq "">
				 '#TrackingNo#',
				 </cfif>
				 
				 <cfif Attributes.TransactionBatchNo neq "">
					 '#Attributes.TransactionBatchNo#',
				 </cfif>			 
				 
				 <cfif Attributes.ReceiptId neq "" and Attributes.ReceiptId neq "{00000000-0000-0000-0000-000000000000}">
					 '#Attributes.ReceiptId#',
					 '#Attributes.ReceiptCostPrice#',			
					 '#Attributes.ReceiptPrice#',
				 <cfelseif Attributes.TransactionQuantity gt "0">  <!--- transfer or initial stock --->
				     '#Attributes.ReceiptCostPrice#',			
					 '#Attributes.ReceiptPrice#',			 	 
				 </cfif>
				 			 
				 <cfif Attributes.OrgUnit neq "" and Attributes.OrgUnit neq "0">
					 '#Attributes.OrgUnit#', 
					 '#Org.OrgUnitCode#', 
					 '#Org.OrgUnitName#', 
				 </cfif>
				 
				 <cfif Attributes.RequestId neq "">
				 	'#Attributes.RequestId#',
				 </cfif>
				 
				 <cfif Attributes.TaskSerialNo neq "">
				    '#attributes.TaskSerialNo#',
				 </cfif>
				 
				 <cfif Attributes.Ledger eq "Yes">			 
				    '#Attributes.GLAccountDebit#',
				    '#Attributes.GLAccountCredit#',				 
				 </cfif>
				 	 
				 <cfif attributes.ParentTransactionId neq "">
				 '#attributes.ParentTransactionId#',
				 </cfif>
				 '#Attributes.Remarks#',			
				 
				 '#Item.Itemdescription#', 
				 '#Item.Category#', 
				 '#Item.ItemPrecision#',
				 
				 '#SESSION.acc#',
				 '#SESSION.last#',  
				 '#SESSION.first#'
				 
				)
				
	</cfquery>
		
	<CFSET caller.baseprice = TransactionCostPrice>	
		
	<!--- ----------------------------------------------------------------------- --->
	<!--- valuation of the deduction transaction taking its value from the source --->
	<!--- any negative transaction has to be sourced and its value will be ------ --->     
	<!--- derrived from the value of the positive transactions ------------------ --->                                                              
	<!--- ----------------------------------------------------------------------- --->

	<cfif attributes.TransactionQuantity lt "0">	
			
		<!--- we need to get the sourcing of this transaction from one or more sources and get a price for them --->
				
		<cfinvoke component    = "Service.Process.Materials.Stock"  
		   method              = "getItemValuation" 
		   datasource          = "#attributes.datasource#"
		   transactionQuantity = "#attributes.TransactionQuantity#"
		   transactionDate     = "#attributes.TransactionDate#"
		   Mission             = "#attributes.Mission#"
		   TransactionId       = "#attributes.TransactionId#"
		   Warehouse           = "#attributes.Warehouse#"
		   Location            = "#attributes.Location#"
		   TransactionLot      = "#attributes.TransactionLot#"
		   TransactionUoM      = "#attributes.TransactionUoM#"
		   ItemNo			   = "#attributes.ItemNo#"
		   TransactionIdOrigin = "#attributes.TransactionIdOrigin#"
		   WorkOrderId         = "#attributes.WorkOrderId#">
				
		<!--- update price and value of the sourcing details as the distribution transaction is a FK and we capture
		in TransactionId and serialNo the transactions that used to source this distribution transaction --->		
					
		<cfquery name="getValue" 
		   datasource="#Attributes.DataSource#" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   SELECT    SUM(TransactionQuantity)       AS Quantity, 
		             SUM(TransactionCostPriceValue) AS Value
	       FROM      Materials.dbo.ItemTransactionValuation
		   WHERE     DistributionTransactionId = '#attributes.TransactionId#' 
		</cfquery>
		
		<!--- get the oldest date of the sourcing transactions to be used as the currency date --->
		
		<cfif Item.ValuationCode eq "Manual">
		
			<!--- always use the current date for conversion --->
			
			<cfset cdt = dateformat(now(),CLIENT.DateFormatShow)>
		
		<cfelse>
		
			<!--- 17/5/2012 we potentially 
			   apply the exchange rate conversion as valid the moment we received the items --->
		
			<cfquery name="getDate" 
			   datasource="#Attributes.DataSource#" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT    TOP 1 S.TransactionDate
		       FROM      Materials.dbo.ItemTransactionValuation V, 
			             Materials.dbo.ItemTransaction S
			   WHERE     V.TransactionId = S.TransactionId
			   AND       V.DistributionTransactionId = '#attributes.TransactionId#' 
			   ORDER BY S.TransactionDate
			</cfquery>
			
			<cfif getDate.recordcount eq "0">
		        <cfset cdt = dateformat(now(),CLIENT.DateFormatShow)>	
			<cfelse>
				<cfset cdt = dateformat(getDate.TransactionDate,CLIENT.DateFormatShow)>
			</cfif>	
			
		</cfif>	
				
		<cfset val = round(getValue.Value*1000)/1000>
		<cfset prc = round((getValue.Value/getValue.Quantity)*10000)/10000>
		
		<!--- set the transaction cost price based on the determined value expressed in the base currency --->
		
		<!---
		
		<cfquery name="Update" 
		   datasource="#Attributes.DataSource#" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">		
		      
		   UPDATE   Materials.dbo.ItemTransaction
		   
		   SET      TransactionCostPrice = '#prc#',
		            TransactionValue     = '#val#'
		   WHERE    TransactionId        = '#attributes.TransactionId#'   
		   AND      TransactionQuantity > 0
		  
		</cfquery>  
		
		--->
		   
		<cfquery name="Update" 
		   datasource="#Attributes.DataSource#" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">			  
		   
		   UPDATE   Materials.dbo.ItemTransaction
		   
		   SET      TransactionCostPrice = '#prc#',
		            TransactionValue     = #val*-1#
		   WHERE    TransactionId        = '#attributes.TransactionId#'   
		   AND      TransactionQuantity < 0 
		   		   
		 </cfquery>  
		 
		 <!--- correction 16/5 to reconstruct in the value based on the exchange rate at the moment of the sourcing transactions --->
		 	 
		 <!--- GL cost price --->
		 
		 <cfset totGL = round(getValue.Value*-1000)/1000>			 				 					 
				 		 
		 <CFSET caller.cprice = prc>	
		 
	<cfelse>
	
		<cfset cdt = dateformat(now(),CLIENT.DateFormatShow)>	 	
			 	
	</cfif>
	
	<cfif Attributes.DetailLineNo gte "1">
	
		<cfparam name="attributes.DetailSeal"         default="">
		<cfparam name="attributes.DetailReadInitial"  default="">
		<cfparam name="attributes.DetailReadFinal"    default="">
		<cfparam name="attributes.DetailReadUoM"      default="">
		<cfparam name="attributes.DetailReference1"   default="">
		<cfparam name="attributes.DetailReference2"   default="">
		<cfparam name="attributes.DetailMeasure0"     default="0">
		<cfparam name="attributes.DetailMeasure1"     default="0">
		<cfparam name="attributes.DetailMeasure2"     default="0">
		<cfparam name="attributes.DetailMeasure3"     default="0">
		
		<!--- enforce the correct entry of density and temperature --->
		
		<cfif attributes.DetailMeasure0 eq "" or not LSIsNumeric(attributes.DetailMeasure0)>
		   <cfset DetailMeasure0 = 0>	  
		<cfelse>
		   <cfset DetailMeasure0 = attributes.DetailMeasure0>	 
		</cfif>
		
		<cfif attributes.DetailMeasure1 eq "" or not LSIsNumeric(attributes.DetailMeasure1)>
		   <cfset DetailMeasure1 = 0>	  
		<cfelse>
		    <cfset DetailMeasure1 = attributes.DetailMeasure1>	    
		</cfif>
		
		<cfif attributes.DetailMeasure2 eq "" or not LSIsNumeric(attributes.DetailMeasure2)>
		   <cfset DetailMeasure2 = 0>	   
		<cfelse>
	 	   <cfset DetailMeasure2 = attributes.DetailMeasure2>		   
		</cfif>
		
		<cfif attributes.DetailMeasure3 eq "" or not LSIsNumeric(attributes.DetailMeasure3)>
		   <cfset DetailMeasure3 = 0>	   
		<cfelse>
		   <cfset DetailMeasure3 = attributes.DetailMeasure3>		   
		</cfif>
			
		<cfquery name="Insert" 
		   datasource="#Attributes.DataSource#" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   INSERT INTO Materials.dbo.ItemTransactionDetail (		
				TransactionId, 
				TransactionLineNo, 
				ContainerSeal, 
				MeterReadingInitial, 
				MeterReadingFinal, 
				MeterReadingUoM,
				Reference1, 
				Reference2, 
				Measurement0, 
				Measurement1, 
		        Measurement2, 
				Measurement3, 
				OfficerUserId, 
				OfficerLastName, 
				OfficerFirstName )
		VALUES (
			 '#Attributes.TransactionId#', 				
			 '#attributes.DetailLineNo#',
			 '#attributes.DetailSeal#',
			 '#attributes.DetailReadInitial#',
			 '#attributes.DetailReadFinal#',
			 '#attributes.DetailReadUoM#',
			 '#attributes.DetailReference1#',
			 '#attributes.DetailReference2#',
			 '#DetailMeasure0#',
			 '#DetailMeasure1#',
			 '#DetailMeasure2#',
			 '#DetailMeasure3#',				
			 '#SESSION.acc#', 
			 '#SESSION.last#',
			 '#SESSION.first#' )
		</cfquery>
	
	</cfif>
						
	<!--- --------------------------------------------------------------- --->		
	<!--- ---2/3 of Generate GL Record----------------------------------- --->
	<!--- --------------------------------------------------------------- --->
	
	<cf_verifyOperational 
	         datasource= "#Attributes.DataSource#"
	         module    = "Accounting" 
			 Warning   = "No">
	 
	<cfif Operational eq "1"> 
	  	
		<!--- Use the journal as used for the PO, so if PO is in EUR, receipts are booked in Euros, just like 
		invoice would be booked in Euros --->
		
		<cfquery name="getJournal" 
		    datasource="#Attributes.DataSource#" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
					SELECT    *
					FROM      Materials.dbo.WarehouseJournal
					WHERE     Warehouse     = '#attributes.Warehouse#' 
					AND       Area          = '#Attributes.TransactionClass#' 
					AND       Currency      = '#Attributes.GLCurrency#'  
		</cfquery>
		
		<!--- acquire the deeper purpose of the transaction if this is workorder triggered --->
		
		<cfif Attributes.workorderid neq "" and Attributes.workorderline neq "">
		
			<cfquery name="getWorkOrder" 
		    datasource="#Attributes.DataSource#" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT    *
				FROM      WorkOrder.dbo.WorkOrderLine
				WHERE     WorkorderId   = '#attributes.WorkOrderId#' 
				AND       WorkOrderLine = '#Attributes.WorkOrderLine#' 				
			</cfquery>
		
			<cfset WorkorderLineId = getWorkOrder.WorkorderlineId>	
		
		<cfelse>
		
			<cfset WorkOrderLineid = "">
			
		</cfif>
		
		<cfquery name="getJournal" 
		    datasource="#Attributes.DataSource#" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
					SELECT    *
					FROM      Materials.dbo.WarehouseJournal
					WHERE     Warehouse     = '#attributes.Warehouse#' 
					AND       Area          = '#Attributes.TransactionClass#' 
					AND       Currency      = '#Attributes.GLCurrency#'  
		</cfquery>		
		
		<!--- get default journal --->
	
		<cfif getJournal.recordcount eq "0">
	 	
			<cfquery name="getJournal" 
			    datasource="#Attributes.DataSource#" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
					SELECT    *
					FROM      Accounting.dbo.Journal
					WHERE     Mission       = '#Warehouse.Mission#' 
					AND       SystemJournal = 'Warehouse'
					AND       Currency      = '#Attributes.GLCurrency#'  
			</cfquery>					
				
			<cfif getJournal.recordcount eq "0">
							
					<cf_waitEnd> 							
					<cf_message message = "A Facility Journal for currency: #Attributes.GLCurrency# was not defined. Operation not allowed." return = "back">
					<cfabort>
				  
			</cfif> 
			
		</cfif>	 
		
		<cfquery name="Journal" 
		    datasource="#Attributes.DataSource#" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT    *
				FROM      Accounting.dbo.Journal
				WHERE     Journal = '#getJournal.Journal#' 	
		</cfquery>
		
		<cfif getJournal.recordcount eq "0">
							
				<cf_waitEnd> 
							
				<cf_message message = "A facility Journal for currency: #Attributes.GLCurrency# does no longer exist. Operation not allowed."
				  return = "back">
				  <cfabort>
				  
		</cfif>	
				
		<cfif   Attributes.GLAccountDebit  neq "" and 
		        Attributes.GLAccountCredit neq "" and 
				Journal.Journal            neq "" and 
				Attributes.Ledger eq "Yes">		  
			
			<cfset OrgUnitOwner = Attributes.OrgUnitOwner>
				
			 <cfquery name="Parameter" 
			    datasource="#Attributes.DataSource#" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				    SELECT    *
				    FROM      Accounting.dbo.Ref_ParameterMission
					WHERE     Mission = '#Warehouse.Mission#'
			 </cfquery> 
			  
			  <!--- this entity posts by parent  --->
			
			  <cfif Parameter.AdministrationLevel eq "Parent">
			  
			        <!--- determine a default owner --->
			
					<cfif Attributes.OrgUnitOwner eq "0">
					
					  <cfquery name="getOwner" 
					    datasource="#Attributes.DataSource#" 
					    username="#SESSION.login#" 
				    	password="#SESSION.dbpw#">
						SELECT    TOP 1 OrgUnit
						FROM      Organization.dbo.Organization O
						WHERE     Mission = '#warehouse.mission#'
						AND       OrgUnitCode IN
			                          (SELECT     TOP 1 HierarchyRootUnit
			                            FROM      Organization.dbo.Organization
										WHERE     Mission          = O.Mission							
			                            AND       MissionOrgUnitId = '#warehouse.MissionOrgUnitId#'
			                            ORDER BY  Created DESC
									)		
						ORDER BY Created DESC					
						</cfquery>
					
						<cfif getOwner.recordcount eq "1">
						
							<cfset OrgUnitOwner = getOwner.OrgUnit>
						 
						</cfif>					
						
					</cfif>
					
			  </cfif>
			  
			<cfif Attributes.OrgUnit neq "">
					
				<cfset costcenter = attributes.orgunit>
				
			<cfelse>
			
			 		<cfquery name="getUnit" 
					    datasource="#Attributes.DataSource#" 
					    username="#SESSION.login#" 
				    	password="#SESSION.dbpw#">
						SELECT    TOP 1 OrgUnit
						FROM      Organization.dbo.Organization O
						WHERE     Mission          = '#warehouse.mission#'
						AND       MissionOrgUnitId = '#warehouse.MissionOrgUnitId#'
						ORDER BY  Created DESC		           								
					</cfquery>
					
					<!--- we apply the cost center of the operating facility --->
					
					<cfset costcenter = getUnit.orgunit>
													
			</cfif>
			
			<cfquery name="Type" 
		    datasource="#Attributes.DataSource#" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    SELECT    *
			    FROM      Materials.dbo.Ref_TransactionType
				WHERE     TransactionType = '#Attributes.TransactionType#'
			</cfquery> 
					
			<!--- provision to pass a descriptive to the GL Transaction header --->
			<cfif attributes.remarks eq "">
				<cfset attributes.remarks = type.description>
			</cfif>
			
			<!--- there are two modes, 
			          standard transaction 
					  and a transaction = sale mode for POS sale which does combine stock and sale into a single action (warehouse) --->
					
			<cfif Attributes.TransactionClass eq "Stock">
					
					<!--- receipt maybe have price differences --->		
												
					<cfif Attributes.TransactionType eq "1">				
						
						<cfset cls1 = "Debit">  <!--- goods --->
						<cfset cls2 = "Credit"> <!--- contra payables --->
						<cfset cls3 = "Debit">  <!--- Price difference --->									
					
					    <!--- only relevant if goods are recorded not as fifo / lifo --->
						<cfif priceDiff lt "0">
							<cfset cls3 = "Credit">
							<cfset priceDiff = abs(priceDiff)>										
						</cfif>	
																							
					<cfelse>
					
						<!--- all other transaction type like issue/transfer/variance --->
					
						<cfif totGl gt "0">		
							 
						   <cfset cls1 = "Debit">
						   <cfset cls2 = "Credit">			  		
						   
						<cfelse>
						
						   <cfset cls1      = "Debit">
						   <cfset cls2      = "Credit">
						   <cfset totGl     = abs(totGl)>
						   <cfset totCredit = totGL>					  
						   
						</cfif>						
									
					</cfif>
					
					<cfif Attributes.GLTransactionSourceId eq "" and Attributes.TransactionBatchNo neq "">
										
						<cfquery name="Batch"
							datasource="#Attributes.DataSource#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    SELECT  *
							FROM    Materials.dbo.WarehouseBatch
							WHERE   BatchNo = '#Attributes.TransactionBatchNo#' 	
						</cfquery>		
						
						<cfset Attributes.GLTransactionSourceId = Batch.BatchId>		
						<cfset Attributes.GLTransactionSourceNo = Batch.BatchNo>				
					
					</cfif>
											
					<cf_GledgerEntryHeader
					    DataSource            = "#Attributes.DataSource#"
						Mission               = "#Attributes.Mission#"
						OrgUnitOwner          = "#OrgUnitOwner#"
						Journal               = "#Journal.Journal#" 
						Description           = "#Attributes.Remarks#"
						TransactionSource     = "#Attributes.TransactionSource#"
						TransactionSourceId   = "#Attributes.GLTransactionSourceId#"
						TransactionSourceNo   = "#Attributes.GLTransactionSourceNo#"
						AccountPeriod         = "#Parameter.CurrentAccountPeriod#"
						TransactionCategory   = "#Attributes.TransactionCategory#"
						JournalTransactionNo  = "#Attributes.GLTransactionNo#"
						MatchingRequired      = "0"
						ActionStatus          = "1"
						Reference             = "Warehouse"       
						ReferenceName         = "#Attributes.ItemNo# #left(Item.Itemdescription,100)#"
						ReferenceId           = "#Attributes.TransactionId#"
						ReferenceNo           = ""
						TransactionDate       = "#Attributes.TransactionDate#"
						DocumentCurrency      = "#Attributes.TransactionCurrency#"
						DocumentDate          = "#Attributes.TransactionDate#"
						DocumentAmount        = "#totCredit#"
						AmountOutstanding     = "0">
						
						<!--- In case of sale we book the sale + tax --->			
					
						<!--- Lines of the stock involved --->
						
						<!--- to prevent unneeded booking we round the price diff to 3 digits first --->
						<cfset pricediff = round(pricediff*1000)/1000>
						
						<cfif pricediff eq "0">
													 
							<cf_GledgerEntryLine
							    DataSource            = "#Attributes.DataSource#"
								Lines                 = "2"
								TransactionDate       = "#Attributes.TransactionDate#"
								Journal               = "#Journal.Journal#"
								JournalNo             = "#JournalTransactionNo#"
								JournalTransactionNo  = "#Attributes.GLTransactionNo#"
								AccountPeriod         = "#Parameter.CurrentAccountPeriod#"
								Currency              = "#Attributes.TransactionCurrency#"
								CurrencyDate          = "#cdt#"
													
								TransactionSerialNo1  = "1"
								Class1                = "#cls1#"
								Reference1            = "Warehouse"       
								ReferenceName1        = "#left(Item.Itemdescription,100)#"
								Description1          = "#Type.Description#"
								GLAccount1            = "#Attributes.GLAccountDebit#"
								Costcenter1           = "#costcenter#"
								WorkOrderLineId1      = "#workorderlineid#"
								ReferenceId1          = "#Attributes.ReferenceId#"
								ReferenceNo1          = "#Attributes.ItemNo#"
								TransactionType1      = "Standard"
								Amount1               = "#totGl#"
									
								TransactionSerialNo2  = "2"
								Class2                = "#cls2#"
								Reference2            = "Warehouse"       
								ReferenceName2        = "#left(Item.Itemdescription,100)#"
								Description2          = "#Type.Description#"
								GLAccount2            = "#Attributes.GLAccountCredit#"
								Costcenter2           = "#costcenter#"
								WorkOrderLineId2      = "#workorderlineid#"
								ReferenceNo2          = "#Attributes.ItemNo#"
								ReferenceId2          = "#Attributes.ReferenceId#"
								TransactionType2      = "Standard"
								Amount2               = "#totCredit#">
														
						<cfelse>		
						
											
							<cf_GledgerEntryLine
							    DataSource            = "#Attributes.DataSource#"
								Lines                 = "3"
								TransactionDate       = "#Attributes.TransactionDate#"
								Journal               = "#Journal.Journal#"
								JournalNo             = "#JournalTransactionNo#"
								JournalTransactionNo  = "#Attributes.GLTransactionNo#"
								AccountPeriod         = "#Parameter.CurrentAccountPeriod#"
								Currency              = "#Attributes.TransactionCurrency#"
								CurrencyDate          = "#cdt#"
													
								TransactionSerialNo1  = "1"
								Class1                = "#cls1#"
								Reference1            = "Warehouse"       
								ReferenceName1        = "#left(Item.Itemdescription,100)#"
								Description1          = "#Type.Description#"
								GLAccount1            = "#Attributes.GLAccountDebit#"
								Costcenter1           = "#costcenter#"
								WorkOrderLineId1      = "#workorderlineid#"
								ReferenceId1          = "#Attributes.ReferenceId#"
								ReferenceNo1          = "#Attributes.ItemNo#"
								TransactionType1      = "Standard"
								Amount1               = "#totGl#"
									
								TransactionSerialNo2  = "2"
								Class2                = "#cls2#"
								Reference2            = "Warehouse"       
								ReferenceName2        = "#left(Item.Itemdescription,100)#"
								Description2          = "#Type.Description#"
								GLAccount2            = "#Attributes.GLAccountCredit#"
								Costcenter2           = "#costcenter#"
								WorkOrderLineId2      = "#workorderlineid#"
								ReferenceNo2          = "#Attributes.ItemNo#"
								ReferenceId2          = "#Attributes.ReferenceId#"
								TransactionType2      = "Standard"
								Amount2               = "#totCredit#"
								
								TransactionSerialNo3  = "3"
								Class3                = "#cls3#"
								Reference3            = "Warehouse"       
								ReferenceName3        = "#left(Item.Itemdescription,100)#"
								Description3          = "#Type.Description# Price and Exchange difference"
								GLAccount3            = "#Attributes.GLAccountDiff#"
								CostCenter3           = "#costcenter#"
								WorkOrderLineId3      = "#workorderlineid#"
								ReferenceNo3          = "#Attributes.ItemNo#"
								ReferenceId3          = "#Attributes.ReferenceId#"
								TransactionType3      = "Standard"
								Amount3               = "#priceDiff#">
																
						</cfif>	
						
				<cfelse>		
				
					 <!--- SALES with COGS transaction 										  
					  		   		   
					   4. Result : Cost of Goods Sold  which goes by category	   
					   5. a/ Stock	   	   
			   
					   6. Offset the tax To be paid 
					   7. a/ Tax paid (offset of the COGS)			
					   
					   Followed by a sale in another header 
					   
					   1. Receivable from the journal 
					   2. a/ Result : Sale which goes by category
					   3  a/ Tax    : Tax to be paid 		
					   
					--->									
									
					 <cfquery name="Tax" 
					    datasource="#Attributes.DataSource#" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						    SELECT    *
						    FROM      Accounting.dbo.Ref_Tax
							WHERE     TaxCode = '#attributes.TaxCode#'
					</cfquery> 			
					
					<!--- convert the cost price to the currency of the DocumentCurrency in the GL transaction --->
					
					<cf_exchangeRate datasource="#Attributes.DataSource#"
								     EffectiveDate = "#Attributes.TransactionDate#"
					                 CurrencyFrom  = "#Attributes.TransactionCurrency#"
									 CurrencyTo    = "#Attributes.SalesCurrency#"> 								 	   
					
					<cfset totGL     = abs(round((totGL/exc)*100)/100)>
									
					<!--- 15/9 added COGS we always ensure that 
					         the costs (debit) is same as deduction from stock --->
							 
					<cfset totCredit = totGL>	
					
					<!--- ---------------------------------------------------- 					
					<cfset totCredit = abs(round((totCredit/exc)*100)/100)>				
					--->					
									
					<cfif Tax.Percentage neq "">	
						<cfset taxCOGS   = totCredit * Tax.Percentage>
						<cfset taxCOGS   = round(taxCOGS*100)/100>		
					<cfelse>
						<cfset taxCOGS   = "0">		
					</cfif>
					
					<cfquery name="Param" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    *   
						FROM      Ref_ParameterMission
						WHERE     Mission = '#Attributes.Mission#' 
					</cfquery>	
					
					<!--- pending is the link to the customer --->		
					
					<cfif totGl neq "0">
								
					<cf_GledgerEntryHeader
					    DataSource            = "#Attributes.DataSource#"
						Mission               = "#Attributes.Mission#"
						OrgUnitOwner          = "#OrgUnitOwner#"
						Journal               = "#Journal.Journal#" 
						Description           = "#Attributes.Remarks#"
						TransactionSource     = "#Attributes.TransactionSource#"
						TransactionSourceId   = "#Attributes.GLTransactionSourceId#"
						TransactionSourceNo   = "#Attributes.GLTransactionSourceNo#"
						AccountPeriod         = "#Parameter.CurrentAccountPeriod#"
						TransactionCategory   = "#Attributes.TransactionCategory#"
						TransactionDate       = "#Attributes.TransactionDate#"
						JournalTransactionNo  = "#Attributes.GLTransactionNo#"
						MatchingRequired      = "1"		
						ActionStatus          = "1"			
						Reference             = "Sale"       
						ReferenceName         = "#Attributes.ItemNo# #left(Item.Itemdescription,100)#"
						ReferencePersonNo     = "#attributes.SalesPersonNo#"
						ReferenceId           = "#Attributes.TransactionId#"
						ReferenceNo           = ""
						DocumentCurrency      = "#Attributes.SalesCurrency#"
						DocumentDate          = "#Attributes.TransactionDate#"
						DocumentAmount        = "#Attributes.SalesTotal#"
						AmountOutstanding     = "0">						
																																					 
							<cfif Param.taxmanagement eq "1">			
																																					 
							<cf_GledgerEntryLine
							    DataSource            = "#Attributes.DataSource#"
								Lines                 = "4"
								TransactionDate       = "#Attributes.TransactionDate#"
								Journal               = "#Journal.Journal#"
								JournalNo             = "#JournalTransactionNo#"
								JournalTransactionNo  = "#Attributes.GLTransactionNo#"
								AccountPeriod         = "#Parameter.CurrentAccountPeriod#"
								Currency              = "#Attributes.SalesCurrency#"
								LogTransaction		  = "No"
																										
								TransactionSerialNo1  = "1"
								Class1                = "Debit"
								Reference1            = "COGS"       
								ReferenceName1        = "#left(Item.Itemdescription,100)#"
								Description1          = "#Type.Description#"
								GLAccount1            = "#Attributes.GLAccountDebit#"
								Costcenter1           = "#costcenter#"
								WorkOrderLineId1      = "#workorderlineid#"
								ReferenceId1          = "#Attributes.ReferenceId#"
								ReferenceNo1          = "#Attributes.ItemNo#"
								TransactionType1      = "Standard"
								Amount1               = "#totGl#"
									
								TransactionSerialNo2  = "2"
								Class2                = "Credit"
								Reference2            = "Stock"       
								ReferenceName2        = "#left(Item.Itemdescription,100)#"
								Description2          = "#Type.Description#"
								GLAccount2            = "#Attributes.GLAccountCredit#"
								Costcenter2           = "#costcenter#"
								WorkOrderLineId2      = "#workorderlineid#"
								ReferenceNo2          = "#Attributes.ItemNo#"
								ReferenceId2          = "#Attributes.ReferenceId#"
								TransactionType2      = "Standard"
								Amount2               = "#totCredit#"														
								
								TransactionSerialNo3  = "3"
								Class3                = "Debit"
								Reference3            = "Correction Sales Tax"       
								ReferenceName3        = "#left(Item.Itemdescription,100)#"
								Description3          = "#Type.Description#"
								TaxCode3              = "#attributes.TaxCode#"
								GLAccount3            = "#Tax.GLAccountReceived#"
								Costcenter3           = "#costcenter#"
								WorkOrderLineId3      = "#workorderlineid#"
								ReferenceNo3          = "#Attributes.ItemNo#"
								ReferenceId3          = "#Attributes.ReferenceId#"
								TransactionType3      = "Standard"
								Amount3               = "#taxCOGS#"
															
								TransactionSerialNo4  = "4"
								Class4                = "Credit"
								Reference4            = "COGS Tax Paid"       
								ReferenceName4        = "#left(Item.Itemdescription,100)#"
								Description4          = "#Type.Description#"
								TaxCode4              = "#attributes.TaxCode#"
								GLAccount4            = "#Tax.GLAccountPaid#"
								Costcenter4           = "#costcenter#"
								WorkOrderLineId4      = "#workorderlineid#"
								ReferenceNo4          = "#Attributes.ItemNo#"
								ReferenceId4          = "#Attributes.ReferenceId#"
								TransactionType4      = "Standard"
								Amount4               = "#taxCOGS#">
								
						<cfelse>
						
							<cf_GledgerEntryLine
							    DataSource            = "#Attributes.DataSource#"
								Lines                 = "2"
								TransactionDate       = "#Attributes.TransactionDate#"
								Journal               = "#Journal.Journal#"
								JournalNo             = "#JournalTransactionNo#"
								JournalTransactionNo  = "#Attributes.GLTransactionNo#"
								AccountPeriod         = "#Parameter.CurrentAccountPeriod#"
								Currency              = "#Attributes.SalesCurrency#"
								LogTransaction		  = "No"
																										
								TransactionSerialNo1  = "1"
								Class1                = "Debit"
								Reference1            = "COGS"       
								ReferenceName1        = "#left(Item.Itemdescription,100)#"
								Description1          = "#Type.Description#"
								GLAccount1            = "#Attributes.GLAccountDebit#"
								Costcenter1           = "#costcenter#"
								WorkOrderLineId1      = "#workorderlineid#"
								ReferenceId1          = "#Attributes.ReferenceId#"
								ReferenceNo1          = "#Attributes.ItemNo#"
								TransactionType1      = "Standard"
								Amount1               = "#totGl#"
									
								TransactionSerialNo2  = "2"
								Class2                = "Credit"
								Reference2            = "Stock"       
								ReferenceName2        = "#left(Item.Itemdescription,100)#"
								Description2          = "#Type.Description#"
								GLAccount2            = "#Attributes.GLAccountCredit#"
								Costcenter2           = "#costcenter#"
								WorkOrderLineId2      = "#workorderlineid#"
								ReferenceNo2          = "#Attributes.ItemNo#"
								ReferenceId2          = "#Attributes.ReferenceId#"
								TransactionType2      = "Standard"
								Amount2               = "#totCredit#">													
									
							</cfif>
									
						</cfif>
						
				</cfif>		
							
				<!--- in case of sale we book tax offset over the stock involved --->
						
		</cfif>		
			
	</cfif>	

<cfelse>

	<!--- transaction exists already no action for this, this usually happes for
	transactions that turn into a sale later --->

</cfif>	
	
<!--- ------------------------------------------------------------------ --->
<!--- 3/3 create a shipping record to support billing/invoicing optional --->
<!--- ------------------------------------------------------------------ --->

<cfif attributes.salesprice eq "COGS">
	<cfset attributes.SalesPrice = TransactionCostPrice>	
</cfif>

<cfif Attributes.Shipping eq "Yes" or Attributes.SalesPrice neq "">

    <cfparam name="Attributes.CommodityCode"     default = "">
    <cfparam name="Attributes.SalesCurrency"     default = "#APPLICATION.BaseCurrency#">
	<cfparam name="Attributes.TaxPercentage"     default = "0">
	<cfparam name="Attributes.SchedulePrice"     default = "0">
	<cfparam name="Attributes.PriceSchedule"     default = "">
	<!--- added to support a mode in which we only sell in different unit, but administer in base UoM --->
	<cfparam name="Attributes.SalesUoM"          default = "#Attributes.TransactionUoM#">
	<cfparam name="Attributes.SalesQuantity"     default = "#Attributes.TransactionQuantity#">
	<cfparam name="Attributes.TaxExemption"      default = "1">
	<cfparam name="Attributes.TaxIncluded"       default = "0">
	<cfparam name="Attributes.SalesPrice"        default = "0">
	<cfparam name="Attributes.SalesAmount"       default = "0">
	<cfparam name="Attributes.SalesTax"          default = "0">
	<cfparam name="Attributes.SalesPersonNo"     default = "">
	<cfparam name="Attributes.InvoiceId"         default = "">
	<cfparam name="Attributes.ARJournal"         default = "">
	<cfparam name="Attributes.ARJournalSerialNo" default = "">
	
	<!--- convert from the sales currency to a base currency in this table --->
			
	<cf_exchangeRate 
	       DataSource   = "appsMaterials"
	       CurrencyFrom = "#Attributes.SalesCurrency#" 
	       CurrencyTo   = "#APPLICATION.BaseCurrency#">				
	
	<cfparam name="Attributes.ExchangeRate"  default = "#exc#">
	
	<cfif attributes.SalesPrice eq "">
	    <cfset SalesPrice = "0">
	<cfelse>
	    <cfset SalesPrice = attributes.SalesPrice>
	</cfif>
	
	<!--- recalculate --->	
	
	<cfif Attributes.SalesTax eq "0">
		
		<cfquery name="getTax" 
			datasource="#Attributes.DataSource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT    *
			    FROM      Accounting.dbo.Ref_Tax
			    WHERE     TaxCode         = '#attributes.taxcode#' 	
		</cfquery>
		
		<cfif getTax.recordcount eq "0">
		
			<cfset attributes.TaxCode  = "00">			
		
			<cfquery name="getTax" 
				datasource="#Attributes.DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT    *
				    FROM      Accounting.dbo.Ref_Tax
				    WHERE     TaxCode         = '#attributes.taxcode#' 	
			</cfquery>
		
		</cfif>
		
		<cfif getTax.TaxCalculation eq "Exclusive">
			
			<cfset attibutes.TaxIncluded     = "0">
			<cfset attributes.TaxPercentage = getTax.Percentage>
			
			<cfif attributes.taxExemption eq "1">
							
				<cfset Attributes.SalesTax  = 0>	
								
			<cfelse>
							
				<cfset Attributes.SalesTax  = (attributes.TaxPercentage * attributes.SalesPrice) * Attributes.TransactionQuantity * -1>	
				
			</cfif>							
				
		<cfelse>
				
			<cfset attibutes.TaxIncluded  = "1">			
			<cfset attributes.TaxPercentage = getTax.Percentage>
			
			<cfif attributes.taxExemption eq "1">
				<cfset Attributes.SalesTax  = 0>	
			<cfelse>
				<cfset Attributes.SalesTax  = ((attributes.TaxPercentage/(1+attributes.TaxPercentage))*attributes.SalesPrice)*Attributes.TransactionQuantity * -1>	
			</cfif>					
							
		</cfif>			
	
	</cfif>
	
	<!--- recalculate --->	
	<cfif attributes.SalesAmount eq "0">
		
		<cfif attributes.TaxIncluded eq "1">
		
			<cfset sales = SalesPrice*(Attributes.TransactionQuantity*-1)-Attributes.SalesTax>
		
		<cfelse>
		
			<cfset sales = SalesPrice*(Attributes.TransactionQuantity*-1)>
		
		</cfif>
		
	<cfelse>
	
		<cfset sales = attributes.SalesAmount>
	
	</cfif>	
			
	<cfif attributes.ExchangeRate eq "0">
	     <cfset attributes.exchangeRate = "1">
	</cfif>
		
	<cfset amt  = sales>
	<cfset amtB = amt/attributes.ExchangeRate>
	<cfset amtB = round(amtB*100)/100>
	
	<cfset amtT = attributes.SalesTax/attributes.ExchangeRate>
	<cfset amtT = round(amtT*100)/100>
		
	<cfquery name="reset" 
	   datasource="#Attributes.DataSource#" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   DELETE FROM ItemTransactionShipping
	   WHERE TransactionId = '#attributes.transactionid#'
	</cfquery>
		
	<cfquery name="Insert" 
	   datasource="#Attributes.DataSource#" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   INSERT INTO Materials.dbo.ItemTransactionShipping 
			(TransactionId,
			 <cfif attributes.commoditycode neq ""> 
			 CommodityCode,
			 </cfif>
			 SalesUoM,
			 SalesQuantity,
			 SalesPersonNo, 
			 SalesCurrency,
			 TaxCode,
			 TaxPercentage,
			 TaxExemption,
			 TaxIncluded, 
			 <cfif attributes.SalesPrice neq "">
			 PriceSchedule,
			 SchedulePrice,
			 SalesPrice,
			 SalesAmount,
			 SalesTax,
			 ExchangeRate,
			 SalesBaseAmount,
			 SalesBaseTax,
			 <cfif attributes.invoiceId neq "">
			 InvoiceId,
			 </cfif>
			 Journal,
			 JournalSerialNo,
			 </cfif>
			 OfficerUserid,
			 OfficerLastName,
			 OfficerFirstName)
	VALUES 
			('#Attributes.TransactionId#', 
			 <cfif attributes.commoditycode neq ""> 
			 '#Attributes.CommodityCode#',
			 </cfif>
			 '#Attributes.SalesUoM#',
			 '#Attributes.SalesQuantity#',
			 '#Attributes.SalesPersonNo#',		
			 '#Attributes.SalesCurrency#',
			 '#attributes.TaxCode#',			 
			 '#attributes.TaxPercentage#',
			 '#attributes.TaxExemption#',
			 '#attributes.TaxIncluded#', 
			<cfif attributes.SalesPrice neq "">
			 '#Attributes.PriceSchedule#',
			 '#attributes.SchedulePrice#',
			 '#attributes.SalesPrice#',
			 '#sales#',
			 '#Attributes.SalesTax#',
			 '#attributes.ExchangeRate#',
			 '#amtB#',
			 '#amtT#',
			 <cfif attributes.invoiceId neq	"">
			 '#Attributes.InvoiceId#',
			 </cfif>
			 '#Attributes.ARJournal#',
			 '#Attributes.ARJournalSerialNo#',
			 </cfif>
			 '#SESSION.acc#', 
			 '#SESSION.last#',
			 '#SESSION.first#')
	</cfquery>	
	
</cfif>


