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
<cfset process = "0">
			
<!--- submit the transaction 
      close the dialog and 
	  then refresh the screen --->

<cfquery name="getTask" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  	SELECT R.RequestId,
	       R.Mission,
	       T.SourceWarehouse,
		   WC.TaskOrderAttachmentEnforce,
		   T.SourceLocation,
		   T.TaskSerialNo,
		   T.StockOrderId,
		   T.ShipToWarehouse,
		   T.ShipToLocation,
		   T.ShipToMode,
		   (SELECT Description FROM Ref_ShipToMode WHERE Code = T.ShipToMode) as ShipToModeDescription,
		   T.TaskType,
		   I.Category,
		   R.ItemNo,
		   R.UoM			
	FROM   Request R 
			INNER JOIN RequestTask T 
				ON R.RequestId = T.RequestId  
			INNER JOIN Item I 
				ON R.ItemNo = I.ItemNo 
			INNER JOIN Warehouse W
				ON T.SourceWarehouse = W.Warehouse
			INNER JOIN Ref_WarehouseClass WC
				ON W.WarehouseClass = WC.Code
	WHERE  T.TaskId = '#url.taskid#'	
</cfquery>	

<cfset BatchReference = trim(Form.BatchReference)>

<cfif len(BatchReference) lte "2">
					    
  	 <cf_alert message = "You must record a Receipt No.">
	 <cfabort>
			
</cfif>		

<cf_fileExist 
	DocumentPath="WhsBatch" 
	SubDirectory="#BatchId#" 
	Filter=""> 
	
<cfif files eq "0" and getTask.TaskOrderAttachmentEnforce eq 1>

	<cf_alert message = "You must attach the receipt document under Attachments"  return = "no">
	<cfabort>
	
</cfif>

<!--- we determine if the transaction will be confirmed directly which is determine by the receiving location --->

<cfquery name="getClearanceMode" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	 SELECT ClearanceMode 
	 FROM   ItemWarehouseLocationTransaction	
     WHERE  Warehouse = '#getTask.ShipToWarehouse#'
	 AND    Location  IN (SELECT LocationReceipt 
	                      FROM   Warehouse 
						  WHERE  Warehouse = '#getTask.ShipToWarehouse#')
	 AND    ItemNo    = '#getTask.ItemNo#'
	 AND    UoM       = '#getTask.UoM#'
     AND    TransactionType = '8'
</cfquery>

<cfif getClearanceMode.ClearanceMode eq "0">	
	 <cfset actionStatus = "1">
<cfelse>
	 <cfset actionStatus = "0">
</cfif> 

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

<cftransaction>
	
