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
			
			<cfquery name="InsertHeader" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">					
				INSERT INTO CustomerRequest ( 	
				        Mission, 
						Warehouse, 
						CustomerId, 
						AddressId, 				
						Source, 
						ActionStatus,
						OfficerUserId, 
						OfficerLastName, 
						OfficerFirstName )
					VALUES ('#Mission#', 
						'#warehouse#', 
						'#Customerid#', 
						'#addressId#',
						'Website',
						'0',
						'#session.acc#',
						'#session.last#',
						'#session.first#' )
			</cfquery>
			
			<cfquery name="getQuote" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     CustomerRequest T			
					WHERE    T.Warehouse       = '#warehouse#'
					AND      T.CustomerId      = '#customerid#'		
					AND      T.AddressId       = '#addressid#'		
					AND      T.ActionStatus    != '9'
					ORDER BY RequestNo DESC
			</cfquery>		
						
			<cf_workflowenabled mission="#Warehouse#" entitycode="WhsQuote">

			<cfif WorkflowEnabled eq "1">
			
				<cfquery name="warehouse" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT    *
					FROM      Warehouse  
					WHERE     Warehouse = '#Warehouse#' 
				</cfquery>	
			
				<cfquery name="OrgUnit" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
					SELECT      *
					FROM        Organization.dbo.Organization
					WHERE       MissionOrgUnitId = '#warehouse.MissionOrgUnitId#'
					ORDER BY    Created DESC
				</cfquery>
						
				<cfset link = "Warehouse/Application/SalesOrder/Quote/QuoteView.cfm?requestno=#getQuote.requestno#">
						   			   				
				<cf_ActionListing 
				    EntityCode       = "WhsQuote"
					EntityClass      = "Standard"			
					EntityStatus     = ""	
					Mission          = "#warehouse.Mission#"
					OrgUnit          = "#OrgUnit.OrgUnit#"			
					ObjectReference  = "Quotation #getQuote.requestno#"
					ObjectReference2 = "#Customer.CustomerName#"
					ObjectKey1       = "#getQuote.RequestNo#"	
				  	ObjectURL        = "#link#"
					AjaxId           = "#getQuote.RequestNo#"
					Show             = "No"
					PersonNo         = "#Customer.PersonNo#"
					PersonEMail      = "#Customer.eMailAddress#">			
			
			</cfif>					
			
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
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
					INSERT INTO CustomerRequestLine ( 	
					        RequestNo,			   
							TransactionId, 							
							TransactionType, 
							TransactionDate, 
							ItemNo, 
							ItemClass,
							ItemDescription, 
							ItemCategory, 								
				            TransactionUoM, 
							TransactionLot,
							TransactionQuantity,            							 
							CustomerIdInvoice,							
							PriceSchedule,
							SalesCurrency, 
							SchedulePrice, 
							SalesPrice, 
							TaxCode,
							TaxPercentage, 
							TaxExemption, 
							TaxIncluded, 
							SalesUnitPrice,
							SalesAmount, 
							SalesTax, 			           						
							SalesPersonNo,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )  
									
					VALUES ('#getQuote.RequestNo#',
					        '#rowguid#',					       
						    '2',
						    getDate(),
						    '#itemno#', 
							'#sale.ItemClass#',
							'#sale.ItemDescription#', 
							'#sale.Category#',													
							'#uom#',     
							'#transactionlot#',       
							'#quantity#',			           							
							'#CustomerId#', 							
							'#sale.priceschedule#',
							'#currency#', 
							'#sale.price#', 
							'#sale.price#', 
							'#sale.TaxCode#',
							'#sale.tax#', 
							'#sale.taxexemption#', 
							'#sale.inclusive#', 
							'#sale.pricenet#',
							'#sale.amount#', 
							'#sale.amounttax#', 			           
							'#client.PersonNo#',						
							'#session.acc#',
							'#session.last#',
							'#session.first#' )		  
							
					</cfquery> 
					
			</cfloop>
			
			<cfset requestNo = "#getQuote.RequestNo#">
			
			<cfreturn requestno>		
				
			<!--- finished --->			
								
	</cffunction>	
	
	
</cfcomponent>