
<!--- recalculate average price --->

<cffunction name="redoIssuanceTransaction"
        access="public"
        returntype="any"
        displayname="Source an issuance transaction and revaluate and post the amounts">
			
		<cfargument name="Datasource"    type="string" 	default="AppsMaterials" required="yes">						
		<cfargument name="Mode"          type="string" 	default="Standard"      required="yes">	
		<cfargument name="filterMission" type="string" 	default=""              required="yes">
		<cfargument name="filterItemNo"  type="string" 	default=""              required="yes">	
		<cfargument name="revaluation"   type="string" 	default="0"             required="yes">	
		<cfargument name="initialStatus" type="numeric" default="0"             required="yes">	
		<cfargument name="finalStatus"   type="numeric" default="1"             required="yes">
			
		<!--- general variables --->
		
		<cfset price   = "0.0">
		<cfset stock   = "0">
		
		<!--- luck day correction --->
		
		<cfquery name="Purchase" 
			datasource="#Datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			SELECT     MIN(TransactionDate) AS myDate
	        FROM       ItemValuation
	        WHERE      Mission   = '#filtermission#'
	        AND        ItemNo    = '#filterItemNo#'
			AND        (TransactionReference LIKE 'OC%' 
			                     OR (TransactionReference LIKE 'D-%' and TransactionValue > 100))
	        -- AND     (TransactionReference LIKE 'D-%' OR TransactionReference LIKE 'OC%')
			
		</cfquery>		
		
		<cfquery name="Sale" 
			datasource="#Datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			SELECT     MIN(TransactionDate) AS myDate
	        FROM       ItemValuation
	        WHERE      Mission   = '#filtermission#'
	        AND        ItemNo    = '#filterItemNo#'
	        AND        (TransactionReference LIKE 'TRA%' 
			                OR TransactionReference LIKE 'OV%' 
							OR TransactionReference LIKE 'D%')							
		</cfquery>
		
		<cfif Sale.myDate lte Purchase.myDate 
		   and Sale.mydate     neq "" 
		   and Purchase.mydate neq "">	   
		   
		   <cfset purdte = dateadd("D",1,Purchase.myDate)>
		
		    <!--- correct one --->
			
			<cfquery name="Update" 
				datasource="#Datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				UPDATE     ItemValuation
				SET        TransactionDate = '#dateformat(purdte,client.dateSQL)#'
		        WHERE      Mission         = '#filtermission#'
		        AND        ItemNo          = '#filterItemNo#'
		        AND        (TransactionReference LIKE 'TRA%' OR TransactionReference LIKE 'OV%') 
				AND        TransactionDate < '#purchase.mydate#'			
			</cfquery>
			
			<!--- correction 2 --->
								
			<cfquery name="Update" 
				datasource="#Datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				UPDATE     ItemValuation
				SET        TransactionDate = '#dateformat(purdte,client.dateSQL)#'
		        WHERE      Mission         = '#filtermission#'
		        AND        ItemNo          = '#filterItemNo#'
		        AND        TransactionReference LIKE 'D%' 
				AND        TransactionDate <= '#purchase.mydate#'			
				AND        TransactionQuantity < 0
				
			</cfquery>
				
		</cfif>
		
		<!--- check in more detail 
		
		Added a correction to put D- transaction that are negative (exceptional
		    in quantity after the date of the first receipt. 
		
		--->
		
		<cfquery name="transaction" 
			datasource="#Datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">								
				SELECT      *
				FROM        ItemValuation
				WHERE       Mission   = '#filtermission#'
				AND         ItemNo    = '#filterItemNo#'
				AND         TransactionQuantity <> 0
				ORDER BY TransactionDate, LEFT(TransactionReference, 2), TransactionQuantity DESC																			
		</cfquery>		
		
		<cfset qty  = 0>
		<cfset omit = "">
						
		<cfloop query="transaction">
		
		  <cfif not find(transactionid,omit)>
		
			  <cfset qty = qty + TransactionQuantity>
			
			  <cfif qty lt 0>
			  
			    <!--- we find the next purchase and put this purchase on top --->
				
				<cfloop condition="#qty# lt 0">
				
					<cfquery name="NextProc" 
					datasource="#Datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
							SELECT    TOP 1 *
						    FROM      ItemValuation
						    WHERE     Mission   = '#filtermission#'
						    AND       ItemNo    = '#filterItemNo#'
							AND       TransactionDate >  '#transactiondate#'
						    AND       ((TransactionReference LIKE 'D-%' AND TransactionQuantity > 0) OR TransactionReference LIKE 'OC%')
							<cfif omit neq "">
							AND       TransactionId not in (#preservesinglequotes(omit)#)
							</cfif>
							ORDER BY  TransactionDate ASC <!--- removed as it was taking the wrong comprass DESC --->
							
					</cfquery>	
					
					<cfif nextproc.recordcount eq "1">		
						
						<cfset qty = qty + nextProc.transactionQuantity>			
					
						<cfquery name="reset" 
							datasource="#Datasource#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">	
							    UPDATE 	ItemValuation
								SET     TransactionDate = '#transactiondate#'
								WHERE   TransactionId   = '#nextproc.transactionid#'														
						</cfquery>	
											
						<cfif omit neq "">
						     <cfset omit = "#omit#,'#nextproc.transactionid#'">	
						<cfelse>
						     <cfset omit = "'#nextproc.transactionid#'">
						</cfif>
						
					<cfelse>
					
						<cfbreak>
					
					</cfif>
				
				</cfloop>
		 
		     </cfif>
			 
		  </cfif>	 
		
		</cfloop>	
		
		<!--- New we make a correction for the sorting of the NC of the sale as they are a quasi purchase and we want them in the correct order  --->	
		
		<cfquery name="transaction" 
			datasource="#Datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
								
				UPDATE      ItemValuation
				SET         TransactionType = '7'
				WHERE       Mission   = '#filtermission#'
				AND         ItemNo    = '#filterItemNo#'
				AND         TransactionQuantity > 0
				AND         TransactionType = '0'
																
		</cfquery>	
		
		
		<!--- start with valuation --->
		
		<cfquery name="transaction" 
			datasource="#Datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
								
				SELECT      *
				FROM        ItemValuation
				WHERE       Mission   = '#filtermission#'
				AND         ItemNo    = '#filterItemNo#'
				AND         TransactionQuantity <> 0
				ORDER BY    TransactionDate, TransactionQuantity DESC  <!--- adjusted 11/1/2023 --->			
									
																
		</cfquery>	
		
		<!--- was ORDER BY    TransactionDate, TransactionType DESC  always first the receipts and d-transactions if postivie  --->	
		
		<cfset init = "1">	
		
		<cfoutput query="Transaction">
		
			<cfif TransactionType neq "4">
			
				<cfset init = "0">
				
			</cfif>
				
			<!--- we set the initial price --->		
		
		    <cfif Transactionquantity gt "0" 
			     and TransactionType eq "4"
				 and (init eq "1" or price eq 0) <!--- we only apply this mode if it is at the beginning as initial stock, otherwise we apply avg cost for them ---> 
				 and TransactionValue neq 0>		
			
			     <cfset val    = (stock * price) + TransactionValue>	
				 <cfset stock  = stock + TransactionQuantity>
				 
			     <cfset prict  = round( TransactionValue * 100000 / TransactionQuantity ) / 100000>	
				 
				 <cfif stock neq "0">
				 
					 <cfset price  = round( val * 100000 / stock)/100000>
				 
				 <cfelse>
				 
				 	<!--- no change --->
				 
				 </cfif>
				 			
			     <cfquery name="transaction" 
						datasource="#Datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
											
							UPDATE      ItemValuation
							SET         TransactionCostPrice = '#prict#' 
							WHERE       TransactionId = '#TransactionId#'									
																			
					</cfquery>	
					
					<cfif prict neq "0" and prict lte "1000000">
					
						<cfquery name="check" 
						datasource="#Datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT      *
							FROM        ItemCostPrice
							WHERE       Mission           = '#filtermission#'
							AND         ItemNo            = '#filterItemNo#'
							AND         SelectionDate     = '#transactiondate#'
						</cfquery>
						
						<cfif check.recordcount eq "1">
												
							<cfquery name="update" 
							datasource="#Datasource#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								UPDATE      ItemCostPrice
								SET         CostPrice     = '#price#', 
								            Created       = getDate()
								WHERE       Mission       = '#filtermission#'
								AND         ItemNo        = '#filterItemNo#'
								AND         SelectionDate = '#transactiondate#'
							</cfquery>	
							
						<cfelse>
																		   						
							<cfquery name="addprice" 
							datasource="#Datasource#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								INSERT INTO ItemCostPrice
								(Mission,ItemNo,SelectionDate,CostPrice)
								VALUES
								('#filtermission#','#filterItemNo#','#transactiondate#','#price#')
							</cfquery>	
													
						</cfif>
					
					</cfif>				
		
			<cfelseif Transactionquantity gt "0" 
			         and TransactionType eq "3" 
					 and TransactionValue neq 0>
			
			        <!--- purchases --->
					 
					<!--- we take the current stock * price + value of the purchase receipt
					 determine the new price for this date after the added quantity is added --->
			
					<cfset val    = (stock * price) + TransactionValue>					
					<cfset stock  = stock + TransactionQuantity>
					<cfset stock = round(stock * 1000)/1000>
														
				    <!--- this purchase price --->	
					<cfset prict  = round( TransactionValue * 100000 / TransactionQuantity ) / 100000>
										
					<!--- new calculated price after receipt --->	
					<cfif stock neq "0">
					    <cfset price  = round( val * 100000 / stock)/100000>
					<cfelse>
					     #price#
					    <!--- <cfset price = "0"> --->
					</cfif>
															
					<cfif price neq "0" and price lte "1000000">
					
						<cfquery name="check" 
						datasource="#Datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT      *
							FROM        ItemCostPrice
							WHERE       Mission           = '#filtermission#'
							AND         ItemNo            = '#filterItemNo#'
							AND         SelectionDate     = '#transactiondate#'
						</cfquery>
						
						<cfif check.recordcount eq "1">
						
						<!--- Edit : #transactiondate# #prict# #price#<br> --->
						
							<cfquery name="update" 
							datasource="#Datasource#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								UPDATE      ItemCostPrice
								SET         CostPrice     = '#price#', 
								            Created       = getDate()
								WHERE       Mission       = '#filtermission#'
								AND         ItemNo        = '#filterItemNo#'
								AND         SelectionDate = '#transactiondate#'
							</cfquery>					
						
						<cfelse>
						
						<!--- Add : #transactiondate# #prict# #price#<br> --->
						
							<cfquery name="addprice" 
							datasource="#Datasource#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								INSERT INTO ItemCostPrice
								(Mission,ItemNo,SelectionDate,CostPrice)
								VALUES
								('#filtermission#','#filterItemNo#','#transactiondate#','#price#')
							</cfquery>	
						
						</cfif>
					
					</cfif>
					
					<cfquery name="transaction" 
						datasource="#Datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
											
							UPDATE      ItemValuation
							SET         TransactionCostPrice = '#prict#' 
							WHERE       TransactionId = '#TransactionId#'									
																			
					</cfquery>						
												
					<!--- Attention : also store price in a table --->
								 
			<cfelse>					
			
					<cfif price eq "0" and TransactionValue neq 0>
					
						<!--- this a correcion in case the very first line is negative Lucia 8/1/2022 : 008240 --->
					
						<cfset price = round(TransactionValue*100000/TransactionQuantity)/100000>
											
						<cfset stock      = stock + Transactionquantity> 
					    <cfset value      = Transactionquantity * price> 
						
						<cfquery name="transaction" 
						datasource="#Datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
											
							UPDATE      ItemValuation
							SET         TransactionValue     = '#Value#',
							            TransactionCostPrice = '#price#'
							WHERE       TransactionId = '#TransactionId#'									
																			
						</cfquery>									
												
					<cfelse>
					
					    <cfparam name="pricT" default="#price#">
					
						<cfset stock      = stock + Transactionquantity>										
						<cfset value      = Transactionquantity * price>
																														
						<cfquery name="transaction" 
						datasource="#Datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
																					
							UPDATE      ItemValuation
							SET         TransactionValue     = '#Value#',
							            TransactionCostPrice = '#price#'     
							WHERE       TransactionId = '#TransactionId#'									
																			
					    </cfquery>		
					
					</cfif>											
										
					<cfquery name="check" 
						datasource="#Datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
							SELECT      *
							FROM        ItemCostPrice
							WHERE       Mission           = '#filtermission#'
							AND         ItemNo            = '#filterItemNo#'	
													
					</cfquery>
											
					<cfif check.recordcount eq "0">
																		
						<cfquery name="addprice" 
						datasource="#Datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
							INSERT INTO ItemCostPrice
							(Mission,ItemNo,SelectionDate,CostPrice)
							VALUES
							('#filtermission#','#filterItemNo#','#transactiondate#','#price#')
							
						</cfquery>	
						
					</cfif>						
		
			</cfif>		
					
		</cfoutput>			
		
</cffunction>	

<cffunction name="getStock"
        access="public"
        returntype="struct"
        displayname="1a get the status on the item/uom into a struct variable">
						
		<cfargument name="Mission"          type="string"  required="true"   default="">						
		<cfargument name="Warehouse"        type="string"  required="true"   default="">		
		<cfargument name="Location"         type="string"  required="true"   default="">	
		<cfargument name="TransactionLot"   type="string"  required="true"   default="">		
		<cfargument name="ItemNo"           type="string"  required="true"   default="">
		<cfargument name="UoM"              type="string"  required="true"   default="">
		<cfargument name="ExcludeBatchNo"   type="string"  required="true"   default="">
				
		<cfset stock.onhand       = "0">
		<cfset stock.earmarked    = "0">	
		<cfset stock.reserved     = "0">
						
		
		<cfquery name="getOnHand" 
				datasource="hubEnterprise" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
				
			    SELECT SUM(StockOnSale) as Total
				FROM (
				SELECT    S.StockAvailable-S.StockExhibited-S.StockVendor-S.StockDisposed as StockOnSale
				FROM      ItemStock S
				WHERE     1=1
				<cfif Mission neq "">
				AND       Mission        = '#mission#' 
				</cfif>
				<cfif Warehouse neq "">
				AND       Warehouse      = '#warehouse#'
				</cfif>
				<cfif Location neq "">
				AND       Location       = '#location#'
				</cfif>
				<cfif TransactionLot neq "">
				AND       TransactionLot = '#transactionlot#'
				</cfif>
								
				AND       ItemNo         = '#itemNo#' 
				
				AND       SelectionDate = CAST(GETDATE() AS Date)
				
				<!--- 
				AND       TransactionUoM = '#UoM#'		
				--->
				
				<!--- Hanno 10/7/2019 
						likely we need to be more granular based on the transactiontype 
						and the actionstatus of the transaction to be included 
						receipt likely best to be status = '1'
						issuance / transfer/ variation like best to be 0 and 1
				--->		
				) as B
				WHERE 1=1				
				
				
			</cfquery>	
					
			<cfif getOnHand.Total neq "">			
			    <cfset stock.onhand  = getOnHand.total>
			<cfelse>
			   <cfset stock.onHand = 0>			
			</cfif>		
					
		<cfreturn stock>	
		
	</cffunction>

<cffunction name="getSaleListing"
        access="public"
        returntype="query"
        displayname="1b. get a listing of sale items with their current delivery status">
		
		<cfargument name="Mission"             type="string"  required="true"   default="">						
		<cfargument name="Warehouse"           type="string"  required="false"  default="">		
		<cfargument name="Customer"            type="string"  required="false"  default="">		
		<cfargument name="SalesId"             type="string"  required="false"  default="">		
		
		<cfquery name="sale" 
				datasource="hubEnterprise" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
		
			SELECT        S.Mission, S.SalesId, ST.SaleDate, S.CustomerId, C.CustomerName, C.MobilePhone, C.EMailAddress, S.Payment, S.PaymentMode, S.SalePerson, S.SaleWarehouse, S.InvoiceDate, S.InvoiceNo, 
	                      S.InvoiceId, S.FELNo, S.FELCae, ST.ItemNo, ST.ItemName, ST.WarehouseQuantity, ST.SaleQuantity,
	                      (SELECT    ISNULL(SUM(DeliveryQuantity), 0) AS Expr1
	                       FROM      SaleTransactionFulfill
	                       WHERE     Mission = ST.Mission 
						   AND       SalesId = ST.SalesId 
						   AND       ItemNo = ST.ItemNo 
						   AND       SaleSerialNo = ST.SaleSerialNo) AS FulFilled
	         FROM         Sale AS S INNER JOIN
	                      SaleTransaction AS ST ON S.Mission = ST.Mission AND S.SalesId = ST.SalesId INNER JOIN
	                      Customer AS C ON S.Mission = C.Mission AND S.CustomerId = C.CustomerId
	         WHERE        ST.SaleStatus <> '3' 
			 AND          S.Mission <> '#mission#'
		 
		 </cfquery>  
		 
		 				
		<cfreturn stock>	
		
		
</cffunction>		


<cffunction name="getStockListing"
        access="public"
        returntype="query"
        displayname="1b. get a listing of items with their current stock levels">
					
			<cfargument name="Mission"             type="string"  required="true"   default="">						
			<cfargument name="Warehouse"           type="string"  required="false"  default="">		
			<cfargument name="Location"            type="string"  required="false"  default="">		
			
			<cfargument name="currency"            type="string"  required="false"  default="GTQ"> 						
			<cfargument name="PriceSchedule"       type="string"  required="false"  default="CFI"> 
			
			<cfargument name="Make"                type="string"  required="true"   default="">
			<cfargument name="Category"            type="string"  required="true"   default="">
			
			<cfargument name="ItemName"            type="string"  required="true"   default="">
						
			<cfargument name="ItemMode"            type="string"  required="true"   default="">
			<cfargument name="ItemNo"              type="string"  required="true"   default="">
			<cfargument name="UoM"                 type="string"  required="true"   default="">
			<cfargument name="Classify"            type="string"  required="true"   default="">
			
			<cfargument name="SettingOnHand"       type="string"  required="false"  default=""> 
			<cfargument name="SettingPromotion"    type="string"  required="false"  default=""> 
			<cfargument name="SettingReservation"  type="string"  required="false"  default="">
			
			<cfargument name="Mode"           type="string"  required="true"   default="Table">
			<cfargument name="Table"          type="string"  required="false"  default="#SESSION.acc#Stock">				
			
			<cfset searchstr = "">
					
			<cfloop index="itm" list="#ItemName#" delimiters=" ">
			
				<cf_softlike left="I.ItemName" right="#itm#" language="#client.languageId#" var="1">					
				<cfif searchstr eq "">						
				    <cfset searchstr = "#softstring#">						
				<cfelse>						
					<cfset searchstr = "#searchstr# AND #softstring#">										
				</cfif>
			
			</cfloop>
				
			
			<cfif priceSchedule eq "">
			
				<cfquery name="get" 
					datasource="hubEnterprise" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					SELECT    *
	                FROM      PriceSchedule
	                WHERE     FieldDefault = 1 AND Mission = '#mission#'
				</cfquery>	
				
				<cfset PriceSchedule = get.PriceSchedule>
				
		     </cfif>
		     
			
			<cfquery name="stock" 
				datasource="hubEnterprise" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
																						
				SELECT TOP 700 *
				
				FROM (			
			
				SELECT      TOP 10000 I.Mission, 
				            I.ItemNo,
							
							<!--- Prosis linkage --->
				            T.ItemNo as ItemNoPrice,
							T.ItemNoExternal,
														
							(SELECT TOP 1 ImagePath 
							 FROM Materials.dbo.ItemImage 
							 WHERE ItemNo = T.ItemNo) as ImagePath,	
							 
							(SELECT TOP 1 UoM
							 FROM Materials.dbo.ItemUoM 
							 WHERE ItemNo = T.ItemNo
							 AND  Operational = 1) as ItemUoMPrice,	
							 
							<!--- end prosis linkage ---> 
							
							I.ItemName, 
							
							(SELECT TOP 1 Reference 
							 FROM   Materials.dbo.ItemUoMMission
							 WHERE  ItemNo = T.ItemNo
							 AND    UoM    <> 'M2'
							 AND    Mission = '#Mission#') as ItemReference,							 
							
							I.ItemCategory, 
							I.ItemBrand, 
							I.ItemClass, 
							I.ItemUoM, 
							I.ItemDetail, 	
							'#PriceSchedule#' as PriceSchedule,
							
							'#currency#' as Currency,														
							
							<!---  linked to Prosis Price Hub now
								-- P.PriceSchedule,
								-- P.Currency,
								-- P.Price*PriceMultiplier as Price,
								-- P.PriceMin*PriceMultiplier as PriceSaleMin,
								-- P.PriceMax*PriceMultiplier as PriceSaleMax,  							
							--->
														
							((SELECT   TOP 1 ISNULL(SalesPrice,0)
                             FROM     Materials.dbo.ItemUoMPrice
                             WHERE    Mission         = '#mission#' 
							 AND      ItemNo          = T.ItemNo 
							 AND      PriceSchedule   = '#priceSchedule#' 
							 AND      Promotion       = '0' 
							 AND      Currency        = '#currency#'
                             ORDER BY DateEffective DESC)) as PriceSaleMax,													  	
							
							I.PriceMultiplier,
							I.UsageMultiplier,
							
							((SELECT   TOP 1 ISNULL(SalesPrice,0)
                             FROM     Materials.dbo.ItemUoMPrice
                             WHERE    Mission         = '#mission#' 
							 AND      ItemNo          = T.ItemNo 
							 AND      PriceSchedule   = '#priceSchedule#' 
							 AND      Promotion       = '1' 
							 AND      Currency        = '#currency#'
                             ORDER BY DateEffective DESC)) as PromotionPrice,
							
							<!--- has to be moved to the price hub 
																						 
							(   SELECT TOP (1) Price
								FROM    EnterpriseHub.dbo.ItemPromotion IP INNER JOIN (SELECT  TOP (1) Mission, ItemNo, DateEffective
																						FROM    EnterpriseHub.dbo.ItemPromotion
																						WHERE   Mission = I.Mission 
																						AND     ItemNo  = I.ItemNo
																						ORDER BY DateEffective  DESC) as D 
									ON IP.Mission = D.Mission AND IP.ItemNo = D.ItemNo and IP.DateEffective = D.DateEffective
								WHERE IP.DateExpiration >= getDate()
								ORDER BY Price ) as PromotionPrice11,	
								
							--->	 	
												 
								 
							 I.Operational, 
							 T.ItemPrecision,
							 W.Warehouse,
							 W.WarehouseName, 
							 
							 (SELECT   TOP (1) W.Warehouse
							  FROM     Employee.dbo.Person AS P INNER JOIN
                                       Employee.dbo.PersonAssignment AS PA ON P.PersonNo = PA.PersonNo INNER JOIN
                                       Organization.dbo.Organization AS O ON PA.OrgUnit = O.OrgUnit INNER JOIN
                                       Materials.dbo.Warehouse AS W ON O.MissionOrgUnitId = W.MissionOrgUnitId INNER JOIN
                                       System.dbo.UserNames AS U ON P.PersonNo = U.PersonNo
                              WHERE    U.Account = '#session.acc#') as WarehouseDefault,
														 							 
							 S.StockCounted, 
							 S.StockAvailable, 
							 S.StockAvailable-S.StockVendor-S.StockExhibited-S.StockDisposed as StockOnSale, 
							 S.StockReserved, 
							 S.StockExhibited+S.StockVendor as StockExhibited, 
							 S.StockDisposed, 
							 S.StockOnOrder,
							 
							  <!--- Transit --->
												  
							 (SELECT   ISNULL(SUM(ReceiptWarehouse),0)
                              FROM     Purchase.dbo.PurchaseLineReceipt AS PLR INNER JOIN
                                       Purchase.dbo.Receipt AS R ON PLR.ReceiptNo = R.ReceiptNo
                              WHERE    PLR.ActionStatus     = '0' 
							  AND      R.Mission            = I.Mission 
							  AND      PLR.Warehouse        = S.Warehouse 
							  AND      PLR.WarehouseItemNo  = T.ItemNo
							  <!--- AND      PLR.WarehouseUoM     = L.UoM   not relevant --->
							  ) as StockInTransit,	
							 												 	   
							 (SELECT   ISNULL(SUM(TransactionQuantity),0)
							  FROM     Materials.dbo.vwCustomerRequest
							  WHERE    ItemNo          = T.ItemNo
							  <!--- AND      TransactionUoM  = T.UoM --->
							  AND      Warehouse       = S.Warehouse
							  AND      BatchNo IS NULL 
							  AND      RequestClass = 'QteReserve' 
							  AND      ActionStatus in ('0','1')) as QuantityRequested, 							 
							 
							 S.Created
							 
				FROM        Item AS I 
				            INNER JOIN ItemStock AS S ON I.Mission = S.Mission AND I.ItemNo = S.ItemNo
							INNER JOIN Warehouse AS W ON S.Mission = W.Mission AND S.Warehouse = W.Warehouse AND W.Operation = 1 
							INNER JOIN Materials.dbo.Item T ON I.ItemNo = T.ItemNoExternal 
							
							<!---
							
							INNER JOIN		
												
								(SELECT    T.*
								 FROM      ItemPriceSale T INNER JOIN 
								           (  SELECT     Mission, ItemNo, Currency, PriceSchedule, MAX(DateEffective) AS DateEffective
											  FROM       ItemPriceSale
								              WHERE      PriceSchedule = '#Priceschedule#'
											  AND        Currency = 'GTQ'
								              GROUP BY   Mission, ItemNo, Currency, PriceSchedule
								            ) as S 
											
								 ON T.Mission = S.Mission 
									AND  T.ItemNo        = S.ItemNo 
									AND  T.PriceSchedule = S.PriceSchedule 
									AND  T.Currency      = S.Currency 
									AND  T.DateEffective = S.DateEffective
										   
												   
								) as P ON P.Mission = W.Mission AND P.ItemNo = I.ItemNo AND P.Mission = I.Mission AND PriceSchedule = '#Priceschedule#'		
								
								--->
														
				<cfif mission eq "Mariscal">			
				WHERE   1=1  --   S.Mission = '#mission#' 
				<cfelse>
				WHERE    S.Mission = '#mission#'
				</cfif>
				AND         I.Operational = 1
				AND         W.Operation = 1
				AND         S.SelectionDate = CAST(GETDATE() AS Date) 
				
				<cfif warehouse neq "">
				AND         W.Warehouse = '#Warehouse#'
				</cfif>		
				
				<cfif Make neq "">
				AND         I.ItemBrand IN (#preservesinglequotes(make)#) 		
				</cfif>
				<cfif Category neq "" and itemNo eq "">
				AND         I.ItemCategory LIKE '%#Category#' 
				</cfif>				
				
				<cfif classify neq "">					
				AND         T.ItemNo IN ( #preserveSingleQuotes(classify)# )					
				</cfif>		
				
				<!--- apply the fuzzy search for the name and apply support for spanish sign --->						
				<cfif ItemName neq "">							
				AND ( 				
				(#preservesingleQuotes(searchstr)#)				
				OR I.ItemNo         LIKE '%#ItemName#' 				
				)				
				</cfif>	
				
				<cfif mission eq "Mariscal">	
				
					<cfif itemNo neq "">				
						<cfif itemMode eq "exact">
						AND    I.ItemNo LIKE '#ItemNo#'
						
						<cfelse>
						AND    I.ItemNo LIKE '%#ItemNo#' 
						</cfif>
					</cfif>
				
				<cfelse>
				
				<cfif itemNo neq "">				
					<cfif itemMode eq "exact">
					AND    (I.ItemNo LIKE '#ItemNo#' OR T.ItemNo IN (SELECT ItemNo
					                                                FROM   Materials.dbo.ItemUoMMission IM 
																	WHERE  Mission = '#mission#'
																	AND    Reference LIKE '#ItemNo#'
																	AND    UoM    <> 'M2'))
					
					<cfelse>
					AND    (I.ItemNo LIKE '%#ItemNo#' OR T.ItemNo IN (SELECT ItemNo
					                                                FROM   Materials.dbo.ItemUoMMission IM 
																	WHERE  Mission = '#mission#'
																	AND    Reference LIKE '%#ItemNo#'
																	AND    UoM    <> 'M2'))
					</cfif>
				</cfif>
				
				</cfif>	
				
				AND        I.Operational = 1 
				AND        W.Operation   = 1		
				
				) as D
				
				WHERE 1=1
				
				<!--- as items are in transit --->				
				-- AND  PriceSaleMax is not NULL
												
				<cfif SettingOnHand eq "1">
				AND        StockOnSale   > 0
				</cfif>
				
				<cfif SettingReservation eq "1">
				AND        StockReserved > 0
				</cfif>
				
				<cfif SettingPromotion eq "1">
				AND        PromotionPrice > 0
				</cfif>
				
				ORDER BY ItemName, WarehouseName
																											
			</cfquery>					
							
			<cfreturn stock>	
		
	</cffunction>
	
	<cffunction name="IssueSale"
        access="public"
        returntype="any"
        displayname="Issue a sale transaction">
		
    </cffunction>	
	
	<cffunction name="AmendSale"
        access="public"
        returntype="any"
        displayname="Amend sale transaction">
		
    </cffunction>	
	
	<cffunction name="CancelSale"
        access="public"
        returntype="any"
        displayname="Cancel sale transaction">
		
    </cffunction>	