<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.loc"          default="">
<cfparam name="url.stockorderid" default="">

<cf_tl id="Accounting information is not available." var="1" class="Message">
<cfset msg1="#lt_text#">

<cf_tl id="Operation not allowed." var="1" class="Message">
<cfset msg2="#lt_text#">	

<!--- Make sure that the resulting stock is not negative--->

<cfquery name="ObtainStockOnHand"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

	SELECT TransferQuantity,
	
			( SELECT ROUND(SUM(IT.TransactionQuantity),2)
			  FROM   Materials.dbo.ItemTransaction IT
			  WHERE  T.Warehouse      = IT.Warehouse
			  AND    T.Location       = IT.Location
			  AND    T.TransactionLot = IT.TransactionLot					
			  AND    T.ItemNo	      = IT.ItemNo
			  AND    T.UnitOfMeasure  = IT.TransactionUoM ) as OnHand
	
	FROM   Transfer#URL.Whs#_#SESSION.acc# T
	WHERE  TransferQuantity > 0 			

</cfquery>

<cfquery name="check" dbtype="query">
	SELECT * FROM ObtainStockOnHand
	WHERE TransferQuantity > OnHand
</cfquery>	 

<cfif Check.recordcount gte 1>

	<cf_tl id="Stock values have changed since you opened this page"  var="vNegative1" class="Message">
	<cf_tl id="Please reload the page and submit your transfer again" var="vNegative2" class="Message">
	
	<cfoutput>
		<script language="JavaScript">
			alert('#vNegative1#. #vNegative2#.');
			Prosis.busy('no')			
			stocktransfer('','#url.systemfunctionid#','#url.stockorderid#');
		</script>
	</cfoutput>

	<cfabort>
	
</cfif>

<!--- define the content of the transactions recorded for transfer and/or conversion, the conversion and transfer transactions
will be put into different batches as they could have different process flows as each is handled as a different type --->

<cfset tot = 0>
<cfset batches = "">


