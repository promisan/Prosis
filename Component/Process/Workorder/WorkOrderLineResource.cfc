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

<!--- ------------------------------------------------------------------------------------------ --->
<!--- Component to serve requests that relate to the handlinmg of PRODUCTION based workorder --- ---> 
<!--- ------------------------------------------------------------------------------------------ --->

<!--- -----------------------------------Annoation Hanno 5/9/2016------------------------------- --->
<!--- -----FOMTEX is different as the production buttom, generate stock and deduct BOM
by first earmarking it before it would be cosumed ---------------------------------------------- --->


<cfcomponent>

   <cfproperty name="name" type="string">
   <cfset this.name = "Execution Queries">	
   
   <cffunction name="BOMConsumption"
        access="public"
        returntype="any"
        displayname="Consume earmarked BOM supplies of a workorder">
				
		<cfargument name="workorderid"      type="string"  required="true"  default="">
		<cfargument name="workorderline"    type="numeric" required="yes">		
		<cfargument name="consumptionbase"  type="string"  required="true"  default="calculated">	<!--- calculated | ordered --->	
		
		<!--- if calculated quantity gte order quantity we can either release or consume the stock --->
		
		<cfargument name="consumptionmode"  type="string"  required="true"  default="standard">	<!--- standard | consumeall --->		
				
		<!--- ------------------------------------------ --->
		<!--- ----- get the provisioning lines --------- --->
		<!--- ------------------------------------------ --->
				
		<cfquery name="Workorder" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT    *
			FROM      Workorder
		    WHERE     WorkorderId = '#workorderid#'    									  
		</cfquery>					
									
		<cfquery name="Line" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     WorkOrderLine WL LEFT OUTER JOIN
		             Ref_ServiceItemDomainClass R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code
			WHERE    WL.WorkOrderId   = '#workorderid#' 
			AND      WL.WorkOrderLine = '#workorderline#'
		</cfquery>		
		
		<cfif workorder.actionstatus eq "3">
			<cfset list = "Consume,Release">
		<cfelse>
			<cfset list = "Consume">	
		</cfif>
				
		<cfloop index="action" list="#List#">
								   
			<cfquery name="getStockResource" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
										
				SELECT     WIR.WorkOrderId,
				           WIR.WorkOrderLine, 
						   WIR.ResourceId,
						   WIR.ResourceItemNo, 					  
						   I.ItemDescription, 
						   I.Classification,
						   I.ItemClass,
						   I.Category,
						   C.Description,
						   I.ItemPrecision,					   
						   WIR.ResourceUoM, 
						   UoM.UoMDescription, 					  
						   SUM(WIR.Quantity) AS Quantity, 
						   							   
						   (
						    
							SELECT    ISNULL(SUM(CalculatedConsumption),0) AS CalculatedConsumption
	                      
							FROM      (SELECT     WL.WorkOrderId, 
							                      WL.WorkOrderLine, 
												  WLI.WorkOrderItemId, 
												  WLI.ItemNo, 
												  WLI.UoM, 
												  WLI.Quantity AS QuantityRequested,																	
												  WLIR.ResourceItemNo, 
												  WLIR.ResourceUoM, 
			                                      WLIR.Quantity AS QuantityNeed,
												  
			                                      (SELECT  ISNULL(SUM(TransactionQuantity), 0)
			                                       FROM    Materials.dbo.ItemTransaction
			                                       WHERE   RequirementId = WLI.WorkOrderItemId 
												   <!--- excluded shipped and return transactions.\,  
												   we determine the total generated and transferred and apply the ratio to the requirement 
												   for BOM --->
												   AND     TransactionType NOT IN ('2','3')) / WLI.Quantity * WLIR.Quantity AS CalculatedConsumption
														 
				                       FROM       WorkOrder W INNER JOIN
			    	                              WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
			                                      WorkOrderLineItem WLI ON WL.WorkOrderId = WLI.WorkOrderId AND WL.WorkOrderLine = WLI.WorkOrderLine INNER JOIN
			                                      WorkOrderLineItemResource WLIR ON WLI.WorkOrderItemId = WLIR.WorkOrderItemId
			        	               WHERE      WL.WorkOrderId   = '#workorderid#' 
									   AND        WL.WorkorderLine = '#workorderline#'
									   ) FP					   
									   
						    WHERE   FP.WorkorderId    = WIR.WorkorderId
						    AND     FP.WorkorderLine  = WIR.WorkOrderLine
						    AND     FP.ResourceItemNo = WIR.ResourceItemNo
						    AND     FP.ResourceUoM    = WIR.ResourceUoM ) as Calculated,						   											   				  
						   
						   <!--- already issued for this requirement --->				   
						   
						   (
						    
							SELECT   ISNULL(SUM(TransactionQuantity*-1), 0)
				            FROM     Materials.dbo.Itemtransaction
				            WHERE    Mission         = '#workorder.mission#'  <!--- ANY warehouse --->								
							
							<cfif line.PointerStock eq "1">									
							
							  AND    RequirementId   = WIR.ResourceId								  
							  
							<cfelse>	
														
							  <!--- same item as required --->
							  AND    ItemNo          = WIR.ResourceItemNo 
				              AND    TransactionUoM  = WIR.ResourceUoM								 
							  
							</cfif> 				
							
							 AND     TransactionType = '2' <!--- any status --->
							 AND     WorkOrderId     = WIR.WorkOrderId 
							 AND     WorkOrderLine   = WIR.WorkOrderLine) AS AlreadyConsumed,		
							 					
				           <!--- earmarked for workorder of the BOM requirement to be reviewed if
							   we take here only the resourceid insteead of the mapping of the item
							   itself which would give a bit more flexibility as we could have different
							   items earmarked --->	
								       											   
						   (SELECT  ISNULL(SUM(TransactionQuantity), 0)
				            FROM    Materials.dbo.Itemtransaction
				            WHERE   Mission         = '#workorder.mission#' 						
							AND     WorkOrderId     = WIR.WorkOrderId 
							AND     WorkOrderLine   = WIR.WorkOrderLine
							AND     RequirementId   = WIR.ResourceId
																						
							<!--- confirmed --->
							AND    (
								     (ActionStatus   = '1' AND TransactionType != '2') 
								                       OR
								     (ActionStatus  IN ('0','1') AND TransactionType = '2')
								   )							   
							)  AS Earmarked															
							   														   										
					FROM         WorkOrderLineResource WIR INNER JOIN
				                 Materials.dbo.Item I ON WIR.ResourceItemNo = I.ItemNo   INNER JOIN
								 Materials.dbo.Ref_Category C ON I.Category = C.Category INNER JOIN
				                 Materials.dbo.ItemUoM UoM ON WIR.ResourceItemNo = UoM.ItemNo 
								                          AND WIR.ResourceUoM = UoM.UoM 
				
				    <!--- get all resource lines --->
					WHERE        WIR.WorkOrderId   = '#workorderid#' 
					AND          WIR.WorkOrderLine = '#workorderline#'						
											
					AND          I.ItemClass = 'Supply'
					AND          WIR.ResourceMode != 'NONE'
					
					<!--- not needed as items in the requirement are not duplicated by the generating method --->
					
					GROUP BY     WIR.WorkOrderId, 
					             WIR.WorkOrderLine, 
								 WIR.ResourceItemNo, 
								 WIR.ResourceUoM,				 
								 WIR.ResourceId,							
								 I.ItemDescription, 
								 I.ItemClass,
								 I.Classification,
								 I.Category,	
								 I.ParentItemNo,
								 C.Description,	
								 I.ItemPrecision,		 
								 UoM.UoMDescription		
								 
					ORDER BY I.Category				 
													
			</cfquery>	 
			
			<cfloop query="getStockResource">	
			
				<cfif action eq "Consume">
												
					<cfif consumptionbase eq "Calculated">
										
						<cfset diff = Calculated - AlreadyConsumed>
					
					<cfelse>
					
						<cfset diff = Quantity   - AlreadyConsumed>
					
					</cfif>
				
				<cfelse>
				
					<cfset diff = Earmarked> <!--- release all --->
				
				
				</cfif>
																
				<cfif diff gte 1 and Earmarked gt 0>									
																	
					<!--- 					
						obtain quantity per lot, warehouse, location that are earmarked for this workorder and create
						a batch transaction for each of them 									
					--->
					
					<cfquery name="stockonhand" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">					
					
					<!--- confirmed stock --->
											
				    SELECT     'Earmarked' as StockMode,		
							   T.ItemNo,	          
							   I.ItemDescription,
							   C.StockControlMode,
							   I.Classification,
							   I.Category,
							   I.ItemPrecision,
							   T.TransactionUoM,
							   U.UoMDescription,	
							   U.ItemUoMId,		
							   T.Warehouse,	
							   T.Location, 
					           WL.Description AS LocationName, 
							   T.TransactionLot, 					   
							   T.WorkOrderId,
							   (SELECT Reference FROM WorkOrder WHERE WorkOrderId = T.WorkOrderId) as WorkOrderReference,			   
							   T.WorkOrderLine,
							   T.RequirementId,
							   ISNULL(SUM(T.TransactionQuantity), 0) AS Quantity, 
							   PL.TransactionLotDate, 				  
							   PL.OrgUnitVendor,
							   PL.TransactionLotSerialNo,
			
							   (SELECT OrgUnitName 
							    FROM   Organization.dbo.Organization 
								WHERE  OrgUnit = PL.OrgUnitVendor) as OrgUnitName
							   
				    FROM       Materials.dbo.ItemTransaction T INNER JOIN
				               Materials.dbo.WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location INNER JOIN
				               Materials.dbo.ProductionLot PL     ON T.Mission   = PL.Mission AND T.TransactionLot = PL.TransactionLot INNER JOIN
					           Materials.dbo.Item I               ON I.ItemNo    = T.ItemNo   INNER JOIN
							   Materials.dbo.Ref_Category C       ON C.Category  = I.Category INNER JOIN
				               Materials.dbo.ItemUoM U            ON T.ItemNo    = U.ItemNo AND T.TransactionUoM = U.UoM
							   
				    WHERE      T.Mission        = '#workorder.mission#' 
									
					<!--- stock also associated to THIS workorder resource it which COULD BE 
					              of different items --->
								  
					AND        T.WorkOrderId    = '#WorkOrderId#'
					AND        T.WorkOrderLine  = '#WorkOrderLine#'		
					AND        T.RequirementId  = '#resourceid#' 
					
					
					<!--- confirmed transactions only --->
					AND    (
						     (ActionStatus   = '1' AND TransactionType != '2') 
						                       OR
						     (ActionStatus  IN ('0','1') AND TransactionType = '2')
						   )				
					
					GROUP BY   T.ItemNo,   <!--- potentially we can have several items for the same resource --->
								   I.ItemDescription,
								   I.Category,
								   I.Classification,
								   I.ItemPrecision,
								   C.StockControlMode,
								   
							   T.TransactionUoM,
								   U.UoMDescription,
								   U.ItemUoMId,
							   T.Warehouse, 									   	      	   
							   T.Location, 			
							   	   WL.Description,   
					           T.TransactionLot, 					   
								   PL.TransactionLotDate, 
								   PL.OrgUnitVendor,	
								   PL.TransactionLotSerialNo,
							   <!--- added 30/12 --->	   				  
							   T.RequirementId,	  
							       T.WorkOrderId,
								   T.WorkorderLine 
							   
					<cfif Line.PointerOverDraw eq "0">		   
						HAVING 	 SUM(T.TransactionQuantity) > 0 						
					</cfif>
													
					ORDER BY I.ItemDescription,
					         T.ItemNo,
							 PL.TransactionLotDate,				 
							 U.ItemUomId  						 				 
							   
					</cfquery>
					
					<cfset resid = resourceid>
					
					<!--- we have a consolidatedidated list of items totaled on the stock level to be processed split is earmarked and not earmarked --->
			
					<!--- define the contra account for the goods to be recorded against --->				
									
					<cfquery name="AccountProduction" 
						datasource="AppsMaterials"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							   SELECT * 
							   FROM   Workorder.dbo.WorkorderGLedger 
							   WHERE  WorkorderId   = '#workorderid#'		
							   AND    Area          = 'Production'
							   AND    GLAccount IN (SELECT GLAccount 
							                        FROM   Accounting.dbo.Ref_Account)	  
					</cfquery>   		
					
					<cfloop query="StockOnHand">
									     				
						<cfif ConsumptionMode eq "consumeall">
						
							<!--- we will consume all earmarked stock regardless --->
						
							<cfif diff eq "0">
								<cfset diff = "9999999">
							</cfif>
											
						</cfif>
					
						<cfif diff gt "0">						
							
							<!--- apply transaction --->
																			
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
							
							<!--- add a batch --->
		
							<cf_assignid>
							
							<cfif action eq "Consume">
																		
								<cfquery name="Insert" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									INSERT INTO WarehouseBatch
										    (Mission,
											 Warehouse, 
											 BatchWarehouse,				
										 	 BatchNo, 	
											 BatchId,
											 BatchDescription,		
											 BatchClass,				
											 TransactionDate,
											 TransactionType, 
											 OfficerUserId, 
											 OfficerLastName, 
											 OfficerFirstName)
									VALUES ('#workorder.mission#',
									        '#warehouse#',
											'#warehouse#',			 
								    	    '#batchNo#',	
											'#rowguid#',			
											'WorkOrder Collection',							
											'WOCollect',
											'#dateformat(now(),client.dateSQL)#',
											'2',
											'#SESSION.acc#',
											'#SESSION.last#',
											'#SESSION.first#')
								</cfquery>
							
							<cfelse>
							
								<cfquery name="Insert" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									INSERT INTO WarehouseBatch
										    (Mission,
											 Warehouse, 
											 BatchWarehouse,				
										 	 BatchNo, 	
											 BatchId,
											 BatchDescription,		
											 BatchClass,				
											 TransactionDate,
											 TransactionType, 
											 OfficerUserId, 
											 OfficerLastName, 
											 OfficerFirstName)
									VALUES ('#workorder.mission#',
									        '#warehouse#',
											'#warehouse#',			 
								    	    '#batchNo#',	
											'#rowguid#',			
											'Release earmark',							
											'WOCollect',
											'#dateformat(now(),client.dateSQL)#',
											'8',
											'#SESSION.acc#',
											'#SESSION.last#',
											'#SESSION.first#')
								</cfquery>
							
							
							</cfif>
							
							<cfif AccountProduction.GLAccount eq "">
						
									<!--- then we defined the default income account for the production based
									     on the category which ideally we do not want to here to be applied --->
															
									<cfquery name="AccountProduction"
											datasource="AppsMaterials" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											    SELECT  GLAccount
												FROM    Ref_CategoryGLedger
												WHERE   Category   = '#Category#' 
												AND     Area       = 'Production'
												AND     GLAccount IN (SELECT GLAccount 
												                      FROM   Accounting.dbo.Ref_Account)
									</cfquery>	
								
						    </cfif>
						
							<cfquery name="AccountTask"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    	SELECT  GLAccount
								FROM    Ref_CategoryGLedger
								WHERE   Category = '#Category#' 
								AND     Area     = 'Variance'
							</cfquery>	
						
							<cfquery name="AccountStock" 
						    datasource="AppsMaterials" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
							   SELECT * 
							   FROM   Ref_CategoryGLedger 
							   WHERE  Area     = 'Stock'
							   AND    Category = '#Category#'
							</cfquery>
							
							<cfif StockControlMode eq "stock">
							
								<cfif Quantity gt diff>
							
									<cfset qty = diff>
									<cfset diff = 0>
								
								<cfelse>
							
									<cfset qty = quantity>	
									<cfset diff = diff - qty>
											
								</cfif>		
								
								<cfif qty gt "0">
																								
									<cf_assignid>
						
									<cfset apply = -1*qty>
									
									<cfif action eq "consume">
																										
										<cf_StockTransact 
											    DataSource            = "AppsMaterials" 
												TransactionId         = "#rowguid#"												
											    TransactionType       = "2"  
												TransactionSource     = "WorkOrderSeries"
												ItemNo                = "#ItemNo#" 
												TransactionUoM        = "#TransactionUoM#"	
												Mission               = "#workorder.Mission#" 
												Warehouse             = "#Warehouse#" 
												ActionStatus          = "1"
												TransactionLot        = "#TransactionLot#" 						
												Location              = "#Location#"										
																		
												TransactionQuantity   = "#apply#"
																			
												TransactionLocalTime  = "Yes"
												TransactionDate       = "#dateformat(now(),CLIENT.DateFormatShow)#"
												TransactionTime       = "#timeformat(now(),'HH:MM')#"
												TransactionBatchNo    = "#batchno#"												
												GLTransactionNo       = "#batchNo#"
												WorkOrderId           = "#workorderid#"
												WorkOrderLine         = "#workorderline#"		
												RequirementId         = "#resid#"					
												OrgUnit               = "#Line.orgunitimplementer#"
												GLAccountDebit        = "#AccountProduction.GLAccount#"
												GLAccountCredit       = "#AccountStock.GLAccount#">			
												
									<cfelse>
																		
										<cfset parentid = rowguid>
									
										<!--- lower earmark --->
										
										<cf_StockTransact 
										    DataSource            = "AppsMaterials" 
											TransactionId         = "#rowguid#"												
										    TransactionType       = "8"  
											TransactionSource     = "WorkOrderSeries"
											ItemNo                = "#ItemNo#" 
											TransactionUoM        = "#TransactionUoM#"	
											Mission               = "#workorder.Mission#" 
											Warehouse             = "#Warehouse#" 
											ActionStatus          = "1"
											TransactionLot        = "#TransactionLot#" 						
											Location              = "#Location#"										
																	
											TransactionQuantity   = "#apply#"
																		
											TransactionLocalTime  = "Yes"
											TransactionDate       = "#dateformat(now(),CLIENT.DateFormatShow)#"
											TransactionTime       = "#timeformat(now(),'HH:MM')#"
											TransactionBatchNo    = "#batchno#"												
											GLTransactionNo       = "#batchNo#"
											WorkOrderId           = "#workorderid#"
											WorkOrderLine         = "#workorderline#"		
											RequirementId         = "#resid#"					
											OrgUnit               = "#Line.orgunitimplementer#"
											GLAccountDebit        = "#AccountProduction.GLAccount#"
											GLAccountCredit       = "#AccountStock.GLAccount#">	
											
										<!--- freed stock --->		
										
										<cf_assignid>		
						
										<cf_StockTransact 
										    DataSource            = "AppsMaterials" 
											ParentTransactionId   = "#parentid#"
											TransactionId         = "#rowguid#"												
										    TransactionType       = "8"  
											TransactionSource     = "WorkOrderSeries"
											ItemNo                = "#ItemNo#" 
											TransactionUoM        = "#TransactionUoM#"	
											Mission               = "#workorder.Mission#" 
											Warehouse             = "#Warehouse#" 
											ActionStatus          = "1"
											TransactionLot        = "#TransactionLot#" 						
											Location              = "#Location#"										
																	
											TransactionQuantity   = "#qty#"
																		
											TransactionLocalTime  = "Yes"
											TransactionDate       = "#dateformat(now(),CLIENT.DateFormatShow)#"
											TransactionTime       = "#timeformat(now(),'HH:MM')#"
											TransactionBatchNo    = "#batchno#"												
											GLTransactionNo       = "#batchNo#"											
											OrgUnit               = "#Line.orgunitimplementer#"
											GLAccountDebit        = "#AccountProduction.GLAccount#"
											GLAccountCredit       = "#AccountStock.GLAccount#">											
									
									</cfif>									
								
								</cfif>
							
							<cfelse>
							
								<!--- we determine the individual stock items instead, like rolls --->
													
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
											  T.WorkOrderId,
											  T.WorkOrderLine,
											  T.RequirementId,
											  
											  <!--- ATTENTION please note that this does include uncleared transactions --->
											  
					                          (SELECT   ISNULL(SUM(TransactionQuantity), 0)
					                            FROM     ItemTransaction
					                            WHERE    TransactionidOrigin = T.TransactionId) AS QuantityUsed
												
									FROM       ItemTransaction T
									
									WHERE      T.Mission        = '#workorder.mission#' 
																								
									<!--- stock associated to this workorder --->
									AND        T.WorkOrderId    = '#WorkOrderId#'
									AND        T.WorkOrderLine  = '#WorkOrderLine#'	
									AND        T.RequirementId  = '#resid#'									
															
									AND        T.TransactionIdOrigin IS NULL <!--- is a source transaction --->
									
									<!--- transaction was not depleted yet --->
									
									AND        TransactionQuantity > 
									              (SELECT     ISNULL(SUM(TransactionQuantity*-1), 0)
					                               FROM       ItemTransaction
					                               WHERE      TransactionidOrigin = T.TransactionId)		
									
								
								</cfquery>		
																						
								<cfloop query="getTransaction">
								
									<cfset Quantity = TransactionQuantity - QuantityUsed>
								
									<cfif Quantity gt diff>
							
										<cfset qty = diff>
										<cfset diff = 0>
								
									<cfelse>
							
										<cfset qty = quantity>	
										<cfset diff = diff - qty>
											
									</cfif>		
									
									<cfif qty gt "0">
									
										<cfset traidorigin  = Transactionid> 	
										<cfset trareference = TransactionReference> 	
									
										<cf_assignid>
															
										<cfset apply = -1*qty>
										
										<cfif action eq "consume">
																	
											<cf_StockTransact 
											    DataSource            = "AppsMaterials" 
												TransactionId         = "#rowguid#"	
												TransactionIdOrigin   = "#TraIdOrigin#" 
											    TransactionType       = "2"  <!--- issuance from stock --->
												TransactionSource     = "WorkOrderSeries"
												ItemNo                = "#ItemNo#" 
												TransactionUoM        = "#TransactionUoM#"	
												Mission               = "#workorder.Mission#" 
												Warehouse             = "#Warehouse#" 
												ActionStatus          = "1"
												TransactionLot        = "#TransactionLot#" 						
												Location              = "#Location#"
												
												TransactionReference  = "#trareference#"						
												TransactionQuantity   = "#apply#"
																		
												TransactionLocalTime  = "Yes"
												TransactionDate       = "#dateformat(now(),CLIENT.DateFormatShow)#"
												TransactionTime       = "#timeformat(now(),'HH:MM')#"
												TransactionBatchNo    = "#batchno#"												
												GLTransactionNo       = "#batchNo#"
												WorkOrderId           = "#workorderid#"
												WorkOrderLine         = "#workorderline#"		
												RequirementId         = "#resid#"					
												OrgUnit               = "#Line.orgunitimplementer#"
												GLAccountDebit        = "#AccountProduction.GLAccount#"
												GLAccountCredit       = "#AccountStock.GLAccount#">		
													
										<cfelse>
										
											<cfset parentid = rowguid>
											
											<!--- deduct the stock from earmark --->
																											
											<cf_StockTransact 
											    DataSource            = "AppsMaterials" 
												TransactionId         = "#rowguid#"	
												TransactionIdOrigin   = "#TraIdOrigin#" 
											    TransactionType       = "8"  <!--- issuance from stock --->
												TransactionSource     = "WorkOrderSeries"
												ItemNo                = "#ItemNo#" 
												TransactionUoM        = "#TransactionUoM#"	
												Mission               = "#workorder.Mission#" 
												Warehouse             = "#Warehouse#" 
												ActionStatus          = "1"
												TransactionLot        = "#TransactionLot#" 						
												Location              = "#Location#"
												
												TransactionReference  = "#trareference#"						
												TransactionQuantity   = "#apply#"
																		
												TransactionLocalTime  = "Yes"
												TransactionDate       = "#dateformat(now(),CLIENT.DateFormatShow)#"
												TransactionTime       = "#timeformat(now(),'HH:MM')#"
												TransactionBatchNo    = "#batchno#"												
												GLTransactionNo       = "#batchNo#"
												WorkOrderId           = "#workorderid#"
												WorkOrderLine         = "#workorderline#"		
												RequirementId         = "#resid#"					
												OrgUnit               = "#Line.orgunitimplementer#"
												GLAccountDebit        = "#AccountProduction.GLAccount#"
												GLAccountCredit       = "#AccountStock.GLAccount#">		
												
												<!--- freed stock which will be acting as a new individual stock start --->		
										
												<cf_assignid>			
												
												<cf_StockTransact 
											    DataSource            = "AppsMaterials" 
												ParentTransactionId   = "#parentid#"
												TransactionId         = "#rowguid#"													
											    TransactionType       = "8"  <!--- issuance from stock --->
												TransactionSource     = "WorkOrderSeries"
												ItemNo                = "#ItemNo#" 
												TransactionUoM        = "#TransactionUoM#"	
												Mission               = "#workorder.Mission#" 
												Warehouse             = "#Warehouse#" 
												ActionStatus          = "1"
												TransactionLot        = "#TransactionLot#" 						
												Location              = "#Location#"
												
												TransactionReference  = "#trareference#"						
												TransactionQuantity   = "#qty#"
																		
												TransactionLocalTime  = "Yes"
												TransactionDate       = "#dateformat(now(),CLIENT.DateFormatShow)#"
												TransactionTime       = "#timeformat(now(),'HH:MM')#"
												TransactionBatchNo    = "#batchno#"												
												GLTransactionNo       = "#batchNo#"													
												OrgUnit               = "#Line.orgunitimplementer#"
												GLAccountDebit        = "#AccountProduction.GLAccount#"
												GLAccountCredit       = "#AccountStock.GLAccount#">											
										
										</cfif>			
									
									</cfif>														
															
								</cfloop>
													
							</cfif>
																	
						</cfif>
					
					</cfloop>	
					
				</cfif>
				
			</cfloop>	
		
		</cfloop>
						
				
	</cffunction>		   
			
</cfcomponent>	
