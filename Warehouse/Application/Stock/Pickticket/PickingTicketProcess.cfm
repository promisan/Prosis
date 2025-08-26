<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfset batchlist = "">

<cftransaction>
		
	<cfquery name="getBatches" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  DISTINCT ShipToWarehouse 
		FROM    Request R
		WHERE   RequestId IN (#PreserveSingleQuotes(form.selected)#)
	</cfquery>		

	<cfoutput query="getBatches">		
			
				
		<cfquery name="Parameter" 
		   datasource="AppsMaterials" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   SELECT     TOP 1 *
		   FROM       WarehouseBatch
		   ORDER BY   BatchNo DESC
		</cfquery>
		
		<cfif Parameter.recordcount eq "0">
		
			   <cfset batchNo = 10000>
			   
		<cfelse>
		
			<cfset BatchNo = Parameter.BatchNo+1>
			<cfif BatchNo lt 10000>
			    <cfset BatchNo = 10000+BatchNo>
			</cfif>
			
		</cfif>				
		
		<cfquery name="StockTo" 
		   datasource="AppsMaterials" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   SELECT TOP 1 * 
			   FROM   Warehouse
			   WHERE  Warehouse = '#ShipToWarehouse#'							 
		 </cfquery>	
		
		<cfquery name="InsertBatch" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO  WarehouseBatch
			    ( Mission,
				  Warehouse, 
				  Location,
				  BatchWarehouse,				  
				  BatchNo, 
				  BatchDescription, 
				  BatchClass,
				  TransactionType, 
				  TransactionDate, 
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName)
		VALUES ('#mission#',
		        <cfif shiptowarehouse eq "">
				'#url.warehouse#',
				NULL,
				<cfelse>
		        '#shipTowarehouse#',  <!--- processing batch to confirm actions --->
				'#StockTo.LocationReceipt#',
				</cfif>
				'#url.warehouse#',     <!--- ----- originating warehouse-------- --->
		        '#batchNo#',
				'Pickticket',
				'WhsShip',
				'2',
				getDate(),
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')
		</cfquery>
		
		<cfquery name="Listing" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  * 
			FROM    Request R, Item I
			WHERE   R.ItemNo = I.ItemNo
			AND     RequestId IN (#PreserveSingleQuotes(form.selected)#) 
			<cfif ShipToWarehouse neq "">
			AND     ShipToWarehouse = '#shiptowarehouse#'
			<cfelse>
			AND     (ShipToWarehouse is NULL or ShipToWarehouse = '')	
			</cfif>
		</cfquery>		
		 
		<!--- loop the requistions to be processed --->
		
		<cfloop query="Listing">
					
			<!--- get the stock from a bin/location in that warehouse sorted by picking order --->				
				
			<cfquery name="getStockOnHand" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				SELECT    T.Warehouse, 
				          T.ItemNo, 
						  T.TransactionUoM, 
						  T.TransactionLot, 
						  T.Location, 
						  SUM(T.TransactionQuantity) AS QuantityOnHand
						  
				FROM      ItemTransaction T INNER JOIN
	            	      ProductionLot Lot ON T.Mission = Lot.Mission AND T.TransactionLot = Lot.TransactionLot INNER JOIN
	                      WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location
						  
				WHERE     T.Warehouse      = '#Warehouse#'  <!--- shipping warehouse --->
				AND       T.ItemNo         = '#ItemNo#' 
				AND       T.TransactionUoM = '#UoM#'
				GROUP BY  T.Warehouse, 
				          T.ItemNo, 
						  T.TransactionUoM, 
						  T.TransactionLot, 
						  Lot.TransactionLotDate, 
						  T.Location, 
						  WL.ListingOrder
				HAVING    SUM(T.TransactionQuantity) > 0
				ORDER BY  Lot.TransactionLotDate, WL.ListingOrder						
			</cfquery>			
					
			<cfset st     = "2b">
			<cfset reqid  = requestid>
					
			<cfloop query="getStockOnHand">
						
				<cfquery name="Req" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   * 
					FROM     Request R, Item I
					WHERE    R.ItemNo = I.ItemNo
					AND      RequestId = '#reqId#' 
				</cfquery>				
			
				<cfquery name="Fullfilled" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   ISNULL(SUM(T.TransactionQuantity*-1),0) AS Quantity
					FROM     ItemTransaction T 
					WHERE    RequestId = '#ReqId#'
					AND      TransactionQuantity < 0
				</cfquery>
				
				<cfset ful = Fullfilled.Quantity>
		
				<!--- define quantity to be processed lowest of request and stock on hand --->
							
				<cfif req.requestedQuantity lte ful>
				   
				      <cfset qte = 0>
				      <cfset st = "3">
					  
				<cfelse>	  
							
					   <cfif QuantityOnHand lt (req.requestedQuantity - ful)>
					  
					      <cfset qte = QuantityOnHand>
					      <cfset st = "2b">
											  	  
					   <cfelse>
					   
					      <cfset qte = (req.requestedQuantity - ful)>
					      <cfset st = "3">	
										
					   </cfif> 
				   
				</cfif>			
				
				<!--- run the Stock transaction utility --->
	
				<cfif qte gt 0>
				
					<cfquery name="GLStock" 
					   datasource="AppsMaterials" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						   SELECT * 
						   FROM   Ref_CategoryGLedger 
						   WHERE  Area     = 'Stock'
						   AND    Category = '#req.Category#'
					</cfquery>
					
					<cfquery name="GLCost" 
					   datasource="AppsMaterials" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						   SELECT * 
						   FROM   Ref_CategoryGLedger 
						   WHERE  Area     = 'COGS'
						   AND    Category = '#req.Category#'
					</cfquery>
															
					<cfquery name="GLVariance"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT  GLAccount
							FROM    Ref_CategoryGLedger
							WHERE   Category = '#req.Category#' 
							AND     Area     = 'Variance'
					</cfquery>		
					
					<cfif GLVariance.GLAccount eq "">
					
						<script>
							alert("Incorrect Variance GL account for Pickticket processing.")	
						</script>
						
						<cfabort>
					
					</cfif>		
				
					<cfif req.requesttype neq "Warehouse">
					
						<cf_StockTransact
						        TransactionType     = "2"
						        ItemNo              = "#ItemNo#" 
								Mission             = "#Mission#" 
								Warehouse           = "#Warehouse#" 
								Location            = "#Location#" 
								TransactionLot      = "#TransactionLot#"
								TransactionUoM      = "#req.UoM#" 
								TransactionQuantity = "#-qte#"
								TransactionDate     = "#dateFormat(now(), CLIENT.DateFormatShow)#"
								TransactionBatchNo  = "#batchno#"
								OrgUnit             = "#req.OrgUnit#"
								RequestId           = "#req.RequestId#"
								Remarks             = "Pickticket"
								Reference           = "#req.Reference#"
								GLAccountDebit      = "#GLCost.GLAccount#"
								GLAccountCredit     = "#GLStock.GLAccount#"
								Shipping            = "Yes"
								ShippingTrigger     = "#req.RequestId#">
											
					<cfelse> <!--- transfer stock between warehouses --->
								 
							 <!--- define destination --->
												
							   <cfquery name="StockTo" 
							   datasource="AppsMaterials" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
								   SELECT TOP 1 * 
								   FROM   Warehouse
								   WHERE  Warehouse = '#req.ShipToWarehouse#'							 
							   </cfquery>	
								   
							<cfif StockTo.recordcount eq "1">
														
								<cf_assignid>
					    
								<cf_StockTransact 
								    TransactionId        = "#rowguid#"
								    TransactionType      = "8"								
									TransactionSource    = "WarehouseSeries"
					                ItemNo               = "#ItemNo#" 
									Warehouse            = "#Warehouse#" 
									Location             = "#Location#" 								
									TransactionUoM       = "#req.UoM#" 
									TransactionLot       = "#TransactionLot#"
									TransactionQuantity  = "#-qte#"
									TransactionDate      = "#dateFormat(now(), CLIENT.DateFormatShow)#"
									TransactionBatchNo   = "#batchno#"
									OrgUnit              = "#req.OrgUnit#"
									RequestId            = "#req.RequestId#" 
									Remarks              = "Internal Transfer"
									Reference            = "#req.Reference#"	
									GLAccountDebit       = "#GLVariance.GLAccount#"
								    GLAccountCredit      = "#GLStock.GLAccount#"							
									Shipping             = "No">
												  			   
								<cf_StockTransact 
								    TransactionType      = "8"
									ParentTransactionId  = "#rowguid#"
									TransactionSource    = "WarehouseSeries"
								    ItemNo               = "#Listing.ItemNo#" 
								    Warehouse            = "#StockTo.Warehouse#" 
									Location             = "#StockTo.LocationReceipt#" 
									TransactionUoM       = "#req.UoM#" 
									TransactionLot       = "#TransactionLot#"
									TransactionQuantity  = "#qte#"
									TransactionDate      = "#dateFormat(now(), CLIENT.DateFormatShow)#"
									TransactionBatchNo   = "#batchno#"
									OrgUnit              = "#req.OrgUnit#"
									RequestId            = "#req.RequestId#" 
									Remarks              = "Internal Transfer"
									Reference            = "#req.Reference#"	
									GLAccountCredit      = "#GLVariance.GLAccount#"
								    GLAccountDebit       = "#GLStock.GLAccount#"									
									Shipping             = "Yes">

									<!---- Added by dev on 2/25/2015 --->
								   <cfquery name="CheckLoc" 
								   datasource="AppsMaterials" 
								   username="#SESSION.login#" 
								   password="#SESSION.dbpw#">
										SELECT Warehouse, Location, Distribution
  										FROM   WarehouseLocation
  										WHERE  Location  = '#StockTo.LocationReceipt#' 
  										AND    Warehouse = '#StockTo.Warehouse#'
								   </cfquery>		
								   
								   <cfif checkloc.Distribution eq "8">
								   
										   <!--- ActionStatus          = "1"  removed --->
								   	
										  <cf_StockTransact 
								            TransactionType       = "2"
											TransactionSource     = "WarehouseSeries"
											ItemNo                = "#Listing.ItemNo#" 
											Warehouse             = "#CheckLoc.Warehouse#" 
											Location              = "#CheckLoc.Location#"
											Mission               = "#Mission#"
											TransactionUoM        = "#req.UoM#"
											TransactionCategory   = "Receipt"
											TransactionQuantity   = "#-qte#"											
											TransactionLot        = "#TransactionLot#" 
											TransactionBatchNo   = "#batchno#"
											TransactionDate       = "#dateFormat(now(), CLIENT.DateFormatShow)#"
											OrgUnit               = "#req.OrgUnit#"
											RequestId             = "#req.RequestId#"											
											Remarks               = "Issuance"
											GLAccountDebit        = "#GLVariance.GLAccount#"
											GLAccountCredit       = "#GLStock.GLAccount#">
																				   		
								   </cfif>
								   								   
									
							</cfif>		
					  
					</cfif>		
					
				</cfif>	
							
			</cfloop>	
									
			<cfquery name="Request" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Request
				SET    Status      = '#st#'
				WHERE  RequestId   = '#RequestId#'
				<cfif ShipToWarehouse neq "">
				AND     ShipToWarehouse = '#shiptowarehouse#'
				<cfelse>
				AND     (ShipToWarehouse is NULL or ShipToWarehouse = '')	
				</cfif>		
			</cfquery>		
						
		</cfloop>
		
		<cfif batchlist eq "">
			<cfset batchlist = "#batchNo#">
		<cfelse>			
			<cfset batchlist = "#batchlist#,#batchNo#">
		</cfif>	
			
	</cfoutput>
			
	<cfquery name="Pickticket"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   T.*,
			         U.UoMDescription,R.Reference
			FROM     ItemTransaction T, 
			         ItemUoM U, 
					 Request R
			WHERE    TransactionBatchNo IN (#preserveSingleQuotes(BatchList)#) 
			AND      T.ItemNo           = U.ItemNo
			AND      T.TransactionUoM   = U.UoM
			AND      T.RequestId        = R.RequestId
	</cfquery>
				
</cftransaction>
	
<cfif Pickticket.recordCount is 0>
	
		<cfquery name="Clear"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    DELETE FROM WarehouseBatch
			WHERE  BatchNo IN (#preserveSingleQuotes(BatchList)#) 
		</cfquery>
		
		<cf_tl id="No Items were processed" var="qitem">
		
		<cfoutput>
		<script language="JavaScript">
		    
			alert("#qItem#.")			
						
		</script>
		</cfoutput>
			
	<cfelse>
	
		<cfquery name="Batch"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   WarehouseBatch
			WHERE  BatchNo IN (#preserveSingleQuotes(BatchList)#) 
		</cfquery>
						
		<cfquery name="BatchClass"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   Ref_WarehouseBatchClass
			WHERE  Code = '#Batch.BatchClass#'
		</cfquery>
		
		<cfset vPickTicketReport = BatchClass.reportTemplate>
		
		<!--- will generate a single report --->
					
		<cfoutput>
		
			<script language="JavaScript">
	
			  w = #CLIENT.width# - 100;
		      h = #CLIENT.height# - 155;
			  printpickticket('#vPickTicketReport#','#preserveSingleQuotes(BatchList)#');
			    		 		
			</script>					
		
		</cfoutput>			
		
		<cfinclude template="PickingListing.cfm">
		
	</cfif>