<cfloop index="actiontype" list="Transfer,Conversion">

	<cfif actiontype eq "Transfer">
	     <cfset url.tpe = "8">
	<cfelse>
		 <cfset url.tpe = "6">
	</cfif>		
	
	<cfquery name="ObtainMode"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   WarehouseTransaction
		WHERE  Warehouse       = '#url.whs#'
		AND    TransactionType = '#url.tpe#'
	</cfquery>
	
	<!--- we obtain the warehouse of transfer in between --->
	
	<cfquery name="getBatch"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    <cfif ObtainMode.PreparationMode eq "0">
	    SELECT   DISTINCT TransferWarehouse, TransferLocation 				 
		<cfelseif ObtainMode.PreparationMode eq "1">
		SELECT   DISTINCT TransferWarehouse 		
		<cfelse>
		SELECT   DISTINCT Warehouse
		</cfif>
		FROM     Transfer#URL.Whs#_#SESSION.acc# S
		<cfif actiontype eq "Transfer">
		WHERE    (TransferItemNo = ItemNo OR TransferItemNo IS NULL) AND (Location <> TransferLocation OR Warehouse <> TransferWarehouse)
		<cfelse>
		WHERE    TransferItemNo <> ItemNo AND TransferItemNo IS NOT NULL
		</cfif>
		AND      TransferLocation IN (SELECT Location 
		                              FROM   Materials.dbo.WarehouseLocation 
									  WHERE  Warehouse = S.TransferWarehouse) 
		AND      TransferQuantity IS NOT NULL				
	</cfquery>	
	
	<cfset tot = tot + getBatch.Recordcount>	
					
		<cfloop query="getBatch">	   
		
			<cfquery name="Lines"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   *, 
				
					  (SELECT    TOP 1 ClearanceMode 
						  FROM   Materials.dbo.WarehouseTransaction
						  WHERE  Warehouse   = S.Warehouse					
						  AND    Operational = 1
						  AND    TransactionType = '#url.tpe#') as ParentClearanceMode,
					
					 (SELECT TOP 1 EntityClass 
						  FROM   Materials.dbo.ItemWarehouseLocationTransaction
						  WHERE  Warehouse   = S.Warehouse					
						  AND    Operational = 1
						  AND    TransactionType = '#url.tpe#') as ParentEntityClass,	  
				
				   	 (SELECT TOP 1 ClearanceMode 
						  FROM  Materials.dbo.ItemWarehouseLocationTransaction
						  WHERE Warehouse   = S.Warehouse
						  AND   Location    = S.Location
						  AND   ItemNo      = S.ItemNo
						  AND   UoM         = S.UnitOfMeasure
						  AND   Operational = 1
						  AND   TransactionType = '#url.tpe#') as ItemClearanceMode,
				
				    (SELECT TOP 1 EntityClass 
						  FROM Materials.dbo.ItemWarehouseLocationTransaction
						  WHERE Warehouse   = S.Warehouse
						  AND   Location    = S.Location
						  AND   ItemNo      = S.ItemNo
						  AND   UoM         = S.UnitOfMeasure
						  AND   Operational = 1
						  AND   TransactionType = '#url.tpe#') as ItemEntityClass
								 			  					
						 
				FROM     Transfer#URL.Whs#_#SESSION.acc# S
				<cfif actiontype eq "Transfer">
				WHERE    (TransferItemNo = ItemNo OR TransferItemNo IS NULL)
				<cfelse>
				WHERE    TransferItemNo <> ItemNo AND TransferItemNo IS NOT NULL
				</cfif>
				
				<cfif ObtainMode.PreparationMode eq "0">
				AND      TransferWarehouse = '#transferWarehouse#'
				AND      TransferLocation  = '#transferLocation#'	
				<cfelseif ObtainMode.PreparationMode eq "1">
				AND      TransferWarehouse = '#transferWarehouse#'
				<cfelse>
				<!--- no filter --->
				</cfif>				
				and      TransferQuantity is not NULL AND TransferQuantity <> 0
				ORDER BY TransactionDate DESC						
			</cfquery>		
						
			<cfif Lines.ItemClearanceMode eq "">
			
				<cfset clearance = Lines.ParentClearanceMode>
				<cfset level     = "parent">  <!--- to determine which field to take --->
				
			<cfelse>
			
				<cfset clearance = Lines.ItemClearanceMode>		
				<cfset level     = "item">	
			
			</cfif>
			
			<cfif Lines.recordcount gte "1">
							
				<cftransaction>
				
					<!--- we assign a batchno --->
							
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
					
					<cfif batches eq "">
					   <cfset batches = "#batchno#">
					<cfelse>
					   <cfset batches = "#batches#,#batchno#">
					</cfif>
					
					<cfquery name="getWarehouse"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT  *	 
						FROM    Warehouse
						WHERE   Warehouse =  '#Lines.TransferWarehouse#'						
					</cfquery>	
					
					<cfquery name="Insert" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO  WarehouseBatch
							   ( Mission,
							   	 <cfif ObtainMode.PreparationMode eq "0">
								 Warehouse, 							 
								 Location,				
								 <cfelseif ObtainMode.PreparationMode eq "1">
								 Warehouse,
								 <cfelse>
								 Warehouse,
								 </cfif>						   
								 BatchWarehouse,
							     BatchNo, 
								 <cfif url.stockorderid neq "">
								 StockOrderId,
								 </cfif>
								 <cfif clearance eq "0">						 
								  ActionStatus, 
				      			  ActionOfficerUserId,
							      ActionOfficerLastName,
							      ActionOfficerFirstName,
						          ActionOfficerDate,
								  ActionMemo,						
								 </cfif>
								 BatchClass,
							     BatchDescription, 
							     TransactionDate,
							     TransactionType, 
							     OfficerUserId, 
							     OfficerLastName, 
							     OfficerFirstName )
						VALUES ('#getWarehouse.mission#',    <!--- url.mis#', interoffice support --->
						        <cfif ObtainMode.PreparationMode eq "0">
						        '#getWarehouse.Warehouse#',  <!--- processing receiving warehouse --->							
								'#Lines.TransferLocation#',
								<cfelseif ObtainMode.PreparationMode eq "1">
								 '#getWarehouse.Warehouse#', <!--- processing receiving warehouse --->	 
								<cfelse>
								 '#URL.Whs#',                <!--- processing same as distributing warehouse --->	   
								</cfif>  
								'#URL.Whs#',                 <!--- originating distributing warehouse --->
						        '#batchNo#',
								 <cfif url.stockorderid neq "">
								 '#url.stockorderid#',
								 </cfif>
								 <cfif clearance eq "0">	
									 '1', 
								     '#SESSION.acc#',
								     '#SESSION.last#',
							         '#SESSION.first#',
							         getDate(),
							         'Auto Clearance',
								 </cfif>
								'WhsTrans', 
								'#actiontype#',
								'#Lines.TransactionDate#',	
												
								'#url.tpe#',
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#')
					</cfquery>	
					
					<cfif url.stockorderid neq "">
										
						<cfquery name="getTask" 
						  datasource="AppsMaterials" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  	SELECT T.*	
							FROM   TaskOrder R INNER JOIN
						           RequestTask T ON R.StockOrderId = T.StockOrderId
						    WHERE  R.StockOrderId = '#url.stockorderid#'	
						</cfquery>	 
								
						<cfquery name="Actors" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							   SELECT    *
							   FROM      Ref_TaskTypeActor
							   WHERE     Code = '#getTask.TaskType#'  
							   <!---
							   AND       EnableTransaction = 1
							   --->
							   ORDER BY ListingOrder
						</cfquery>
				
						<cfloop query = "Actors">
						
							<cfif EntryMode eq "Lookup">
							
								<cfparam name="FORM.Actor_#Role#" default="">
							
								<cfset personNo = evaluate("FORM.Actor_#Role#")>
							
								<cfif currentrow eq "1">
							
									<cfparam name="Form.PersonNo" default="#personno#">
							
								</cfif>
										
								<cfquery name="get" 
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									   SELECT    *
									   FROM      Employee.dbo.Person
									   WHERE     PersonNo = '#PersonNo#'  		   
								</cfquery>
								
								<cfif get.Recordcount eq "1">
									
									<cfquery name="Insert" 
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									INSERT INTO  WarehouseBatchActor
										   ( BatchNo, 
										     Role,
											 ActorPersonNo,
											 ActorLastName,
											 ActorFirstName,			 
										     OfficerUserId, 
										     OfficerLastName, 
										     OfficerFirstName )
									VALUES ('#batchNo#',
											'#role#',
											'#personno#',
											'#get.LastName#',
											'#get.FirstName#',				
											'#SESSION.acc#',
											'#SESSION.last#',
											'#SESSION.first#')
									</cfquery>
								
								</cfif>
								
							<cfelse>
							
								<cfparam name="Form.PersonNo" default="">
								
								<cfparam name="FORM.lastName_#Role#" default="">
								<cfparam name="FORM.firstName_#Role#" default="">
							
								<cfset lastname   = evaluate("FORM.lastname_#Role#")>
								<cfset firstname  = evaluate("FORM.firstname_#Role#")>	
								
								<cfif firstname neq "" and lastname neq "">
							
									<cfquery name="Insert" 
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									
									INSERT INTO  WarehouseBatchActor
										   ( BatchNo, 
										     Role,					
											 ActorLastName,
											 ActorFirstName,			 
										     OfficerUserId, 
										     OfficerLastName, 
										     OfficerFirstName )
											 
									VALUES ('#batchNo#',
											'#role#',					
											'#LastName#',
											'#FirstName#',				
											'#SESSION.acc#',
											'#SESSION.last#',
											'#SESSION.first#')
											
									</cfquery>
									
								</cfif>	
										
							</cfif>	
						
						</cfloop>
						
					</cfif>	
					
					<!--- Pending 31/12/2011 also save the additional actor details at this point --->
							
					<cfloop query="Lines">
										
						<cfset qty = -1*TransferQuantity>	
						<cfset tratpe = url.tpe>								
										
					    <cf_getWarehouseBilling 
						    FromWarehouse = "#warehouse#" 
							FromLocation  = "#Location#" 
							ToWarehouse   = "#transferWarehouse#" 
							ToLocation    = "#transferLocation#">
							
						<cfif TransactionIdOrigin eq "">
						   
						   		<cfset workorderid   = "">
								<cfset workorderline = "">
								<cfset requirementid = "">
									
						<cfelse>
						   
						   		<cfquery name="getline"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
								    SELECT  *
									FROM    ItemTransaction
									WHERE   TransactionId = '#TransactionIdOrigin#'									
								</cfquery>							   		
						   	
								<cfset workorderid   = getline.WorkOrderId>
								<cfset workorderline = getline.workorderline>
								<cfset requirementid = getline.requirementid>
						   
						</cfif>	
							
						 <!--- get the orgUnit of the destination --->
						 
						 <cfquery name="OrgFrom"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
							    SELECT  TOP 1 OrgUnit
								FROM    Organization.dbo.Organization
								WHERE   MissionOrgUnitId = (SELECT MissionOrgUnitId 
								                            FROM   Warehouse 
															WHERE  Warehouse = '#Warehouse#')								
								ORDER BY Created DESC							
						</cfquery>		
						 
						<cfquery name="OrgTo"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
							    SELECT  TOP 1 OrgUnit
								FROM    Organization.dbo.Organization
								WHERE   MissionOrgUnitId = (SELECT MissionOrgUnitId 
								                            FROM   Warehouse 
															WHERE  Warehouse = '#TransferWarehouse#')								
								ORDER BY Created DESC							
						</cfquery>						 							
	                   											
						<cf_verifyOperational 
					         datasource= "AppsMaterials"
					         module    = "Accounting" 
							 Warning   = "No">
					  
						  <cfif Operational eq "1"> 
						  
						  		<cfset area = "variance">
						  
						  		<cfif getWarehouse.mission neq url.mis>										    
								   <cfset area = "interout">	
								<cfelse>
								   <cfset area = "variance">									
								</cfif>
						  
								<cfquery name="AccountStock"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
								    SELECT  GLAccount
									FROM    Ref_CategoryGLedger
									WHERE   Category = '#Category#' 
									AND     Area     = 'Stock'
								</cfquery>	
																																
								<cfquery name="AccountTask"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT  GLAccount
										FROM    Ref_CategoryGLedger
										WHERE   Category = '#Category#' 										
										AND     Area     = '#area#'  <!--- variance | interoffice | interout --->
								</cfquery>		
																																																						
								<cfif AccountStock.recordcount eq "0" or AccountTask.recordcount eq "0">
												
									<cf_alert message = "#msg1# #msg2#"
									  return = "no">
									  
									<cfabort>		
										 				
								</cfif>								      	   
							   							   							   
							   <!--- FROM location --->
							   
							   <!--- 22/02/2012 I added shipping record to be created --->
							   
							   <cfif clearance eq "0">	
								  <cfset actionStatus = "1">
							   <cfelse>
								  <cfset actionStatus = "0">
							   </cfif>  
							   						   
							   <cf_assignid>
							   <cfset traid = rowguid>
							   
							   <cfif area eq "variance">
							   
							   	    <cfset ship      = "No">
							   		<cfset price     = "">
									<cfset tax       = "">
									<cfset exem      = "1">
									<cfset ship      = "No">
									<cfset Class     = "COGS">
													   
							   <cfelse>   <!--- interoffice --->
							   
								   	<cfquery name="TaxCode"
										datasource="AppsMaterials" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
								   		SELECT       *
										FROM         ItemWarehouse
										WHERE        Warehouse = '#Warehouse#' 
										AND          ItemNo    = '#ItemNo#' 
										AND          UoM       = '#UnitOfMeasure#'
										
									</cfquery>	
							   
							   	    <cfset Class     = "Interoffice">
							   		<cfset ship      = "Yes">
							   	    <cfset price     = "COGS">
									<cfset tax       = TaxCode.TaxCode>
									<cfset exem      = "0">
									
									<!--- check POS.cfc to record a sale --->
								 
							   </cfif>
						  				  
							   <cf_StockTransact 
							        TransactionId        = "#traid#"
									TransactionClass     =  "#class#"
									TransactionIdOrigin  = "#TransactionIdOrigin#"
									TransactionReference = "#transactionReference#"
								    DataSource           = "AppsMaterials" 
								    TransactionType      = "#tratpe#"
									TransactionSource    = "WarehouseSeries"
									ItemNo               = "#ItemNo#" 
									Mission              = "#url.mis#" 
									Warehouse            = "#Warehouse#" 
									TransactionLot       = "#TransactionLot#"
									BillingMode          = "#billingmode#"
									Location             = "#Location#"
									TransactionCurrency  = "#APPLICATION.BaseCurrency#"
									TransactionQuantity  = "#qty#"
									TransactionUoM       = "#UnitOfMeasure#"						
									ReceiptId            = "#ReceiptId#"
									TransactionDate      = "#dateformat(TransactionDate,CLIENT.DateFormatShow)#"
									TransactionTime      = "#timeformat(TransactionDate,'HH:MM')#"							
									TransactionLocalTime = "Yes"
									TransactionBatchNo   = "#batchno#"
									workorderid          = "#workorderid#"
									workorderline        = "#workorderline#"
									requirementid        = "#requirementid#"
									Remarks              = "#TransferMemo#"
									ActionStatus         = "#actionstatus#"
									DetailLineNo         = "1"
									OrgUnit              = "#OrgFrom.OrgUnit#"
									Shipping             = "#ship#"  
									SalesPrice           = "#price#"
									SalesQuantity        = "#qty*-1#"
									TaxCode              = "#tax#"		
									TaxExemption         = "#exem#"						
									DetailReference1     = "#MeterName#"
									DetailReadInitial    = "#MeterInitial#"
									DetailReadFinal      = "#MeterFinal#"
									GLTransactionNo      = "#batchNo#"
									GLCurrency           = "#APPLICATION.BaseCurrency#"
									GLAccountDebit       = "#AccountTask.GLAccount#"
									GLAccountCredit      = "#AccountStock.GLAccount#">	
								
							 <!--- TO location --->	
								 
							 <cfif TransferItemNo neq "">
									<cfset ToItemNo = TransferItemNo>
									<cfset ToUoM    = TransferUoM>
							 <cfelse>
									<cfset ToItemNo = ItemNo>
									<cfset ToUoM    = UnitOfmeasure>		    
							 </cfif>	
							 
							 <!--- in case of interoffice we shich the account, type as if it is a receipt --->			 
							 
							 <cfif area neq "variance">
																			
									<!--- the receiving warehouse will have type 1 as they need to pay for it --->
									<cfset tratpe = "1">
									<cfset area = "interoffice">	
																																									
									<cfquery name="AccountTask"
										datasource="AppsMaterials" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										    SELECT  GLAccount
											FROM    Ref_CategoryGLedger
											WHERE   Category = '#Category#' 
											AND     Area     = '#area#'  <!--- variance | interoffice | interout --->
									</cfquery>		
																																																						
									<cfif AccountTask.recordcount eq "0">
													
										<cf_alert message = "#msg1# #msg2#"
										  return = "no">
										  
										<cfabort>		
											 				
									</cfif>		
									
							 </cfif>	
								
							 <cf_assignid>
						     <cfset newid = rowguid>
							 								
						     <cf_StockTransact 
							    TransactionId        = "#newid#" 
								TransactionClass     = "#class#"
							    ParentTransactionId  = "#traid#"
							    DataSource           = "AppsMaterials" 								
								TransactionReference = "#transactionReference#"
							    TransactionType      = "#tratpe#"
								TransactionSource    = "WarehouseSeries"
								ItemNo               = "#ToItemNo#" 
								Mission              = "#getWarehouse.Mission#" 
								Warehouse            = "#getWarehouse.Warehouse#" 
								TransactionLot       = "#TransactionLot#"
								BillingMode          = "#billingmode#"
								Location             = "#TransferLocation#"
								TransactionCurrency  = "#APPLICATION.BaseCurrency#"
								TransactionQuantity  = "#TransferQuantity#"
								TransactionUoM       = "#ToUoM#"											
								TransactionDate      = "#dateformat(TransactionDate,CLIENT.DateFormatShow)#"
								TransactionTime      = "#timeformat(TransactionDate,'HH:MM')#"							
								TransactionLocalTime = "Yes"
								TransactionBatchNo   = "#batchno#"
								workorderid          = "#workorderid#"
								workorderline        = "#workorderline#"
								requirementid        = "#requirementid#"
								OrgUnit              = "#OrgTo.OrgUnit#"
								Shipping             = "No"  
								SalesPrice           = "#price#"
								SalesQuantity        = "#TransferQuantity#"
								TaxCode              = "#tax#"	
								TaxExemption         = "#exem#"
								Remarks              = "#TransferMemo#"
								ActionStatus         = "#actionstatus#"
								GLTransactionNo      = "#batchNo#"
								GLCurrency           = "#APPLICATION.BaseCurrency#"
								GLAccountDebit       = "#AccountStock.GLAccount#"
								GLAccountCredit      = "#AccountTask.GLAccount#">		
								
								<!--- we set the sale price if the item has no prices set for 
											the warehouse of this entity --->
											
								<cfif tratpe eq "1" and traid neq "">		
								
									<cfquery name="Parent"
										datasource="AppsMaterials" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
								   		SELECT       *
										FROM         ItemTransaction
										WHERE        TransactionId = '#traid#' 										
									</cfquery>	
								
									<cfinvoke component = "Service.Process.Materials.Item"  
									   method           = "createItemUoMPrice" 
									   mission          = "#getWarehouse.Mission#" 
									   ItemNo           = "#ToItemNo#" 
									   UoM              = "#ToUoM#"
									   DateEffective    = "#dateformat(TransactionDate,CLIENT.DateFormatShow)#"
									   Cost             = "#Parent.TransactionCostPrice#"									   
									   datasource       = "AppsMaterials">	 								
								   
								</cfif>    
																
								<cfquery name="getLocationTo"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT   *				 
										FROM     WarehouseLocation
										WHERE    Warehouse = '#getWarehouse.Warehouse#'
										AND      Location  = '#transferLocation#'
								</cfquery>		
								
								<cfquery name="AccountCOGS"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT  GLAccount
										FROM    Ref_CategoryGLedger
										WHERE   Category = '#Category#' 
										AND     Area     = 'COGS'
								</cfquery>	
															
								<cfif getLocationTo.Distribution eq "8" and AccountCOGS.recordcount eq "1">
								
									<!--- check of the storage location is a consumption location so we record immediately the consumption --->
									
									<cfif transactionidOrigin neq "">
										<cfset origin = newid>
									<cfelse>
										<cfset origin = "">	
									</cfif>
																								
									<cf_StockTransact 
								    DataSource           = "AppsMaterials" 
								    TransactionType      = "2"
									TransactionIdOrigin  = "#newid#"								
									TransactionSource    = "WarehouseSeries"
									ItemNo               = "#ToItemNo#" 
									Mission              = "#url.mis#" 
									Warehouse            = "#TransferWarehouse#" 
									TransactionLot       = "#TransactionLot#"
									Location             = "#TransferLocation#"
									TransactionCurrency  = "#APPLICATION.BaseCurrency#"								
									TransactionQuantity  = "-#TransferQuantity#"
									TransactionUoM       = "#ToUoM#"									
									AssetId              = "#getLocationTo.AssetId#"	
									TransactionDate      = "#dateformat(TransactionDate,CLIENT.DateFormatShow)#"
									TransactionTime      = "#timeformat(TransactionDate,'HH:MM')#"							
									TransactionLocalTime = "Yes"																																			
									TransactionBatchNo   = "#batchno#"		
									workorderid          = "#workorderid#"
									workorderline        = "#workorderline#"
									requirementid        = "#requirementid#"		
									OrgUnit              = "#OrgTo.OrgUnit#"				
									Remarks              = "#TransferMemo#"		
									ActionStatus         = "#actionstatus#"
									GLTransactionNo      = "#batchNo#"
									GLCurrency           = "#APPLICATION.BaseCurrency#"
									GLAccountDebit       = "#AccountCOGS.GLAccount#"
									GLAccountCredit      = "#AccountStock.GLAccount#">	
									
								</cfif>								
								
								<!--- removed ReceiptId  = "#ReceiptId#" --->		
								
						  <cfelse>
						  						  
						  	<!--- not supported without accounting anymore !!!!!!! to be disabled --->
						  									
						  </cfif>
						  		
					</cfloop>
									
				</cftransaction>
				
				<cfloop query="Lines">		
				
					<cfif clearance neq "0">
					
						<cfset wfclass = evaluate("#level#EntityClass")>
						
						<cfif wfclass neq "">
						
							  <cfquery name="warehouse" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">	
									SELECT  * 
									FROM    Warehouse 
									WHERE   Warehouse = '#Warehouse#'
							  </cfquery>
						
							  <cfquery name="get" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">	
									SELECT * 
									FROM   Item 
									WHERE  ItemNo = '#ItemNo#'
							  </cfquery>
										
						      <cfset link = "Warehouse/Application/Stock/Batch/BatchView.cfm?mission=#url.mis#&batchno=#batchno#">
										
							  <cf_ActionListing 
								    EntityCode       = "WhsTransaction"
									EntityClass      = "#EntityClass#"
									EntityGroup      = ""
									EntityStatus     = ""
									Mission          = "#url.mis#"															
									ObjectReference  = "#ActionType#: #warehouse.warehousename#"
									ObjectReference2 = "#get.ItemDescription#" 											   
									ObjectKey4       = "#rowguid#"
									ObjectURL        = "#link#"
									Show             = "No">				
						
						</cfif>
					
					</cfif>
				
				</cfloop>
			
			</cfif>
			
		</cfloop>	
		
	<cfif tot eq 0>
		
		<cfoutput>
		<cfparam name="url.systemfunctionid" default="">
		<script language="JavaScript">
		  Prosis.busy('no')
          alert('No transfers recorded.\n\n The operation aborted') 	
		  try {	stocktransfer('','#url.systemfunctionid#','#url.stockorderid#','#url.mis#','#url.whs#') } catch(e) {}
	    </script>	
		</cfoutput>
		
		<cfabort>
	
	</cfif>			
		
</cfloop>

<cfoutput>

	<cfquery name="clear"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM Transfer#URL.Whs#_#SESSION.acc#		
	</cfquery>		
	
	<cf_tl id="Transfer has been submitted for final confirmation" var="vMessage1" class="message">
	<cf_tl id="Stock levels were updated" var="vMessage2" class="message">
	
	<script language="JavaScript">
	      Prosis.busy('no')       		 
		  <cfloop index="itm" list="#batches#"> 
		       batch('#itm#','#url.mis#','process','#url.systemfunctionid#','')
		  </cfloop>
		  alert('#vMessage1#') 
 	      stocktransfer('','#url.systemfunctionid#','#url.stockorderid#')		
	</script>	
		
</cfoutput>