<!--- create a transaction batch --->
	 
	<cfquery name="whs" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT   *
	   FROM     Warehouse
	   WHERE    Warehouse =  '#getTask.shiptowarehouse#' 
	</cfquery>
	
	<cfquery name="Insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO  WarehouseBatch
		   ( Mission,
		     Warehouse, 	
			 BatchWarehouse,	
		     BatchNo, 
		     BatchDescription,
			 BatchMemo,
			 BatchReference, 
			 BatchId,
			 Category,
		     TransactionDate,
		     TransactionType, 
			 <cfif ActionStatus eq "1">						 				 
		      	  ActionOfficerUserId,
				  ActionOfficerLastName,
				  ActionOfficerFirstName,
				  ActionOfficerDate,
				  ActionMemo,						
       	     </cfif>
			 ActionStatus,
		     OfficerUserId, 
		     OfficerLastName, 
		     OfficerFirstName )
	VALUES ('#gettask.mission#',
	        '#getTask.shiptowarehouse#',	
			'#getTask.sourcewarehouse#',		
	        '#batchNo#',
			'Bulk #getTask.ShipToModeDescription#',
			'Bulk #getTask.ShipToModeDescription# for #whs.WarehouseName#',
			'#BatchReference#',
			'#url.batchid#',
			<cfif form.category neq "">
			'#Form.Category#',
			<cfelse>
			NULL,
			</cfif>
			'#dateFormat(now(), client.dateSQL)#',
			'8',
			<cfif ActionStatus eq "1">					 
			     '#SESSION.acc#',
			     '#SESSION.last#',
		         '#SESSION.first#',
		         getDate(),
		         'Auto Clearance',
			 </cfif>			
			'#ActionStatus#',
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#')
	</cfquery>
	
	<cfquery name="Actors" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT    *
		   FROM      Ref_TaskTypeActor
		   WHERE     Code = '#getTask.TaskType#'  
		   <cfif getTask.ShipToMode eq "Collect">  
		   AND       EnableTransaction = 1
		   </cfif>
		   ORDER BY ListingOrder
	</cfquery>
	
	<cfloop query = "Actors">	
			
		<cfif EntryMode eq "Lookup">
		
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
						 ActorReference,
						 ActorLastName,
						 ActorFirstName,			 
					     OfficerUserId, 
					     OfficerLastName, 
					     OfficerFirstName )
				VALUES ('#batchNo#',
						'#role#',
						'#personno#',
						'#get.Reference#',
						'#get.LastName#',
						'#get.FirstName#',				
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#')
				</cfquery>
			
			</cfif>
			
		<cfelse>
		
			<cfparam name="Form.PersonNo" default="">
		
		    <cfset reference  = evaluate("FORM.reference_#Role#")>
			<cfset lastname   = evaluate("FORM.lastname_#Role#")>
			<cfset firstname  = evaluate("FORM.firstname_#Role#")>	
		
			<cfquery name="Insert" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO  WarehouseBatchActor
					   ( BatchNo, 
					     Role,	
						 ActorReference,				
						 ActorLastName,
						 ActorFirstName,			 
					     OfficerUserId, 
					     OfficerLastName, 
					     OfficerFirstName )
				VALUES ('#batchNo#',
						'#role#',	
						'#Reference#',				
						'#LastName#',
						'#FirstName#',				
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#')
				</cfquery>
		
		
		</cfif>	
	
	</cfloop>
			
	<cf_verifyOperational 
	     datasource= "AppsMaterials"
	     module    = "Accounting" 
		 Warning   = "No">
	  
	<cfif Operational eq "1"> 
	  
			<cfquery name="AccountStock"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT  GLAccount
				FROM    Ref_CategoryGLedger
				WHERE   Category = '#getTask.Category#' 
				AND     Area = 'Stock'
			</cfquery>	
					
			<cfquery name="AccountTask"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT  GLAccount
				FROM    Ref_CategoryGLedger
				WHERE   Category = '#getTask.Category#' 
				AND     Area     = 'Variance'
			</cfquery>	
			
			<cfquery name="AccountCOGS" 
			   datasource="AppsMaterials" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT * 
			   FROM   Ref_CategoryGLedger R
			   WHERE  Area     = 'COGS'
			   AND    Category = '#getTask.Category#'
			   AND    GLAccount IN (SELECT GLAccount 
			                        FROM   Accounting.dbo.Ref_Account WHERE GLAccount = R.GLAccount)
			</cfquery>
							
			<cfif AccountCOGS.recordcount eq "0" and operational eq "1">
					    
			  	 <cf_message message = "COGS account for #Item.Category# does not exist">
				 <cfabort>
			
			</cfif>			
					
			<cfif AccountStock.recordcount lt "0" or AccountTask.Recordcount lt "0">
								
				<cf_tl id="GL Account information is not available." var="1" class="Message">
				<cfset msg1="#lt_text#">
				
				<cf_tl id="Operation not allowed." var="1" class="Message">
				<cfset msg2="#lt_text#">				
				
				<cf_alert 
				  message = "#msg1# #msg2#"
				  return = "no">
				  <cfabort>
			
			</cfif>
							
		   <cfset glstock  = "#AccountStock.GLAccount#">
		   <cfset gltask   = "#AccountTask.GLAccount#">	
		   <cfset glcogs   = "#AccountCOGS.GLAccount#">	
		   <cfset ledger = "Yes">
		   
	<cfelse>
	
		   <cfset glstock  = "">
		   <cfset gltask   = "">	
		   <cfset glcogs   = "">
		   <cfset ledger = "No">
	
	</cfif>	   
		
	<!--- get the detail lines --->
	
	<cfquery name="LinesTask" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	  
	  	SELECT   R.RequestId, 
		         R.Mission,
				 R.UoM,
				 R.ItemNo,
				 T.ShipToWarehouse, 
				 T.ShipToLocation,
				 T.TaskId,
				 T.TaskSerialNo
				 
 		FROM     Request R INNER JOIN
                 RequestTask T ON R.RequestId = T.RequestId  INNER JOIN
                 Item I ON R.ItemNo = I.ItemNo  
		WHERE    T.StockOrderId    = '#getTask.StockOrderId#'	
		AND      T.ShipToWarehouse = '#getTask.ShipToWarehouse#'
		AND      T.ShipToMode      = '#getTask.ShipToMode#'
		AND      T.RecordStatus   != '3'
		AND      T.TaskQuantity >  (SELECT  ISNULL(SUM(TransactionQuantity),0)
						            FROM    ItemTransaction P
									WHERE   P.RequestId    = T.RequestId									
									AND     P.TaskSerialNo = T.TaskSerialNo
									  <!--- make sure we have the shipping transactions 
									  AND     TransactionId IN (SELECT TransactionId 
									                            FROM   ItemTransactionShipping
																WHERE  TransactionId = T.TransactionId)
									  --->			  
									  AND     P.TransactionQuantity > 0 
									  AND     P.ActionStatus != '9')  
	</cfquery>	
	
	<cfif getTask.shipToMode eq "Collect">	
						
		<cfloop query="LinesTask">
				
			<cfparam name="Form.Location"    default="">	
			<cfparam name="Form.Quantity_#left(taskid,8)#"    default="">
			<cfparam name="Form.StorageId_#left(taskid,8)#"   default="00000000-0000-0000-0000-000000000000">	
			
			<cfset acc  = evaluate("Form.Quantity_#left(taskid,8)#")>		
			<cfset sti  = evaluate("Form.StorageId_#left(taskid,8)#")>		
			
			<cfif form.location eq "">
			
				<script>
				    alert('Invalid target storage location recorded.')
				</script>	 		
				<cfabort>
			
			</cfif>	
								
								
			<cfif acc neq "0" and acc neq "" and sti neq "">	
			
				<cfif not LSIsNumeric(acc)>
			
					<script>
					    alert('Invalid quantity recorded')
					</script>	 		
					<cfabort>
			
				</cfif>	
													
				<cfquery name="getLocation" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT  *
				    FROM    WarehouseLocation
					WHERE   Storageid = '#sti#'				
				</cfquery>								
				
				<cfif getLocation.recordcount eq "0">
				
					<script>					
						alert("You must select a storage location. Operator aborted.")					
					</script>
					
					<cfabort>
				
				</cfif>
			
			</cfif>									
											
			<cfif acc neq "0" and acc neq "" and getLocation.recordcount eq "1">	
			
			   <cfset process = 1>	
			
			   <cfset issue  = -1*acc>		
			   
			   <!--- take stock from the FROM, which has the meter readings connected --->   
			   
			   <cf_assignid>		   
			   
			   <cf_getWarehouseBilling 
				    FromWarehouse = "#getLocation.warehouse#" 
					FromLocation  = "#getLocation.Location#" 
					ToWarehouse   = "#getTask.ShipToWarehouse#">	
					
				 <!--- get the orgUnit of the destination --->
										 
				 <cfquery name="Org"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT  TOP 1 OrgUnit
					FROM    Organization.dbo.Organization
					WHERE   MissionOrgUnitId = (SELECT MissionOrgUnitId 
					                            FROM   Warehouse 
												WHERE  Warehouse = '#getTask.ShipToWarehouse#')			
					ORDER BY Created DESC												
				</cfquery>			
				
				 <cfquery name="ShipTo"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    SELECT  *
							FROM    Warehouse
							WHERE   Warehouse = '#getTask.ShipToWarehouse#'																					
						</cfquery>				
			 			  
			   <cf_StockTransact 	
			        TransactionId        = "#rowguid#"			        
				    DataSource           = "AppsMaterials" 
				    TransactionType      = "8"
					TransactionSource    = "WarehouseSeries"
					ItemNo               = "#ItemNo#" 
					Mission              = "#Mission#" 
					Warehouse            = "#getLocation.Warehouse#" 
					Location             = "#getLocation.Location#"
					TransactionCurrency  = "#APPLICATION.BaseCurrency#"
					TransactionQuantity  = "#issue#"
					TransactionUoM       = "#UoM#"									
					RequestId            = "#RequestId#"	
					OrgUnit              = "#Org.OrgUnit#"		
					LocationId           = "#ShipTo.LocationId#"			
					TaskSerialNo         = "#TaskSerialNo#"			
					TransactionDate      = "#form.transactiondate#"
					TransactionTime      = "#form.transaction_hour#:#form.transaction_minute#"										
					PersonNo             = "#Form.PersonNo#"		
					TransactionBatchNo   = "#batchno#"
					Remarks              = "#form.Remarks#"		
					BillingMode          = "#billingmode#"	
					ActionStatus         = "#ActionStatus#"												
					Ledger               = "#ledger#"										
					GLTransactionNo      = "#batchNo#"
					GLCurrency           = "#APPLICATION.BaseCurrency#"
					GLAccountDebit       = "#gltask#"
					GLAccountCredit      = "#glstock#">	
					
				<!---	moved to the other NEW location which is usually a truck --->
			
				<cf_StockTransact 
					ParentTransactionId  = "#rowguid#"
				    DataSource           = "AppsMaterials" 
				    TransactionType      = "8"
					TransactionSource    = "WarehouseSeries"
					ItemNo               = "#ItemNo#" 
					Mission              = "#Mission#" 
					Warehouse            = "#ShipToWarehouse#" 
					Location             = "#form.Location#"			
					TransactionCurrency  = "#APPLICATION.BaseCurrency#"
					Shipping             = "Yes"			
					TransactionQuantity  = "#acc#"
					TransactionUoM       = "#UoM#"						
					RequestId            = "#RequestId#"
					TaskSerialNo         = "#TaskSerialNo#"			
					TransactionDate      = "#form.transactiondate#"
					TransactionTime      = "#form.transaction_hour#:#form.transaction_minute#"			
					TransactionBatchNo   = "#batchno#"
					ActionStatus         = "#ActionStatus#"	
					Remarks              = "#form.Remarks#"			
					Ledger               = "#ledger#"
					GLTransactionNo      = "#batchNo#"
					GLCurrency           = "#APPLICATION.BaseCurrency#"						
					GLAccountDebit       = "#glstock#"
					GLAccountCredit      = "#gltask#">
					
					<!---	TransactionCostPrice = "#getValue.Price#" --->		
					
					<cfif getLocation.Distribution eq "8">
		
						<cf_StockTransact 
						ParentTransactionId  = "#rowguid#"
					    DataSource           = "AppsMaterials" 
					    TransactionType      = "2"
						TransactionSource    = "WarehouseSeries"
						ItemNo               = "#ItemNo#" 
						Mission              = "#Mission#" 
						Warehouse            = "#ShipToWarehouse#" 
						Location             = "#form.Location#"		
						AssetId              = "#getLocation.AssetId#"	
						TransactionCurrency  = "#APPLICATION.BaseCurrency#"
						Shipping             = "No"										
						TransactionQuantity  = "#issue#"
						TransactionUoM       = "#UoM#"										
						RequestId            = "#RequestId#"
						TaskSerialNo         = "#TaskSerialNo#"			
						TransactionDate      = "#form.transactiondate#"
						TransactionTime      = "#form.transaction_hour#:#form.transaction_minute#"			
						TransactionBatchNo   = "#batchno#"
						ActionStatus         = "#ActionStatus#"	
						Remarks              = "#form.Remarks#"
						Ledger               = "#ledger#"
						GLTransactionNo      = "#batchNo#"
						GLCurrency           = "#APPLICATION.BaseCurrency#"
						GLAccountDebit       = "#glcogs#"
						GLAccountCredit      = "#glstock#">		
						
						<!--- TransactionCostPrice = "#getValue.Price#" --->
					
					</cfif>
			
			</cfif>
										
		</cfloop>	
			
						
	<cfelse>		
	
			<!--- delivery to --->
		    <!--- taken out from the delivering location which will need to be confirmed in a shipping record --->
			
			<cfloop query="LinesTask">
			
					<cfparam name="Form.Location"  default="">
			
				    <cfif form.location eq "">
			
						<script>
						    alert('Invalid target storage location recorded.')
						</script>	 		
						<cfabort>
			
					</cfif>	
					
					<cfparam name="Form.Quantity_#left(taskid,8)#"    default="">
					<cfparam name="Form.StorageId_#left(taskid,8)#"   default="00000000-0000-0000-0000-000000000000">	
								
					<cfset acc  = evaluate("Form.Quantity_#left(taskid,8)#")>		
					<cfset sti  = evaluate("Form.StorageId_#left(taskid,8)#")>		
			
					<cf_assignid>
					
					<cf_getWarehouseBilling 
						    FromWarehouse = "#getTask.SourceWarehouse#" 
							FromLocation  = "#form.Location#" 
							ToWarehouse   = "#getTask.ShipToWarehouse#">		
							
					<cfif acc neq "0" and acc neq "" and sti neq "">	
					
						<cfif not LSIsNumeric(acc)>
			
							<script>
							    alert('Invalid quantity recorded')
							</script>	 		
							<cfabort>
					
						</cfif>		
													 
						 <cfquery name="Org"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    SELECT  TOP 1 OrgUnit
							FROM    Organization.dbo.Organization
							WHERE   MissionOrgUnitId = (SELECT MissionOrgUnitId 
							                            FROM   Warehouse 
														WHERE  Warehouse = '#getTask.ShipToWarehouse#')			
							ORDER BY Created DESC												
						</cfquery>	
						
						 <cfquery name="ShipTo"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    SELECT  *
							FROM    Warehouse
							WHERE   Warehouse = '#getTask.ShipToWarehouse#'																					
						</cfquery>					
							
						<cf_StockTransact 
						    TransactionId       = "#rowguid#"
						    DataSource          = "AppsMaterials" 
						    TransactionType     = "8"
							TransactionSource   = "WarehouseSeries"
							ItemNo              = "#ItemNo#" 
							Mission             = "#Mission#" 
							Warehouse           = "#getTask.SourceWarehouse#" 
							Location            = "#form.Location#"			
							TransactionCurrency = "#APPLICATION.BaseCurrency#"
							Shipping            = "Yes"		
							TransactionQuantity = "-#acc#"
							TransactionUoM      = "#UoM#"						
							RequestId           = "#RequestId#"
							OrgUnit             = "#Org.OrgUnit#"
							LocationId          = "#shipto.LocationId#"
							TaskSerialNo        = "#TaskSerialNo#"			
							TransactionDate     = "#form.transactiondate#"
							TransactionTime     = "#form.transaction_hour#:#form.transaction_minute#"			
							TransactionBatchNo  = "#batchno#"
							ActionStatus        = "#ActionStatus#"	
							Remarks             = "#form.Remarks#"			
							Ledger              = "#ledger#"
							BillingMode         = "#BillingMode#"
							GLTransactionNo     = "#batchNo#"
							GLCurrency          = "#APPLICATION.BaseCurrency#"
							GLAccountDebit      = "#gltask#"
							GLAccountCredit     = "#glstock#">							
															
						<cfquery name="getLocation" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT  *
						    FROM    WarehouseLocation
							WHERE   Storageid = '#sti#'				
						</cfquery>													
						
						<cfif getLocation.recordcount eq "0">
						
							<script>					
								alert("You must select a storage location. Operator aborted.")					
							</script>
							<cfabort>
						
						</cfif>
					
					</cfif>				
																
					<cfif acc neq "0" and acc neq "" and getLocation.recordcount eq "1">	
					
					   <cfset process = 1>			
					
					   <!--- transferred to and receive it in the other location --->
					   				 			  
					   <cf_StockTransact 
					   		ParentTransactionId  = "#rowguid#"
						    DataSource           = "AppsMaterials" 
						    TransactionType      = "8"
							TransactionSource    = "WarehouseSeries"
							ItemNo               = "#ItemNo#" 
							Mission              = "#Mission#" 
							Warehouse            = "#getLocation.Warehouse#" 
							Location             = "#getLocation.Location#"
							TransactionCurrency  = "#APPLICATION.BaseCurrency#"							
							TransactionQuantity  = "#acc#"
							TransactionUoM       = "#UoM#"									
							RequestId            = "#RequestId#"						
							TaskSerialNo         = "#TaskSerialNo#"			
							TransactionDate      = "#form.transactiondate#"
							TransactionTime      = "#form.transaction_hour#:#form.transaction_minute#"										
							PersonNo             = "#Form.PersonNo#"		
							TransactionBatchNo   = "#batchno#"
							ActionStatus         = "#ActionStatus#"	
							Remarks              = "#form.Remarks#"															
							Ledger               = "#ledger#"										
							GLTransactionNo      = "#batchNo#"
							GLCurrency           = "#APPLICATION.BaseCurrency#"
							GLAccountDebit       = "#glstock#"
							GLAccountCredit      = "#gltask#">		
							
							<!--- TransactionCostPrice = "#getValue.Price#" --->											
							
							<cfif getLocation.Distribution eq "8">
							
								<!--- check of the storage location is a consumption location so we record immediately the consumption --->
															
								<cf_StockTransact 
								ParentTransactionId  = "#rowguid#"
							    DataSource           = "AppsMaterials" 
							    TransactionType      = "2"
								TransactionSource    = "WarehouseSeries"
								ItemNo               = "#ItemNo#" 
								Mission              = "#Mission#" 
								Warehouse            = "#getLocation.Warehouse#" 
								Location             = "#getLocation.Location#"
								TransactionCurrency  = "#APPLICATION.BaseCurrency#"  <!--- TransactionCostPrice = "#getValue.Price#" --->								
								TransactionQuantity  = "-#acc#"
								TransactionUoM       = "#UoM#"									
								RequestId            = "#RequestId#"
								AssetId              = "#getLocation.AssetId#"
								TaskSerialNo         = "#TaskSerialNo#"			
								TransactionDate      = "#form.transactiondate#"
								TransactionTime      = "#form.transaction_hour#:#form.transaction_minute#"										
								PersonNo             = "#Form.PersonNo#"		
								TransactionBatchNo   = "#batchno#"
								ActionStatus         = "#ActionStatus#"	
								Remarks              = "#form.Remarks#"															
								Ledger               = "#ledger#"										
								GLTransactionNo      = "#batchNo#"
								GLCurrency           = "#APPLICATION.BaseCurrency#"
								GLAccountDebit       = "#glcogs#"
								GLAccountCredit      = "#glstock#">	
								
							</cfif>	
							
					</cfif>					
									
															
		</cfloop>								
	
	</cfif>			
	
	<cfif process eq "0">
	
		<cf_alert message = "You have not recorded any receipts. Operation aborted" return= "no">
		<cfabort>	
	
	</cfif>
	  
</cftransaction>

<script language="JavaScript">
  ColdFusion.Window.hide('dialogprocesstask')  
</script>

<cfoutput query="LinesTask">
	
	<cfif currentrow eq recordcount>
		<cfset refresh = "yes">
	<cfelse>
		<cfset refresh = "no">	
	</cfif>
	
	<script language="JavaScript">
		  
	  // refresh the content of the receipts
	  ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskProcessDetail.cfm?taskid=#taskid#&actormode=#url.actormode#','box#taskid#')
	  // update the status in the view on the line level
	  ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskViewStatus.cfm?refresh=#refresh#&taskid=#taskid#&actormode=#url.actormode#','status#taskid#')
	</script>

</cfoutput>                                                                                                                                                                                                                                                                                                                       