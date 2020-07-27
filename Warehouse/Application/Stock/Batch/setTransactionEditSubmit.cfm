
<!--- redo transaction which is pending for clearance 
1. get the transaction(s) to be removed
2. then remove transaction (RI to financials)
3. apply the transaction again + financials using the method 
--->

<cfquery name="prior"
	datasource="AppsMaterials" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     ItemTransaction T
		WHERE    TransactionId = '#url.TransactionId#'
		ORDER BY Created DESC
</cfquery>	

<cfquery name="batch"
	datasource="AppsMaterials" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     WarehouseBatch
		WHERE    BatchNo = '#prior.TransactionBatchNo#'		
</cfquery>

<cfif Batch.ActionStatus neq "0">

	<script>
	   alert("Quantity amendment is no longer supported as batch has been cleared.")
	</script>

<cfelse>

	<cfswitch expression="#url.field#">
	
			<cfcase value="quantity">
			
				<cftransaction>
							
					<cfquery name="Item"
						datasource="AppsMaterials" 
					    username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT   *
							FROM     Item T
							WHERE    ItemNo = '#prior.ItemNo#'		
					</cfquery>	
					
					<cfquery name="getLines"
						datasource="AppsMaterials" 
					    username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT   *
							FROM     ItemTransaction
							WHERE    TransactionId = '#url.TransactionId#' 
							         OR ParentTransactionid = '#url.TransactionId#'  
							ORDER BY Created DESC
					</cfquery>			
														
					<cfquery name="getLinesAction"
						datasource="AppsMaterials" 
					    username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT   *
							FROM     ItemTransactionAction
							WHERE    TransactionId IN (#quotedValueList(getLines.Transactionid)#) 						
					</cfquery>	
					
					<cfquery name="getValuation"
							datasource="AppsMaterials" 
						    username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT   *
								FROM     ItemTransactionValuation
								WHERE    (TransactionId IN (#quotedValueList(getLines.Transactionid)#) 
								AND      DistributionTransactionId NOT IN (#quotedValueList(getLines.Transactionid)#)) 			
					</cfquery>	
					
					<cfif getValuation.recordcount gte "1">
					
						<script>
						   alert("Stock has been sourced operation no longer supported, contract your administrator.")
					   </script>
					
						<!--- this transaction has been sourced which applies only for receipts, 
								then you may no longer change it, operation aborted --->
					
					<cfelse>
																			
						<cfloop query="getLines">
						
							<cfquery name="getStock" 
							  datasource="AppsMaterials" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
								    SELECT    SUM(TransactionQuantity) as OnHand
									FROM      ItemTransaction
									WHERE     Warehouse       = '#warehouse#'
									AND       ItemNo          = '#ItemNo#'
									AND       TransactionUoM  = '#TransactionUoM#'
									<!--- added the transactionlot --->   	
									AND       TransactionLot  = '#TransactionLot#'						   		      
							</cfquery>
							
							<cfset bal = getStock.Onhand - transactionQuantity + url.value*-1>
						
							<cfif bal lt 0>
								
								<cfoutput>						    
								<script>
									alert("You are not allowed to issue beyond the calculated stock level : #getStock.Onhand - transactionQuantity#.\n\nPlease transfer stock to this location first.")
								</script>
								</cfoutput>
	
								<cfabort>							
							
							</cfif>
															
							<cfquery name="Ship"
								datasource="AppsMaterials" 
							    username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									    SELECT   *
										FROM     ItemTransactionShipping
										WHERE    TransactionId = '#Transactionid#'				
							</cfquery>	
															
							<cfif Ship.recordcount eq "1">
							   <cfset shipping = "Yes">		
							   <cfset cls      = "COGS">				   						   
							<cfelse>
							   <cfset shipping = "No">
							   <cfset cls      = "Stock">
							</cfif>											
								
							<cfif url.value eq "void">
								
									<!--- archive --->	
									
									<cf_StockTransactDelete transactionId="#TransactionId#">						
									
									<!--- also remove triggered associated transactiona here --->		
									
									<cfquery name="removemetrics"
									datasource="AppsMaterials" 
								    username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    DELETE FROM AssetItemAction
										WHERE  TransactionId = '#TransactionId#'			
									</cfquery>								
									
									<cfquery name="removeevents"
									datasource="AppsMaterials" 
								    username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    DELETE FROM AssetItemEvent
										WHERE  TransactionId = '#TransactionId#'			
									</cfquery>						   
								
							<cfelse>
														
									<cf_StockTransactDelete transactionId="#TransactionId#" mode="log">		
								
									<cfquery name="getDetail"
									datasource="AppsMaterials" 
								    username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT   *
										FROM     ItemTransactionDetail
										WHERE    TransactionId = '#Transactionid#'				
									</cfquery>	
									
									<cfquery name="remove"
									datasource="AppsMaterials" 
								    username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    DELETE FROM ItemTransaction
										WHERE  TransactionId = '#TransactionId#'			
									</cfquery>																
											
									<!--- removes shipping, details, financials and also the valuation if this would 
									exists --->							
																		
							</cfif>		
																						
						</cfloop>						
						
						<cfif url.value neq "void">
						
							<!--- we add in the reverse order --->
						
							<cfquery name="getInsert" dbtype="query">
							    SELECT   *
								FROM     getLines
								ORDER BY Created 
							</cfquery>	
							
							<cfloop query="getInsert">
							
								<cfif Transactionid eq url.transactionid>
								   <cfset qty = url.value*-1>
								<cfelse>
								   <cfset qty = url.value>  
								</cfif>
												
								<!--- repost amended transaction --->		
										
								<cfif prior.actionstatus eq "1" and getAdministrator(prior.mission) eq "1">
									<cfset status = "1">
								<cfelse>
									<cfset status = "0">							
								</cfif>		
																							  				  
							    <cf_StockTransact 
							        TransactionId             = "#transactionid#"
									TransactionClass          = "#cls#"								
								    DataSource                = "AppsMaterials" 
								    TransactionType           = "#transactiontype#"
									TransactionSource         = "WarehouseSeries"
									ItemNo                    = "#ItemNo#" 
									Mission                   = "#Mission#" 
									Warehouse                 = "#Warehouse#" 
									Location                  = "#Location#"
									TransactionLot            = "#TransactionLot#"
									TransactionIdOrigin       = "#TransactionIdOrigin#"
									TransactionCurrency       = "#APPLICATION.BaseCurrency#"
									
									TransactionQuantity       = "#qty#"				
									
									TransactionUoM            = "#TransactionUoM#"
									TransactionUoMMultiplier  = "#TransactionUoMMultiplier#"
									TransactionCostPrice      = "#TransactionCostPrice#"
									ReceiptId                 = "#ReceiptId#"
									ReceiptCostPrice          = "#ReceiptCostPrice#"
									ReceiptPrice              = "#ReceiptPrice#"
									ActionStatus              = "#status#"
									TransactionDate           = "#dateformat(TransactionDate,CLIENT.DateFormatShow)#"
									TransactionTime           = "#timeformat(TransactionDate,'HH:MM')#"			
									TransactionBatchNo        = "#TransactionBatchNo#"
									Remarks                   = "#Remarks#"
									
									WorkOrderId               = "#WorkOrderId#"
									WorkOrderLine             = "#WorkOrderLine#"
									RequirementId             = "#requirementId#"								
									BillingUnit               = "#BillingUnit#"
									
									OrgUnit                   = "#OrgUnit#"
									PersonNo                  = "#PersonNo#"
									
									CustomerId                = "#CustomerId#"
									AssetId                   = "#AssetId#"
									ProgramCode               = "#ProgramCode#"
									RequestId                 = "#RequestId#"
									TaskSerialNo              = "#TaskSerialNo#"
									BillingMode               = "#BillingMode#"
									
									TransactionReference      = "#TransactionReference#"
									TransactionMetric         = "#TransactionMetric#"
									ParentTransactionId       = "#parenttransactionid#"				
													
									DetailLineNo              = "#getDetail.recordcount#"
									DetailReference1          = "#getDetail.Reference1#"
									DetailReference2          = "#getDetail.Reference2#"
									DetailReadInitial         = "#getDetail.MeterReadingInitial#"
									DetailReadFinal           = "#getDetail.MeterReadingFinal#"
									
									Shipping                  = "#shipping#"
									
									SchedulePrice             = "#ship.SchedulePrice#"	
									SalesUoM                  = "#Ship.SalesUoM#"       <!--- as recorded in the sale POS --->	 
									SalesQuantity             = "#qty*-1#"              <!--- as recorded in the sale POS --->	
									
									SalesPersonNo             = "#ship.SalesPersonNo#"
									SalesCurrency             = "#ship.SalesCurrency#"
									TaxCode                   = "#ship.TaxCode#"
									SalesPrice                = "#ship.SalesPrice#"
									SalesTotal				  = "#ship.SalesPrice*qty*-1#"
									TaxPercentage             = "#ship.TaxPercentage#"
									TaxExemption              = "#ship.TaxExemption#"
									TaxIncluded               = "#ship.TaxIncluded#"
									InvoiceId                 = "#ship.InvoiceId#"
									ARJournal                 = "#ship.Journal#"
									ARJournalSerialNo         = "#ship.JournalSerialNo#"																
									
									GLTransactionNo           = "#TransactionBatchNo#"
									GLTransactionSourceId     = "#Batch.BatchId#"
									
									GLCurrency                = "#APPLICATION.BaseCurrency#"
									GLAccountDebit            = "#GLAccountDebit#" 
									GLAccountCredit           = "#GLAccountCredit#">									
									
									<!--- we restore actions as well maybe best to pass this into the component as well
									19/8/2019 --->
									
									<cfquery name="getAction" dbtype="query">
											SELECT   *
											FROM     getLinesAction
											WHERE    TransactionId = '#TransactionId#'
									</cfquery>									
									
									<cfloop query="getAction">
									
										<cfquery name="insertItemTransactionAction"
											datasource="AppsMaterials" 
										    username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												INSERT INTO  ItemTransactionAction		
												(ActionId, TransactionId, ActionCode, ActionMode, ActionDate, ActionStatus, ActionMemo, OfficerUserId, OfficerLastName, OfficerFirstName)								
												VALUES
												('#ActionId#', '#TransactionId#', 
												 '#ActionCode#', 
												 '#ActionMode#', 
												 '#ActionDate#', 
												 '#ActionStatus#', 
												 '#ActionMemo#', 
												 '#OfficerUserId#', 
												 '#OfficerLastName#', 
												 '#OfficerFirstName#')																				
										</cfquery>									
									
									</cfloop>									
										
							</cfloop>
						
					     </cfif>	
					   
					   </cfif>
					  			
				</cftransaction>
				
				<cfif prior.TransactionType eq "2">
											
							<cfquery name="get"
								datasource="AppsMaterials" 
							    username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT   *,   ( SELECT O.ObjectId 
										     FROM   Organization.dbo.OrganizationObject O
											 WHERE  O.EntityCode = 'WhsTransaction'
											 AND    O.Operational = 1				
											 AND    O.ObjectKeyValue4 = T.TransactionId
										   ) as WorkflowId	 
									FROM     ItemTransaction T
									WHERE    TransactionId = '#url.TransactionId#'					
							</cfquery>	
								
							<cfoutput>
				
							    <table width="100%">
								<tr>																
															
								<td width="100%" class="labelit" bgcolor="ffffbf" align="right" style="min-width:70px;padding-left:4px; height:18; padding-right:2px;border-left:1px solid silver;border-right:1px solid silver">
								
									<cf_precision number="#item.ItemPrecision#">		
																							
									<cfif get.recordcount eq "0">		
																		
										<font color="FF0000"><cf_tl id="voided"></font>																
										
										<!--- check if batch has still transaction --->
										
										<cfquery name="check"
											datasource="AppsMaterials" 
										    username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											    SELECT  *
												FROM    ItemTransaction
												WHERE   TransactionBatchNo = '#prior.TransactionBatchNo#'					
										</cfquery>	
										
										<cfif check.recordcount eq "0">
										
											    <cfquery name="Update"
												datasource="AppsMaterials" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													UPDATE WarehouseBatch
													SET    ActionStatus           = '9', 
													       ActionOfficerUserId    = '#SESSION.acc#',
													       ActionOfficerLastName  = '#SESSION.last#',
														   ActionOfficerFirstName = '#SESSION.first#',
														   ActionOfficerDate      = getDate(),
														   ActionMemo             = 'Voided transaction'
													WHERE  BatchNo                = '#prior.TransactionBatchNo#'
												</cfquery>
													
												<cftry>
											
													<cfquery name="Clear"
													datasource="AppsMaterials" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
														DELETE FROM UserQuery.dbo.StockBatch_#SESSION.acc#	
														WHERE  BatchNo     = '#prior.TransactionBatchNo#'
													</cfquery>
												
													<cfcatch></cfcatch>
											
												</cftry>
																				
											  <script>alert("This batch has been denied.")</script>
										
										</cfif>								
										
									<cfelse>	
																																										
									    #NumberFormat(-get.TransactionQuantity,'#pformat#')#
										<cf_space spaces="16">								
										
									</cfif>
								
								</td>		
								
								<td style="width:30;padding-left:8px;padding-right:4px;padding-top:2px">
									<table width="100%">																	
										<tr>							
										
										<cfif get.transactionQuantity eq "0">		
										<cfelse>
											<td style="padding-left:6px;width:30;padding-right:4px">											
											    <cf_img icon="edit" onclick="ptoken.navigate('#SESSION.root#/warehouse/application/stock/batch/setTransactionEdit.cfm?systemfunctionid=#url.systemfunctionid#&transactionid=#transactionid#','quantity_#transactionid#')">															
											</td>	
										</cfif>	
										
										<cfif get.workflowid eq "">		
															
										    <!--- ----------------------------------------------------------------------------- --->													
										    <!--- 15/4/2013 we only check for the transaction mode is the location/item changes --->
											<!--- ----------------------------------------------------------------------------- --->
																																																																													
											<cfquery name="Check"
												datasource="AppsMaterials" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT   *
													FROM     ItemWarehouseLocationTransaction 
													WHERE    Warehouse       = '#get.warehouse#'
													AND      Location        = '#get.Location#'
													AND      ItemNo          = '#get.itemno#'
													AND      UoM             = '#get.transactionuom#'
													AND      TransactionType = '#get.TransactionType#'
											</cfquery>
																		
											<cfif check.entityclass neq "">
																							
												<td style="padding-left:5px" id="workflow_#get.transactionid#">
												
													<img src="#SESSION.root#/images/workflow_task.gif" 
													     alt="Submit an observation" 
														 width="12" height="12"
														 border="0" 
														 onclick="transactionobservation('#get.transactionid#')">
														 
												</td>
											
											</cfif>					
											
										</cfif>		
										
										</tr>
									</table>
									
								</td>
								
								</tr>
								</table>		
							
							</cfoutput>						
					
				<cfelse>
					
						<!--- we know implicitly it has full access --->
						<cfset fullaccess = "GRANTED">				
						<cfinclude template="BatchViewTransactionLines.cfm">
						
				</cfif>	
				
		</cfcase>
	
		<cfcase value="reference">	
		
			   <cfquery name="update"
				datasource="AppsMaterials" 
			    username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    UPDATE ItemTransaction
					SET    TransactionReference = '#url.value#' 
					WHERE  TransactionId        = '#TransactionId#'			
			   </cfquery>	
			   
			   <cfquery name="get"
				datasource="AppsMaterials" 
			    username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT * 
					FROM   ItemTransaction				
					WHERE  TransactionId = '#TransactionId#'			
			   </cfquery>	
			   
			   <cfoutput>
			   
			   <table width="100%">
					<tr class="labelmedium">			    	
						<td style="padding-left:3px">#get.TransactionReference#</td>
						<td align="right" style="padding-left:1px;padding-right:4px">
						<cf_img icon="edit" onclick="ptoken.navigate('#SESSION.root#/warehouse/application/stock/batch/setTransactionEdit.cfm?field=reference&systemfunctionid=#url.systemfunctionid#&transactionid=#url.transactionid#','reference_#url.transactionid#')">																									
						</td>
					</tr>
			   </table>		
			   
			   </cfoutput>							
		
		</cfcase>	
			
	</cfswitch>

</cfif>