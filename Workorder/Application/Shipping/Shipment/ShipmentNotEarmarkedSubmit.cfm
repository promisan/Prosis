
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
    FROM     WorkOrderLineItem
	WHERE    WorkOrderItemId = '#url.WorkorderItemid#'	
</cfquery>	   
    
<cfquery name="workorder" 
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
	   WHERE    Mission = '#workorder.mission#' 
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
			 BatchId,
			 BatchClass,
			 BatchDescription,						
			 TransactionDate,
			 TransactionType, 					
			 ActionStatus,
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
	VALUES 	('#workorder.mission#',
		     '#url.warehouse#',
			 '#url.warehouse#',					
			 '#Form.BatchReference#',
			 '#batchNo#',	
			 '#rowguid#',
			 'WOEarmark',			 
			 'Earmark stock for workorder',										
			 #dte#,
			 '8',					
			 '1',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')
</cfquery>

<!--- ------------------------ --->
<!--- --post the sales lines-- --->
<!--- ------------------------ --->   

<cfinvoke component = "Service.Process.WorkOrder.WorkorderLineItem"  
   method           = "InternalWorkOrder" 
   datasource       = "appsMaterials"
   mission          = "#WorkOrder.Mission#" 
   Table            = "WorkOrderlineItem"
   PointerSale      = "#url.pointersale#"
   workorderid      = "#get.WorkOrderId#"
   workorderline    = "#get.WorkOrderLine#"
   mode             = "view"
   returnvariable   = "NotEarmarked">	 
									
<cfquery name="getstock" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT     T.Mission,
	           T.Warehouse,
	           T.ItemNo,
			   I.Category,
	           T.TransactionUoM,
			   C.StockControlMode,
			   U.ItemUoMId,
			   T.Location, 						           
			   T.TransactionLot, 
			   PL.TransactionLotSerialNo,
			   T.WorkOrderId,
			   T.WorkOrderLine,
			   T.RequirementId,
			   ISNULL(SUM(T.TransactionQuantity), 0) AS OnHand 		
			   
    FROM       Materials.dbo.ItemTransaction T INNER JOIN		              
               Materials.dbo.ItemUoM U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM INNER JOIN		              			   
               Materials.dbo.Item I ON T.ItemNo = I.ItemNo INNER JOIN
			   Materials.dbo.Ref_Category C ON C.Category = I.Category INNER JOIN
               Materials.dbo.ProductionLot PL     ON T.Mission = PL.Mission AND T.TransactionLot = PL.TransactionLot
			   
			   
    WHERE      T.Mission        = '#workorder.mission#' 
	AND        T.Warehouse      = '#url.warehouse#'
	
	<!--- only non-earmarked lines can be earmarked --->
	
	AND        (
	
	<!--- ----------------------------------------------------------- --->
	<!--- get any items that are the same of the sales item directly  --->
	<!--- ----------------------------------------------------------- --->
	
	           (  T.ItemNo = '#get.ItemNo#' 
				  AND T.TransactionUoM = '#get.UoM#' 
				  <cfif url.pointersale eq "0">
					  AND (T.RequirementId is NULL or T.RequirementId IN (#preserveSingleQuotes(NotEarmarked)#))				  
				  <cfelse>
					  AND (T.RequirementId IN (#preserveSingleQuotes(NotEarmarked)#))	
				  </cfif>				  			  
			   )  
			   
	<!--- ---------------------------------------------------------------- --->
	<!--- get any items that are associated to the sales item in the stock --->
	<!--- ---------------------------------------------------------------- --->		   
			   
			   <!--- 
			   OR
			   
			   (
			   
			   )
			   
			   --->
			   
			   )
			
	GROUP BY   T.Mission,
	           T.Warehouse,
	           T.ItemNo,
			   I.Category,
	           T.TransactionUoM,
			   C.StockControlMode,
			   U.ItemUoMId,
			   T.Location, 
	           T.TransactionLot,
			   PL.TransactionLotSerialNo,  
			   <!--- added 30/12 --->	   				  
			   T.RequirementId,	  
			   T.WorkOrderId,
			   T.WorkorderLine 	  		
			   
	HAVING 	 SUM(T.TransactionQuantity) > 0 	   					   
			   
</cfquery>  
		
<cfloop query="getStock">		
				
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
			AND     GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
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
	
		<cfset id = replace(ItemUoMId,"-","","ALL")>
		<cfset reqid = replace(RequirementId,"-","","ALL")>
	
		<cfparam name="form.earmark_#id#_#location#_#TransactionlotSerialNo#_#reqid#" default="0">
		<cfset earmark = evaluate("form.earmark_#id#_#location#_#TransactionlotSerialNo#_#reqid#")>
									
		<cfif earmark gt "0">
	
			<cfif earmark gt onhand>					
				<cfset qty = onhand>					
			<cfelse>					
				<cfset qty = earmark>					
			</cfif>					
																					
			<cfif isValid("numeric",qty)>		
									
				<cfif qty neq 0>															
											
					<cf_assignid>	
										
					<cfset count = count+1>
					<cfset parid = rowguid>
					
					<!--- -------------------- --->
					<!--- -lower unearmarked-- --->
					<!--- -------------------- --->	
					
					<cf_StockTransact 
					    DataSource            = "AppsMaterials" 
						TransactionId         = "#rowguid#"	
					    TransactionType       = "8"  <!--- COGS --->
						TransactionSource     = "WorkorderSeries"
						ItemNo                = "#ItemNo#" 
						Mission               = "#Mission#" 
						Warehouse             = "#Warehouse#" 
						TransactionLot        = "#TransactionLot#" 						
						Location              = "#Location#"
						TransactionReference  = "#Form.BatchReference#"
						TransactionCurrency   = "#APPLICATION.BaseCurrency#"
						TransactionQuantity   = "#-qty#"
						TransactionUoM        = "#TransactionUoM#"						
						TransactionLocalTime  = "Yes"
						TransactionDate       = "#dateformat(date,CLIENT.DateFormatShow)#"
						TransactionTime       = "#timeformat(date,'HH:MM')#"
						TransactionBatchNo    = "#batchno#"												
						GLTransactionNo       = "#batchNo#"
						WorkOrderId           = "#workorderid#"
						WorkOrderLine         = "#workorderline#"	
						RequirementId         = "#requirementid#"																
						GLAccountDebit        = "#AccountCOGS.GLAccount#"
						GLAccountCredit       = "#AccountStock.GLAccount#">
					
					<!--- -------------------- --->	
					<!--- --higher earmarked-- --->	
					<!--- -------------------- --->
					
					<cf_assignid>
					
					<cf_StockTransact 
					    DataSource            = "AppsMaterials" 
						TransactionId         = "#rowguid#"	
					    TransactionType       = "8"  <!--- COGS --->
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
						TransactionDate       = "#dateformat(date,CLIENT.DateFormatShow)#"
						TransactionTime       = "#timeformat(date,'HH:MM')#"
						TransactionBatchNo    = "#batchno#"												
						GLTransactionNo       = "#batchNo#"
						ParentTransactionId   = "#parid#"
						WorkOrderId           = "#get.workorderid#"
						WorkOrderLine         = "#get.workorderline#"	
						RequirementId         = "#get.workorderItemId#"   <!--- important to keep the same --->					
						GLAccountCredit       = "#AccountCOGS.GLAccount#"
						GLAccountDebit        = "#AccountStock.GLAccount#">					
					
				</cfif>									
									
			</cfif>
			
		</cfif>	
		
	<cfelse>
	
		<!--- Hanno 18/11/2013 attention the below query could well not be the same as the above query for its total, 
				this has to be carefully analyses and then tuned the query to prevent it --->
								
		<cfquery name="getTransaction" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     TransactionId, 
			           ItemNo, 
					   ItemDescription, 
					   Location,
					   TransactionDate, 
					   TransactionLot,
					   TransactionUoM,
					   TransactionReference, 
					   TransactionQuantity,
					   WorkOrderId,
					   WorkOrderLine,
					   RequirementId,
                           (SELECT   ISNULL(SUM(TransactionQuantity), 0)
                            FROM     ItemTransaction
                            WHERE    TransactionidOrigin = T.TransactionId) AS QuantityUsed
			FROM       ItemTransaction T
			WHERE      T.Mission        = '#workorder.mission#'
			AND        T.Warehouse      = '#url.warehouse#'
			AND        T.Location       = '#Location#'										
			AND        T.ItemNo         = '#ItemNo#'
			AND        T.TransactionUoM = '#TransactionUoM#' 
			AND        T.TransactionLot = '#TransactionLot#'
			AND        (T.RequirementId is NULL or T.RequirementId IN (#preserveSingleQuotes(notEarmarked)#))	<!--- not earmarked --->
			AND        T.TransactionIdOrigin IS NULL <!--- is a source transaction --->
			
			GROUP BY  TransactionId, 
			          ItemNo, 
					  Location,
					  ItemDescription, 
					  TransactionDate, 
					  TransactionLot,
					  TransactionUoM,
					  TransactionReference, 
					  TransactionQuantity,
					  WorkOrderId,
					  WorkOrderLine,
					  RequirementId
			
			<!--- transaction was not depleted yet --->
			
			HAVING    TransactionQuantity +
                             (SELECT     ISNULL(SUM(TransactionQuantity), 0)
                              FROM       ItemTransaction
                              WHERE      TransactionidOrigin = T.TransactionId) > 0
						   
		
		</cfquery>							
		
		<cfloop query="getTransaction">
	
			<cfset id = replace(TransactionId,"-","","ALL")>
		
			<cfparam name="form.earmark_#id#" default="0">
			<cfset earmark = evaluate("form.earmark_#id#")>
										
			<cfif earmark gt "0">
			
				<!--- check the balance at this very moment again --->			
				<cfset onhand = TransactionQuantity + QuantityUsed>
		
				<cfif earmark gt onhand>					
					<cfset qty = onhand>					
				<cfelse>					
					<cfset qty = earmark>					
				</cfif>					
																						
				<cfif isValid("numeric",qty)>		
										
					<cfif qty neq 0>															
												
						<cf_assignid>	
											
						<cfset count = count+1>
						<cfset parid = rowguid>
						
						<!--- -------------------- --->
						<!--- -lower unearmarked-- --->
						<!--- -------------------- --->	
						
						<cf_StockTransact 
						    DataSource            = "AppsMaterials" 
							TransactionId         = "#rowguid#"	
							TransactionIdOrigin   = "#Transactionid#"
						    TransactionType       = "8"  <!--- COGS --->
							TransactionSource     = "WorkorderSeries"
							ItemNo                = "#ItemNo#" 
							Mission               = "#workorder.Mission#" 
							Warehouse             = "#url.Warehouse#" 
							TransactionLot        = "#TransactionLot#" 						
							Location              = "#Location#"
							TransactionReference  = "#TransactionReference#"
							TransactionCurrency   = "#APPLICATION.BaseCurrency#"
							TransactionQuantity   = "#-qty#"
							TransactionUoM        = "#TransactionUoM#"						
							TransactionLocalTime  = "Yes"
							TransactionDate       = "#dateformat(date,CLIENT.DateFormatShow)#"
							TransactionTime       = "#timeformat(date,'HH:MM')#"
							TransactionBatchNo    = "#batchno#"												
							GLTransactionNo       = "#batchNo#"		
																		
							WorkOrderId           = "#workorderid#"
							WorkOrderLine         = "#workorderline#"		
							RequirementId         = "#RequirementId#"   								
							
							GLAccountDebit        = "#AccountCOGS.GLAccount#"
							GLAccountCredit       = "#AccountStock.GLAccount#">
						
						<!--- -------------------------------------------------------- --->	
						<!--- --higher earmarked and create a new source transaction-- --->	
						<!--- -------------------------------------------------------- --->
						
						<cf_assignid>
						
						<cf_StockTransact 
						    DataSource            = "AppsMaterials" 
							TransactionId         = "#rowguid#"	
						    TransactionType       = "8"  <!--- COGS --->
							TransactionSource     = "WorkorderSeries"
							ItemNo                = "#ItemNo#" 
							Mission               = "#WorkOrder.Mission#" 
							Warehouse             = "#url.Warehouse#" 
							TransactionLot        = "#TransactionLot#" 						
							Location              = "#Location#"
							TransactionReference  = "#TransactionReference#"
							TransactionCurrency   = "#APPLICATION.BaseCurrency#"
							TransactionQuantity   = "#qty#"
							TransactionUoM        = "#TransactionUoM#"						
							TransactionLocalTime  = "Yes"
							TransactionDate       = "#dateformat(date,CLIENT.DateFormatShow)#"
							TransactionTime       = "#timeformat(date,'HH:MM')#"
							TransactionBatchNo    = "#batchno#"												
							GLTransactionNo       = "#batchNo#"
							ParentTransactionId   = "#parid#"
							WorkOrderId           = "#get.workorderid#"
							WorkOrderLine         = "#get.workorderline#"	
							RequirementId         = "#get.workorderItemId#"   <!--- important to keep the same --->					
							GLAccountCredit       = "#AccountCOGS.GLAccount#"
							GLAccountDebit        = "#AccountStock.GLAccount#">					
						
					</cfif>		
											
				</cfif>
					
		</cfif>	
		
		</cfloop>		
	
	</cfif>	
			
</cfloop>

</cftransaction>

<cfoutput>
<script>
  earmarkrefresh('#url.warehouse#','#url.workorderitemid#')
  ProsisUI.closeWindow('myearmark',true)
</script>
</cfoutput>
