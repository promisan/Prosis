<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Stock requests">
			
	<cffunction name="addCart" access="public"  displayname="Create Request header" securejson="true">
							
			<cfargument name = "Cart"       		type="string"  required="true"   default="">				
			<cfargument name = "Mode"        		type="string"  required="true"   default="Quote">	 <!--- Quote | Sale --->
			
			<!--- meta for Request mode			
			  check if a sale already exists for the warehouse, customer and addressid, only if not we add,			
			--->			
			
			<cfset arrayCart       = deserializeJSON(Cart)>
			
			<cfset vStore          = arrayCart['store']>
			<cfset vCustomer       = arrayCart['customer']>
			<cfset vProduct        = arrayCart['products']>
			
			<cfset Mission         = vStore.Mission>
			<cfset Warehouse       = vStore.Warehouse>
			<cfset CustomerId      = vCustomer.CustomerId>
			<cfset AddressId       = vCustomer.AddressId>
			
			<cfloop array="#vProduct#" index="Product">
			
				<cfset Currency        = Product.Currency>
				<cfset ItemNo          = Product.ItemNo>
				<cfset UoM             = Product.ItemUoM>
				<cfset TransactionLot  = Product.Lot>
				<cfset Quantity        = Product.Quantity>
				<cfset PriceSchedule   = Product.PriceSchedule>
			
				<!--- obtain the pricing --->
				
				<cfinvoke component  = "Service.Process.Materials.POS"  
				   method            = "getPrice" 
				   priceschedule     = "#priceschedule#"
				   discount          = "0"
				   warehouse         = "#warehouse#" 
				   customerid        = "#customerid#"
				   customeridTax     = "#customerid#"
				   currency          = "#Currency#"
				   ItemNo            = "#itemno#"
				   UoM               = "#uom#"
				   quantity          = "#quantity#"
				   returnvariable    = "sale">	
			   
				   <cf_assignid>			   
				   
				  <cfquery name="Insert" 
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
					INSERT INTO dbo.Sale#Warehouse# ( 				   
							TransactionId, 
							Source,
							TransactionType, 
							TransactionDate, 
							ItemNo, 
							ItemClass,
							ItemDescription, 
							ItemCategory, 
							Mission, 
							Warehouse, 
							Location, 			
				            TransactionUoM, 
							TransactionLot,
							TransactionQuantity,            
							CustomerId, 
							CustomerIdInvoice,
							AddressId,
							PriceSchedule,
							SalesCurrency, 
							SchedulePrice, 
							SalesPrice, 
							TaxCode,
							TaxPercentage, 
							TaxExemption, 
							TaxIncluded, 
							SalesAmount, 
							SalesTax, 			           						
							SalesPersonNo,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )  
									
					VALUES ('#rowguid#',
					        'Website',
						    '2',
						    getDate(),
						    '#itemno#', 
							'#sale.ItemClass#',
							'#sale.ItemDescription#', 
							'#sale.Category#',
							'#sale.Mission#', 
							'#warehouse#', 
							'',
							'#uom#',     
							'#transactionlot#',       
							'#quantity#',			           
							'#Customerid#', 
							'#CustomerId#', 
							'#addressId#',
							'#sale.priceschedule#',
							'#currency#', 
							'#sale.price#', 
							'#sale.price#', 
							'#sale.TaxCode#',
							'#sale.tax#', 
							'#sale.taxexemption#', 
							'#sale.inclusive#', 
							'#sale.amount#', 
							'#sale.amounttax#', 			           
							'#client.PersonNo#',						
							'#session.acc#',
							'#session.last#',
							'#session.first#' )		  
							
					</cfquery> 
					
				</cfloop>
				
				<!--- finished --->			
								
	</cffunction>	
	
	
</cfcomponent>