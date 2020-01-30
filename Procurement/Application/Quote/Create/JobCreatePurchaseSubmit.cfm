
<cfparam name="Form.PurchaseNo" default="">
<cfparam name="SESSION.reqNo" default="">
<cfset url.selected = SESSION.reqNo>

<cf_tl id="Please select a vendor" var="1">
<cfset vselect =#lt_text#>

<cfif Form.vendororgunit eq "">
	<cfoutput>
	<script>
		 alert("#vselect#") 
	</script>
	</cfoutput>
	
	<cfabort>

</cfif>

<cfif Form.Select eq "exist" and Form.PurchaseNo eq "">

	<cf_tl id="REQ038" var="1">
	<cfset vReq038=#lt_text#>
	<script>parent.Prosis.busy('no')</script>
	<cf_alert message="#vReq038#" return="close">
	<cfabort>

</cfif>

<cfif Form.OrderClass eq "">
	
	<script>parent.Prosis.busy('no')</script>
	<cf_alert message = "You must select an order class"  return = "back">			
	<cfabort>
	
</cfif>

<cfset sel = replace(url.selected,":","'",  "all")> 

<!--- verify currency --->

<cfquery name="Check" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT DISTINCT RequestCurrency
	 FROM  RequisitionLine
	 WHERE RequisitionNo IN (#PreserveSingleQuotes(sel)#)					  
	 AND   RequisitionNo NOT IN (SELECT RequisitionNo FROM PurchaseLine)
</cfquery>

<!--- we no longer have to do this 8/1/2019

<cfif check.recordcount gte "2">

	<script>
		 alert("Please select lines of the same requested currency.") 
	</script>
	<cfabort>

</cfif>

--->

<cfparam name="Form.OrgUnit" default="">

<!--- revise to take for entry screen, in the entry screen we show by default
the requisition orgunit, parent --->

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   Ref_ParameterMission 
		WHERE  Mission = '#URL.Mission#' 
</cfquery>

<!--- Both 1. initiatilization --->

<cfif form.OrgUnit eq "">
			
	<cfquery name="Root" 
 	datasource="AppsOrganization" 
	maxrows=1 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   Org.OrgUnit
		FROM	 Ref_MissionPeriod P INNER JOIN
	             Ref_Mandate M ON P.Mission = M.Mission AND P.MandateNo = M.MandateNo INNER JOIN
	             Organization Org ON M.Mission = Org.Mission AND M.MandateNo = Org.MandateNo
		WHERE    P.Mission = '#URL.Mission#'
		AND      P.Period  = '#URL.Period#'
		AND      Org.TreeUnit = 1
	</cfquery>		
	
	<cfif Root.OrgUnit neq "">
		
		<cfset unit = Root.OrgUnit>	
	
	<cfelse>
	
		<cfquery name="Unit" 
	 	datasource="AppsPurchase" 
		maxrows=1 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT OrgUnit
			 FROM   RequisitionLine
			 WHERE  RequisitionNo IN (#PreserveSingleQuotes(sel)#)	 			  
		</cfquery>					  
		
		<cfset unit = Unit.OrgUnit>
	
	</cfif>
	
</cfif>	
	
<!--- create PO --->

		
<cftransaction>

<cfif Form.Select eq "Add">

		<!---  2. define reference No  --->
		<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
				
			<cfset No = Parameter.PurchaseSerialNo+1>
			<cfif No lt 1000>
			     <cfset No = 1000+#No#>
			</cfif>
				
			<cfquery name="Update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE Ref_ParameterMission
				SET    PurchaseSerialNo = '#No#'				
				WHERE  Mission = '#URL.Mission#'
			</cfquery>
			
		</cflock>
	
		<cfset PoNo = "#Parameter.MissionPrefix#-#Parameter.PurchasePrefix#-#No#">		
		
		<cfquery name="Class" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	SELECT *
		    FROM   Ref_OrderClass
			WHERE  Code = '#Form.OrderClass#' 
		</cfquery>
		
		<cfif Class.PreparationModeCreate eq "1">
		    <cfset st = "3">
		<cfelse>
			<cfset st = "0">
		</cfif>
			
		<!--- 3. create job header  --->
		<cfquery name="Header" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO Purchase 
					 (PurchaseNo, 
					  OrgUnit, 
					  OrgUnitVendor, 
					  Currency,
					  Period, 
					  Mission, 
					  OrderClass, 
					  OrderType, 
					  Userdefined1,
					  Userdefined2,
					  Userdefined3,
					  Userdefined4,
					  ActionStatus, 
					  <cfif st eq "3">
					  OrderDate,
					  </cfif>
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
		     VALUES ('#pono#', 
			         '#Form.OrgUnit#',
			         '#Form.vendororgunit#', 	
					 '#Form.Currency#',				 
					 '#URL.Period#', 
					 '#URL.Mission#', 
					 '#Form.OrderClass#',
					 '#Form.OrderType#', 
					 '#Form.Userdefined1#',
					 '#Form.Userdefined2#',
					 '#Form.Userdefined3#',
					 '#Form.Userdefined4#',
					 '#st#',	
					 <cfif st eq "3">
					 getDate(),
					 </cfif>			 					
					 '#SESSION.acc#', 
					 '#SESSION.last#', 
					 '#SESSION.first#')
		</cfquery>
		
		<!---  4. enter actor --->
		<cfquery name="InsertActor" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     INSERT INTO PurchaseActor 
						 (PurchaseNo, 
						  Role, 
						  ActorUserId, 
						  ActorLastName, 
						  ActorFirstName, 
						  OfficerUserId, 
						  OfficerLastName, 
						  OfficerFirstName) 
				 VALUES  ('#pono#',
				          'ProcBuyer', 
						  '#SESSION.acc#', 
						  '#SESSION.last#', 
						  '#SESSION.first#',
						  '#SESSION.acc#', 
						  '#SESSION.last#', 
						  '#SESSION.first#')
		</cfquery>
		
		<!---  5. update requisition lines --->
		<cfquery name="Update" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE RequisitionLine
		 SET    ActionStatus = '3'
		 WHERE  RequisitionNo IN (SELECT RequisitionNo 
	                              FROM   RequisitionLine
							      WHERE  RequisitionNo IN (#PreserveSingleQuotes(sel)#))					  
		</cfquery>
		
		<cfparam name="Form.Currency" default="#application.BaseCurrency#">
		
		<cfset curr = Form.currency>

<cfelse>

	<cfset PONo = Form.PurchaseNo>
	
	<!---  5. update requisition lines --->
		<cfquery name="Update" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE RequisitionLine
		 SET    ActionStatus = '3'
		 WHERE  RequisitionNo IN (SELECT RequisitionNo 
	                              FROM   RequisitionLine
							      WHERE  RequisitionNo IN (#PreserveSingleQuotes(sel)#))					  
		</cfquery>
	
	<cfquery name="Purchase" 
     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		  	 SELECT *
			 FROM   PurchaseLine 
			 WHERE  PurchaseNo = '#Form.PurchaseNo#'
	</cfquery>
	
	<cfset curr = Purchase.Currency>

</cfif>

<!---  6. enter action --->
<cfquery name="InsertAction" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO RequisitionLineAction 
			 (RequisitionNo, 
			  ActionStatus, 
			  ActionDate, 
			  OfficerUserId, 
			  OfficerLastName, 
			  OfficerFirstName) 
	 SELECT  RequisitionNo, 
	         '3', 
			 getDate(), 
			 '#SESSION.acc#', 
			 '#SESSION.last#', 
			 '#SESSION.first#'
	 FROM    RequisitionLine
	 WHERE   RequisitionNo IN (SELECT RequisitionNo 
	                          FROM   RequisitionLine 
							  WHERE  RequisitionNo IN (#PreserveSingleQuotes(sel)#))
</cfquery>

<cfquery name="SelectLines" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT *	      
	 FROM   RequisitionLine
	 WHERE  RequisitionNo IN (#PreserveSingleQuotes(sel)#)					  
	 AND    RequisitionNo NOT IN (SELECT RequisitionNo FROM PurchaseLine)
</cfquery>

<cfloop query="selectlines">

	<cfif Curr eq RequestCurrency>
	
		<cfset exc = "1">		
		<!--- take the price and tex from the request line --->
		<cfset Price = RequestCurrencyPrice>
	
	<cfelse>	
	
		<cf_exchangeRate CurrencyFrom="#RequestCurrency#" CurrencyTo="#Curr#" datasource="AppsPurchase">
		<cfset Price = RequestCurrencyPrice / exc>
			
	</cfif>			
	
	<cfset OrderAmountCost    = RequestQuantity*Price>	
	
	<cfset TaxIncluded = Parameter.DefaultTaxIncluded>
		
	<cfif Parameter.TaxExemption eq "1">
		
			<cfset OrderTax             = 0>			
			<cfset OrderAmountTax       = 0>							
			<cfset OrderAmountBaseCost  = RequestAmountBase>
			<cfset OrderAmountBaseTax   = 0>						
					
	<cfelse>
		
			<cfset OrderTax             = Parameter.TaxDefault>
			<cfset OrderAmountTax       = OrderAmountCost*OrderTax>		
			<cfset OrderAmountBaseCost  = RequestAmountBase>			
			<cfset OrderAmountBaseTax   = OrderAmountBaseCost*OrderTax>					
						
	</cfif>		
	
	<cfset OfferId              = "">
	<cfset OrderMultiplier      = "1">
	<cfset OrderQuantity        = RequestQuantity>
	<cfset UoM                  = QuantityUoM>
	<cfset Volume               = "0">
	<cfset itemNo 				= "">
	
	 <!--- we check if we have this as prefered vendor listed for a stock item --->	
				
	<cfif WarehouseItemNo neq "" and WarehouseUoM neq "">
		 		 
		<cfquery name="getPrice" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 SELECT   TOP 1 *
			 FROM     Materials.dbo.ItemVendorOffer
			 WHERE    ItemNo        = '#WarehouseItemNo#' 
			 AND      UoM           = '#WarehouseUoM#' 
			 AND      OrgUnitVendor = '#Form.vendororgunit#' 
			 AND      Mission       = '#Mission#' 
			 AND      Currency      = '#curr#'
			 <cfif Warehouse neq "">
			 AND      LocationId = (SELECT LocationId 
			                        FROM   Materials.dbo.Warehouse 
									WHERE  Warehouse = '#Warehouse#')
			 </cfif>
			 ORDER BY DateEffective DESC			
			
		 </cfquery>		
		 		 	 
		 <cfif getPrice.recordcount eq "0">
		 
			 <cfquery name="getPrice" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				 SELECT   TOP 1 *
				 FROM     Materials.dbo.ItemVendorOffer
				 WHERE    ItemNo        = '#WarehouseItemNo#' 
				 AND      UoM           = '#WarehouseUoM#' 
				 AND      OrgUnitVendor = '#Form.vendororgunit#' 
				 AND      Mission       = '#Mission#' 			 
				 <cfif Warehouse neq "">
				 AND      LocationId = (SELECT LocationId 
				                        FROM   Materials.dbo.Warehouse 
										WHERE  Warehouse = '#Warehouse#')
				 </cfif>
				 ORDER BY DateEffective DESC					 	
			 </cfquery>
			 
			 <cf_exchangeRate CurrencyFrom="#getPrice.currency#" CurrencyTo="#curr#" datasource="AppsPurchase">
			 			 
		 <cfelse>
		 
		 	<cfset exc = "1">	 
		 
		 </cfif>		 
		 						 				 		
		 <cfif getPrice.recordcount eq "1">
		 
			 <cfquery name="getUoM" 
		     datasource="AppsPurchase" 
	    	 username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     Materials.dbo.ItemUoM
			 WHERE    ItemNo        = '#WarehouseItemNo#' 
			 AND      UoM           = '#WarehouseUoM#' 						
			 </cfquery>			
		 
		    <cfset OfferId              = getPrice.Offerid>
		 	<cfset OrderTax             = getPrice.ItemTax/100>		
		 	<cfset TaxIncluded          = getPrice.TaxIncluded>
			
			<cfif getPrice.ItemPrice neq "0">
			  			
			    <cfif TaxIncluded eq "0">
			 		<cfset Price            = getPrice.ItemPrice>					
				<cfelse>
					<cfset Price            = getPrice.ItemPrice/(1+OrderTax)>					
				</cfif>			
				
			<cfelse>
			
			    <cfif TaxIncluded eq "1">
			 		<cfset Price            = getPrice.ItemPrice>					
				<cfelse>
					<cfset Price            = getPrice.ItemPrice/(1+OrderTax)>					
				</cfif>							
						  
			</cfif>
													
			<cfif getPrice.OfferMinimumQuantity neq "0">		
				
				<cfset OrderMultiplier = getPrice.OfferMinimumQuantity>	
				<cfset Price = Price * OrderMultiplier> 	
				<cf_tl id="Box" var="1">				
				<cfset UoM                  = "#lt_text# #OrderMultiplier#">	
				<cfset Volume               = getPrice.OfferMinimumVolume>
				
			<cfelse>			
				<cfset OrderMultiplier = "1">	
				<cfset Volume               = "0">			    
			</cfif>
			
			<!--- expressed in the currency of the order --->
			<cfset price = price / exc>
						
			<cfset OrderQuantity        = RequestQuantity/OrderMultiplier>
						
			<cfset OrderAmountCost      = OrderQuantity*Price>									
			<cfset OrderAmountTax       = OrderAmountCost*OrderTax>
											
			<cfset ItemNo = getUOM.ItemBarCode>
			
			<!--- we recalculate the base price as this is no longer based on the requisition line base value --->
			<cf_exchangeRate CurrencyFrom="#form.Currency#" CurrencyTo="#Application.BaseCurrency#" datasource="AppsPurchase">
			
			<cfset OrderAmountBaseCost  = OrderAmountCost/exc>			
			<cfset OrderAmountBaseTax   = OrderAmountTax/exc>		
						 
		 </cfif>		 
		 		 
	</cfif>		
		
	<!---
	<cfoutput><script> alert("cost:#form.currency#:#requestquantity#-----#price#----#OrderAmountCost#")</script></cfoutput>
	--->
		
	<cfif OrderAmountBaseCost lte 0>
		<cfset OrderAmountBaseCost = 1>
	</cfif>			
	
	<!--- rounding up to 3 digits --->
			
	<cfset ExchangeRate         = OrderAmountCost / OrderAmountBaseCost>	
	<cfset OrderAmountCost      = round(OrderAmountCost*1000)/1000>									
	<cfset OrderAmountTax       = round(OrderAmountTax*1000)/1000>
	<cfset OrderAmountBaseCost  = round(OrderAmountBaseCost*1000)/1000>			
	<cfset OrderAmountBaseTax   = round(OrderAmountBaseTax*1000)/1000>				
	<cfset totalBase            = round((OrderAmountBaseCost+OrderAmountBaseTax)*1000)/1000>	
		
	<!--- 7. create PO entries --->
	<cfquery name="InsertLines" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO PurchaseLine 
		  (RequisitionNo, 
			  PurchaseNo, 		 
			  OrderItem, 		
			  OrderItemNo,
			  <cfif OfferId neq "">
			  OfferId,
			  </cfif> 
			  OrderQuantity, 
			  OrderMultiplier, 
			  OrderUoM, 
			  OrderUoMVolume,
			  Currency, 
			  OrderPrice, 		
			  OrderTax, 
			  OrderAmountCost, 
			  OrderAmountTax,
			  TaxIncluded,
			  TaxExemption,		
			  ExchangeRate, 
			  OrderAmountBaseCost, 
			  OrderAmountBaseTax, 
			  OrderAmountBaseObligated,
			  ActionStatus, 
			  OfficerUserId, 
			  OfficerLastName, 
			  OfficerFirstName) 
		 SELECT RequisitionNo, 
		        '#PoNo#', 			
				RequestDescription, 	
				'#ItemNo#',
				<cfif OfferId neq "">
			  	'#OfferId#',
			  	</cfif> 		
				'#OrderQuantity#', 
				'#OrderMultiplier#', 
				'#UoM#', 
				'#volume#',
				'#Curr#', 
				'#Price#', 		
				'#OrderTax#',							
				'#OrderAmountCost#', 	
				'#OrderAmountTax#', 				
				'#TaxIncluded#',				
				'#Parameter.TaxExemption#',
				'#ExchangeRate#',				       
				'#OrderAmountBaseCost#', 
				'#OrderAmountBaseTax#', 
				'#TotalBase#',
				'0', 
				'#SESSION.acc#', 
				'#SESSION.last#', 
				'#SESSION.first#'
		 FROM  RequisitionLine
		 WHERE RequisitionNo = '#requisitionno#'		
	</cfquery>
	
	<!--- ---------STAFIING INTEGRATION -------- --->	
	<!--- check if position needs to be extended --->
	<!--- -------------------------------------- --->
		
	<cfquery name="Position" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT * 	      
		 FROM  Employee.dbo.PositionParentFunding
		 WHERE RequisitionNo = '#RequisitionNo#'		
	</cfquery>
	
	<cfif Position.recordcount eq "1">
		
		<!--- -------------requisitione funding -------------- --->
		<cfinvoke component = "Service.Process.Employee.PositionAction"  
		   method           = "PositionFunding" 
		   PositionParentId = "#Position.PositionParentId#"
		   RequisitionNo    = "#RequisitionNo#"
		   Datasource       = "appsPurchase">		
		
	</cfif>
	
</cfloop>	 

<cfquery name="Currency" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			UPDATE Purchase
			SET    Currency = (SELECT TOP 1 Currency FROM PurchaseLine WHERE PurchaseNo = '#PoNo#'),
				   ModificationNo     = ModificationNo+1,
			       ModificationDate   = getDate(),
			       ModificationUserId = '#session.acc#'		
			WHERE  PurchaseNo = '#PoNo#'		
			
	</cfquery>	

</cftransaction>	

<script>

	<cfoutput>
	
		try {  
			 parent.opener.reloadForm()	} 
		catch(e) {}		
			ColdFusion.navigate('SelectLines.cfm?mission=#url.mission#&period=#url.period#','pending')
			ColdFusion.navigate('../../PurchaseOrder/Purchase/POViewView.cfm?header=No&ID=PO&ID1=#PoNo#&Mode=Edit','contentbox2')
			window.focus()
			
	</cfoutput>	
	
</script>


