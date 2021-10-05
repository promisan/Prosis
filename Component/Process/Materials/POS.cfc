<!--- content 

	1. getPrice (24)
	2. applyPromotion (412)
	3. InitiateSaleFromStockBatch
	4. PostTransaction (1109)
	5. InitiateInvoice ( 	
	6. getTransaction
	7. PurgeTransaction
	
--->

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries">
	
	<!--- -------------------------------------------------------- --->		
	<!--- --------------  ---APPLY SALES PRICE-------------------- --->
	<!--- -------------------------------------------------------- --->		
	
	<cffunction name="getPrice"
             access="public"
             returntype="struct"
             displayname="get the Sales Price and Tax into a struct variable">
		
		<cfargument name="Mission"         type="string"  required="true"   default="">					
		<cfargument name="Warehouse"       type="string"  required="true"   default="">			
		<cfargument name="Scope"           type="string"  required="true"   default="Materials">	
		<cfargument name="Customerid"      type="GUID"    required="true"   default="00000000-0000-0000-0000-000000000000">
		<cfargument name="CustomeridTax"   type="string"  required="false"  default="00000000-0000-0000-0000-000000000000">
		<cfargument name="PriceSchedule"   type="string"  required="true"   default="">
		<cfargument name="Discount"        type="string"  required="true"   default="0">		
		<cfargument name="ItemNo"          type="string"  required="true"   default="">
		<cfargument name="UoM"             type="string"  required="true"   default="">
		<cfargument name="Quantity"        type="string"  required="true"   default="1">
		<cfargument name="Currency"        type="string"  required="true"   default="#application.basecurrency#">
		<cfargument name="Mode"            type="string"  required="true"   default="Last">		
						
		<cfset sale.priceschedule = "">
		<cfset sale.price         = 0>
		<cfset sale.taxcode       = "00">		
								
		<cfquery name="getWarehouse" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *   
			FROM      Warehouse
			WHERE     Warehouse = '#Warehouse#' 			
		</cfquery>	
		
		<cfif getWarehouse.recordcount eq "1">
			<cfset mission = getWarehouse.Mission>
		</cfif>
		
		<!--- we ensure the system will take the latest price which matches --->
		
		<cfquery name="getDate" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  MAX(DateEffective) AS Date
				FROM    ItemUoMPrice
				WHERE   ItemNo      = '#ItemNo#' 
				AND     UoM         = '#UoM#'
				AND     Mission     = '#Mission#'			
				<cfif getWarehouse.recordcount eq "1">
				AND 	Warehouse   = '#getWarehouse.Warehouse#'
				</cfif> 
				<cfif PriceSchedule neq "">
				AND     PriceSchedule = '#PriceSchedule#'
				<cfelse>
				AND 	PriceSchedule = (SELECT top 1 CODE FROM Materials.dbo.Ref_PriceSchedule WHERE FieldDefault = 1)
				</cfif>
		</cfquery>	
				
		
		<cfif Mode eq "Last" and getDate.Date neq "">
		
		   	<CF_DateConvert Value="#DateFormat(getDate.Date,CLIENT.DateFormatShow)#">
     		<cfset lowest = dateValue>
				
		<cfelse>
		
			<cfset lowest = "">
		
		</cfif>
		
		<!--- loand relevant price data into memory --->
		
		<cfquery name="getPriceData" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     ItemUoMPrice
				WHERE    ItemNo      = '#ItemNo#' 
				AND      UoM         = '#UoM#'
				AND      DateEffective <= GETDATE() 
				<cfif lowest neq "">
				AND       DateEffective >= #lowest#
				</cfif>							
		</cfquery>		
				
		<cfset sale.mission = getWarehouse.Mission>	
		
		<cfquery name="getCustomer" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *  
			<cfif scope eq "Materials">			
			FROM      Customer
			<cfelse>
			FROM      WorkOrder.dbo.Customer
			</cfif>
			WHERE     CustomerId = '#CustomerId#' 
		</cfquery>		
		
		<cfif CustomerIdTax eq "">
			 <cfset CustomerIdTax = CustomerId>			 
		</cfif>	
		
		<cfquery name="getCustomerTax" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *  
			<cfif scope eq "Materials">			
			FROM      Customer
			<cfelse>
			FROM      WorkOrder.dbo.Customer
			</cfif>
			WHERE     CustomerId = '#CustomerIdTax#' 
		</cfquery>				
		
		<cfset sale.taxexemption = getCustomerTax.TaxExemption>
		
		<cfquery name="getItem" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      Item
			WHERE     ItemNo     = '#ItemNo#' 			
		</cfquery>			
		
		<cfset sale.category        = getItem.Category>	
		<cfset sale.itemdescription = getItem.ItemDescription>	
		<cfset sale.itemclass       = getItem.ItemClass>	
		
		<!--- get the most recent effective schedule for this customer --->
					
		<cfif PriceSchedule eq ""> 
				
			<cfquery name="getSchedule" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT    TOP 1 *
				<cfif scope eq "Materials">			
				FROM      CustomerSchedule
				<cfelse>
				FROM      WorkOrder.dbo.CustomerSchedule
				</cfif>				
				WHERE     Category   = '#getItem.Category#' 
				AND       CustomerId = '#customerid#'
				AND       DateEffective <= GETDATE() 
				<cfif lowest neq "">
				AND       DateEffective >= #lowest#
				</cfif>
				ORDER BY  DateEffective DESC
			</cfquery>			
			
			<!--- Nery: Temp Solution as SanBenito store is having too many issues with pricing (not taking regular) --->
			
			<cfif getSchedule.RecordCount eq 0>
			
				<cfquery name="getSchedule" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT Code AS PriceSchedule
				    FROM   Ref_PriceSchedule
					WHERE  FieldDefault = 1
				</cfquery>
			
				<cfset PriceSchedule = getSchedule.PriceSchedule>
			
			<cfelse>
			
				<cfset PriceSchedule = getSchedule.PriceSchedule>
					
			</cfif>
		
		</cfif>	
							
		<!--- get the price for this store / warehouse --->
		
		<cfquery name="getPrice" maxrows=1 dbtype="query">
			SELECT    *
			FROM      getPriceData			   
			WHERE     Warehouse    = '#warehouse#'
			AND       Currency     = '#Currency#' 									
			<!--- price schedule found, take last schedule --->
			AND       PriceSchedule = '#PriceSchedule#'		
			ORDER BY  DateEffective DESC
		</cfquery>	
		
		
						
		<cfif getPrice.recordcount eq "1">
		
			<cfset sale.priceschedule = getPrice.PriceSchedule>
			<cfset sale.scheduleprice = getPrice.SalesPrice>
			<cfset sale.price         = getPrice.SalesPrice>
			<cfset sale.taxcode       = getPrice.TaxCode>
			
			<cfset sale.price = sale.price * (100-discount)/100>
					
		<!--- we check for a price in ANOTHER currency and convert it to the currency of selection --->
		
		<cfelse>
				
			<cfquery name="getPrice" maxrows=1 dbtype="query">
				SELECT    *
				FROM      getPriceData			   
				WHERE     Warehouse    = '#warehouse#'															
				<!--- price schedule found, take last schedule --->
				AND       PriceSchedule = '#PriceSchedule#'		
				ORDER BY  DateEffective DESC
		    </cfquery>		
						
			<cfif getPrice.recordcount eq "1">
						
				<cf_exchangeRate datasource="AppsMaterials" 
				     currencyFrom="#getPrice.Currency#" 
				     currencyTo="#Currency#">
					 
					 <cfset sale.priceschedule = getPrice.PriceSchedule>
					 <cfset sale.scheduleprice = getPrice.SalesPrice>
					 <cfset sale.price         = getPrice.SalesPrice/exc>
					 <cfset sale.taxcode       = getPrice.TaxCode>
					 					 
			<cfelse>	
						
			    <!--- get from any warehouse in the same mission --->
			   
			    <cfquery name="getPrice" maxrows=1 dbtype="query">
					SELECT    *
					FROM      getPriceData			   
					WHERE     Mission       = '#mission#'															
					AND       Currency      = '#Currency#' 	
					<!--- price schedule found, take last schedule --->
					AND       PriceSchedule = '#PriceSchedule#'		
					ORDER BY  DateEffective DESC
					
		        </cfquery>
			   												
				<cfif getPrice.recordcount eq "1">
													
					 <cfset sale.priceschedule = getPrice.PriceSchedule>
					 <cfset sale.scheduleprice = getPrice.SalesPrice>
					 <cfset sale.price         = getPrice.SalesPrice>
					 <cfset sale.taxcode       = getPrice.TaxCode>				 
					 					 
				<cfelse>		
				
					<cfquery name="getDefault" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    *   
							FROM      Ref_PriceSchedule
							WHERE     FieldDefault = 1 			
					</cfquery>		
					
					<cfquery name="getPrice" maxrows=1 dbtype="query">
						SELECT    *
						FROM      getPriceData			   
						WHERE     Mission       = '#mission#'															
						AND       Currency      = '#Currency#' 	
						<!--- price schedule found, take last schedule --->
						AND       PriceSchedule = '#getDefault.Code#'		
						ORDER BY  DateEffective DESC
		           </cfquery>	
				   				   					
					<cfif getPrice.recordcount eq "1">
					
						 <cfset sale.priceschedule = getPrice.PriceSchedule>
						 <cfset sale.scheduleprice = getPrice.SalesPrice>
						 <cfset sale.price         = getPrice.SalesPrice>
						 <cfset sale.taxcode       = getPrice.TaxCode>							
					
					<cfelse>					    
								
						<!--- finally we take the price from the standard cost -in Base currency --->	
							
						<cfquery name="getPrice" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
		
								SELECT    TOP 1 *
								FROM      ItemVendorOffer AS ivo INNER JOIN
		                                  ItemVendor AS iv ON ivo.OrgUnitVendor = iv.OrgUnitVendor AND ivo.ItemNo = iv.ItemNo
								WHERE     iv.Preferred = 1 
								AND       ivo.DateEffective <= GETDATE() 
								AND       ivo.ItemNo   = '#itemno#' 
								AND       ivo.UoM      = '#uom#'
								AND       Mission      = '#mission#'
								AND       Currency     = '#currency#'
								AND       (ivo.DateExpiration IS NULL OR ivo.DateExpiration >= GETDATE())							
								ORDER BY  DateEffective DESC 	
							</cfquery>					
									
						<cfif getPrice.recordcount eq "1">									
										 
						 <cfset sale.price         = getPrice.ItemPrice>
						 <cfset sale.scheduleprice = getPrice.ItemPrice>
						 
						 <cfquery name="getWarehouse" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT    *
							    FROM      ItemWarehouse
							    WHERE     ItemNo        = '#itemno#' 
								AND       UoM           = '#uom#' 		
								AND       Warehouse     = '#getWarehouse.Warehouse#'					
							</cfquery>	
							
							<cfset sale.taxcode  = getWarehouse.TaxCode>	
						
						<cfelse>
									
							<cfquery name="getPrice" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT    *
							    FROM      ItemUoMMission
							    WHERE     ItemNo        = '#itemno#' 
								AND       UoM           = '#uom#' 		
								AND       Mission       = '#Mission#'					
							</cfquery>		
							
							<cfquery name="getWarehouse" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT    *
							    FROM      ItemWarehouse
							    WHERE     ItemNo        = '#itemno#' 
								AND       UoM           = '#uom#' 		
								AND       Warehouse     = '#getWarehouse.Warehouse#'					
							</cfquery>	
							
							<cfset sale.taxcode  = getWarehouse.TaxCode>	
													
							<cfif getPrice.recordcount eq "1">		
						
							<cf_exchangeRate datasource="AppsMaterials" 
						     	currencyFrom="#APPLICATION.BaseCurrency#" 
							    currencyTo="#Currency#">
							 					 					 
							   <cfset sale.price         = getPrice.StandardCost/exc>
							   <cfset sale.scheduleprice = sale.price>
							 
							<cfelse>
												
							   <cfset sale.price         = "0.00">		
							   <cfset sale.scheduleprice = sale.price>			
							
							</cfif> 
						
						</cfif>
						
					</cfif>	
									
					<!--- we take another action price ---> 				
								
				</cfif>				
			
			</cfif>
			
			<cfset sale.price = sale.price * (100-discount)/100>
				
		</cfif>
				
		<cfquery name="getTax" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT    *
			    FROM      Accounting.dbo.Ref_Tax
			    WHERE     TaxCode         = '#sale.taxcode#' 					
		</cfquery>
		
		<cfif getTax.recordcount eq "0">
		
			<cfset sale.TaxCode  = "00">			
		
			<cfquery name="getTax" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT    *
				    FROM      Accounting.dbo.Ref_Tax
				    WHERE     TaxCode         = '#sale.taxcode#' 	
			</cfquery>
		
		</cfif>
		
		<cfif getTax.TaxCalculation eq "Exclusive">
			
			<cfset sale.inclusive  = "0">
			<cfset sale.tax        = getTax.Percentage>
			
			<cfif getCustomerTax.taxExemption eq "1">
			
				<cfset sale.amount     = sale.price * quantity>
				<cfset sale.amounttax  = 0>	
								
			<cfelse>
			
				<cfset sale.amount     = sale.price * quantity>
				<cfset sale.amounttax  = (sale.tax * sale.price) * quantity>	
				
			</cfif>							
				
		<cfelse>
				
			<cfset sale.inclusive  = "1">
			<!--- #Change done as exemption for a customer was not working --->
			<cfset sale.tax = getTax.Percentage>
			
			<cfif getCustomerTax.taxExemption eq "1">
				<cfset sale.amounttax  = ((sale.price/(1+sale.tax))*sale.tax)*quantity>
			<cfelse>
				<cfset sale.amounttax  = ((sale.tax/(1+sale.tax))*sale.price)*quantity>
			</cfif>		
			
			<!--- <cfset sale.amount     = ((1/(1+getTax.Percentage))*sale.price)*quantity> --->
			<!--- changed way of calculating amountsle as otherwise sometimes we have .01 data loss ---->
			<cfset sale.amount    = (sale.price*quantity)-sale.amounttax>

			<cfif getCustomerTax.taxExemption eq "1">
				<cfset sale.amounttax  = 0>
				
			</cfif>		
										
		</cfif>		
		
		<!--- rounding --->
		<cfset sale.amount    = round(sale.amount*10000)/10000>
		<cfset sale.amounttax = round(sale.amounttax*10000)/10000>
		
		<cfif quantity eq "0">
			<cfset sale.pricenet = "0">
		<cfelse>
			<cfset sale.pricenet  = sale.amount / quantity>
		</cfif>	
				
		<cfreturn sale>				
		
		</cffunction>	
				
		<!--- -------------------------------------------------------- --->		
		<!--- --------------  ---APPLY PROMOTION --------------------- --->
		<!--- -------------------------------------------------------- --->		
			
		<cffunction name="applyPromotion"
	            access="public"
	            returntype="any"
	            displayname="adjust the sale price with the promotional disacounts">
			 
			 <cfargument name="Warehouse"     type="string"  required="true"   default="">		
			 <cfargument name="Customerid"    type="GUID"    required="true"   default="">
			 <cfargument name="RequestNo"     type="string"  required="true"   default="">
			 							 
			 <!--- meta code 
				
				1. Define the mission from the input and filter only valid promotions sorted by priority
				2. We iniitalise the data set the field PROMOTIONID and PromotionDiscount to NULL in the temp table
				A1. We loop through the promotions
					B1. We loop through the elements of a promotion 
						C. Verify if the requirement is met and update in the temp table the TransactionId the ROMOTIONID and PromotionDiscount to be applied
							IMPORTANT : Lines already with a DISCOUNT to be applied will not be used for the next verification !!
					B2  If each of the elements is met we apply the discount to the temp table as we have it through the line - element associated
					B3  If not met we remove the TransactionId from the array for any of the elements for the promotion	
				A2. We go to the Next promotion					
				
			 --->
			 
			 <cftry>
			 
			 <!--- we need to make a provision for the moment no longer a promotion would apply and then the old price should come back --->
			 
			 <cfquery name="resetPrices" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
																					
					UPDATE   CustomerRequestLine 	
					SET      SalesPrice      = SchedulePrice * ((100 - salesDiscount)/100), 					 
					         SalesAmount     = SchedulePrice * ((100 - salesDiscount)/100) * TransactionQuantity * (1-taxpercentage/1),				 		
							 SalesTax        = SchedulePrice * ((100 - salesDiscount)/100) * TransactionQuantity * (taxpercentage/1),
							 PromotionId        = NULL,
							 PromotionDiscount = 0		
					WHERE    RequestNo = '#RequestNo#' 	
					AND      TaxIncluded = '1' and SchedulePrice is not NULL and PromotionId is not NULL	
					<!--- reloaded for change --->
					AND      BatchId is NULL		
					
					UPDATE   CustomerRequestLine 
					SET      SalesPrice      = SchedulePrice * ((100 - salesDiscount)/100), 					 
					         SalesAmount     = SchedulePrice * ((100 - salesDiscount)/100) * TransactionQuantity,				 		
							 SalesTax        = SchedulePrice * ((100 - salesDiscount)/100) * TransactionQuantity * taxpercentage,
							 PromotionId        = NULL,
							 PromotionDiscount = 0		
					WHERE    RequestNo = '#RequestNo#'
					AND      TaxIncluded = '0' and SchedulePrice is not NULL and PromotionId is not NULL		
					AND      BatchId is NULL	
																
			 </cfquery>	
			 
			 <cfcatch></cfcatch>	
			 
			 </cftry>
			 
			 <cfset hasPromotion = "0">
							 						 
			 <cfquery name="get" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    *   
				FROM      Warehouse
				WHERE     Warehouse = '#Warehouse#' 
			</cfquery>	
			
			<!--- this method does not discriminate on the category --->
			
			 <cfquery name="getschedule" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT DISTINCT PriceSchedule
			    FROM   CustomerSchedule
			    WHERE  CustomerId     = '#CustomerId#'
				AND    DateEffective <= getDate()
			</cfquery>	
			
			<!--- if no schedules are found for customer we do not filter by schedule --->
						
			<cfquery name="promotion" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				SELECT    *
				FROM      Promotion T
				WHERE     Mission = '#get.mission#' 
				AND       DateEffective  <= GETDATE()
				AND       (DateExpiration >= GETDATE() or DateExpiration is NULL)
				AND       Operational = 1
				
				<cfif getschedule.recordcount gte "1">
				AND       EXISTS (SELECT 'X'
				                  FROM   PromotionSchedule
								  WHERE  PromotionId = T.PromotionId								  
								  AND    PriceSchedule IN (#quotedvalueList(getschedule.priceSchedule)#))
				</cfif>				  
				<!--- elements --->
				AND       EXISTS (SELECT 'X' 
						          FROM   PromotionElementItem 
								  WHERE  PromotionId = T.PromotionId ) 				
				ORDER BY  Priority  <!--- highest priority first --->
				
				
			</cfquery>	
			
			<cfset serno = 0>			
						
			<cfloop query="promotion">	
			
				<cfset status = "1">	
												
				<cfquery name="element" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
						SELECT    *
						FROM      PromotionElement
						WHERE     PromotionId = '#promotionid#' 						
						ORDER BY  ElementOrder		
						
				</cfquery>				
						   				
				<cfset serno = serno+1>						
									
				<cfloop query="element">	
					
					<cfset ids = "">
					<cfset qty = "0">												
										
				    <!--- get all element items in a promotion, they act as OR --->
			
					<cfquery name="ElementItem" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
						SELECT    Category+'-'+CategoryItem as Item
						FROM      PromotionElementItem
						WHERE     PromotionId     = '#promotionid#' 
						AND       ElementSerialNo = '#elementserialno#'							
					</cfquery>	
																														
					<cfset targetlist = quotedvaluelist(ElementItem.Item)>
											
					<cfset mapped = "0">				
												
					<cfquery name="getSaleLines" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">							
						SELECT   T.TransactionId, 
						         I.Category+'-'+I.CategoryItem AS Item, 
								 T.TransactionQuantity
						FROM     vwCustomerRequest T INNER JOIN Materials.dbo.Item I ON T.ItemNo = I.ItemNo					
						WHERE    PromotionId IS NULL <!--- no double promotions --->
						AND      CustomerId = '#url.customerid#' <!--- this applies to all addresses of the customer --->	
						AND      ActionStatus != '9'
						AND      BatchNo is NULL
						ORDER BY SchedulePrice DESC						
					</cfquery>											
				
					<cfloop query="getSaleLines">
					
						<cfif findNoCase(Item,Targetlist) gt 0>
							
							<cfif ids eq "">
								<cfset ids = "'#transactionid#'">
							<cfelse>																									
								<cfset ids = "#ids#,'#transactionid#'">
							</cfif>
							<cfset qty = qty + TransactionQuantity> 
											
						</cfif>										
																				
					</cfloop>	
					
					<cfif qty gte element.Quantity>
					
							<cfset hasPromotion = "1">
					
				           <cfquery name="taglines" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">							
								UPDATE   CustomerRequestLine  	
								SET      PromotionId       = '#element.PromotionId#',
										 PromotionDiscount = '#element.Discount#',		
										 PromotionType     = '#element.DiscountType#',												 
										 PromotionRun      = '#serno#'	
								WHERE    TransactionId     IN (#preservesingleQuotes(ids)#) 							
							</cfquery>				
								
					</cfif>								
					
				</cfloop>																							
														
			</cfloop>
			
			<!--- Apply the discounts AND also review the existing lines who might have lost the discount --->
			
			<cfquery name="lines" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">							
					SELECT  * 
					FROM    CustomerRequestLine   							
					WHERE   RequestNo = '#RequestNo#'							
			</cfquery>		
				
			<cfloop query="lines">	
				
				<cfif PromotionId neq "">
				
				    <cfif PromotionType eq "Percentage">				
						<cfset price = SchedulePrice - (SchedulePrice * PromotionDiscount)>	
					<cfelseif PromotionType eq "Fixed">
					    <cfset price = PromotionDiscount>	
					<cfelse>
						<cfset price = SchedulePrice - PromotionDiscount>	
						<cfif price lt 0>
							<cfset price = 0>
						</cfif>
					</cfif>	
					
					<cfif salesdiscount neq "">
						<cfset price = price*((100-salesdiscount)/100)>
					</cfif>
																	
					<cfquery name="getTax" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT    *
						    FROM      Ref_Tax
						    WHERE     TaxCode  = '#taxcode#' 	
					</cfquery>
					
					<cfif getTax.recordcount eq "0">
					
						<cfset TaxCode  = "00">			
					
						<cfquery name="getTax" 
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT    *
							    FROM      Ref_Tax
							    WHERE     TaxCode  = '#taxcode#' 	
						</cfquery>
					
					</cfif>
						
				    <cfset tax = getTax.Percentage>
						
					<cfif getTax.TaxCalculation eq "Exclusive">
							
						<cfset inclusive  = "0">
						<cfset amount     = price * TransactionQuantity>
						<cfset amounttax  = (tax * price) * TransactionQuantity>	
							
					<cfelse>
							
						<cfset inclusive  = "1">
						<cfset amount   = ((1/(1+tax))*price)*TransactionQuantity>
						<cfset amounttax      = ((tax/(1+tax))*price)*TransactionQuantity>	
							
					</cfif>		
				
					<cfset amount  = round(amount*100)/100>
					<cfset amounttax     = round(amounttax*100)/100>		
					
					<cfif transactionquantity neq "0">
						<cfset unitprice = amount /  transactionquantity>
					<cfelse>
					    <cfset unitprice = 0>
					</cfif>									
											
					<cfquery name="applyDiscount" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">							
						UPDATE   CustomerRequestLine 	
						SET      SalesPrice     = '#price#', 
								 SalesUnitPrice = '#unitprice#',
						         SalesAmount    = '#amount#', 
								 SalesTax       = '#amounttax#'						
						WHERE    TransactionId  = '#TransactionId#' 												
					</cfquery>		
				
				</cfif>			
				
			</cfloop>	
			
			<cfreturn hasPromotion>
				
	</cffunction>
	
	<!--- -------------------------------------------------------- --->		
	<!--- --------------POSTING OF TRANSACTION ------------------- --->
	<!--- -------------------------------------------------------- --->		
	
	<cffunction name="IssuanceToSale"
             access="public"
             returntype="any"
             displayname="Generates a draft sale transaction from a inventory or issuance batch">	
			 
			 <cfargument name="BatchNo"       type="string"  required="true"   default="">
			 <cfargument name="Warehouse"     type="string"  required="true"   default="">		
			 <cfargument name="Customerid"    type="GUID"    required="true"   default="">
			 
			  <!---
			 
			 	determine the customer
				populate the table Sale[Whs]_session.acc and open 				
				NB : you can add another batch for the same customer, which will show as well under a single sales 				
				we loop through the lines of the batch and then populate the table 
				
			  --->
			 
			  <cfquery name="Batch" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">							
						SELECT * 
						FROM   WarehouseBatch 
						WHERE  BatchNo = '#batchno#'															
			  </cfquery>		
			 
			  <cfquery name="getWarehouse" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">							
						SELECT * 
						FROM   Warehouse 
						WHERE  Warehouse = '#warehouse#'															
			  </cfquery>		
				
			  <cfquery name="getTransaction" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">							
						SELECT * 
						FROM   ItemTransaction
						WHERE  TransactionBatchNo = '#batchno#'															
						AND   ( TransactionType IN ('2','5')
								OR
							   (TransactionType = '8' and TransactionQuantity < 0)
								)
						ORDER BY CustomerId		
			  </cfquery>					  
			  	 			 
			  <cfoutput query="getTransaction" group="customerid">	
			  
				  	 <!--- clear 
					   
				    <cfquery name="reset" 
						datasource="AppsTransaction" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						DELETE FROM dbo.Sale#Warehouse# 
						WHERE (CustomerId = '#CustomerId#' 
						      or CustomerId = '00000000-0000-0000-0000-000000000000')
					</cfquery>		
					
					--->		  
			  
			       <cfoutput>
			
					<cfinvoke component = "Service.Process.Materials.POS"  
					   method           = "getPrice" 
					   warehouse        = "#warehouse#" 
					   customerid       = "#customerid#"
					   customeridTax    = "#customerid#"
					   currency         = "#getWarehouse.saleCurrency#"
					   ItemNo           = "#itemno#"
					   UoM              = "#TransactionUoM#"
					   quantity         = "#TransactionQuantity*-1#"
					   returnvariable   = "sale">	
				
					   <!--- ---------------------------------------------- --->
					   <!--- DEFINE the location from where it is retrieved --->			
					   <!--- ---------------------------------------------- --->			
								
					   <cf_assignid>					  			   
					   
					    <cfquery name="get" 
							datasource="AppsTransaction" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT * FROM dbo.Sale#Warehouse# 
							WHERE TransactionId = '#TransactionId#'
						</cfquery>
						
					   <cfif get.recordcount eq "0">	
					
						   <cfquery name="Insert" 
								datasource="AppsTransaction" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								
								INSERT INTO dbo.Sale#Warehouse# 
								
							         (	SourceBatchNo,
									    TransactionId, 								    
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
										PersonNo
										<!--- ,
										SalesPersonNo --->)  
												
								VALUES ('#BatchNo#',
								        '#TransactionId#',
									    '2',
									    '#transactiondate#', <!--- inherit from original transaction --->
									    '#itemno#', 
										'#sale.ItemClass#',
										'#sale.ItemDescription#', 
										'#sale.Category#',
										'#sale.Mission#', 
										'#warehouse#', 
										'',
										'#TransactionUoM#',    
										'#TransactionLot#',        
										'#TransactionQuantity*-1#',			           
										'#CustomerId#', 
										'#CustomerId#',											
										'#sale.priceschedule#',
										'#getWarehouse.saleCurrency#', 
										'#sale.price#', 
										'#sale.price#', 
										'#sale.TaxCode#',
										'#sale.tax#', 
										'#sale.taxexemption#', 
										'#sale.inclusive#', 
										'#sale.amount#', 
										'#sale.amounttax#', 			           
										'#client.PersonNo#')
										<!---
										,'#url.salespersonno#' ---> 											
										  
							</cfquery>			
						
						</cfif>	
						
					</cfoutput>
				 
			</cfoutput> 
			 
	</cffunction>		 		 			 
	
	
	<!--- -------------------------------------------------------- --->		
	<!--- --------------BENEFICIARY            ------------------- --->
	<!--- -------------------------------------------------------- --->		
	
	<cffunction name="PostBeneficiary"
             access="public"
             returntype="any"
             displayname="Post beneficiary transaction">			 			 
			 
			<cfargument name="Warehouse"          		type="string"  required="true"   default="">
			<cfargument name="Customerid"         		type="GUID"    required="true"   default="">
			<cfargument name="TransactionId" 	  		type="GUID"    required="true"   default="">
			<cfargument name="enableBeneficiary"        type="string"  required="true"   default="0">
	
			<cfif enableBeneficiary eq 1>
							
						<cfquery name="getLinesBeneficiary"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT  *
							FROM    UserTransaction.dbo.Sale#Warehouse#Beneficiary
							WHERE   CustomerId 		= '#CustomerId#'
							AND     TransactionId 	= '#TransactionId#' 
							AND     FirstName IS NOT NULL
							AND     FirstName!=''
							AND     Operational     = '1'
						</cfquery>	
								
						<cfloop query="getLinesBeneficiary">
	
									<cfquery name="checkBeneficiary"
										datasource="AppsMaterials" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT  *
										FROM    CustomerBeneficiary CB
										WHERE   CustomerId 		= '#getLinesBeneficiary.CustomerId#'
										AND     BeneficiaryId 	= '#getLinesBeneficiary.BeneficiaryId#' 
									</cfquery>				
									
									<cfif checkBeneficiary.recordcount eq 0>
	
										<cfquery name="checkBeneficiary"
											datasource="AppsMaterials" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											INSERT INTO CustomerBeneficiary 
								           (CustomerId
								           ,BeneficiaryId
								           ,DateEffective
								           ,LastName
								           ,FirstName
								           ,Relationship
								           ,Birthdate
								           ,Gender
								           ,Source
								           ,Operational
								           ,OfficerUserId
								           ,OfficerLastName
								           ,OfficerFirstName)
								     		VALUES
								           ('#getLinesBeneficiary.CustomerId#'
								           ,'#getLinesBeneficiary.BeneficiaryId#'
								           ,GetDate()
								           ,'#getLinesBeneficiary.LastName#'
								           ,'#getLinesBeneficiary.FirstName#'
								           ,'#getLinesBeneficiary.Relationship#'
								           ,'#getLinesBeneficiary.BirthDate#'
								           ,'#getLinesBeneficiary.Gender#'
								           ,'Manual'
								           ,1
								           ,'#SESSION.acc#'
										   ,'#SESSION.last#'
										   ,'#SESSION.first#')
										</cfquery>				
									</cfif>		


									<cfquery name="checkBeneficiaryTransaction"
										datasource="AppsMaterials" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT  *
										FROM    ItemTransactionBeneficiary CB
										WHERE   CustomerId 		= '#getLinesBeneficiary.CustomerId#'
										AND     BeneficiaryId 	= '#getLinesBeneficiary.BeneficiaryId#'
										AND     TransactionId   = '#TransactionId#' 
									</cfquery>		


									<cfif checkBeneficiaryTransaction.recordcount eq 0>
										<cfquery name="checkBeneficiary"
											datasource="AppsMaterials" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											INSERT INTO ItemTransactionBeneficiary
           									(CustomerId
           									,BeneficiaryId
           									,TransactionId
           									,SalesQuantity
           									,OfficerUserId
           									,OfficerLastName
           									,OfficerFirstName)		
     										VALUES
           									('#getLinesBeneficiary.CustomerId#'
	           									,'#getLinesBeneficiary.BeneficiaryId#'
           										,'#TransactionId#'
           										,1
           										,'#SESSION.acc#'
										    	,'#SESSION.last#'
										    	,'#SESSION.first#'
										 	)
										</cfquery>
									</cfif>
									
					</cfloop>	
			</cfif>
							
	</cffunction>						
	

	<!--- -------------------------------------------------------- --->		
	<!--- --------------POSTING SETTLEMENT ONLY ------------------ --->
	<!--- -------------------------------------------------------- --->		
	
	<cffunction name="postSettlement"
             access="public"
             returntype="any"
             displayname="Post Settlement">			 			 
			 
			<cfargument name="Warehouse"          type="string"  required="true"   default="">
			<cfargument name="Terminal"           type="string"  required="true"   default="0">
			<cfargument name="RequestNo"          type="string"  required="true"   default="">
			<cfargument name="Memo"               type="string"  required="true"   default="">
			<cfargument name="BatchId"            type="string"  required="true"   default="">
			<cfargument name="Customerid"         type="GUID"    required="true"   default="">
			<cfargument name="CustomeridInvoice"  type="GUID"    required="true"   default="">
			<cfargument name="AddressId"  		  type="GUID"    required="true"   default="00000000-0000-0000-0000-000000000000">
			<cfargument name="Currency"           type="string"  required="true"   default="">
			<cfargument name="Workflow"           type="string"  required="true"   default="No">		
			<cfargument name="Settlement"         type="string"  required="true"   default="1">						
			<cfargument name="TransactionDate"    type="string"  required="true"   default="">	<!--- euro format --->		
			<cfargument name="cleanup"            type="string"  required="true"   default="Yes">
			<cfargument name="mail"               type="string"  required="true"   default="No">
				
			<cftransaction>
				
			<cfquery name="get" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT  *
				FROM   Warehouse
				WHERE  Warehouse = '#warehouse#'	   							   
				
			</cfquery>						
				
			<cfset OrgUnitOwner = "0">
		
			 <cfquery name="Parameter" 
			    datasource="AppsMaterials" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				    SELECT    *
				    FROM      Accounting.dbo.Ref_ParameterMission
					WHERE     Mission = '#get.Mission#'
			 </cfquery> 
			  
			  <!--- this entity posts by parent  --->
			
			  <cfif Parameter.AdministrationLevel eq "Parent">
			  
		          <!--- determine the owner --->
														
				  <cfquery name="getOwner" 
				    datasource="AppsMaterials" 
				    username="#SESSION.login#" 
			    	password="#SESSION.dbpw#">
						SELECT    TOP 1 OrgUnit
						FROM      Organization.dbo.Organization O
						WHERE     Mission = '#get.mission#'
						AND       OrgUnitCode IN
			                          (SELECT     TOP 1 HierarchyRootUnit
			                            FROM      Organization.dbo.Organization
										WHERE     Mission          = O.Mission							
			                            AND       MissionOrgUnitId = '#get.MissionOrgUnitId#'
			                            ORDER BY Created DESC)
						ORDER BY  Created DESC					
					</cfquery>
				
					<cfif getOwner.recordcount eq "1">						
						<cfset OrgUnitOwner = getOwner.OrgUnit>						 
					</cfif>					
											
			</cfif>				
				
			<CF_DateConvert Value="#TransactionDate#">
			<cfset dte = dateValue>
								
			<cfif month(dte) gte "10">
				<cfset TransactionPeriod = "#year(dte)##month(dte)#">
			<cfelse>
				<cfset TransactionPeriod = "#year(dte)#0#month(dte)#">
			</cfif>	
							
			<cfquery name="getSettle"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  *
				FROM    UserTransaction.dbo.Settle#warehouse#
				WHERE   CustomerId = '#customerid#'
				AND     AddressId  = '#addressid#'	
				AND     ABS(SettleAmount) >= '0.01'
				AND     SettleCode IN (SELECT Code FROM Materials.dbo.Ref_Settlement)	 	 		 	 				
			</cfquery>	
			
			<cfset settle = "0">
			
			<cfloop query="getSettle">
				
				<cfif Currency neq SettleCurrency>
													
					    <!--- convert to the invoice currency --->
						
						<cf_exchangeRate 
						CurrencyFrom = "#SettleCurrency#" 
				        CurrencyTo   = "#Currency#">										
						
						<cfset settle = settle + SettleAmount*exc>	
				
				<cfelse>
				
						<cfset settle = settle + SettleAmount>
							
				</cfif>		
			
			</cfloop>
			
			 <cfquery name="getBatch"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT * 
					FROM    WarehouseBatch						
					WHERE   BatchId = '#BatchId#'
			</cfquery>	
			
			<cfif getBatch.recordCount eq 1>				
				   
				    <cfset BatchNo = getBatch.BatchNo>	
				    <cfset setbatchid = getBatch.BatchId>						
			
					<cfquery name="customer"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  *
						FROM    Customer
						WHERE   CustomerId = '#getBatch.customerid#'
					</cfquery>										
						
					<cfquery name="qHeader" 
  						datasource="AppsMaterials" 
  						username="#SESSION.login#" 
  						password="#SESSION.dbpw#">	
						SELECT  *
	 					FROM    Accounting.dbo.TransactionHeader TH 
 						WHERE   TransactionSourceId = '#setbatchid#' 
						AND     TransactionSource = 'SalesSeries'
					</cfquery>							
							
					<cfset parentJournal          = qHeader.Journal>
					<cfset parentJournalSerialNo  = qHeader.JournalSerialNo>	
					
					<cfset Receivable_Journal    = parentJournal>
					<cfset Receivable_JournalNo  = parentJournalSerialNo>
					<cfset tot = qHeader.AmountOutstanding>					

					<cfquery name="getParentJournal" 
				    	datasource="AppsMaterials" 
				    	username="#SESSION.login#" 
				    	password="#SESSION.dbpw#">
						SELECT    TOP 1 *
						FROM      Accounting.dbo.JournalAccount
						WHERE     Journal = '#parentJournal#' 	
						ORDER BY  ListDefault DESC	
					</cfquery>	
				
					<cfif getParentJournal.GLAccount eq "">
			 	
						<cf_message message = "A RECEIVABLE contra-account was not defined for this journal. Operation not allowed."
					  	return = "no">
					  	<cfabort>
						
					</cfif>						
					
					<cfset receivable = getParentJournal.GLAccount>						
							
					<!--- --------------------- --->
					<!--- POSTING SETTLEMENT--- --->
					<!--- --------------------- --->	
					
					<!--- we take a journal of which the currency is the same as the sale --->
					
					<cfquery name="Journal" 
					    datasource="AppsMaterials" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						SELECT    *
						FROM      Materials.dbo.WarehouseJournal
						WHERE     Warehouse     = '#Warehouse#' 
						AND       Area          = 'SETTLE'
						AND       Currency      = '#Currency#'  
					</cfquery>	
					
					<!--- get default journal --->
				
					<cfif Journal.recordcount eq "0">
				 	
						<cf_message message = "A Facility settlement journal for currency: #Currency# was not defined. Operation not allowed."
						  return = "back">
						  <cfabort>
							
					</cfif>	 
		
 					<cfquery name="getJournal" 
					    datasource="AppsMaterials" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						SELECT    *
						FROM      Accounting.dbo.JournalAccount
						WHERE     Journal = '#Journal.Journal#'
						AND		  Mode = 'Contra'
						ORDER BY  ListDefault DESC
						 		
					</cfquery> 
					
					<cfif getJournal.GLAccount eq "">
				 	
						<cf_message message = "A receipt journal was not defined. Operation not allowed."
						  return = "back">
						  <cfabort>
							
					</cfif>	 	
		
					<cfset sett_tot = 0>
					
					<cfquery name="qCheckSettlement"
                      datasource="AppsMaterials"
                      username="#SESSION.login#"
                      password="#SESSION.dbpw#">
						SELECT MAX(SettleSerialNo) AS SettleSerialNo 
						FROM   Materials.dbo.WarehouseBatchSettlement
						WHERE  BatchNo = '#BatchNo#'
					</cfquery>		
					
					<cfif qCheckSettlement.SettleSerialNo eq "">
						<cfset iCounter = 0>
					<cfelse>
						<cfset iCounter = qCheckSettlement.SettleSerialNo>	
					</cfif>	
					
					<cfloop query="getSettle">
						<cfset iCounter = iCounter + 1>
						<!--- update WarehouseBatchSettlment --->					
							<cfquery name="Add"
	                          datasource="AppsMaterials"
	                          username="#SESSION.login#"
	                          password="#SESSION.dbpw#">
	                                INSERT INTO Materials.dbo.WarehouseBatchSettlement
	                                     (BatchNo,
	                                     SettleSerialNo,
	                                     SettleCode,
	                                     SettleCurrency,
	                                     SettleAmount,
	                                     BankName,
	                                     PromotionCardNo,
	                                     CreditCardNo,
	                                     ExpirationMonth,
	                                     ExpirationYear,
	                                     ApprovalCode,
	                                     ApprovalReference,
	                                     OfficerUserId,
	                                     OfficerLastName,
	                                     OfficerFirstName)
	                                     VALUES
	                                    ('#batchno#',
	                                    '#iCounter#',
	                                    '#settlecode#',
	                                    '#settlecurrency#',
	                                    '#settleamount#',
	                                    '#BankName#',
	                                    '#PromotionCardNo#',
	                                    '#CreditCardNo#',
	                                    '#ExpirationMonth#',
	                                    '#ExpirationYear#',
	                                    '#ApprovalCode#',
	                                    '#ApprovalReference#',
	                                    '#SESSION.acc#',
	                                    '#SESSION.last#',
	                                    '#SESSION.first#')                 
	                     </cfquery>  					
						
						<!--- posting --->
					
						<cfquery name="getAccount" 
						    datasource="AppsMaterials" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
							SELECT    *
							FROM      Ref_SettlementMission M
							WHERE     Mission = '#get.mission#' 		
							AND       Code   = '#settlecode#'
							AND       GLAccount IN (SELECT GLAccount 
							                        FROM   Accounting.dbo.Ref_Account 
													WHERE  GLAccount = M.GLAccount)
							AND       GLAccount != ''						
						</cfquery>	
					
						<cfif getAccount.recordcount eq "0">
						
						    <!--- the amount is not settled and will remain open --->
							
						    <!---
							<cf_message message = "A settlement account code for #settlecode# was not defined. Operation not allowed."
						     return = "back">
						     <cfabort>
							 --->
								
						<cfelse>
						
							<cfquery name="getStoreUnit" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">				
									SELECT   OrgUnit 
									FROM     Organization.dbo.Organization
									WHERE    MissionOrgUnitId IN (SELECT MissionOrgUnitId 
									                              FROM   Warehouse 
																  WHERE  Warehouse = '#warehouse#')
									AND      DateEffective <= '#dateformat(TransactionDate,CLIENT.DateSQL)#'  
									ORDER BY DateEffective
							</cfquery>
						
							<cf_GledgerEntryHeader
							    DataSource            = "AppsMaterials"
								Mission               = "#get.mission#"
								OrgUnitOwner          = "#OrgUnitOwner#"
								OrgUnitSource         = "#getStoreUnit.OrgUnit#"
								Journal               = "#getJournal.Journal#" 
								Description           = "Tender from #Customer.CustomerName#"
								DocumentDate       	  = "#TransactionDate#"	
								TransactionDate       = "#TransactionDate#"	
								TransactionPeriod     = "#transactionperiod#"    
								TransactionSource     = "SalesSeries"
								TransactionSourceId   = "#setbatchid#"					
								TransactionCategory   = "Receipt"
								JournalTransactionNo  = "#batchno#"
								MatchingRequired      = "0"
								ActionStatus          = "1"
								Reference             = "Settlement"       
								ReferenceOrgUnit      = "#getStoreUnit.OrgUnit#"
								ReferenceName         = "#Customer.CustomerName#"
								ReferenceId           = "#CustomerId#"
								ReferenceNo           = "#iCounter#"
								DocumentCurrency      = "#SettleCurrency#"					
								DocumentAmount        = "#SettleAmount#"
								AmountOutstanding     = "0">											
							
								<cfset sett_tot = sett_tot + SettleAmount>
								
								<!--- contra account for receivables --->
											
								<cf_GledgerEntryLine
								    DataSource            = "AppsMaterials"
									Lines                 = "2"
									Journal               = "#getJournal.Journal#"
									JournalNo             = "#JournalTransactionNo#"
									JournalTransactionNo  = "#batchno#"			
									DocumentDate       	  = "#TransactionDate#"	
									TransactionDate       = "#TransactionDate#"	
									TransactionPeriod     = "#transactionperiod#" 
									ParentJournal         = "#parentJournal#"
									ParentJournalSerialNo =	"#parentJournalSerialNo#"			
									Currency              = "#SettleCurrency#"
									LogTransaction		  = "Yes"		
														
									TransactionSerialNo1  = "0"
									Class1                = "Credit"
									   
									Reference1            = "Off-set Receivable"       
									ReferenceName1        = "#Customer.CustomerName#"
									Description1          = "Receipt"
									GLAccount1            = "#receivable#"									
									ReferenceId1          = "#customerid#"						
									TransactionType1      = "Contra-account"
									Amount1               = "#SettleAmount#"
									
									TransactionSerialNo2  = "1"
									Class2                = "Debit"									 
									Reference2            = "Receipt on Receivable"       
									ReferenceName2        = "#Customer.CustomerName#"
									ReferenceNo2		  = "#SettleCode#"
									Description2          = "Receipt"
									GLAccount2            = "#getAccount.GLAccount#"									
									ReferenceId2          = "#customerid#"						
									TransactionType2      = "Standard"
									Amount2               = "#SettleAmount#">			
								
						    </cfif>
									
					</cfloop>	
					
					<!--- better to use the component --->			
		
					<cfquery name="qUpdateOutstanding"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE Accounting.dbo.TransactionHeader
						SET    AmountOutstanding = Round('#tot-sett_tot#',2) 
						WHERE  Journal           = '#Receivable_Journal#'
						AND    JournalSerialNo   = '#Receivable_JournalNo#'
					</cfquery>							
										
				</cfif>			

				<cfif cleanup eq "Yes">
				
					<cfquery name="cleanSettle"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						DELETE  FROM  UserTransaction.dbo.Settle#warehouse#
						WHERE   CustomerId = '#customerid#'
	 	 				AND     AddressId = '#addressid#'	 	 											
					</cfquery>					
				
				</cfif>	

				</cftransaction>
				
				<cfreturn setbatchid>
	
	</cffunction>	
			
	<!--- -------------------------------------------------------- --->		
	<!--- -------------- POSTING OF POS TRANSACTION -------------- --->
	<!--- -------------------------------------------------------- --->		
	
	<cffunction name="PostTransaction"
             access="public"
             returntype="any"
             displayname="Post a sales transaction">			 			 
			 
			<cfargument name="Warehouse"          type="string"  required="true"   default="">			
			<cfargument name="Terminal"           type="string"  required="true"   default="0">
			<cfargument name="RequestNo"          type="string"  required="true"   default="">
			<cfargument name="Memo"               type="string"  required="true"   default="">
			
			<!--- transaction to be replaced --->
			<cfargument name="BatchId"            type="string"  required="true"   default="">
			
			<!-- the below 3 fields can be derrived now --->
			<cfargument name="Customerid"         type="GUID"    required="true"   default="">
			<cfargument name="CustomeridInvoice"  type="GUID"    required="true"   default="">
			<cfargument name="AddressId"  		  type="GUID"    required="true"   default="00000000-0000-0000-0000-000000000000">
						
			<cfargument name="Currency"           type="string"  required="true"   default="">
			<cfargument name="Workflow"           type="string"  required="true"   default="No">		
			<cfargument name="Settlement"         type="string"  required="true"   default="1">						
			<cfargument name="TransactionDate"    type="string"  required="true"   default="#dateformat(now(),client.dateformatshow)#">		
			<cfargument name="TransactionHour"    type="string"  required="true"   default="0">		
			<cfargument name="TransactionMinute"  type="string"  required="true"   default="0">			
			<cfargument name="cleanup"            type="string"  required="true"   default="Yes">
			<cfargument name="mail"               type="string"  required="true"   default="No">
			
			<CF_DateConvert Value="#TransactionDate#">
			<cfset TraDate = dateValue>
			
			<cfset TraDate = DateAdd("h","#TransactionHour#", TraDate)>
			<cfset TraDate = DateAdd("n","#TransactionMinute#", TraDate)>						
									
			<cfquery name="Parameter" 
			   datasource="AppsMaterials" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT   TOP 1 *
			   FROM     WarehouseBatch
			   ORDER BY BatchNo DESC
			</cfquery>			
			
			<cfif Parameter.recordcount eq "0">
				<cfset batchNo = 10000>
			<cfelse>
				<cfset BatchNo = Parameter.BatchNo+1>
				<cfif BatchNo lt 10000>
				     <cfset BatchNo = 10000+BatchNo>
				</cfif>
			</cfif>
			
			<cfset vParentBatchNo = "">
			
			<cfif BatchId neq "">
			
				 <cfquery name="getBatch"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT * 
						FROM    WarehouseBatch						
						WHERE   BatchId = '#BatchId#'
				   </cfquery>	
				   
				   <cfset vParentBatchNo = getBatch.BatchNo>
			
				   <cfinvoke component = "Service.Process.Materials.POS"  
					   method           = "purgeTransaction" 
					   mode             = "void"
					   batchid          = "#batchid#"
					   terminal         = "#terminal#">
						
			</cfif>
			
			<!--- posting trasnaction 
				
				1. Sale currency defines the journal (if not exisit prevent)
				2. Cost prise is defined in ItemTransaction ans is being converted to the currency of the journal
				3. Posting of transaction
				
				JOURNAL is defined by the warehouse
				
				    Check how the tax is booked upon receipt of goods which then have to be deducted
												
				      <!--- repeated for each line of the sale --->
					  
					   1. Receivable from the journal 
					   2. a/ Result : Sale which goes by category
					   3  a/ Tax    : Tax to be paid 		
					   
					   <!--- header for each line of the sale --->
					   		   
					   1. Result : Cost of Goods Sold  which goes by category	   
					   2. a/ Stock	
					   
					   if enabled for entity   	   
					   
					   3. Offset the tax To be paid or Taxes received
					   4. a/ Tax paid (offset of the COGS) : if enabled for entity
					   		   
					Settlement transaction 
					   
					   1. Cash / Credit card / Bank : account code is defined   
					   2. A/Receivable
					   
					   and link all lines to this header 		   
			
			--->		
						
			<cfquery name="get" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT  *
				FROM   Warehouse
				WHERE  Warehouse = '#warehouse#'	   							   
			</cfquery>				
			
			<cfquery name="Param" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *   
				FROM      Ref_ParameterMission
				WHERE     Mission = '#get.Mission#' 
			</cfquery>	
			
			<cfquery name="getTerminal" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT  *
				FROM   WarehouseTerminal
				WHERE  Warehouse     = '#warehouse#'	   							   
				AND    TerminalName  = '#terminal#' 
			</cfquery>
			
			<cfquery name="org" 
			  datasource="AppsOrganization" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			    SELECT   TOP 1 *
				FROM     Organization
				WHERE    MissionOrgUnitId = '#get.MissionOrgUnitId#'	   							   
				ORDER BY MandateNo DESC
			</cfquery>
			
			<cfquery name="customer"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  *
				FROM    Customer
				WHERE   CustomerId = '#customerid#'
			</cfquery>	
			
			<cfquery name="getLines"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   CustomerRequestLine
				WHERE  RequestNo = '#url.requestNo#'				
				AND    TransactionQuantity <> 0
				ORDER BY Created ASC
			</cfquery>	
									
			<cfset tot = "0">
						
			<cfset currency = getLines.SalesCurrency>
			
			<cfloop query="getLines">		   
				<cfset tot = tot + SalesTotal>
			</cfloop>
									
			<!--- better to adjust this to have also the requestNo --->
			
			<cfquery name="getSettle"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  *
				FROM    Settle#warehouse#
				WHERE   RequestNo = '#requestNo#'				
				AND     ABS(SettleAmount) >= '0.01'
				AND     SettleCode IN (SELECT Code FROM Materials.dbo.Ref_Settlement)	 	 		
			</cfquery>	
			
			<cfset settle = "0">
			
			<cfloop query="getSettle">
				
				<cfif Currency neq SettleCurrency>
													
					    <!--- convert to the invoice currency --->
						
						<cf_exchangeRate 
						CurrencyFrom = "#SettleCurrency#" 
				        CurrencyTo   = "#Currency#">										
						
						<cfset settle = settle + SettleAmount*exc>	
				
				<cfelse>
				
						<cfset settle = settle + SettleAmount>
							
				</cfif>		
			
			</cfloop>
			
			<cfif settle lt "0">  <!--- tot --->			
			
			    <!--- ------------------------------------------------------------------------------ --->
				<!--- can not be posted yet as we have missing amounts to be settled : to be defined --->
				<!--- ------------------------------------------------------------------------------ --->
			
			<cfelse>
					
				<cfquery name="getMission" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   SELECT   *
				   FROM     Warehouse
				   WHERE    Warehouse = '#warehouse#' 
				</cfquery>
				
				<cfquery name="getTransaction" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   SELECT   *
				   FROM     WarehouseTransaction
				   WHERE    Warehouse = '#warehouse#' 
				   AND      TransactionType = '2'
				</cfquery>
				
				<cfif getTransaction.ClearanceMode eq "2" and getTransaction.Operational eq "1">				 
					 <cfset act = "0">						
				<cfelse>				
					<cfset act = "1">				
				</cfif>
				
				<cfset mission = getmission.mission>
								
				<cftransaction>
				
				<cf_assignid>
				<cfset setbatchid = rowguid>
				
				<!--- provision to correct 
										
				<cfif newbatch eq "1">
				
				--->
								
					<cfquery name="Insert" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO WarehouseBatch
							    (Mission,
								 Warehouse, 							
								 BatchWarehouse, 	
							 	 BatchNo,	
								 BatchClass,						
								 <cfif vParentBatchNo neq "">ParentBatchNo,</cfif>
								 BatchId,
								 BatchDescription,	
								 BatchMemo,	
								 CustomerId,	
								 CustomerIdInvoice,			
								 AddressId,
								 TransactionDate,
								 TransactionType, 								 
								 ActionStatus,
								 <cfif act eq "1">
									 ActionOfficerUserId,
									 ActionOfficerLastName,
									 ActionOfficerFirstName,
									 ActionOfficerDate,
								 </cfif>
								 OfficerUserId, 
								 OfficerLastName, 
								 OfficerFirstName)
						VALUES ('#Mission#',
						        '#warehouse#',		
								'#warehouse#',											
					    	    '#batchNo#',
								'WhsSale',
								<cfif vParentBatchNo neq "">'#vParentBatchNo#',</cfif>
								'#setbatchid#',
								'Point of Sale',	
								'#Memo#',
								'#customerid#',		
								'#customeridinvoice#',
								'#AddressId#',		
								#TraDate#,
								'2',
								'#act#',
								 <cfif act eq "1">
									'#SESSION.acc#',
									'#SESSION.last#',
									'#SESSION.first#',
									getDate(),
								</cfif>
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#')
					</cfquery>						
					
					<!---

				<cfelse>
				
					<cfquery name="set" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						UPDATE WarehouseBatch
						SET    BatchDescription  = 'Point of Sale', 
						       BatchId           = '#setbatchid#',
							   CustomerId        = '#customerid#',	
							   CustomerIdInvoice = '#customeridinvoice#',
							   AddressId 		 = '#AddressId#'
						WHERE  BatchNo = '#batchno#'	
					 </cfquery>		
					 
					 <cfquery name="recordactor" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO WarehouseBatchActor
							(BatchNo, Role, ActorLastName, ActorFirstName, OfficerUserId, OfficerLastName, OfficerFirstName, Created)
							VALUES
								('#BatchNo#',
								'Sales Officer',
								'#session.last#',
								'#session.first#',
								'#session.acc#',
								'#session.last#',
								'#session.first#',
								getDate())
					 </cfquery>		
					 			
				</cfif>		
				
				--->					
			
				<!--- ------------ --->
				<!--- POSTING COGS --->
				<!--- ------------ --->
				
				<!--- post posting starts for stock portion under the same batch which includes COGS / Sales --->
				
				<cfset BatchNoRevert = "">
														
				<cfloop query="getLines">
				
				    	<!--- COGS booking --->
						
						<cfquery name="GetSale" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_CategoryGledger
							WHERE    Category = '#ItemCategory#'
							AND      Area = 'Sales'
							AND      GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
						</cfquery>									
							
						<cfquery name="GetDebit" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_CategoryGledger
							WHERE    Category = '#ItemCategory#'
							AND      Area = 'COGS'
							AND      GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
						</cfquery>
						
						<cfif getDebit.recordcount eq "0">
						
							<cf_message message = "Debit account has not been recorded. Operation not allowed." return = "no">
							<cfabort>
						
						</cfif>
												
						<cfquery name="GetCredit" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_CategoryGledger
							WHERE    Category = '#ItemCategory#' 
							AND      Area     = 'STOCK'
							AND      GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
						</cfquery>
						
						<cfif getCredit.recordcount eq "0">
						
							<cf_message message = "Credit account has not been recorded. Operation not allowed." return = "no">
							<cfabort>
						
						</cfif>
								
						<cf_assignId>
						
						<cfif transactionQuantity lt 0>
						    <!--- receipt  --->
							<cfset tra = abs(transactionQuantity)>
						<cfelse>
						    <!--- issuance --->
							<cfset tra = transactionQuantity*-1>
						</cfif>
						
						<!--- we check if for this UoM a base UoM for standard sale is defined which means
						we convert the requested into the UoM of the defined default UoM for this item for stock
						deduction purposes  --->
						
						<cfquery name="GetSaleUoM" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     ItemUoMMission M INNER JOIN ItemUoM U ON U.ItemNo = M.ItemNo AND U.UoM = M.UoM
							WHERE    M.ItemNo  = '#ItemNo#'
							AND      M.UoM     = '#TransactionUoM#'
							AND      Mission   = '#Mission#'						
						</cfquery>
						
						<cfquery name="itemLocation" 
					       datasource="AppsMaterials" 
					       username="#SESSION.login#" 
					       password="#SESSION.dbpw#">
					         SELECT    Location
					         FROM      ItemWarehouseLocation
							 WHERE     ItemNo      = '#Itemno#'		
							 AND       UoM         = '#TransactionUoM#'
							 AND       Warehouse   = '#Warehouse#'
							 AND       Location   != '#getMission.LocationReceipt#'
							 AND       Operational = 1 				 
							 ORDER BY  PickingOrder <!--- sorts locations by required order --->								 
						</cfquery>

						<cfif tra gt "0" or itemLocation.recordcount eq "0">  <!--- negative, not found in any location except the default --->
						
							<cfif GetSaleUoM.recordCount gt 0 and GetSaleUoM.TransactionUoM neq "">
						
								<cfset tra    =  tra * GetSaleUoM.UoMMultiplier>
								<cfset trauom =  GetSaleUoM.TransactionUoM>
							
							<cfelse>
						
								<!--- <cfset tra    = tra * GetSaleUoM.UoMMultiplier> --->
								<cfset trauom =  TransactionUoM>	
						
							</cfif>
						
							<!--- -------------------------------------------------------- --->						
							<!--- make the COGS and create ItemTransactionShipping records --->
							<!--- -------------------------------------------------------- --->		
							
							<cf_StockTransact 
							    DataSource            = "AppsMaterials" 
								TransactionClass      = "COGS"
								TransactionId         = "#TransactionId#"            <!--- ATTENTION IF EXISTS we do not create it again 20/7/2015  --->	
							    TransactionType       = "#TransactionType#"
								CustomerId            = "#CustomerId#"
								TransactionSource     = "WarehouseSeries"						
								ItemNo                = "#ItemNo#" 
								Mission               = "#Mission#" 
								Warehouse             = "#Warehouse#" 
								TransactionLot        = "#TransactionLot#"
								Location              = "#get.LocationReceipt#"   	
								TransactionCurrency   = "#APPLICATION.BaseCurrency#"  <!--- stock transaction are always in base currency --->		
								TransactionCategory   = "Inventory"		
								TransactionQuantity   = "#tra#"
								TransactionUoM        = "#trauom#"					
								TransactionLocalTime  = "Yes"
								ActionStatus          = "#act#"
								TransactionReference  = "#TransactionReference#"
								TransactionDate       = "#dateformat(TraDate,CLIENT.DateFormatShow)#" <!--- attention we take the header here instead --->
								TransactionTime       = "#timeformat(TraDate,'HH:MM')#"               <!--- this can be overwritten in the interface --->
								TransactionTimeZone   = "No"
								TransactionBatchNo    = "#batchno#"		
								PersonNo              = "#PersonNo#"														
								SalesPersonNo         = "#SalesPersonNo#"
								SalesCurrency         = "#salesCurrency#"	
								PriceSchedule         = "#PriceSchedule#"		
								SchedulePrice         = "#SchedulePrice#"	
								SalesUoM              = "#TransactionUoM#"       <!--- as recorded in the sale POS --->	 
								SalesQuantity         = "#transactionQuantity#"  <!--- as recorded in the sale POS --->								
								SalesPrice            = "#SalesPrice#"
								TaxCode               = "#taxCode#"
								TaxPercentage         = "#taxPercentage#"
								TaxExemption          = "#taxExemption#"
								TaxIncluded           = "#taxIncluded#" 
								SalesAmount           = "#SalesAmount#"
								SalesTax              = "#SalesTax#"
								SalesTotal            = "#SalesTotal#"				
								
								Ledger                = "Yes"							
								GLCurrency            = "#currency#"
								GLTransactionNo       = "#batchNo#"
								GLTransactionSourceId = "#setbatchid#"
																
								ProgramCode           = "#ProgramCode#"						
								GLAccountDebit        = "#getDebit.GLAccount#"
								GLAccountCredit       = "#getCredit.GLAccount#">
								
								<cfset PostBeneficiary(Warehouse,CustomerId,TransactionId,getmission.Beneficiary)>
																
						<cfelse>		
						
							<!--- make it positive to be taken from the location --->
							
							<cfset tra = tra*-1>	
																					
							<cfif GetSaleUoM.recordCount gt 0 and GetSaleUoM.TransactionUoM neq "">
						
								<cfset tra    =  tra * GetSaleUoM.UoMMultiplier>
								<cfset trauom =  GetSaleUoM.TransactionUoM>
							
						    <cfelse>
																	
								<cfset trauom =  TransactionUoM>	
						
							</cfif>									
							
							<cfquery name="myLocation" 
						       datasource="AppsMaterials" 
						       username="#SESSION.login#" 
						       password="#SESSION.dbpw#">
						         SELECT    Location
						         FROM      ItemWarehouseLocation
								 WHERE     ItemNo    = '#Itemno#'		
								 AND       UoM       = '#traUoM#'
								 AND       Warehouse = '#Warehouse#'
								 AND       Operational = 1 				 
								 ORDER BY  PickingOrder <!--- sorts locations by required order --->								 
						    </cfquery>		

							<cfset vtotal_locqty = 0>	
							<cfset total = tra>		
							
							<!--- reserved is on the item/warehouse level --->
							
							<cfinvoke component = "Service.Process.Materials.Stock"  
								   method           = "getStock" 
								   warehouse        = "#warehouse#" 								   						  
								   ItemNo           = "#itemno#"
								   UoM              = "#trauom#"							  
								   returnvariable   = "stock">		
								   
							<cfif stock.reserved neq "">
								<cfset reserved = stock.reserved>
							<cfelse>
								<cfset reserved = "0">	
							</cfif>	
																			
							<cfloop index="loc" list="#valueList(myLocation.Location)#">	
							
								<!--- stock is on the item/warehouse/location level --->
								
								<cfinvoke component = "Service.Process.Materials.Stock"  
								   method           = "getStock" 
								   warehouse        = "#warehouse#" 
								   location         = "#loc#"							  
								   ItemNo           = "#itemno#"
								   UoM              = "#trauom#"							  
								   returnvariable   = "stock">		
								   
								<cfset stockavail = stock.onhand>
								
								<!--- we deduct the reservation from the stock first and then the remained is available --->
								
								<cfif stockavail gt reserved>
									<cfset stockavail = stockavail - reserved>
									<cfset reserved = 0>
								<cfelse>
									<cfset stockavail = 0>	
									<cfset reserved = reserved - stockavail>
								</cfif>
								  								 								  
								<cfif stockavail gt tra>								  
								  	<cfset locqty = tra>
									<cfset tra    = 0>									
								<cfelse>								  
								  	<cfset locqty = stockavail>
									<cfset tra    = tra - stockavail>								  								  
								</cfif>									  				  
								  
								<cfif GetSaleUoM.recordCount gt 0 and GetSaleUoM.TransactionUoM neq "">
									  <cfset salequantity = locqty / GetSaleUoM.UoMMultiplier>
								<cfelse>
								  	  <cfset salequantity = locqty>	  
								</cfif>		
								  															  
								<cfif locqty gt "0">
								  	
								  	<cfset vtotal_locqty = vtotal_locqty + locqty>
								 								 								  								
									<!--- -------------------------------------------------------- --->						
									<!--- make the COGS and create ItemTransactionShipping records --->
									<!--- -------------------------------------------------------- --->											
																		
									<cfset ratio = 	locqty/total>		
									<cfset locqty = locqty*-1> <!--- express as negative --->		
																						
									<cf_StockTransact 
									    DataSource            = "AppsMaterials" 
										TransactionClass      = "COGS"											
									    TransactionType       = "#TransactionType#"
										CustomerId            = "#CustomerId#"
										TransactionSource     = "WarehouseSeries"						
										ItemNo                = "#ItemNo#" 
										Mission               = "#Mission#" 
										Warehouse             = "#Warehouse#" 
										TransactionLot        = "#TransactionLot#"
										Location              = "#loc#"   	
										TransactionCurrency   = "#APPLICATION.BaseCurrency#"  <!--- stock transaction are always in base currency --->		
										TransactionCategory   = "Inventory"		
										TransactionQuantity   = "#locqty#"
										TransactionUoM        = "#trauom#"															
										ActionStatus          = "#act#"
										TransactionReference  = "#TransactionReference#"
										TransactionLocalTime  = "Yes"
										TransactionDate       = "#dateformat(TraDate,CLIENT.DateFormatShow)#" <!--- attention we take the header here instead --->
										TransactionTime       = "#timeformat(TraDate,'HH:MM')#"               <!--- this can be overwritten in the interface --->
										TransactionTimeZone   = "No"										
										TransactionBatchNo    = "#batchno#"		
										PersonNo              = "#PersonNo#"														
										SalesPersonNo         = "#SalesPersonNo#"
										SalesCurrency         = "#salesCurrency#"	
										PriceSchedule         = "#PriceSchedule#"	
										SchedulePrice         = "#SchedulePrice#"	
										SalesUoM              = "#TransactionUoM#"
										SalesQuantity         = "#salequantity#"
										SalesPrice            = "#SalesPrice#"
										TaxCode               = "#taxCode#"
										TaxPercentage         = "#taxPercentage#"
										TaxExemption          = "#taxExemption#"
										TaxIncluded           = "#taxIncluded#" 
										SalesAmount           = "#SalesAmount*ratio#"
										SalesTax              = "#SalesTax*ratio#"
										SalesTotal            = "#SalesTotal*ratio#"				
										
										Ledger                = "Yes"							
										GLCurrency            = "#currency#"
										GLTransactionNo       = "#batchNo#"
										GLTransactionSourceId = "#setbatchid#"
																		
										ProgramCode           = "#ProgramCode#"						
										GLAccountDebit        = "#getDebit.GLAccount#"
										GLAccountCredit       = "#getCredit.GLAccount#">
										
										<cfset PostBeneficiary(Warehouse,CustomerId,TransactionId,getmission.Beneficiary)>
										
									</cfif>	
										
								</cfloop>	
								
								<cfif vtotal_locqty eq 0>
									<!--- Finishing without posting any transaction for this line--->
									<cf_message message = "Stock was not available in any location for item : #ItemNo# (#trauom#)"
					  				return = "no">
					  				<cfabort>
									
								</cfif>			
																																
								<cfif vtotal_locqty lt total>
									<!--- Finishing without posting any transaction for this line--->
									<cf_message message = "Stock was not completely available for item : #ItemNo# (#trauom#)"
					  				return = "no">
					  				<cfabort>
									
								</cfif>								 	
								
							</cfif>							
							
				</cfloop>	
								
				<!--- ----------------------------- --->
				<!--- POSTING SALE and RECEIVABLE-- --->
				<!--- ----------------------------- --->
							
				<cfquery name="Journal" 
				    datasource="AppsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					SELECT    *
					FROM      Materials.dbo.WarehouseJournal
					WHERE     Warehouse     = '#Warehouse#' 
					AND       Area          = 'SALE'
					AND       Currency      = '#Currency#'  
				</cfquery>	
				
				<!--- get default journal --->
			
				<cfif Journal.recordcount eq "0">
			 	
					<cf_message message = "A facility RECEIVABLE journal for currency: #Currency# was not defined. Operation not allowed."
					  return = "no">
					  <cfabort>
						
				</cfif>	 
				
				<cfquery name="getJournal" 
				    datasource="AppsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					SELECT    TOP 1 *
					FROM      Accounting.dbo.JournalAccount
					WHERE     Journal = '#Journal.Journal#' 	
					ORDER BY  ListDefault DESC	
				</cfquery>	
				
				<cfif getJournal.GLAccount eq "">
			 	
					<cf_message message = "A RECEIVABLE contra-account was not defined for this journal. Operation not allowed."
					  return = "no">
					  <cfabort>
						
				</cfif>	 
				
				<cfset OrgUnitOwner = "0">
			
				 <cfquery name="Parameter" 
				    datasource="AppsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					    SELECT    *
					    FROM      Accounting.dbo.Ref_ParameterMission
						WHERE     Mission = '#get.Mission#'
				 </cfquery> 
				  
				  <!--- this entity posts by parent  --->
				
				  <cfif Parameter.AdministrationLevel eq "Parent">
				  
			          <!--- determine the owner --->
															
					  <cfquery name="getOwner" 
					    datasource="AppsMaterials" 
					    username="#SESSION.login#" 
				    	password="#SESSION.dbpw#">
							SELECT    TOP 1 OrgUnit
							FROM      Organization.dbo.Organization O
							WHERE     Mission = '#get.mission#'
							AND       OrgUnitCode IN
				                          (SELECT     TOP 1 HierarchyRootUnit
				                            FROM      Organization.dbo.Organization
											WHERE     Mission          = O.Mission							
				                            AND       MissionOrgUnitId = '#get.MissionOrgUnitId#'
				                            ORDER BY Created DESC)
							ORDER BY  Created DESC					
						</cfquery>
					
						<cfif getOwner.recordcount eq "1">						
							<cfset OrgUnitOwner = getOwner.OrgUnit>						 
						</cfif>					
												
				</cfif>
				
				<cfset receivable = getJournal.GLAccount>
				
				<cfset tot = round(tot*1000)/1000>
				
				<!--- document date reflects when the action was done, transaction 
				date is when the transaction become financially effective : posted --->
				
				<cfif Memo neq "">
				    <cfset mem = memo>
				<cfelse>
					<cfset mem = "Sale #Customer.CustomerName#">
				</cfif>
				
				<CF_DateConvert Value="#dateformat(TraDate,CLIENT.DateFormatShow)#">
				<cfset dte = dateValue>
								
				<cfif month(dte) gte "10">
					<cfset TransactionPeriod = "#year(dte)##month(dte)#">
				<cfelse>
					<cfset TransactionPeriod = "#year(dte)#0#month(dte)#">
				</cfif>		
				
				<cfquery name="getStoreUnit" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				
						SELECT   OrgUnit 
						FROM     Organization.dbo.Organization
						WHERE    MissionOrgUnitId IN (SELECT MissionOrgUnitId 
						                              FROM   Warehouse 
													  WHERE  Warehouse = '#warehouse#')
						AND      DateEffective <= '#dateformat(TraDate,CLIENT.DateSQL)#'  
						ORDER BY DateEffective
				</cfquery>		
				
				<!--- ReferenceOrgUnit      = "#Customer.OrgUnit#"	removed as we have already the id, instead the warehouse --->
						
				<cf_GledgerEntryHeader
					    DataSource            = "AppsMaterials"
						Mission               = "#get.mission#"
						OrgUnitOwner          = "#OrgUnitOwner#"
						OrgUnitSource         = "#getStoreUnit.OrgUnit#"
						OrgUnitTax            = "#getTerminal.TaxOrgUnitEDI#"
						Journal               = "#getJournal.Journal#" 
						Description           = "#mem#"
						DocumentDate          = "#dateformat(TraDate,CLIENT.DateFormatShow)#"	
						TransactionPeriod     = "#transactionperiod#"
						TransactionSource     = "SalesSeries"
						TransactionSourceId   = "#setbatchid#"					
						TransactionCategory   = "Receivables"
						JournalTransactionNo  = "#batchno#"
						MatchingRequired      = "1"
						ActionStatus          = "1"
						workflow              = "#workflow#"
						Reference             = "Receivables"   
						ReferenceOrgUnit      = "#Customer.OrgUnit#"    
						ReferenceName         = "#Customer.CustomerName#"
						ReferenceId           = "#CustomerId#"
						ReferenceNo           = ""						
						ReferencePersonNo     = "#getLines.SalesPersonNo#"
						DocumentCurrency      = "#Currency#"					
						DocumentAmount        = "#tot#"
						ActionBefore          = "#dateformat(TraDate,CLIENT.DateFormatShow)#"	
						AmountOutstanding     = "#tot#">	
						
						<!--- contra account for receivables --->
						<cfset Receivable_Journal    = "#getJournal.Journal#">
						<cfset Receivable_JournalNo  = "#JournalTransactionNo#">
															
						<cf_GledgerEntryLine
						    DataSource            = "AppsMaterials"
							Lines                 = "1"
							Journal               = "#getJournal.Journal#"
							JournalNo             = "#JournalTransactionNo#"
							TransactionDate       = "#dateformat(TraDate,CLIENT.DateFormatShow)#" 
							TransactionPeriod     = "#transactionperiod#"    
							JournalTransactionNo  = "#batchno#"							
							Currency              = "#Currency#"
							LogTransaction		  = "Yes"												
								
							TransactionSerialNo1  = "0"
							Class1                = "Debit"
							Reference1            = "Sales Receivable"      							
							ReferenceName1        = "#Customer.CustomerName#"
							Description1          = "Sale"
							GLAccount1            = "#receivable#"
							Costcenter1           = "#Org.OrgUnit#"						
							ReferenceId1          = "#Customerid#"						
							TransactionType1      = "Contra-account"
							Amount1               = "#tot#">		
									
							<cfset ln = "0">							
									
						<cfloop query="getLines">						
											
							<!--- COGS booking --->
					
							<cfquery name="GetSale" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT   *
								FROM     Ref_CategoryGledger S
								WHERE    Category = '#ItemCategory#'
								AND      Area     = 'Sales'
								AND      GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account WHERE GLAccount = S.GLAccount)
							</cfquery>			
							
							<cfif GetSale.recordcount eq "0">
		 	
								<cf_message message = "A sales accounts was not defined for category : #ItemCategory#">
								  <cfabort>
					
							</cfif>	 								
															
							<cfquery name="Tax" 
						    datasource="AppsMaterials" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
							    SELECT    *
							    FROM      Accounting.dbo.Ref_Tax
								WHERE     TaxCode = '#TaxCode#'
							</cfquery> 									

							<cfparam name="Attributes.TransactionPeriod"        default="#TransactionPeriod#">															
					
							<cf_GledgerEntryLine
							    DataSource            = "AppsMaterials"
								Lines                 = "2"
								TransactionDate       = "#dateformat(TraDate,CLIENT.DateFormatShow)#"		
								TransactionPeriod     = "#transactionperiod#" 								
								Journal               = "#getJournal.Journal#"
								JournalNo             = "#JournalTransactionNo#"
								JournalTransactionNo  = "#batchno#"							
								Currency              = "#currency#"
								LogTransaction		  = "Yes"												
									
								TransactionSerialNo1  = "#ln+1#"
								Class1                = "Credit"
								Reference1            = "Sales Income"   									
								ReferenceName1        = "#left(Itemdescription,100)#"
								Description1          = "Sale"
								GLAccount1            = "#getSale.GLAccount#"
								Costcenter1           = "#Org.OrgUnit#"
								ReferenceNo1          = "#ItemNo#"		
								ReferenceQuantity1    = "#TransactionQuantity#"						
								TransactionType1      = "Standard"
								TransactionTaxCode1    = "#TaxCode#"
								Amount1               = "#SalesAmount#"	
								
								TransactionSerialNo2  = "#ln+1#"
								Class2                = "Credit"
								Reference2            = "Sales Tax"  									  
								ReferenceName2        = "#left(Itemdescription,100)#"
								Description2          = "Sale"
								GLAccount2            = "#Tax.GLAccountReceived#"
								Costcenter2           = "#Org.OrgUnit#"
								ReferenceNo2          = "#ItemNo#"		
								ReferenceQuantity2    = "#TransactionQuantity#"							
								TransactionType2      = "Standard"
								TransactionTaxCode2   = "#TaxCode#"
								Amount2               = "#SalesTax#">																		
			
							<cfset ln = ln+1>
							
						</cfloop>	
							
				<cfquery name="setJournal" 
		    	datasource="AppsMaterials" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
					UPDATE   Materials.dbo.ItemTransactionShipping
					SET      Journal         = '#getJournal.Journal#', 
					         JournalSerialNo = '#JournalTransactionNo#'
					WHERE    TransactionId IN (SELECT  TransactionId
			              				       FROM    Materials.dbo.ItemTransaction
		    			                       WHERE   TransactionBatchNo = '#batchno#')
				</cfquery>		
											
				<cfset parentJournal          = getJournal.Journal>
				<cfset parentJournalSerialNo  = JournalTransactionNo>
				
				<cfif settlement eq "1">
							
					<!--- --------------------- --->
					<!--- POSTING SETTLEMENT--- --->
					<!--- --------------------- --->	
					
					<!--- we take a journal of which the currency is the same as the sale --->
					
					<cfquery name="Journal" 
					    datasource="AppsMaterials" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						SELECT    *
						FROM      Materials.dbo.WarehouseJournal
						WHERE     Warehouse     = '#Warehouse#' 
						AND       Area          = 'SETTLE'
						AND       Currency      = '#Currency#'  
					</cfquery>	
					
					<!--- get default journal --->
				
					<cfif Journal.recordcount eq "0">
				 	
						<cf_message message = "A Facility settlement journal for currency: #Currency# was not defined. Operation not allowed."
						  return = "back">
						  <cfabort>
							
					</cfif>	 
		
 					<cfquery name="getJournal" 
					    datasource="AppsMaterials" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						SELECT    *
						FROM      Accounting.dbo.JournalAccount
						WHERE     Journal = '#Journal.Journal#'
						AND		  Mode = 'Contra'
						ORDER BY  ListDefault DESC
						 		
					</cfquery> 
					
					<cfif getJournal.GLAccount eq "">
				 	
						<cf_message message = "A receipt journal was not defined. Operation not allowed."
						  return = "back">
						  <cfabort>
							
					</cfif>	 	
		
					<cfset sett_tot = 0>
					
					<cfloop query="getSettle">
					
						<!--- update WarehouseBatchSettlment --->					
							<cfquery name="Add"
	                          datasource="AppsMaterials"
	                          username="#SESSION.login#"
	                          password="#SESSION.dbpw#">
	                                INSERT INTO Materials.dbo.WarehouseBatchSettlement
	                                     (BatchNo,
	                                     SettleSerialNo,
	                                     SettleCode,
	                                     SettleCurrency,
	                                     SettleAmount,
	                                     BankName,
	                                     PromotionCardNo,
	                                     CreditCardNo,
	                                     ExpirationMonth,
	                                     ExpirationYear,
	                                     ApprovalCode,
	                                     ApprovalReference,
	                                     OfficerUserId,
	                                     OfficerLastName,
	                                     OfficerFirstName)
	                                     VALUES
	                                    ('#batchno#',
	                                    '#currentrow#',
	                                    '#settlecode#',
	                                    '#settlecurrency#',
	                                    '#settleamount#',
	                                    '#BankName#',
	                                    '#PromotionCardNo#',
	                                    '#CreditCardNo#',
	                                    '#ExpirationMonth#',
	                                    '#ExpirationYear#',
	                                    '#ApprovalCode#',
	                                    '#ApprovalReference#',
	                                    '#SESSION.acc#',
	                                    '#SESSION.last#',
	                                    '#SESSION.first#')                 
	                     </cfquery>  					
						
						<!--- posting --->
					
						<cfquery name="getAccount" 
						    datasource="AppsMaterials" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
							SELECT    *
							FROM      Ref_SettlementMission M
							WHERE     Mission = '#get.mission#' 		
							AND       Code   = '#settlecode#'
							AND       GLAccount IN (SELECT GLAccount 
							                        FROM   Accounting.dbo.Ref_Account 
													WHERE  GLAccount = M.GLAccount)
							AND       GLAccount != ''						
						</cfquery>	
					
						<cfif getAccount.recordcount eq "0">
						
						    <!--- the amount is not settled and will remain open --->
							
						    <!---
							<cf_message message = "A settlement account code for #settlecode# was not defined. Operation not allowed."
						     return = "back">
						     <cfabort>
							 --->
								
						<cfelse>
						
							<cfquery name="getStoreUnit" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">				
									SELECT   OrgUnit 
									FROM     Organization.dbo.Organization
									WHERE    MissionOrgUnitId IN (SELECT MissionOrgUnitId 
									                              FROM   Warehouse 
																  WHERE  Warehouse = '#warehouse#')
									AND      DateEffective <= '#dateformat(TraDate,CLIENT.DateSQL)#'  
									ORDER BY DateEffective
							</cfquery>
						
							<cf_GledgerEntryHeader
							    DataSource            = "AppsMaterials"
								Mission               = "#get.mission#"
								OrgUnitOwner          = "#OrgUnitOwner#"
								OrgUnitSource         = "#getStoreUnit.OrgUnit#"
								Journal               = "#getJournal.Journal#" 
								Description           = "Tender from #Customer.CustomerName#"
								DocumentDate       	  = "#dateformat(TraDate,CLIENT.DateFormatShow)#"	
								TransactionDate       = "#dateformat(TraDate,CLIENT.DateFormatShow)#"	
								TransactionPeriod     = "#transactionperiod#"    
								TransactionSource     = "SalesSeries"
								TransactionSourceId   = "#setbatchid#"					
								TransactionCategory   = "Receipt"
								JournalTransactionNo  = "#batchno#"
								MatchingRequired      = "0"
								ActionStatus          = "1"
								Reference             = "Settlement"       
								ReferenceOrgUnit      = "#getStoreUnit.OrgUnit#"
								ReferenceName         = "#Customer.CustomerName#"
								ReferenceId           = "#CustomerId#"
								ReferenceNo           = ""
								DocumentCurrency      = "#SettleCurrency#"					
								DocumentAmount        = "#SettleAmount#"
								AmountOutstanding     = "0">											
							
								<cfset sett_tot = sett_tot + SettleAmount>
								
								<!--- contra account for receivables --->
											
								<cf_GledgerEntryLine
								    DataSource            = "AppsMaterials"
									Lines                 = "2"
									Journal               = "#getJournal.Journal#"
									JournalNo             = "#JournalTransactionNo#"
									JournalTransactionNo  = "#batchno#"			
									DocumentDate       	  = "#dateformat(TraDate,CLIENT.DateFormatShow)#"	
									TransactionDate       = "#dateformat(TraDate,CLIENT.DateFormatShow)#"	
									TransactionPeriod     = "#transactionperiod#" 
									ParentJournal         = "#parentJournal#"
									ParentJournalSerialNo =	"#parentJournalSerialNo#"			
									Currency              = "#SettleCurrency#"
									LogTransaction		  = "Yes"		
														
									TransactionSerialNo1  = "0"
									Class1                = "Credit"
									   
									Reference1            = "Off-set Receivable"       
									ReferenceName1        = "#Customer.CustomerName#"
									Description1          = "Receipt"
									GLAccount1            = "#receivable#"									
									ReferenceId1          = "#customerid#"						
									TransactionType1      = "Contra-account"
									Amount1               = "#SettleAmount#"
									
									TransactionSerialNo2  = "1"
									Class2                = "Debit"									 
									Reference2            = "Receipt on Receivable"       
									ReferenceName2        = "#Customer.CustomerName#"
									ReferenceNo2		  = "#SettleCode#"
									Description2          = "Receipt"
									GLAccount2            = "#getAccount.GLAccount#"									
									ReferenceId2          = "#customerid#"						
									TransactionType2      = "Standard"
									Amount2               = "#SettleAmount#">			
								
						    </cfif>
									
					</cfloop>	
					
					<!--- Hanno better to use the component we have to correct this, but it can work here --->			
		
					<cfquery name="qUpdateOutstanding"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE Accounting.dbo.TransactionHeader
						SET    AmountOutstanding = Round('#tot-sett_tot#',2) 
						WHERE  Journal           = '#Receivable_Journal#'
						AND    JournalSerialNo   = '#Receivable_JournalNo#'
					</cfquery>		
									
					<!--- 2/8/2014 send the receipt mail 
					
					<cfif mail eq "Yes">					
						<cf_receiptStandard batchId="#setbatchid#">					
					</cfif>
					
					--->
										
				</cfif>			
								
				<cfif cleanup eq "Yes">
				
					<cfquery name="cleanSale"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE CustomerRequest
						SET    BatchNo      = '#batchno#', 
						       ActionStatus = '1'
						WHERE  RequestNo    = '#RequestNo#'	 	 					 					
					</cfquery>	
					
					<cfquery name="cleanSettle"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						DELETE FROM  UserTransaction.dbo.Settle#warehouse#
						WHERE  RequestNo = '#RequestNo#'	 	 					 						
					</cfquery>					
				
				</cfif>					
						
				</cftransaction>
				
			</cfif>
					
			<cfreturn setbatchid>		
			 
	</cffunction>	
		
	<cffunction name="repostFromIssuance"
             access="public"
             returntype="any"
             displayname="Reposts a sale transaction from adjusted COGS transactions">			 	
			 
			 <cfargument name="BatchId" type="string" required="true" default="">
			 
			 <cfquery name="get"
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 	SELECT  *
				FROM    WarehouseBatch
				WHERE   BatchId = '#batchid#'				
			 </cfquery> 	
			 
			 <cfquery name="customer"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  *
				FROM    Customer
				WHERE   CustomerId = '#get.customerid#'
			</cfquery>	
			 
			 <!--- the purpose is to update a sale which was already booked but with the wrong quantities, it is an operational
			 correction. cancel the sale in transactionheader as well as the related transactions based on the parent (settlement) 
			   and create a new sale transaction with the SAME POS reference, which is done after 
			  the sale is adjusted at a later stage for the quantities that were issued COGS transactions. 
			  
			  <cftransaction>
			  obtain the COGS transactions + shipping 
				  edit transactionheader: documentamount, amount and process the amountoutstanding
				  remove transaction lines and 
				  add transaction lines 
			  </cftransaction>
			  --->
								  
			  <!--- remove lines and add lines --->
			  
			  <cfquery name="getHeader"
				 datasource="AppsMaterials" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">			  
				  SELECT       *	
				  FROM         Accounting.dbo.TransactionHeader
				  WHERE        TransactionSourceId = '#BatchId#' 
				  AND          TransactionCategory = 'Receivables'
			  </cfquery>
			  
			  <cfquery name="getLines"
			 	datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
						  
				  SELECT     T.TransactionBatchNo, 
							 T.TransactionDate, 
							 T.ItemCategory,
							 T.ItemNo, 
				             T.ItemDescription, 
				             ITS.SalesCurrency, 
							 ITS.TaxCode,
							 ITS.SalesQuantity,
							 ROUND(ITS.SalesAmount, 2)     AS SalesAmount, 
							 ROUND(ITS.SalesTax, 2)        AS SalesTax, 
	                         ROUND(ITS.SalesTotal, 2)      AS SalesTotal, 
							 ROUND(T.TransactionValue, 3)  AS Value 
							
				  FROM       ItemTransaction AS T INNER JOIN ItemTransactionShipping AS ITS ON T.TransactionId = ITS.TransactionId
				  WHERE      T.TransactionBatchNo = '#get.BatchNo#'
			  </cfquery>
			  
			  <cfquery name="getTotal"
			 	datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			  
				  SELECT     SUM(ROUND(ITS.SalesAmount, 2)) AS SalesAmount, 
							 SUM(ROUND(ITS.SalesTax, 2))    AS SalesTax, 
	                         SUM(ROUND(ITS.SalesTotal, 2))  AS SalesTotal, 
							 SUM(ROUND(IT.TransactionValue, 3)) AS Value 
							
				  FROM       ItemTransaction AS IT INNER JOIN
	                         ItemTransactionShipping AS ITS ON IT.TransactionId = ITS.TransactionId
							 
				  WHERE      IT.TransactionBatchNo = '#get.BatchNo#'
			  
			  </cfquery>
			  
			  <cfquery name="Warehouse" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  
				   SELECT *
				   FROM   Warehouse
				   WHERE  Warehouse = '#get.warehouse#'	   							   
				   
			  </cfquery>		
			
			  <cfquery name="Param" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  
				   SELECT  *   
				   FROM    Ref_ParameterMission
				   WHERE   Mission = '#warehouse.Mission#' 
				   
			  </cfquery>	
						 			
			  <!--- we need to updo posting to SAT and visa versa --->
			
			  <cfquery name="org" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				    SELECT   TOP 1 *
					FROM     Organization.dbo.Organization
					WHERE    MissionOrgUnitId = '#warehouse.MissionOrgUnitId#'	   							   
					ORDER BY MandateNo DESC
			  </cfquery>			  
			  
			  <cfquery name="getJournal" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					SELECT    TOP 1 *
					FROM      Accounting.dbo.JournalAccount
					WHERE     Journal = '#getHeader.Journal#' 	
					ORDER BY  ListDefault DESC	
			  </cfquery>	
				
			  <cfif getJournal.GLAccount eq "">
			 	
					<cf_message message = "A RECEIVABLE contra-account was not defined for this journal. Operation not allowed."
					  return = "no">
					<cfabort>
						
			  </cfif>	 		 
				
			  <cfset receivable = getJournal.GLAccount>			
			  
			  <cftransaction> 		
			  
			  <cfif getHeader.recordcount eq "1">
			  
					<!--- update header --->	
					
					<cfquery name="update"
					 datasource="AppsMaterials" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">			  
					  	  UPDATE Accounting.dbo.TransactionHeader
						  SET    DocumentAmount  = '#gettotal.salesTotal#',
						         Amount          = '#gettotal.salesTotal#'
						  WHERE  Journal         = '#getHeader.Journal#'
						  AND    JournalSerialNo = '#getHeader.JournalSerialNo#'				  
					</cfquery>					  
								
					<!--- record the action of amendment TransactionHeaderAction --->
					
					<cfquery name="check"
					 datasource="AppsMaterials" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">			  
					  	  SELECT *
						  FROM  Accounting.dbo.Ref_Action
						  WHERE Code = 'Repost'					  
					</cfquery>		
					
					<cfif check.recordcount eq "1">
					
						<cfquery name="TransactionAction" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">	
						
							INSERT INTO Accounting.dbo.TransactionHeaderAction (
									Journal,
									JournalSerialNo,							
									ActionCode,
									ActionMemo,
									ActionDate,
									OfficerUserId,
									OfficerLastName,
									OfficerFirstName)
							VALUES ('#getHeader.Journal#',
									'#getHeader.JournalSerialNo#',
									'#check.Code#',
									'Change AR from #numberformat(getHeader.DocumentAmount,',.__')# to #numberformat(gettotal.salesTotal,',.__')#',
									getDate(),
									'#SESSION.acc#',
									'#SESSION.last#',					
									'#SESSION.first#')
											
						</cfquery>
						
					</cfif>	
							
				  				  
				<!--- remove lines --->
				  
				<cfquery name="clear"
				 datasource="AppsMaterials" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">			  
				  	  DELETE FROM   Accounting.dbo.TransactionLine
					  WHERE  Journal         = '#getHeader.Journal#'
					  AND    JournalSerialNo = '#getHeader.JournalSerialNo#'				  
				</cfquery>				  
			  			  
			    <!--- contra account for receivables --->
			  													
				<cf_GledgerEntryLine
				    DataSource            = "AppsMaterials"
					Lines                 = "1"
					Journal               = "#getHeader.Journal#"
					JournalNo             = "#getHeader.JournalSerialNo#"
					TransactionDate       = "#dateformat(getHeader.TransactionDate,CLIENT.DateFormatShow)#" 
					TransactionPeriod     = "#getHeader.TransactionPeriod#"    
					JournalTransactionNo  = "#get.batchno#"							
					Currency              = "#getHeader.Currency#"
					LogTransaction		  = "Yes"												
						
					TransactionSerialNo1  = "0"
					Class1                = "Debit"
					Reference1            = "Sales Receivable"      							
					ReferenceName1        = "#Customer.CustomerName#"
					Description1          = "Sale"
					GLAccount1            = "#receivable#"
					Costcenter1           = "#Org.OrgUnit#"						
					ReferenceId1          = "#get.Customerid#"						
					TransactionType1      = "Contra-account"
					Amount1               = "#getTotal.SalesTotal#">		
									
					<cfset ln = "0">							
									
				<cfloop query="getLines">						
										
					<!--- COGS booking --->
			
					<cfquery name="GetSale" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     Ref_CategoryGledger S
						WHERE    Category = '#ItemCategory#'
						AND      Area     = 'Sales'
						AND      GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account WHERE GLAccount = S.GLAccount)
					</cfquery>			
					
					<cfif GetSale.recordcount eq "0">
 	
						<cf_message message = "A sales accounts was not defined for category : #ItemCategory#">
						  <cfabort>
			
					</cfif>	 								
													
					<cfquery name="Tax" 
				    datasource="AppsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					    SELECT    *
					    FROM      Accounting.dbo.Ref_Tax
						WHERE     TaxCode = '#TaxCode#'
					</cfquery> 	
													
					<cf_GledgerEntryLine
					    DataSource            = "AppsMaterials"
						Lines                 = "2"
						TransactionDate       = "#dateformat(getHeader.TransactionDate,CLIENT.DateFormatShow)#"		
						TransactionPeriod     = "#getHeader.TransactionPeriod#" 								
						Journal               = "#getHeader.Journal#"
						JournalNo             = "#getHeader.JournalSerialNo#"
						JournalTransactionNo  = "#get.batchno#"							
						Currency              = "#getHeader.currency#"
						LogTransaction		  = "Yes"												
							
						TransactionSerialNo1  = "#ln+1#"
						Class1                = "Credit"
						Reference1            = "Sales Income"   									
						ReferenceName1        = "#left(Itemdescription,100)#"
						Description1          = "Sale"
						GLAccount1            = "#getSale.GLAccount#"
						Costcenter1           = "#Org.OrgUnit#"
						ReferenceNo1          = "#ItemNo#"		
						ReferenceQuantity1    = "#SalesQuantity#"					
						TransactionType1      = "Standard"
						Amount1               = "#SalesAmount#"	
						
						TransactionSerialNo2  = "#ln+2#"
						Class2                = "Credit"
						Reference2            = "Sales Tax"  									  
						ReferenceName2        = "#left(Itemdescription,100)#"
						Description2          = "Sale"
						GLAccount2            = "#Tax.GLAccountReceived#"
						Costcenter2           = "#Org.OrgUnit#"
						ReferenceNo2          = "#ItemNo#"	
						ReferenceQuantity2    = "#SalesQuantity#"							
						TransactionType2      = "Standard"
						TransactionTaxCode    = "#TaxCode#"
						Amount2               = "#SalesTax#">																		
		
						<cfset ln = ln+2>
						
					</cfloop>												 			  
			  			  
				</cfif>
			
			</cftransaction> 			 			 
			 
	</cffunction>		 
	
	<cffunction name="initiateInvoice" access="public" returntype="struct" displayname="retrieve a transaction for processing">
			 			 
			<cfargument name="Warehouse"          type="string"  required="true"    default="">
			<cfargument name="BatchId"            type="string"  required="true"    default="">
			<cfargument name="Customerid"         type="GUID"    required="true"    default="">
			<cfargument name="CustomeridInvoice"  type="GUID"    required="true"    default="">
			<cfargument name="Currency"           type="string"  required="true"    default="">							
			<cfargument name="TransactionDate"    type="string"  required="true"    default="">	
			<cfargument name="Terminal"    		  type="string"  required="false"   default="">	
			<cfargument name="Mode"      		  type="string"  required="false"   default="1">
			
			<cfquery name="get"
			 datasource="AppsLedger" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 	SELECT  *
				FROM    TransactionHeader
				WHERE   TransactionSourceId = '#batchid#'
				AND     TransactionCategory = 'Receivables'				
			</cfquery> 		
												
			<cfquery name="getWarehouseJournal"
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 	SELECT  *
				FROM    WarehouseJournal
				WHERE   Warehouse = '#warehouse#'
				AND		Area      = 'SETTLE'
				AND		Currency  = '#currency#'
			</cfquery> 	
			
			 <!--- force manual or contextual manual through the interface selected button --->
			
			<cfif getWarehouseJournal.TransactionMode eq "1" or Mode eq "1">
					
				<cfset Invoice.Mode              = "1"> <!--- manual --->
				<cfset Invoice.ErrorDescription  = "">
				<cfset Invoice.ErrorDetail       = "">
				<cfset Invoice.Status            = "1">
				
				<cf_assignid>
														   
				<cfquery name="inherit"
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					
						INSERT INTO TransactionHeaderAction
							
								(Actionid,
								 Journal, 
								 JournalSerialNo,
								 ActionCode,
								 ActionMode,
								 ActionDate,
								 ActionStatus,
								 ActionReference1,											
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
							 
						VALUES   ('#rowguid#',
						         '#get.Journal#', 
							     '#get.JournalSerialNo#',
								 'Invoice',
								 '1',
								 getDate(),
								 '1',
								 'No tax series set',										
								 '#session.acc#',
								 '#session.last#',
								 '#session.first#')
								 
						
																							
					</cfquery>		
					
					<cfset Invoice.ActionId = rowguid> 						
				
			<cfelse>
			
			    <cfset Invoice.Mode              = "2">
				<cfset Invoice.ErrorDescription  = "">
				<cfset Invoice.ErrorDetail       = "">
				<cfset Invoice.Status            = "1">							   	
					
				<!--- validate series otherwise Invoice.Mode = "1" : Manual which was removed by Hanno 13 June 2021 --->
												
					<cfquery name="getSeries"
					 datasource="AppsOrganization" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 	SELECT  *
						FROM    OrganizationTaxSeries
						WHERE   SeriesType   = 'Invoice'	
						<cfif get.OrgUnitTax neq 0>
						AND     Orgunit 	= '#get.OrgUnitTax#'
						</cfif>
						AND		Operational  = 1										
						<!--- AND	((InvoiceCurrent < InvoiceEnd) <cfif Mode eq "3" > OR (UserKey IS NOT NULL)</cfif>) --->
					</cfquery> 	

					<cfif getSeries.recordCount eq "0">
					
							<!--- No valid series defined for EDI --->
							<cfset Invoice.Mode             = "1"> <!--- manual --->
							<cfset Invoice.ErrorDescription = "No tax series set">
							<cfset Invoice.ErrorDetail      = "">
							
							<!--- Hanno 6/13/2021 here we need to add the logging TransactionHeaderAction 
							                               for the manual mode  --->														   
							
							<cf_assignid>
														   
							<cfquery name="inherit"
									datasource="AppsLedger" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
								
									INSERT INTO TransactionHeaderAction
										
											(Actionid,
											 Journal, 
											 JournalSerialNo,
											 ActionCode,
											 ActionMode,
											 ActionDate,
											 ActionStatus,
											 ActionReference1,											
											 OfficerUserId,
											 OfficerLastName,
											 OfficerFirstName)
										 
									VALUES   ('#rowguid#',
									         '#get.Journal#', 
										     '#get.JournalSerialNo#',
											 'Invoice',
											 '1',
											 getDate(),
											 '1',
											 'No tax series set',										
											 '#session.acc#',
											 '#session.last#',
											 '#session.first#')
											 
																																			
								</cfquery>		
								
								<cfset Invoice.ActionId = rowguid> 					   
					
					<cfelse>
					
							<!--- EDI --->

							<!--- disabled 
							<cfif Terminal eq "">
								<cfset Terminal = getSeriesType.TerminalName>
							</cfif>
							--->
							
						    <!--- initiate EDI once it fails after 2 attempts Invoice.Mode = "1" --->	
						
							<cfinvoke component = "Service.Process.EDI.Manager"
									   method           = "SaleIssue" 
									   Datasource       = "AppsOrganization"
									   Mission          = "#get.Mission#"
									   Terminal			= "#Terminal#"
								       Mode 			= "#Mode#"
									   BatchId			= "#BatchId#"
									   returnvariable	= "stResponse">								
		
							<cfif stResponse.Status neq "OK">	
								 
								<!--- 10 retries--->							
								
								<cfloop index="rtNo" from="1" to="10">	
																
									<cfinvoke component = "Service.Process.EDI.Manager"  
											   method           = "SaleIssue" 
											   Datasource       = "AppsOrganization"
											   Mission          = "#get.Mission#"
											   Terminal			= "#Terminal#"
											   Mode 			= "#Mode#"
											   BatchId			= "#BatchId#"
											   RetryNo			= "#rtNo#"
											   returnvariable	= "stResponse">		
								
									<cfif stResponse.Status eq "OK">
										<cfbreak>
									</cfif>
										
								</cfloop> 	
									
							</cfif>	 
							
							<cfset Invoice.ActionId = stResponse.ActionId> 		
						
					</cfif>
				
				<!---	
				</cfif>											
				--->
			
			</cfif>					
							
			<cfreturn Invoice>	
	
	</cffunction>	
	
	<cffunction name="getTransaction"
             access="public"
             returntype="struct"
             displayname="retrieve a transaction for processing">

			 <cfargument name="Warehouse" type="string"  required="true"   default="">			 
			 <cfargument name="BatchId"   type="string"  required="true"   default="">	
			 <cfargument name="RequestNo" type="string"  required="true"   default="">		
			 		   
			   <cfquery name="getBatch"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM    WarehouseBatch						
					WHERE   BatchId = '#batchid#'
			   </cfquery>	
			   			
		     <cfset aReturn.customerId = getBatch.customerId>
		     <cfset aReturn.addressId = getBatch.addressId>

			 <cftransaction>
		 			 							 
				 <cfquery name="insertBatch"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">												
					
					INSERT INTO Materials.dbo.CustomerRequestLine
					
				           (TransactionId
						   ,RequestNo
						   ,BatchId
				           ,TransactionType
				           ,TransactionDate
						   ,TransactionReference
				           ,ItemNo
				           ,ItemClass
				           ,ItemDescription
				           ,ItemCategory				         		         
				           ,TransactionUoM
				           ,TransactionQuantity
				           ,TransactionLot
				           ,PersonNo				          
						   ,CustomerIdInvoice						  
				           ,ProgramCode
				           ,PriceSchedule
				           ,SalesCurrency
				           ,SchedulePrice
				           ,SalesPrice
						   ,SalesPersonNo
				           ,TaxCode
				           ,TaxPercentage
				           ,TaxExemption
				           ,TaxIncluded
						   ,SalesUnitPrice
				           ,SalesAmount
				           ,SalesTax
				           ,OrgUnit
				           ,OrgUnitCode
				           ,OrgUnitName )
							   
				   SELECT    NEWID() AS TransactionId, 
				             '#RequestNo#',
		 				     '#batchid#',
				             IT.TransactionType, 
							 IT.TransactionDate,
							 IT.TransactionReference, 
							 IT.ItemNo, 
							 I.ItemClass, 
							 IT.ItemDescription, 
							 IT.ItemCategory, 								
							 ITS.SalesUoM,
							 SUM(ITS.SalesQuantity) AS SalesQuantity,
							 IT.TransactionLot, 
							 IT.PersonNo, 								   		
						     <cfif getBatch.CustomerIdInvoice eq "">
							  NULL,
						     <cfelse>
							  '#getBatch.CustomerIdInvoice#',
						     </cfif>								   
							 IT.ProgramCode, 
							 ITS.PriceSchedule, ITS.SalesCurrency, ITS.SchedulePrice, ITS.SalesPrice, ITS.SalesPersonNo, 
                                ITS.TaxCode, ITS.TaxPercentage, ITS.TaxExemption, ITS.TaxIncluded, 
							 <!--- aggregate by removing the location of the transaction --->
							 SUM(ITS.SalesAmount)/SUM(ITS.SalesQuantity) AS SalesUnitPrice,
							 SUM(ITS.SalesAmount) AS SalesAmount, 
							 SUM(ITS.SalesTax) AS SalesTax, 
							 IT.OrgUnit, IT.OrgUnitCode, IT.OrgUnitName
							  
					FROM     Materials.dbo.ItemTransaction IT 
					         INNER JOIN Materials.dbo.ItemTransactionShipping ITS ON IT.TransactionId = ITS.TransactionId
					         INNER JOIN Materials.dbo.Item I ON IT.ItemNo = I.ItemNo 
					WHERE    TransactionBatchNo = '#getBatch.BatchNo#'
					AND      SalesQuantity <> 0
					
					GROUP BY IT.Mission, 
					         IT.TransactionType, 
							 IT.TransactionDate, IT.TransactionReference, IT.ItemNo, I.ItemClass, IT.ItemDescription, IT.ItemCategory, 
							 IT.Warehouse, 
	                         IT.TransactionLot, IT.PersonNo, IT.ProgramCode, ITS.PriceSchedule, ITS.SalesCurrency, ITS.SchedulePrice, ITS.SalesPrice, ITS.SalesPersonNo, ITS.TaxCode, 
          			             ITS.TaxPercentage, ITS.TaxExemption, ITS.TaxIncluded, IT.OrgUnit, IT.OrgUnitCode, IT.OrgUnitName, IT.TransactionUoM, ITS.SalesUoM
								 							
				 </cfquery>
				 					 

				 <cfquery name="deleteTmp"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					DELETE Settle#Warehouse#
					WHERE CustomerId = '#aReturn.customerId#'
					<cfif getBatch.AddressId neq "">
						AND AddressId = '#aReturn.AddressId#'
					</cfif>	
				 </cfquery>							 
				 
				 <cfquery name="insertBatch"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			 
					INSERT INTO Settle#Warehouse#
					           (RequestNo,
							    CustomerId,
					            AddressId,
					            SettleCode,
					            PromotionCardNo,
					            CreditCardNo,
					            ExpirationMonth,
					            ExpirationYear,
					            ApprovalCode,
					            ApprovalReference,
					            SettleCurrency,
					            SettleAmount)
						SELECT  '#RequestNo#',
						         '#aReturn.customerId#',
								 <cfif getBatch.AddressId neq "">
							  	'#getBatch.AddressId#',
								 <cfelse>
							  	 NULL,
						         </cfif>	
							     SettleCode,
							     PromotionCardNo,
							     CreditCardNo,
							     ExpirationMonth,
					    		 ExpirationYear,
							     ApprovalCode,
							     ApprovalReference,
							     SettleCurrency,
					    		 SettleAmount
 					  FROM  Materials.dbo.WarehouseBatchSettlement
					  WHERE BatchNo = '#getBatch.BatchNo#'
				 </cfquery>		 
		 
		 	</cftransaction>	
			 
			<cfreturn aReturn>
			 
	</cffunction>		
	
	<cffunction name="purgeTransaction"
             access="public"
             displayname="Removes a posted sales transsaction">
			 
			   <!--- check for external settlements --->			   
			 
			   <cfargument name="BatchId"  		type="string"  required="true"   default="">
			   <cfargument name="Terminal" 		type="string"  required="true"   default="">
			   <cfargument name="Mode"     		type="string"  required="true"   default="Purge">
			   <cfargument name="Status"   		type="string"  required="true"   default="9">
			   <cfargument name="triggerEDI"    type="string"  required="false"  default="No">
			   <cfargument name="Journal"    	type="string"  required="false"  default="">
			   <cfargument name="JournalSNo"    type="string"  required="false"  default="">
			   
 			   <cftransaction> 
			   			 
				   <cfquery name="getBatch"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT * 
						FROM    WarehouseBatch						
						WHERE   BatchId = '#batchid#'
						AND     ActionStatus <> '9'
				   </cfquery>	
				   
				   <cfif getBatch.recordcount eq "0">
				   
					    <cfquery name="getBatch"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT * 
								FROM    WarehouseBatch						
								WHERE   BatchId = '#batchid#'					
					   </cfquery>	
				   
				   </cfif>
					
				   <cfif status eq "9">
					
				        <!--- we remove also the COGS transactions / COGS and financial --->
	
						<cfquery name="List"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						  	SELECT  TransactionId 
							FROM    ItemTransaction
							WHERE   TransactionBatchNo = '#getBatch.BatchNo#'
						</cfquery>
						
						<cfloop query="List">	
						
							<!---checking if is the first time or the 2nd, 3rd, etc.--->
							<cfquery name="Deny"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
					  			SELECT  TOP 1 TransactionId 
								FROM    ItemTransactionDeny
								WHERE   TransactionId = '#List.TransactionId#'
							</cfquery>
							 	    						
							<cfif Deny.recordCount gt 0 >  
								<cf_stockTransactDelete transactionid="#List.TransactionId#" Mode="Purge" Parenttransactionid = "#Deny.TransactionId#">
							<cfelse>
								<cf_stockTransactDelete transactionid="#List.TransactionId#" Mode="Purge">
							</cfif>
						</cfloop>
						
				   </cfif>		
									
				   <!--- delete sale + settlements ---> 	
				   			   
				   <cfif Mode eq "Void">
				   		   					   
					   	 <cfquery name="voidBatch"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							UPDATE WarehouseBatch						
							SET    ActionStatus = '#status#', 
							       ActionOfficerUserId    = '#SESSION.acc#',
								   ActionOfficerLastName  = '#SESSION.last#',
								   ActionOfficerFirstName = '#SESSION.first#',
								   ActionOfficerDate      = getDate()
							WHERE  BatchId = '#batchid#'
						</cfquery>	
						
						<!--- Hanno 20/7/2015 
						is this needed still ?, i think this is no longer needed as the transaction is excluded 
												
						<cfquery name="deleteBatchLines"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									DELETE Accounting.dbo.TransactionLine 
									FROM Accounting.dbo.TransactionLine TL 
									WHERE EXISTS
									(
										SELECT 'X' 
										FROM   Accounting.dbo.TransactionHeader TH
										WHERE  TransactionSourceId = '#batchid#'
										AND    TH.Journal          = TL.Journal
										AND    TH.JournalSerialNo  = TL.JournalSerialNo
									)
						</cfquery>		
						
						--->
						
						<!--- we no longer remove the sale / settlement but we deactivate it --->
						
						<!--- check if we can indeed void this by checking if we have transactions related --->
						
						<cfquery name="getDependentLine"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT *
							FROM   Accounting.dbo.TransactionLine V
							WHERE NOT EXISTS (						
											SELECT 'X'
											FROM   Accounting.dbo.TransactionLine L
											WHERE  EXISTS (SELECT 'X' 
											               FROM   Accounting.dbo.TransactionHeader													
											               WHERE  TransactionSourceId  = '#batchid#'
														   AND    Journal = L.Journal
														   AND    JournalSerialNo = L.JournalSerialNo) 
											AND    Journal = V.Journal
											AND    JournalSerialNo = V.JournalSerialNo	)				  
							AND   EXISTS  (
											SELECT 'X'
											FROM   Accounting.dbo.TransactionLine L
											WHERE  EXISTS (SELECT 'X' 
											               FROM   Accounting.dbo.TransactionHeader													
											               WHERE  TransactionSourceId  = '#batchid#'
														   AND    Journal = L.Journal
														   AND    JournalSerialNo = L.JournalSerialNo) 
											AND    Journal         = V.ParentJournal
											AND    JournalSerialNo = V.ParentJournalSerialNo								  
											)	
							<cfif Journal neq "" AND JournalSNo neq "">
								AND v.Journal 			= '#Journal#'
								AND v.JournalSerialNo 	= '#JournalSNo#'
							</cfif>
																											    
						</cfquery>	
						
						<cfif getDependentLine.recordcount gte "1">
						
							<cf_alert message="You may no longer remove this transaction as settlements were recorded.">					
							<cfabort>
						
						</cfif>									
							
						<cfquery name="deleteBatch"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								UPDATE Accounting.dbo.TransactionHeader						
								SET    RecordStatus         = '9',
									   RecordStatusOfficer  = '#SESSION.acc#',							  
								       RecordStatusDate     = getDate()
								WHERE  TransactionSourceId  = '#batchid#'
								<cfif Journal neq "" AND JournalSNo neq "">
								AND    Journal 			= '#Journal#'
								AND    JournalSerialNo 	= '#JournalSNo#'
								</cfif>
						</cfquery>	
												
						<!--- post the tax action --->
						
						<cfif triggerEDI eq "Yes">
						
							 	<cfquery name="getAction"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">					
									SELECT  A.*
									FROM    Accounting.dbo.TransactionHeader H
											INNER JOIN Accounting.dbo.TransactionHeaderAction A ON H.Journal = A.Journal AND H.JournalSerialNo=A.JournalSerialNo
									WHERE   TransactionSourceId = '#batchid#'
									AND     TransactionCategory  = 'Receivables'	
									ORDER BY A.Created DESC									
							   	</cfquery>		
							   
							    <cfif getAction.recordcount gt "0" and getAction.ActionStatus eq "1">
								
								   	<cfif getAction.ActionMode eq "2">
											
										<cfinvoke component = "Service.Process.EDI.Manager"  
											   method           = "SaleVoid" 
											   Datasource       = "AppsMaterials"
											   Mission          = "#getBatch.Mission#"
											   Terminal			= "#Terminal#"	
											   BatchId			= "#BatchId#"
											   returnvariable	= "stResponse">

										<cfif stResponse.Status neq "OK">
											<cftransaction action="rollback"/>
											<cfoutput>
												<script>
												alert('#stResponse.ErrorDescription#')
											</script>
											</cfoutput>
										</cfif>

									</cfif>
									
								</cfif>
						</cfif>
									   
				   <cfelse>
					
					   <cfquery name="deleteBatch"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							DELETE FROM WarehouseBatch						
							WHERE  BatchId = '#batchid#'
						</cfquery>	
						
						<cfquery name="deleteBatch"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							DELETE FROM  Accounting.dbo.TransactionHeader						
							WHERE  TransactionSourceId = '#batchid#'
						</cfquery>	
					
					</cfif>
					
			   </cftransaction>
						 
	</cffunction>

	<cffunction name="getSalesByDate"
             access="public"
             displayname="get the Sales Price and Tax into a struct variable">
						
		<cfargument name="Mission"       type="string"  required="true"    default="">				
		<cfargument name="DateStart"     type="date"    required="true"    default="now()">				
		<cfargument name="DateEnd"     	 type="date"    required="true"    default="now()">		
		<cfargument name="Warehouse"     type="string"  required="false"   default="">				
		<cfargument name="Currency"      type="string"  required="false"   default="">
		<cfargument name="Category"      type="string"  required="false"   default="">
		<cfargument name="ItemNo"      	 type="string"  required="false"   default="">		
		<cfargument name="BaseAmounts"   type="string"  required="false"   default="Yes">	
		<cfargument name="Voided"    	 type="string"  required="false"   default="No">	
		<cfargument name="COGS"    	 	 type="string"  required="false"   default="Yes">	
		<cfargument name="TableName"     type="string"  required="true"    default="">			
	
		<cf_droptable dbname="AppsQuery" tblname="#TableName#">	
		<cf_droptable dbname="AppsQuery" tblname="#TableName#_AmountDebit">	
		
		<cfif COGS eq "Yes">		
			
			<cfoutput>
			<cfsavecontent variable="getCOGS">						        
					        Accounting.dbo.TransactionHeader H 
							INNER JOIN Accounting.dbo.TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo									
					WHERE   H.Mission = '#Mission#'
					AND     H.TransactionSource    = 'WarehouseSeries'						
					AND     H.TransactionCategory  = 'Inventory'
					AND     L.Reference            = 'COGS'						
			</cfsavecontent>
			</cfoutput>
			
		</cfif>

	   <cfquery name="getBatch"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
						
			SELECT  I.Category,
					C.Description as CategoryDescription,
					I.ItemNo,
					I.ItemDescription,
					DATEADD(dd, DATEDIFF(dd, 0, WB.transactiondate), 0)  as TransactionDate,
					WB.TransactionDate as TransactionDateTime,
					WB.Warehouse,
					W.WarehouseName,										
					WB.BatchNo, 
					WB.Batchid,						
					WB.BatchReference,
					WB.BatchMemo,		
					U.ItemBarCode,
					CU.CustomerId,
					CU.CustomerName, 
					CU.Reference AS CustomerReference,	
					T.TransactionLot,						
					T.TransactionUoM, 					
					
					<cfif Voided eq "No">-</cfif> (1 * T.TransactionQuantity) AS Quantity, 
					
					<cfif BaseAmounts eq "Yes">
					
						'#application.basecurrency#' AS Currency,
						<cfif Voided eq "Yes">-</cfif> 1 * (S.SalesBaseAmount) as Sale,															
						<cfif Voided eq "Yes">-</cfif> 1 * (S.SalesBaseTax)    as SalesTax,
						
						<cfif COGS eq "Yes">
							<cfif Voided eq "Yes">-</cfif>1 * ( SELECT AmountBaseDebit
								                                FROM   #preserveSingleQuotes(getCOGS)# 
																AND    H.ReferenceId = T.TransactionId) as COGS,
									
							<cfif Voided eq "Yes">-</cfif> 1 * (S.SalesBaseAmount - (SELECT AmountBaseDebit
								                                FROM   #preserveSingleQuotes(getCOGS)# 
																AND    H.ReferenceId = T.TransactionId)) AS GrossMargin,
						</cfif>
						
						<cfif Voided eq "Yes">-</cfif> 1 * S.SalesBaseAmount AS TransactionTotal,
					
					<cfelse>
					
						S.SalesCurrency as Currency,	
						<cfif Voided eq "Yes">-</cfif> 1 * (ROUND(S.SalesAmount,2)) AS Sale,
						<cfif Voided eq "Yes">-</cfif> 1 * (ROUND(S.SalesTax,2)) AS SalesTax, 
						
						<cfif COGS eq "Yes">
							<cfif Voided eq "Yes">-</cfif> 1 * (SELECT AmountDebit
																FROM   #preserveSingleQuotes(getCOGS)# 
																AND    H.ReferenceId = T.TransactionId) as COGS,
		
							<cfif Voided eq "Yes">-</cfif> 1 * (ROUND((S.SalesAmount - (SELECT AmountDebit
								                                 FROM   #preserveSingleQuotes(getCOGS)#
																 AND     H.ReferenceId = T.TransactionId)),2)) AS GrossMargin,
						</cfif>	
									
						<cfif Voided eq "Yes">-</cfif> 1 * ROUND(S.SalesAmount,2) AS TransactionTotal,
						
					</cfif>

					T.OfficerUserId      as SellerUserId,
					T.OfficerLastName    as SellerLastName,
					T.OfficerFirstName   as SellerFirstName,
					I.Created            as ItemCreated,
					S.SalesPersonNo,
					P.FirstName          as SalesPersonFirstName,
					P.LastName           as SalesPersonLastName

			INTO    Userquery.dbo.#TableName#	
												
				<cfif Voided eq "Yes">
					FROM    ItemTransactionDeny T INNER JOIN ItemTransactionShippingDeny S ON T.TransactionId = S.TransactionId
				<cfelse>
					FROM    ItemTransaction T INNER JOIN ItemTransactionShipping S ON T.TransactionId = S.TransactionId
				</cfif>		
								
				INNER JOIN WarehouseBatch WB ON T.TransactionBatchNo = WB.BatchNo AND WB.Mission ='#mission#'
				INNER JOIN Item I            ON I.ItemNo = T.ItemNo
				INNER JOIN ItemUoM U         ON U.ItemNo = I.ItemNo AND U.UoM = T.TransactionUoM
				INNER JOIN Ref_Category C    ON C.Category = I.Category					
				INNER JOIN Customer CU       ON WB.CustomerId = CU.CustomerId										
				INNER JOIN Warehouse W       ON WB.Warehouse = W.Warehouse	
				LEFT OUTER JOIN Employee.dbo.Person P ON P.PersonNo = S.SalesPersonNo					
					
			WHERE 	WB.Mission = '#mission#' 		
																		
			<cfif warehouse neq "">
				AND    WB.Warehouse = '#warehouse#'			
			</cfif>					
	
			<cfif Category neq "">
				AND    I.Category = '#Category#'			
			</cfif>
	
			<cfif ItemNo neq "">
				AND    I.ItemNo = '#ItemNo#'			
			</cfif>	
			
			AND  WB.TransactionDate BETWEEN #DateStart# AND #DateEnd#	
			
			AND  T.TransactionQuantity <> 0
			
		</cfquery>		

	</cffunction>			
	
</cfcomponent>