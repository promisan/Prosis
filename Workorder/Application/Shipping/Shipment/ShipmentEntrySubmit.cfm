
<!--- meta code : 

   loop through the lines and validate if the quantity <= stock on hand still 
   
   create a batch record per warehouse : 
   
   BatchDescription = "WorkOrder Shipment"
   BatchReference = workorder
   BatchId = wokrorderid
   Location,ItemNo, UoM = null
   Warehouse
   TransactionType= 2
   
   Post the shipment with the workorderitemid, which then is pending clearance (normal pattern).
    
   Allow for printing      
   
  --->   
   
<cfset count = 0>
  
<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
    FROM     WorkOrder
	WHERE    WorkOrderId = '#url.workorderid#'	
</cfquery>	   
  
<!--- create batch --->

<cfset date = evaluate("Form.transactionDate_date")>	

<CF_DateConvert Value = "#date#">
<cfset dte = dateValue>		

<cfquery name="param" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   	   SELECT   *
	   FROM     Ref_ParameterMission
	   WHERE    Mission = '#get.mission#' 
</cfquery>

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

<cf_assignid>

<cftransaction>

<cfparam name="Form.DeliveryRequest" default="0">

<!--- record the batch --->
				
<cfquery name="Insert" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO WarehouseBatch
		    (Mission,
			 Warehouse, 
			 BatchWarehouse,					
			 BatchReference,		
		 	 BatchNo,
			 BatchClass, 	
			 BatchId,
			 BatchDescription,		
			 BatchMemo,			
			 TransactionDate,
			 TransactionType, 					
			 ActionStatus,
			 DeliveryMode,	
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
	VALUES 	('#get.mission#',
		     '#form.warehouse#',
			 '#form.warehouse#',					
			 '#Form.BatchReference#',
			 '#batchNo#',	
			 'WOShip',
			 '#rowguid#',
			 'WorkOrder Shipment',										
			 '#Form.BatchMemo#',
			 #dte#,
			 '2',					
			 '0',
			 '#form.DeliveryRequest#',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')
</cfquery>

<!--- -------------------- --->
<!--- post the sales lines --->
<!--- --------------------- --->   
   
<cfquery name="getWorkOrderLines" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    WIL.WorkOrderItemId, 
	          WIL.WorkOrderId, 
			  WIL.WorkOrderLine, 
			  WIL.CommodityCode,
			  I.Category, 
			  WIL.ItemNo, 
			  C.StockControlMode,
			  WIL.UoM, 
			  WL.OrgUnitImplementer, 
			  Currency, 
			  SalePrice,
			  SaleTax,
			  TaxCode,
			  TaxExemption,
			  TaxIncluded,
			  SaleAmountTax
	FROM      WorkOrder.dbo.WorkOrderLineItem WIL INNER JOIN
              Materials.dbo.Item I           ON WIL.ItemNo = I.ItemNo INNER JOIN
			  Materials.dbo.Ref_Category C   ON C.Category = I.Category INNER JOIN
              WorkOrder.dbo.WorkOrderLine WL ON WIL.WorkOrderId = WL.WorkOrderId AND WIL.WorkOrderLine = WL.WorkOrderLine 
	WHERE     WIL.WorkOrderId = '#url.workorderid#'	
</cfquery>	

<cfloop query="getWorkOrderLines">		

		<cfquery name="AccountStock"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT  GLAccount
				FROM    Ref_CategoryGLedger
				WHERE   Category  = '#Category#' 
				AND     Area      = 'Stock'
				AND     GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
		</cfquery>		
		
		<!--- first step we can look at the workorder account --->
																		
		<cfquery name="AccountCOGS"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT  GLAccount
				FROM    Ref_CategoryGLedger
				WHERE   Category = '#Category#' 
				AND     Area     = 'COGS'
				AND     GLAccount IN (SELECT GLAccount 
				                      FROM   Accounting.dbo.Ref_Account)
		</cfquery>	
							
		<cfif AccountCOGS.recordcount eq "0" or AccountStock.recordcount eq "0">
		   
		   <table align="center">
		      	<tr>
				   <td class="labelit" align="center"><font color="FF0000">Attention : GL Account for stock and/or COGS production has not been defined</td>
				</tr>
		   </table>
		   <cfabort>
		
		</cfif>	

        <cfif StockControlMode eq "stock">

        	<!---added by kherrera:20160513--->
        	<cfquery name="qGetWODetail" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  	SELECT  I.*, WL.*, W.*
					FROM    WorkOrder.dbo.WorkOrderLineItem I, 
					        WorkOrder.dbo.WorkOrderLine WL,
					        WorkOrder.dbo.WorkOrder W
					WHERE   I.WorkOrderId    = W.WorkOrderId
					AND     WL.WorkOrderId   = I.WorkorderId
					AND     WL.WorkOrderLine = I.WorkOrderLine
					AND     I.WorkorderItemId = '#workorderItemId#'	
			</cfquery>  

			<cfquery name="Class" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			  	SELECT   * 
				FROM     WorkOrder.dbo.Ref_ServiceItemDomainClass 
				WHERE    ServiceDomain  = '#qGetWODetail.ServiceDomain#'
				AND      Code           = '#qGetWODetail.ServiceDomainClass#'	
			</cfquery> 
					
			<!--- existing mode --->
									
			<cfquery name="getstock" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT     T.Mission,
				           T.Warehouse,
				           T.ItemNo,
						   I.Category,
				           T.TransactionUoM,
						   U.ItemUoMId,
						   T.Location, 						           
						   T.TransactionLot, 
						   PL.TransactionLotSerialNo,
						   ISNULL(SUM(T.TransactionQuantity), 0) AS OnHand 		
						   
			    FROM       Materials.dbo.ItemTransaction T INNER JOIN		              
			               Materials.dbo.ItemUoM U         ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM INNER JOIN		              
	              		   Materials.dbo.Item I            ON T.ItemNo = I.ItemNo INNER JOIN
			               Materials.dbo.ProductionLot PL  ON T.Mission = PL.Mission AND T.TransactionLot = PL.TransactionLot
						   
			    WHERE      T.Mission        = '#get.mission#' 
				AND        T.Warehouse      = '#form.warehouse#'

				<!---added by kherrera:20160513--->
				<cfif class.PointerOverdraw eq "0">	
					<!--- only earmarked lines can be taken here --->		
					AND        T.RequirementId = '#WorkOrderItemId#' 
				<cfelse>		
					
					<!--- any location/lot which has been used for shipment in this warehouse before --->
					AND        (
					
								T.RequirementId = '#WorkOrderItemId#'  OR 

							   ( T.ItemNo = '#qGetWODetail.ItemNo#' AND  T.TransactionUoM = '#qGetWODetail.UoM#' AND T.TransactionType = '2' )
							   
							   )
					            	
				</cfif>
				
				GROUP BY   T.Mission,
				           T.Warehouse,
				           T.ItemNo,
						   I.Category,
				           T.TransactionUoM,
						   U.ItemUoMId,
						   T.Location, 
				           T.TransactionLot,
						   PL.TransactionLotSerialNo  		
				
				<!---added by kherrera:20160513--->
				<cfif class.PointerOverdraw eq "0">
					HAVING 	 SUM(T.TransactionQuantity) > 0 	   					   
				</cfif>		   
						   
			</cfquery>  			
				
			<cfloop query="getStock">					 	
					
				<cfset id = replace(ItemUoMId,"-","","ALL")>
		
				<cfparam name="form.ship_#id#_#location#_#TransactionlotSerialNo#" default="0">
				<cfset shipment = evaluate("form.ship_#id#_#location#_#TransactionlotSerialNo#")>				
				<cfset shipment = replaceNoCase(shipment,",","","ALL")> 
											
				<cfif shipment gt "0">
	
					<cfif shipment gt onhand>					
						<cfset qty = onhand*-1>					
					<cfelse>					
						<cfset qty = shipment*-1>					
					</cfif>	

					<!---added by kherrera:20160513--->
					<cfif class.PointerOverdraw eq "1">
						<cfset qty = shipment*-1>	   					   
					</cfif>				
																							
					<cfif isValid("numeric",qty)>		

						<cfif qty neq 0>															
																									
							<cf_assignid>						
							<cfset count = count+1>
							
							<!--- posting --->	
							
							<cf_StockTransact 
							    DataSource            = "AppsMaterials" 
								TransactionId         = "#rowguid#"	
							    TransactionType       = "2"  <!--- COGS --->
								TransactionSource     = "WorkorderSeries"
								ItemNo                = "#ItemNo#" 
								Mission               = "#Mission#" 
								Warehouse             = "#Warehouse#" 
								TransactionLot        = "#TransactionLot#" 						
								Location              = "#Location#"
								TransactionReference  = "#Form.BatchReference#"
								TransactionCurrency   = "#APPLICATION.BaseCurrency#"
								TransactionQuantity   = "#qty#"
								TransactionUoM        = "#TransactionUoM#"						
								TransactionLocalTime  = "Yes"
								TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
								TransactionTime       = "#timeformat(dte,'HH:MM')#"
								TransactionBatchNo    = "#batchno#"												
								GLTransactionNo       = "#batchNo#"
								WorkOrderId           = "#getWorkOrderLines.workorderid#"
								WorkOrderLine         = "#getWorkOrderLines.workorderline#"	
								RequirementId         = "#getWorkOrderLines.workorderItemId#"   <!--- important to keep the same --->
								OrgUnit               = "#getWorkOrderLines.orgunitimplementer#"
								GLAccountDebit        = "#AccountCOGS.GLAccount#"
								GLAccountCredit       = "#AccountStock.GLAccount#"
								Shipping              = "Yes"
								SalesCurrency         = "#getWorkOrderLines.currency#"
								SalesPrice            = "#getWorkOrderLines.SalePrice#"
								TaxPercentage         = "#getWorkOrderLines.SaleTax#"
								TaxCode               = "#getWorkOrderLines.TaxCode#"
								TaxExemption          = "#getWorkOrderLines.TaxExemption#"
								TaxIncluded           = "#getWorkOrderLines.TaxIncluded#"
								SalesTax              = "0">
							
						</cfif>									
											
					</cfif>
					
				</cfif>	
						
			</cfloop>
			
		<cfelse>
		
			<!--- indivdual mode --->
			
			<cfquery name="getTransaction" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    T.TransactionId,
				          T.Mission,
				          T.Warehouse,
				          T.ItemNo,						 
				          T.TransactionUoM,						  
						  T.Location, 						           
						  T.TransactionLot, 
						  T.TransactionReference,
						  T.TransactionQuantity,
                          (SELECT   ISNULL(SUM(TransactionQuantity), 0)
                            FROM     ItemTransaction
                            WHERE    TransactionidOrigin = T.TransactionId) AS QuantityUsed
				FROM       ItemTransaction T
				WHERE      T.Mission        = '#get.mission#'
				AND        T.Warehouse      = '#form.warehouse#'																
				AND        T.RequirementId  = '#WorkOrderItemId#' <!--- earmarked --->
				AND        T.TransactionIdOrigin IS NULL <!--- is a source transaction --->
				
				GROUP BY   T.TransactionId,
				           T.Mission,
				           T.Warehouse,
						   T.TransactionReference,
				           T.ItemNo,						 
				           T.TransactionUoM,						  
						   T.Location, 
				           T.TransactionLot,
						   T.TransactionQuantity 				
				
				<!--- transaction was not depleted yet --->
				
				HAVING    TransactionQuantity +
                              (SELECT     ISNULL(SUM(TransactionQuantity), 0)
                               FROM       ItemTransaction
                               WHERE      TransactionidOrigin = T.TransactionId) > 0
			
			</cfquery>									
							
			<cfloop query="getTransaction">					 	
								
				<cfset id = replace(TransactionId,"-","","ALL")>
		
				<cfparam name="form.ship_#id#" default="0">
				<cfset shipment = evaluate("form.ship_#id#")>
				<cfset shipment = replaceNoCase(shipment,",","","ALL")> 
											
				<cfif shipment gt "0">
					
					<!--- check the balance at this very moment again --->			
					<cfset onhand = TransactionQuantity + QuantityUsed>
	
					<cfif shipment gt onhand>					
						<cfset qty = onhand*-1>					
					<cfelse>					
						<cfset qty = shipment*-1>					
					</cfif>		
																												
					<cfif isValid("numeric",qty)>		
											
						<cfif qty neq 0>															
													
							<cf_assignid>						
							<cfset count = count+1>
							
							<!--- posting --->							
							
							<cf_StockTransact 
							    DataSource            = "AppsMaterials" 
								TransactionId         = "#rowguid#"	
								TransactionIdOrigin   = "#Transactionid#"  <!--- NEW --->
							    TransactionType       = "2"  <!--- COGS --->
								TransactionSource     = "WorkorderSeries"
								ItemNo                = "#ItemNo#" 
								Mission               = "#Mission#" 
								Warehouse             = "#Warehouse#" 
								TransactionLot        = "#TransactionLot#" 						
								Location              = "#Location#"
								TransactionReference  = "#TransactionReference#"
								TransactionCurrency   = "#APPLICATION.BaseCurrency#"
								TransactionQuantity   = "#qty#"
								TransactionUoM        = "#TransactionUoM#"						
								TransactionLocalTime  = "Yes"
								TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
								TransactionTime       = "#timeformat(dte,'HH:MM')#"
								TransactionBatchNo    = "#batchno#"												
								GLTransactionNo       = "#batchNo#"
								WorkOrderId           = "#getWorkOrderLines.workorderid#"
								WorkOrderLine         = "#getWorkOrderLines.workorderline#"	
								RequirementId         = "#getWorkOrderLines.workorderItemId#"   <!--- important to keep the same --->
								OrgUnit               = "#getWorkOrderLines.orgunitimplementer#"														
								GLAccountDebit        = "#AccountCOGS.GLAccount#"
								GLAccountCredit       = "#AccountStock.GLAccount#"
								Shipping              = "Yes"
								CommodityCode         = "#getWorkOrderLines.CommodityCode#"		
								SalesQuantity         = "#qty*-1#"
								SalesCurrency         = "#getWorkOrderLines.currency#"
								SalesPrice            = "#getWorkOrderLines.SalePrice#"
								TaxPercentage         = "#getWorkOrderLines.SaleTax#"
								TaxExemption          = "#getWorkOrderLines.TaxExemption#"
								TaxIncluded           = "#getWorkOrderLines.TaxIncluded#"								
								TaxCode 			  = "#getWorkOrderLines.TaxCode#">
								
								<!--- rfuentes 2017-06-09 to let StockTransact component calculate the Tax than then is saved to ItemTransactionShipping, which then
								is taken from SetTotal.cfm file to calculate the amount of the Tax at the moment the Invoice is issued --->
															
						</cfif>									
											
					</cfif>
					
				</cfif>	
						
			</cfloop>
				
		</cfif>	

</cfloop>

<cfif count eq 0>

	<script>
		alert("Problem no shipment lines were recorded.");
		<!---added by kherrera:20160513--->
		location.reload();
	</script>
	
	<cfoutput>
	
	<input type="submit" name="Submit" value="Submit" style="width:200" class="button10G" 
		  onclick="ptoken.navigate('ShipmentEntrySubmit.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#url.workorderid#','submitbox','','','POST','shipmentform')">
		  
	</cfoutput>	  
	
	<cfabort>
	
<cfelse>

	<cfoutput>

	<!--- refresh the screen in the full mode --->
	
	<script>
		ptoken.open('#session.root#/Warehouse/Application/Stock/Batch/BatchView.cfm?mode=process&trigger=workorder&mission=#get.mission#&batchno=#batchno#&systemfunctionid=#url.systemfunctionid#','_top')
	</script>
	
	</cfoutput>

</cfif>

</cftransaction>
