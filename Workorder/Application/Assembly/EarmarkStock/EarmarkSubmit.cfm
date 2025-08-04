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

<!--- meta code : 

   loop through the lines and validate if the quantity <= stock on hand still 
   
   create a batch record per warehouse : 
   
   BatchDescription = "WorkOrder Earmark"
   BatchReference = workorder
   BatchId = wokrorderid
   Location,ItemNo, UoM = null
   Warehouse
   TransactionType= 2
   
   Post the shipment with the workorderitemid, which then is pending clearance (normal pattern).
    
   Allow for printing      
   
--->   

<cfset count = 0>
    
<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
	    FROM     WorkOrder
		WHERE    WorkOrderId = '#form.workorderid#'	
</cfquery>	   
	
<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  	SELECT    * 
		FROM      WorkOrderLineItem I, WorkOrder W
		WHERE     I.WorkOrderId   = W.WorkOrderId
		<cfif form.selectline neq "">
		AND   WorkorderItemId = '#form.selectline#'	
		<cfelse>
		AND   1=0
		</cfif>				
</cfquery>  
  
<!--- create batch --->

<cfset date = dateformat(now(),CLIENT.DateFormatShow)>
<CF_DateConvert>
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
	 SELECT    TOP 1 *
	 FROM      WarehouseBatch
	 ORDER BY  BatchNo DESC
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
		VALUES ('#workorder.mission#',
			    '#form.warehouseto#',
				'#form.warehouse#',					
				'#Form.BatchReference#',
				'#batchNo#',	
				'#rowguid#',
				'WOEarmark',			 
				'Earmark stock for workorder',										
				#dte#,
				'8',		<!--- transfer --->			
				'1',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')
	</cfquery>	
										
	<cfquery name="getstock" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
	    SELECT     T.ItemNo,	          
				   I.ItemDescription,
				   C.StockControlMode,
				   C.Category,
				   I.Classification,
				   T.TransactionUoM,
				   U.UoMDescription,	
				   U.ItemUoMId,			
				   T.Location, 
				   I.ItemPrecision,		           
				   T.TransactionLot, 
				   PL.TransactionLotSerialNo, 				 
				   T.WorkOrderId,
				   T.WorkOrderLine,
			       T.RequirementId,
				   ISNULL(SUM(T.TransactionQuantity), 0) AS OnHand 			 
				   
	    FROM       Materials.dbo.ItemTransaction T INNER JOIN	                            
		           Materials.dbo.Item I               ON I.ItemNo = T.ItemNo     INNER JOIN
				   Materials.dbo.Ref_Category C       ON C.Category = I.Category INNER JOIN
	               Materials.dbo.ItemUoM U            ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM INNER JOIN
				   Materials.dbo.ProductionLot PL     ON T.Mission   = PL.Mission AND T.TransactionLot = PL.TransactionLot
				   
	    WHERE      T.Mission         = '#workorder.mission#' 
		AND        T.Warehouse       = '#Form.warehouse#'		
		AND        T.ItemNo          = '#Form.itemno#' 		
		AND        T.TransactionUoM  = '#Form.uom#'
		
		<cfif FORM.ListWorkOrderItemId eq "">
		AND        T.RequirementId is NULL <!--- not earmarked --->
		<cfelse>			
		AND        T.RequirementId IN (#preservesingleQuotes(FORM.ListWorkOrderItemId)#) 
		</cfif>
		
		GROUP BY   T.ItemNo,
					   I.ItemDescription,
					   I.Classification,
					   I.ItemPrecision,
					   C.StockControlMode,
					   C.Category,
				   T.TransactionUoM,
					   U.UoMDescription,
					   U.ItemUoMId,
				   T.Location, 			  
		           T.TransactionLot,
				       PL.TransactionLotSerialNo,
				   T.RequirementId,
					   T.WorkOrderId,
					   T.WorkOrderLine
			       				   
		HAVING 	 SUM(T.TransactionQuantity) > 0 	
			
		ORDER BY I.ItemDescription,
		         T.ItemNo,
				 U.ItemUomId  					 		   
			   
	</cfquery> 
								
	<cfloop query="getStock">		
	
		<cfif get.recordcount eq "1">
		
			<cfset targetworkorderid   = get.workorderid>
			<cfset targetworkorderline = get.workorderline>
			<cfset targetrequirementid = get.workorderitemid>	
			
				
		<cfelse>
			<cfset targetworkorderid   = workorderid>
			<cfset targetworkorderline = workorderline>
			<cfset targetrequirementid = requirementid>
		</cfif>
					
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
		   
			<script>
				Prosis.busy('no')
			</script>
   
		   <cfabort>
		
		</cfif>
		
		<cfif StockControlMode eq "stock">
		
			<cfset id = replace(ItemUoMId,"-","","ALL")>
			<cfset reqid = replace(RequirementId,"-","","ALL")>
		
			<cfparam name="form.transfer_#id#_#location#_#TransactionlotSerialNo#_#reqid#" default="0">
			<cfset earmark = evaluate("form.transfer_#id#_#location#_#TransactionlotSerialNo#_#reqid#")>
										
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
							Mission               = "#workorder.Mission#" 
							Warehouse             = "#Warehouse#" 
							TransactionLot        = "#TransactionLot#" 						
							Location              = "#Location#"
							TransactionReference  = "#Form.BatchReference#"
							TransactionCurrency   = "#APPLICATION.BaseCurrency#"
							TransactionQuantity   = "#-qty#"
							TransactionUoM        = "#TransactionUoM#"						
							TransactionLocalTime  = "Yes"
							TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
							TransactionTime       = "#timeformat(now(),'HH:MM')#"
							TransactionBatchNo    = "#batchno#"												
							GLTransactionNo       = "#batchNo#"
							WorkOrderId           = "#getstock.workorderid#"
							WorkOrderLine         = "#getstock.workorderline#"	
							RequirementId         = "#getstock.requirementid#"																
							GLAccountDebit        = "#AccountCOGS.GLAccount#"
							GLAccountCredit       = "#AccountStock.GLAccount#">
						
						<!--- -------------------- --->	
						<!--- --higher earmarked-- --->	
						<!--- -------------------- --->
						
						<cf_assignid>
						
						<cfif Form.LocationTo eq "">
							<cfset locationto = location>
						<cfelse>
						    <cfset locationto = form.locationto>
						</cfif>
						
						<!--- new warehouse / location --->
																								
						<cf_StockTransact 
						    DataSource            = "AppsMaterials" 
							TransactionId         = "#rowguid#"	
						    TransactionType       = "8"  <!--- transfer --->
							TransactionSource     = "WorkorderSeries"
							ItemNo                = "#ItemNo#" 
							Mission               = "#workorder.Mission#" 																					
							Warehouse             = "#Form.WarehouseTo#" 										
							Location              = "#LocationTo#"														
							TransactionLot        = "#TransactionLot#" 			
							TransactionReference  = "#Form.BatchReference#"
							TransactionCurrency   = "#APPLICATION.BaseCurrency#"
							TransactionQuantity   = "#qty#"
							TransactionUoM        = "#TransactionUoM#"						
							TransactionLocalTime  = "Yes"
							TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
							TransactionTime       = "#timeformat(now(),'HH:MM')#"
							TransactionBatchNo    = "#batchno#"												
							GLTransactionNo       = "#batchNo#"
							ParentTransactionId   = "#parid#"
							WorkOrderId           = "#targetworkorderid#"
							WorkOrderLine         = "#targetworkorderline#"	
							RequirementId         = "#targetrequirementId#"   <!--- important to keep the same --->					
							GLAccountCredit       = "#AccountCOGS.GLAccount#"
							GLAccountDebit        = "#AccountStock.GLAccount#">		
									
						
					</cfif>									
										
				</cfif>
				
			</cfif>	
			
		<cfelse>
		
			<!--- Hanno 18/11/2013 attention the below query could well not be the same as the above query for its total, 
					this has to be carefully analyses and then tuned the query to prevent it 
					
				NOTE: based on the item 
				we are getting the individual source transactions for this item in order to them
				make issuances to the other item from it. 
										
			--->
									
			<cfquery name="getTransaction" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    TransactionId, 
					          ItemNo, 
							  ItemDescription, 
							  ItemPrecision,
							  TransactionDate, 
							  TransactionReference, 
							  TransactionQuantity,
	                            (SELECT   ISNULL(SUM(TransactionQuantity), 0)
	                             FROM     ItemTransaction
	                             WHERE    TransactionidOrigin = T.TransactionId) AS QuantityUsed
					FROM       ItemTransaction T
					WHERE      T.Mission        = '#workorder.mission#'
					AND        T.Warehouse      = '#form.warehouse#'
					AND        T.Location       = '#Location#'										
					AND        T.ItemNo         = '#ItemNo#'
					AND        T.TransactionUoM = '#TransactionUoM#' 
					AND        T.TransactionLot = '#TransactionLot#'
					<cfif requirementid eq "">
					AND        T.RequirementId  IS NULL <!--- not earmarked --->
					<cfelse>
					AND        T.RequirementId  = '#RequirementId#' <!--- earmarked --->
					</cfif>
					AND        T.TransactionIdOrigin IS NULL <!--- is a source transaction --->
					
					GROUP BY  TransactionId, 
					          ItemNo, 
							  ItemDescription, 
							  ItemPrecision,
							  TransactionDate, 
							  TransactionReference, 
							  TransactionQuantity
					
					<!--- transaction was not depleted yet --->
					
					HAVING    TransactionQuantity +
	                              (SELECT     ISNULL(SUM(TransactionQuantity), 0)
	                               FROM       ItemTransaction
	                               WHERE      TransactionidOrigin = T.TransactionId) > 0
							
			</cfquery>
			
			<cfloop query="getTransaction">
		
				<cfset id = replace(TransactionId,"-","","ALL")>
			
				<cfparam name="form.transfer_#id#" default="0">
				<cfset earmark = evaluate("form.transfer_#id#")>
				<cfset earmark = replaceNoCase(earmark,",","","ALL")>	
											
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
							    TransactionType       = "8"  <!--- transfer --->
								TransactionSource     = "WorkorderSeries"
								ItemNo                = "#getstock.ItemNo#" 
								Mission               = "#workorder.Mission#" 
								Warehouse             = "#form.Warehouse#" 
								Location              = "#getstock.Location#"								
								TransactionLot        = "#getstock.TransactionLot#" 						
								
								TransactionReference  = "#TransactionReference#"
								TransactionCurrency   = "#APPLICATION.BaseCurrency#"
								TransactionQuantity   = "#-qty#"
								TransactionUoM        = "#getstock.TransactionUoM#"						
								TransactionLocalTime  = "Yes"
								TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
								TransactionTime       = "#timeformat(now(),'HH:MM')#"
								TransactionBatchNo    = "#batchno#"												
								GLTransactionNo       = "#batchNo#"		
																			
								WorkOrderId           = "#getstock.workorderid#"
								WorkOrderLine         = "#getstock.workorderline#"		
								RequirementId         = "#getstock.RequirementId#"   								
								
								GLAccountDebit        = "#AccountCOGS.GLAccount#"
								GLAccountCredit       = "#AccountStock.GLAccount#">
							
							<!--- -------------------------------------------------------- --->	
							<!--- --higher earmarked and create a new source transaction-- --->	
							<!--- -------------------------------------------------------- --->
							
							<cf_assignid>
														
							<cfif Form.LocationTo eq "">
								<cfset locationto = getstock.location>
							<cfelse>
							    <cfset locationto = form.locationto>
							</cfif>
							
							<cf_StockTransact 
							    DataSource            = "AppsMaterials" 
								TransactionId         = "#rowguid#"	
							    TransactionType       = "8"  <!--- transfer --->
								TransactionSource     = "WorkorderSeries"
								ItemNo                = "#getstock.ItemNo#" 
								Mission               = "#WorkOrder.Mission#" 
								
								Warehouse             = "#form.WarehouseTo#" 
								Location              = "#locationto#"
								
								TransactionLot        = "#getstock.TransactionLot#" 						
								
								TransactionReference  = "#TransactionReference#"
								TransactionCurrency   = "#APPLICATION.BaseCurrency#"
								TransactionQuantity   = "#qty#"
								TransactionUoM        = "#getstock.TransactionUoM#"						
								TransactionLocalTime  = "Yes"
								TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
								TransactionTime       = "#timeformat(now(),'HH:MM')#"
								TransactionBatchNo    = "#batchno#"												
								GLTransactionNo       = "#batchNo#"
								ParentTransactionId   = "#parid#"
								WorkOrderId           = "#targetworkorderid#"
								WorkOrderLine         = "#targetworkorderline#"	
								RequirementId         = "#targetrequirementid#"   <!--- important to keep the same --->					
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
		_cf_loadingtexthtml='';	
		// reflect the from box
		ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/getStockLevel.cfm?workorderidselect=#getstock.workorderid#&mission=#workorder.mission#&warehouse='+document.getElementById('warehouse').value+'&itemno='+document.getElementById('itemno').value+'&uom='+document.getElementById('uom').value+'&workorderid='+document.getElementById('workorderid').value+'&workorderline='+document.getElementById('workorderline').value,'stockbox')
		// refresh the to box 
		ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/WorkOrderListing.cfm?mission=#workorder.mission#&warehouse=#form.warehouseto#&workorderid='+document.getElementById('workorderid').value+'&workorderline='+document.getElementById('workorderline').value,'orderbox')
		Prosis.busy('no')
		ptoken.open('#session.root#/Warehouse/Application/Stock/Batch/BatchView.cfm?mode=process&trigger=workorder&mission=#workorder.mission#&batchno=#batchno#&systemfunctionid='+document.getElementById('systemfunctionid').value,'_blank','left=30, top=30, width=' + w + ', height= ' + h + ', toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes')

	</script>
   
</cfoutput>   

