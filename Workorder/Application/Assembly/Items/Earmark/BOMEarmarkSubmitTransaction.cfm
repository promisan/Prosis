
<cfparam name="trareference" default=""> 
<cfparam name="traidorigin"  default="">
									
<!--- now we get the stock from a bin/location in order of importance and grouped the Lot to process the transactions in a loop --->
	
<cfset apply = replaceNoCase(apply,",","","ALL")> 
									
<cfif isValid("numeric",apply) and apply gt 0>					
					
	<cfif stockmode eq "earmarked">
		
			<cfif url.action eq "2">
																				
				<!--- post issuance transaction and book contra-stock into the production account to be offset for production or vendor delivery of FP goods --->
						
				<cf_assignid>
					
				<cfset apply = -1*apply>
											
				<cf_StockTransact 
					    DataSource            = "AppsMaterials" 
						TransactionId         = "#rowguid#"	
						TransactionIdOrigin   = "#TraIdOrigin#" 
					    TransactionType       = "2"  <!--- issuance from stock --->
						TransactionSource     = "WorkOrderSeries"
						ItemNo                = "#ItemNo#" 
						TransactionUoM        = "#TransactionUoM#"	
						Mission               = "#workorder.Mission#" 
						Warehouse             = "#url.Warehouse#" 
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
						WorkOrderId           = "#url.workorderid#"
						WorkOrderLine         = "#url.workorderline#"		
						RequirementId         = "#resid#"					
						OrgUnit               = "#workorderline.orgunitimplementer#"
						GLAccountDebit        = "#AccountProduction.GLAccount#"
						GLAccountCredit       = "#AccountStock.GLAccount#">		
					
			<cfelse>
			
				<!--- Hanno adjustment for Hicosa handling --->
				<!--- PENDING 18/9/2016 : 
				
				stock was earmarked and unearmarked button is selected means transfer stock but in the transfer
				make sure the destination is no longer earmarked to the workorder : free stock --->
			
				<!--- transfer earmarked to other warehouse --->
				
				
				<cfif url.warehouse neq url.DestinationWarehouse and location neq url.DestinationLocation>
			
					<cf_assignid>
						
					<cfset apply = -1*apply>
					
					<cfset parentid = rowguid>
					
					<cf_StockTransact 
						    DataSource            = "AppsMaterials" 
							TransactionId         = "#rowguid#"	
							TransactionIdOrigin   = "#TraIdOrigin#" 
						    TransactionType       = "8"  <!--- transfer from nonearmarked stock --->
							TransactionSource     = "WorkOrderSeries"
							ItemNo                = "#ItemNo#" 
							TransactionUoM        = "#TransactionUoM#"	
							Mission               = "#workorder.Mission#" 
							Warehouse             = "#url.Warehouse#" 
							
							TransactionLot        = "#TransactionLot#" 						
							Location              = "#Location#"
							ActionStatus          = "1"
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
							OrgUnit               = "#workorderline.orgunitimplementer#"
							GLAccountDebit        = "#AccountTask.GLAccount#"
							GLAccountCredit       = "#AccountStock.GLAccount#">	
							
					<!--- move to earmarked stock --->	
				
					<cf_assignid>	
						
					<cf_StockTransact 
				        ParentTransactionId   = "#parentid#"
					    DataSource            = "AppsMaterials" 
						TransactionId         = "#rowguid#"							
					    TransactionType       = "8"  <!--- transfer to earmarked stock under new transaction --->
						ActionStatus          = "1"
						TransactionSource     = "WorkOrderSeries"
						ItemNo                = "#ItemNo#" 
						TransactionUoM        = "#TransactionUoM#"	
						Mission               = "#workorder.Mission#" 
						Warehouse             = "#url.DestinationWarehouse#" 
						Location              = "#url.DestinationLocation#"
						TransactionLot        = "#TransactionLot#" 										
						
						TransactionReference  = "#trareference#"							
						TransactionQuantity   = "#qty#"
												
						TransactionLocalTime  = "Yes"
						TransactionDate       = "#dateformat(now(),CLIENT.DateFormatShow)#"
						TransactionTime       = "#timeformat(now(),'HH:MM')#"
						TransactionBatchNo    = "#batchno#"												
						GLTransactionNo       = "#batchNo#"		
										
						WorkOrderId           = "#url.workorderid#"
						WorkOrderLine         = "#url.workorderline#"		
						RequirementId         = "#resid#"											
						
						OrgUnit               = "#workorderline.orgunitimplementer#"
						GLAccountDebit        = "#AccountStock.GLAccount#"
						GLAccountCredit       = "#AccountTask.GLAccount#">			
						
				</cfif>	
										
			</cfif>																						
								  	
	<cfelseif stockmode eq "notearmarked">
																					
			<!--- post issuance transaction and book contra-stock into the production account to be offset for production or vendor delivery of FP goods --->
											
			<cf_assignid>
				
			<cfset apply = -1*apply>
			
			<cfset parentid = rowguid>
				
			<cf_StockTransact 
				    DataSource            = "AppsMaterials" 
					TransactionId         = "#rowguid#"	
					TransactionIdOrigin   = "#TraIdOrigin#" 
				    TransactionType       = "8"  <!--- transfer from unearmarked --->
					TransactionSource     = "WorkOrderSeries"
					ItemNo                = "#ItemNo#" 
					TransactionUoM        = "#TransactionUoM#"	
					Mission               = "#workorder.Mission#" 
					Warehouse             = "#url.Warehouse#" 
					
					TransactionLot        = "#TransactionLot#" 						
					Location              = "#Location#"
					ActionStatus          = "1"
					TransactionReference  = "#trareference#"						
					TransactionQuantity   = "#apply#"
											
					TransactionLocalTime  = "Yes"
					TransactionDate       = "#dateformat(now(),CLIENT.DateFormatShow)#"
					TransactionTime       = "#timeformat(now(),'HH:MM')#"
					TransactionBatchNo    = "#batchno#"												
					GLTransactionNo       = "#batchNo#"					
					WorkOrderId           = "#workorderid#"
					WorkOrderLine         = "#workorderline#"		
					RequirementId         = "#requirementid#"					
					OrgUnit               = "#workorderline.orgunitimplementer#"
					GLAccountDebit        = "#AccountTask.GLAccount#"
					GLAccountCredit       = "#AccountStock.GLAccount#">	
					
			<!--- move to earmarked stock --->	
			
			<cf_assignid>	
			
			<cfif url.action eq "2">
			
				 <!--- earmark stock and then issue it --->
					
				<cf_StockTransact 
			        ParentTransactionId   = "#parentid#"
				    DataSource            = "AppsMaterials" 
					TransactionId         = "#rowguid#"						
				    TransactionType       = "8"  <!--- transfer to earmarked stock --->
					ActionStatus          = "1"
					TransactionSource     = "WorkOrderSeries"
					ItemNo                = "#ItemNo#" 
					TransactionUoM        = "#TransactionUoM#"	
					Mission               = "#workorder.Mission#" 
					Warehouse             = "#url.Warehouse#" 
					
					TransactionLot        = "#TransactionLot#" 						
					Location              = "#Location#"
					
					TransactionReference  = "#trareference#"						
					TransactionQuantity   = "#qty#"
											
					TransactionLocalTime  = "Yes"
					TransactionDate       = "#dateformat(now(),CLIENT.DateFormatShow)#"
					TransactionTime       = "#timeformat(now(),'HH:MM')#"
					TransactionBatchNo    = "#batchno#"												
					GLTransactionNo       = "#batchNo#"						
					WorkOrderId           = "#url.workorderid#"
					WorkOrderLine         = "#url.workorderline#"		
					RequirementId         = "#resid#"											
					OrgUnit               = "#workorderline.orgunitimplementer#"
					GLAccountDebit        = "#AccountStock.GLAccount#"
					GLAccountCredit       = "#AccountTask.GLAccount#">			
				
		        <!--- issue stock --->
				 				 
				<cfif traidOrigin neq ""> <!--- individual mode --->
				     <!--- reset the new origin --->
					<cfset traIdOrigin = rowguid>
				</cfif>
			
				<cf_assignid>
							
				<cf_StockTransact 						       
				    DataSource            = "AppsMaterials" 
					TransactionId         = "#rowguid#"	
					TransactionIdOrigin   = "#TraIdOrigin#" 
				    TransactionType       = "2"  <!--- issue earmarked stock --->
					ActionStatus          = "1"
					TransactionSource     = "WorkOrderSeries"
					ItemNo                = "#ItemNo#" 
					TransactionUoM        = "#TransactionUoM#"	
					Mission               = "#workorder.Mission#" 
					Warehouse             = "#url.Warehouse#" 
					
					TransactionLot        = "#TransactionLot#" 						
					Location              = "#Location#"
					
					TransactionReference  = "#trareference#"						
					TransactionQuantity   = "#apply#"
											
					TransactionLocalTime  = "Yes"
					TransactionDate       = "#dateformat(now(),CLIENT.DateFormatShow)#"
					TransactionTime       = "#timeformat(now(),'HH:MM')#"
					TransactionBatchNo    = "#batchno#"												
					GLTransactionNo       = "#batchNo#"						
					WorkOrderId           = "#url.workorderid#"
					WorkOrderLine         = "#url.workorderline#"		
					RequirementId         = "#resid#"											
					OrgUnit               = "#workorderline.orgunitimplementer#"
					GLAccountDebit        = "#AccountProduction.GLAccount#"
					GLAccountCredit       = "#AccountStock.GLAccount#">			
					
			<cfelse>
			
				<!--- move to earmarked stock --->	
			
				<cf_assignid>	
					
				<cf_StockTransact 
			        ParentTransactionId   = "#parentid#"
				    DataSource            = "AppsMaterials" 
					TransactionId         = "#rowguid#"						
				    TransactionType       = "8"  <!--- transfer to earmarked stock --->
					ActionStatus          = "1"
					TransactionSource     = "WorkOrderSeries"
					ItemNo                = "#ItemNo#" 
					TransactionUoM        = "#TransactionUoM#"	
					Mission               = "#workorder.Mission#" 
					Warehouse             = "#url.DestinationWarehouse#" 
					Location              = "#url.DestinationLocation#"
					TransactionLot        = "#TransactionLot#" 										
					
					TransactionReference  = "#trareference#"						
					TransactionQuantity   = "#qty#"
											
					TransactionLocalTime  = "Yes"
					TransactionDate       = "#dateformat(now(),CLIENT.DateFormatShow)#"
					TransactionTime       = "#timeformat(now(),'HH:MM')#"
					TransactionBatchNo    = "#batchno#"												
					GLTransactionNo       = "#batchNo#"		
									
					WorkOrderId           = "#url.workorderid#"
					WorkOrderLine         = "#url.workorderline#"		
					RequirementId         = "#resid#"											
					
					OrgUnit               = "#workorderline.orgunitimplementer#"
					GLAccountCredit       = "#AccountTask.GLAccount#"
					GLAccountDebit        = "#AccountStock.GLAccount#">			
									
			</cfif>		
							
	</cfif>			
			
</cfif>
