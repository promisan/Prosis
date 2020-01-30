			
<!--- submit the transaction 
      close the dialog and 
	  then refresh the screen --->
	  
<cfparam name="Form.Batchreference" default="">	  
<cfparam name="url.actionid"       default="">	  

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
	SubDirectory="#url.BatchId#" 
	Filter=""> 
	
<cfif files eq "0" and (getTask.ShipToMode eq "Deliver" or (getTask.ShipToMode eq "Collect" and getTask.TaskOrderAttachmentEnforce eq 1))>

	<cf_alert message = "You must attach the receipt document [Attachments]"  return = "no">
	<cfabort>
	
</cfif>

<!--- ------------------------------------------------------------------------ --->
<!--- we are going to determine if the transaction will be confirmed directly
which is determine by the receiving warehouse for the default location --->
<!--- ----------------------------------------------------------------------- --->

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

<cfparam name="form.TransactionQuantity" default="">

<cfif form.transactionquantity eq "0" or form.TransactionQuantity eq "">

	<cf_alert message = "Please record transaction receipt quantity"  return = "no">
	 <cfabort>

</cfif>

<cftransaction>
	
	<!--- create a transaction --->
	 
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
		     BatchNo, 
		     Warehouse, 	
			 BatchWarehouse,	
		    
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
			'#batchNo#',       
			<cfif url.actormode eq "issuance">
			'#getTask.ShipToWarehouse#',	<!--- this warehouse will perform the confirmation action --->
			'#getTask.sourcewarehouse#',			        
			'Authorised Withdrawal',
			'Authorised Withdrawal for #whs.WarehouseName#',
			<cfelse>
			'#getTask.sourcewarehouse#',	
			'#getTask.sourcewarehouse#',			        
			'Bulk #getTask.ShipToModeDescription#',
			'Bulk #getTask.ShipToModeDescription# for #whs.WarehouseName#',
			</cfif>
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
		   
	<!--- total in transactionUoM transferred, 
	  in case of collection we no longer use this but it is calculated --->	   
	
	<cfset total   = replace("#Form.TransactionQuantity#",",","")>
	<cfset total   = trim(total)>
	
	<cfif not LSIsNumeric(total)>
	
		<script>
		    alert('Invalid quantity recorded')
		</script>	 		
		<cfabort>
	
	</cfif>
	
	<cfif getTask.shipToMode eq "Collect">
	
	  		<!--- move from the old locations in a loop --->	
			
			<cfset row = "4">
	  
			<cfloop index="itm" from="1" to="#row#">		
					
					<cfparam name="f#itm#_containerseal"         default="">			
					<cfparam name="f#itm#_quantityaccepted"      default="0">
					<cfparam name="f#itm#_meterreadinginitial"   default="0">
					<cfparam name="f#itm#_meterreadingfinal"     default="0">
					<cfparam name="f#itm#_meterreadinguom"       default="">
					<cfparam name="f#itm#_reference1"            default="">
					<cfparam name="f#itm#_reference2"            default="">
					<cfparam name="f#itm#_measurement0"          default="0">
					<cfparam name="f#itm#_measurement1"          default="0">
					<cfparam name="f#itm#_measurement2"          default="0">
					<cfparam name="f#itm#_measurement3"          default="0">			
					<cfparam name="f#itm#_storageid"             default="00000000-0000-0000-0000-000000000000">				
										
					<cfset sea  = evaluate("f#itm#_containerseal")>			
					<cfset acc  = evaluate("f#itm#_quantityaccepted")>			
					<cfset mei  = evaluate("f#itm#_meterreadinginitial")>
					<cfset mef  = evaluate("f#itm#_meterreadingfinal")>		
					<cfset uom  = evaluate("f#itm#_meterreadinguom")>		
					<cfset ms0  = evaluate("f#itm#_measurement0")>
					<cfset ms1  = evaluate("f#itm#_measurement1")>
					<cfset ms2  = evaluate("f#itm#_measurement2")>
					<cfset ms3  = evaluate("f#itm#_measurement3")>			
					<cfset ref1 = evaluate("f#itm#_reference1")>
					<cfset ref2 = evaluate("f#itm#_reference2")>
					<cfset sti  = evaluate("f#itm#_StorageId")>
										
					<cfif acc neq "0" and acc neq "" and sti neq "">		
															
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
					
					   <cfset issue  = -1*acc>		
					   
					   <cfif uom neq getTask.UoM>
									
						   <cf_getUoMMultiplier ItemNo="#getTask.ItemNo#" UoMTo="#uom#" UoMFrom="#getTask.UoM#">
						   <cfset issue = uommultiplier * issue>
						   <cfset issue = round(issue*1000)/1000>
						   					
					   </cfif>			
					   
					   <!--- transfer FROM, which has the meter readings connected --->   
					   
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
						    DataSource           = "AppsMaterials" 
						    TransactionType      = "8"
							TransactionSource    = "WarehouseSeries"
							ItemNo               = "#getTask.ItemNo#" 
							Mission              = "#getTask.Mission#" 
							Warehouse            = "#getLocation.Warehouse#" 
							Location             = "#getLocation.Location#"
							TransactionCurrency  = "#APPLICATION.BaseCurrency#"
							TransactionQuantity  = "#issue#"
							TransactionUoM       = "#getTask.UoM#"									
							RequestId            = "#getTask.RequestId#"						
							TaskSerialNo         = "#getTask.TaskSerialNo#"		
							OrgUnit              = "#Org.OrgUnit#"	
							LocationId           = "#ShipTo.LocationId#"
							TransactionDate      = "#form.transactiondate#"
							TransactionTime      = "#form.transaction_hour#:#form.transaction_minute#"										
							PersonNo             = "#Form.PersonNo#"		
							TransactionBatchNo   = "#batchno#"
							Remarks              = "#form.Remarks#"		
							BillingMode          = "#billingmode#"	
							ActionStatus         = "#ActionStatus#"					
							DetailLineNo         = "#itm#"
							DetailSeal           = "#sea#"
							DetailReadInitial    = "#mei#"
							DetailReadFinal      = "#mef#"
							DetailReadUoM        = "#uom#"
							DetailReference1     = "#ref1#"
							DetailReference2     = "#ref2#"
							DetailMeasure0       = "#ms0#"
							DetailMeasure1       = "#ms1#"
							DetailMeasure2       = "#ms2#"
							DetailMeasure3       = "#ms3#"		
							Ledger               = "#ledger#"										
							GLTransactionNo      = "#batchNo#"
							GLCurrency           = "#APPLICATION.BaseCurrency#"
							GLAccountDebit       = "#gltask#"
							GLAccountCredit      = "#glstock#">	
					
					</cfif>
					
			</cfloop>	
			
			<!--- get the total value of the transaction and transfer it to --->
					
			<cfquery name="getValue" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					SELECT  ABS(SUM(TransactionValue)/SUM(TransactionQuantity)) AS Price,
					        ABS(SUM(TransactionQuantity)) as Quantity
					FROM    ItemTransaction
					WHERE   TransactionBatchNo = '#batchNo#' 
					AND     TransactionQuantity < 0
			</cfquery>			
					
			<!---	all moved to the other NEW location which is usually a truck --->
					
			<cf_StockTransact 
			    DataSource           = "AppsMaterials" 
			    TransactionType      = "8"
				TransactionSource    = "WarehouseSeries"
				ItemNo               = "#getTask.ItemNo#" 
				Mission              = "#getTask.Mission#" 
				Warehouse            = "#getTask.ShipToWarehouse#" 
				Location             = "#form.Location#"			
				TransactionCurrency  = "#APPLICATION.BaseCurrency#"
				Shipping             = "Yes"		
				TransactionCostPrice = "#getValue.Price#"
				TransactionQuantity  = "#getValue.Quantity#"
				TransactionUoM       = "#getTask.UoM#"						
				RequestId            = "#getTask.RequestId#"
				TaskSerialNo         = "#getTask.TaskSerialNo#"			
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
				
				<!--- DetailInformation    = "#Form.DetailInformation#" --->
				
				<!--- --------------------------------------------------- --->
				<!--- after the receipt we book a issuance from the stock --->
				<!--- --------------------------------------------------- --->
												
				<cfif getLocation.Distribution eq "8">
				
					<cf_StockTransact 
				    DataSource           = "AppsMaterials" 
				    TransactionType      = "2"
					TransactionSource    = "WarehouseSeries"
					ItemNo               = "#getTask.ItemNo#" 
					Mission              = "#getTask.Mission#" 
					Warehouse            = "#getTask.ShipToWarehouse#" 
					Location             = "#form.Location#"		
					AssetId              = "#getLocation.AssetId#"	
					TransactionCurrency  = "#APPLICATION.BaseCurrency#"
					Shipping             = "No"		
					TransactionCostPrice = "#getValue.Price#"
					TransactionQuantity  = "-#getValue.Quantity#"
					TransactionUoM       = "#getTask.UoM#"										
					RequestId            = "#getTask.RequestId#"
					TaskSerialNo         = "#getTask.TaskSerialNo#"			
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
				
				</cfif>
						
	<cfelse>
			
			<!--- ----------- --->
			<!--- DELIVERY TO --->
			<!--- ----------- --->
			
		    <!--- taken out from the delivering location which will need to be confirmed in a shipping record --->
			
			<cf_assignid>
			
			<cf_getWarehouseBilling 
					FromWarehouse = "#getTask.SourceWarehouse#" 
					FromLocation  = "#form.Location#" 
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
			    TransactionId       = "#rowguid#"
			    DataSource          = "AppsMaterials" 
			    TransactionType     = "8"
				TransactionSource   = "WarehouseSeries"
				ItemNo              = "#getTask.ItemNo#" 
				Mission             = "#getTask.Mission#" 
				Warehouse           = "#getTask.SourceWarehouse#" 
				Location            = "#form.Location#"			
				TransactionCurrency = "#APPLICATION.BaseCurrency#"
				Shipping            = "Yes"		
				TransactionQuantity = "-#total#"
				TransactionUoM      = "#getTask.UoM#"						
				RequestId           = "#getTask.RequestId#"
				TaskSerialNo        = "#getTask.TaskSerialNo#"		
				OrgUnit             = "#Org.OrgUnit#"	
				LocationId          = "#ShipTo.LocationId#"
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
				
				<!--- record the seals to the taskorder as they refer to the task order  --->
				
				<cfloop index="itm" from="1" to="10">	
								
					<cfparam name="form.Reference1_#itm#" default="">			
					
					<cfset val = evaluate("form.Reference1_#itm#")>
										
					<cfif val neq "">
										
						<cfquery name="InsertDetails" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">		
							INSERT INTO TaskOrderDetail
								( StockOrderId,
								  TransactionId,
								  Reference1,
								  OfficerUserId, 
								  OfficerLastName,
								  OfficerFirstName)
							VALUES
								( '#getTask.StockOrderId#',
								  '#rowguid#',
								  '#val#',
								  '#SESSION.acc#',
								  '#SESSION.last#',
								  '#SESSION.first#' )						
						</cfquery>		
										
					</cfif>
									
				</cfloop>
				
				<!--- -------------------------------------------------------------- --->
				
				<!--- get the total value of the transaction --->
			
				<cfquery name="getValue" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
						SELECT  ABS(SUM(TransactionValue)/SUM(TransactionQuantity)) AS Price
						FROM    ItemTransaction
						WHERE   TransactionBatchNo = '#batchNo#' 
						AND     TransactionQuantity < 0
				</cfquery>		
				
				<!--- pass the price of the delivery to the new stock --->		
				
				<cfset totacc = "0">		
			  
				<cfloop index="itm" from="1" to="8">		
						
					<cfparam name="f#itm#_containerseal"         default="">			
					<cfparam name="f#itm#_quantityaccepted"      default="0">
					<cfparam name="f#itm#_meterreadinginitial"   default="0">
					<cfparam name="f#itm#_meterreadingfinal"     default="0">					
					<cfparam name="f#itm#_meterreadinguom"       default="">
					<cfparam name="f#itm#_reference1"            default="">
					<cfparam name="f#itm#_reference2"            default="">
					<cfparam name="f#itm#_measurement0"          default="0">
					<cfparam name="f#itm#_measurement1"          default="0">
					<cfparam name="f#itm#_measurement2"          default="0">
					<cfparam name="f#itm#_measurement3"          default="0">			
					<cfparam name="f#itm#_storageid"             default="">
					
					<cfset sti  = evaluate("f#itm#_StorageId")>			
					<cfset sea  = evaluate("f#itm#_containerseal")>			
					<cfset acc  = evaluate("f#itm#_quantityaccepted")>			
					<cfset mei  = evaluate("f#itm#_meterreadinginitial")>
					<cfset mef  = evaluate("f#itm#_meterreadingfinal")>		
					<cfset uom  = evaluate("f#itm#_meterreadinguom")>		
					<cfset ms0  = evaluate("f#itm#_measurement0")>
					<cfset ms1  = evaluate("f#itm#_measurement1")>
					<cfset ms2  = evaluate("f#itm#_measurement2")>
					<cfset ms3  = evaluate("f#itm#_measurement3")>			
					<cfset ref1 = evaluate("f#itm#_reference1")>
					<cfset ref2 = evaluate("f#itm#_reference2")>		
					
					<cfif acc neq "0" and acc neq "" and sti neq "">	
					
						<!--- we convert to the UoM of the receipt --->
						
						<cfif uom neq getTask.UoM>
									
						   <cf_getUoMMultiplier ItemNo="#getTask.ItemNo#" UoMFrom="#uom#" UoMTo="#getTask.UoM#">
						   <cfset acc = acc * uommultiplier>
						   <cfset acc = round(acc*1000)/1000>
					
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
								alert("You must select a storage location. Operation aborted.")					
							</script>
							<cfabort>
						
						</cfif>
					
					</cfif>				
																
					<cfif acc neq "0" and acc neq "" and getLocation.recordcount eq "1">		
					
					   <cfset totacc = totacc + acc>	
					
					   <!--- transferred to the following tank that will receive the fuel --->
					   				 			  
					   <cf_StockTransact 
						    DataSource           = "AppsMaterials" 
						    TransactionType      = "8"
							TransactionSource    = "WarehouseSeries"
							ItemNo               = "#getTask.ItemNo#" 
							Mission              = "#getTask.Mission#" 
							Warehouse            = "#getLocation.Warehouse#" 
							Location             = "#getLocation.Location#"
							TransactionCurrency  = "#APPLICATION.BaseCurrency#"
							TransactionCostPrice = "#getValue.Price#"
							TransactionQuantity  = "#acc#"
							TransactionUoM       = "#getTask.UoM#"									
							RequestId            = "#getTask.RequestId#"						
							TaskSerialNo         = "#getTask.TaskSerialNo#"			
							TransactionDate      = "#form.transactiondate#"
							TransactionTime      = "#form.transaction_hour#:#form.transaction_minute#"										
							PersonNo             = "#Form.PersonNo#"		
							TransactionBatchNo   = "#batchno#"
							ActionStatus         = "#ActionStatus#"	
							Remarks              = "#form.Remarks#"								
							DetailLineNo         = "#itm#"
							DetailSeal           = "#sea#"
							DetailReadInitial    = "#mei#"
							DetailReadFinal      = "#mef#"
							DetailReadUoM        = "#uom#"
							DetailReference1     = "#ref1#"
							DetailReference2     = "#ref2#"
							DetailMeasure0       = "#ms0#"
							DetailMeasure1       = "#ms1#"
							DetailMeasure2       = "#ms2#"
							DetailMeasure3       = "#ms3#"		
							Ledger               = "#ledger#"										
							GLTransactionNo      = "#batchNo#"
							GLCurrency           = "#APPLICATION.BaseCurrency#"
							GLAccountDebit       = "#glstock#"
							GLAccountCredit      = "#gltask#">													
							
							<cfif getLocation.Distribution eq "8">
							
								<!--- check of the storage location is a consumption location so we record immediately the consumption --->
															
								<cf_StockTransact 
							    DataSource           = "AppsMaterials" 
							    TransactionType      = "2"
								TransactionSource    = "WarehouseSeries"
								ItemNo               = "#getTask.ItemNo#" 
								Mission              = "#getTask.Mission#" 
								Warehouse            = "#getLocation.Warehouse#" 
								Location             = "#getLocation.Location#"
								TransactionCurrency  = "#APPLICATION.BaseCurrency#"
								TransactionCostPrice = "#getValue.Price#"
								TransactionQuantity  = "-#acc#"
								TransactionUoM       = "#getTask.UoM#"									
								RequestId            = "#getTask.RequestId#"
								AssetId              = "#getLocation.AssetId#"
								TaskSerialNo         = "#getTask.TaskSerialNo#"			
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
				
				<cfset diff = total - totacc>
				
				<cfif abs(diff) gte 1>
				
					<cf_alert message = "Transaction is not in balance (#total# - #totacc#), operation aborted"  return = "no">
					<cfabort>
				
				</cfif>						
	
	</cfif>			
	  
</cftransaction>

<cfoutput>

<cfif url.actormode eq "issuance">

	<script language="JavaScript">
	  ColdFusion.Window.hide('dialogprocesstask')  
	  // update the status in the view on the line level
	  ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Shipment/TaskDetailStatus.cfm?taskid=#url.taskid#&actormode=#url.actormode#','status#url.taskid#')
	</script>

<cfelse>
	
	<script language="JavaScript">
	  ColdFusion.Window.hide('dialogprocesstask')  
	  // refresh the content of the receipts
	  ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskProcessDetail.cfm?taskid=#url.taskid#&actormode=#url.actormode#','box#url.taskid#')
	  // update the status in the view on the line level
	  ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskViewStatus.cfm?taskid=#url.taskid#&actormode=#url.actormode#','status#url.taskid#')
	</script>
	
</cfif>	

</cfoutput> 