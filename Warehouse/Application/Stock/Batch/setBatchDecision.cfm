
<cfparam name="url.action" default="Confirm">
<!--- conform batch --->

<cf_compression>	

<cfquery name="Batch"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     WarehouseBatch
	WHERE    BatchNo = '#URL.BatchNo#'
</cfquery>

<cfswitch expression="#url.action#">

	<cfcase value="Confirm">		
		
		<cfif Len(Form.ActionMemo) gt 800>
			<cfset ActionMemo = left(Form.ActionMemo,800)>	
		<cfelse>
			<cfset Actionmemo = Form.ActionMemo>	
		</cfif>
		
		<cfquery name="Update"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE WarehouseBatch
				SET    ActionMemo = '#ActionMemo#'
				WHERE  BatchNo     = '#url.BatchNo#'
		</cfquery>
		
		<cftry>
		
			<cfquery name="Clear"
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM StockBatch_#SESSION.acc#	
				WHERE  BatchNo     = '#url.BatchNo#'
			</cfquery>
		
			<cfcatch></cfcatch>
		
		</cftry>
		
		<cfquery name="Lines"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     ItemTransaction
			WHERE    TransactionBatchNo = '#URL.BatchNo#'
		</cfquery>
		
		<cftransaction>
		
			<cfoutput query="Lines">	
																	
				<cfquery name="Check"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     ItemWarehouseLocationTransaction 
					WHERE    Warehouse       = '#warehouse#'
					AND      Location        = '#Location#'
					AND      ItemNo          = '#itemno#'
					AND      UoM             = '#transactionuom#'
					AND      TransactionType = '#transactiontype#'
				</cfquery>
				
				<!--- process only the batch enabled lines or not defined, exclude manual or wf lines in the batch --->
				
				<cfif check.clearancemode eq "0" or check.clearancemode eq "1" or check.clearancemode eq "">
						
					<cfquery name="Update"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE ItemTransaction
						SET    ActionStatus = '1' 		
						WHERE  TransactionId = '#transactionid#'
					</cfquery>				
				
				</cfif>
				
				<cfif RequestId neq "">
					<cf_setRequestStatus RequestId="#Requestid#">
				</cfif>							
			
			</cfoutput>	
														
			<cfquery name="getTransaction"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   TOP 1 *
				FROM     ItemTransaction 
				WHERE    TransactionBatchNo = '#url.BatchNo#'	
				AND      ActionStatus = '0'
			</cfquery>
			
			<cfif getTransaction.recordcount eq "0">
			
				<!--- the batch is completed now --->
		
				<cfquery name="Update"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE WarehouseBatch
					SET    ActionStatus = '1', 
					       ActionOfficerUserId    = '#SESSION.acc#',
					       ActionOfficerLastName  = '#SESSION.last#',
						   ActionOfficerFirstName = '#SESSION.first#', 
						   ActionOfficerDate      = getDate()
					WHERE  BatchNo = '#url.BatchNo#'
				</cfquery>
							
			</cfif>
			
			<cfif Batch.DeliveryMode eq "1">
			
				<!--- trigger a kuntz delivery workorder object --->
												
				<cfinvoke component = "Service.Process.WorkOrder.Delivery"  
				   method           = "addDelivery" 
				   datasource       = "appsMaterials"
				   batchId          = "#Batch.BatchId#">			
		
			</cfif>
			
			<!--- if the transaction is a sales transaction we determine if something has changed to trigger reposting --->
			
			<cfif Batch.BatchClass eq "WhsSale">
			
				<cfquery name="checkDeny"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   TOP 1 *
					FROM     ItemTransactionDeny
					WHERE    TransactionBatchNo = '#url.BatchNo#'					
				</cfquery>
				
				<cfif checkDeny.recordcount eq "1">
				
					<!--- it is likely something has change --->
																
					<cfinvoke component = "Service.Process.Materials.POS"  
					   method           = "repostFromIssuance" 
					   datasource       = "appsMaterials"
					   batchId          = "#Batch.BatchId#">			
				
				</cfif>
												
				<!--- we close the API step as defined in the workflow if it is the next step only --->
				
				<cfquery name="getHeader"
				 datasource="AppsMaterials" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">			  
					  SELECT    *	
					  FROM      Accounting.dbo.TransactionHeader
					  WHERE     TransactionSourceId = '#Batch.BatchId#' 
					  AND       TransactionCategory = 'Receivables'
					  AND       RecordStatus = '1'
			    </cfquery>
				
				<cfif getHeader.recordcount eq "1">
				
					<cfquery name="getObject"
					 datasource="AppsMaterials" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">			  
						  SELECT    *	
						  FROM      Organization.dbo.OrganizationObject
						  WHERE     ObjectKeyValue4 = '#getHeader.TransactionId#' 
						  AND       Operational  = '1'
				    </cfquery>
					
					<cfif getObject.ObjectId neq "">
					
						<!--- we check if an external process needs to be done here on the workflow of the sale --->
					
						<cfinvoke component = "Service.Process.System.Workflow"  
							   method           = "ProcessStep" 
							   datasource       = "appsMaterials"
							   Action           = "external"
							   ObjectId         = "#getObject.ObjectId#"
							   batchId          = "#Batch.BatchId#">			
						   
					</cfif>	  
				
				</cfif> 
			
			</cfif>
								
		</cftransaction>				
		
		<cfif Batch.ItemNo neq "">		
			<cf_BatchDecisionMail>		
		</cfif>
				
		<!--- check to set the batch status --->
			
		<cfoutput>
				
			<script language="JavaScript">	
			     
				try { opener.stockbatchsummary('#url.systemfunctionid#'); } catch(e) {}	
			    
				try {													
			     if (opener.document.getElementById('calendarrefresh')) {		    
				     opener.document.getElementById('calendarrefresh').click()  		
				  } else {   				    					
		    	    opener.stockbatch('x','#url.systemfunctionid#','','#batch.warehouse#') } 
				 } catch(e) {}	
													
				try { document.getElementById('icancel').className = "hide" } catch(e) {}
				
				try {
				
					document.getElementById('box1').className = "hide"
					document.getElementById('box2').className = "hide"
					document.getElementById('box3').className = "hide"
					document.getElementById('box4').className = "hide"
					document.getElementById('box5').className = "hide"
					document.getElementById('box6').className = "hide"
				
				} catch(e) {}			
					
				// set the overall status now     				
				
				ptoken.navigate('setBatchStatus.cfm?stockorderid=#url.stockorderid#&trigger=decision&systemfunctionid=#url.systemfunctionid#&batchno=#url.BatchNo#','status')
				
			</script>
			
			<cf_button icon="images/selectDocument.gif"
			      mode="greenlarge" 
				  label="Next" 
				  label2="Transdaction"
				  onclick="window.location='BatchView.cfm?mode=process&systemfunctionid=#url.systemfunctionid#&mission=#batch.mission#&warehouse=#Batch.warehouse#'" 
				  name="Next" 
				  id="Next" 
				  value="Next">							
		
		</cfoutput>
				
	</cfcase>
	
	<cfcase value="Deny">
						
		<!--- cancel batch --->
		
		<!--- loop 
		
		1. delete transactions 
		2. reset requisition status
		3. set batch = 9
		--->			  
		
		<cftransaction>
					
			<!--- Hanno if transactions in this batch were driven by a request 
			we should REVERT the request so it
			gets the correct status and also [PENDING] we should revert the RequestHeader here
			???? --->
			
			<cfinvoke component   = "Service.Process.Materials.Batch"  
			   method         = "DenyBatch" 
			   datasource     = "appsOrganization"
			   BatchNo        = "#Batch.BatchNo#"	
			   ActionMemo     = "#Form.ActionMemo#">		
			   
			<cfif Batch.DeliveryMode eq "1">
			
				<!--- reset a delivery workorder object --->
												
				<cfinvoke component = "Service.Process.WorkOrder.Delivery"  
				   method           = "addDelivery" 
				   datasource       = "appsOpganization"
				   batchId          = "#Batch.BatchId#"
				   mode             = "Cancel">			
		
			</cfif> 			
			
					
		</cftransaction>
			
		<cfif Batch.ItemNo neq "">
		
			<cf_BatchDecisionMail>		
		
		</cfif>		
		
		<cfoutput>
			
			<!--- refreshing the standard screen --->
			
			<script language="JavaScript">
			
			    try { opener.stockbatchsummary('#url.systemfunctionid#') } catch(e) {}		
				
				try {													
			     if (opener.document.getElementById('calendarrefresh')) {		    
				     opener.document.getElementById('calendarrefresh').click() } 		
				   else {   				    					
		    	    opener.stockbatch('x','#url.systemfunctionid#','','#batch.warehouse#') } 
				 } catch(e) {}		    	
			  
				document.getElementById('iconfirm').className = "hide"
				ptoken.navigate('setBatchStatus.cfm?stockorderid=#url.stockorderid#&trigger=decision&systemfunctionid=#url.systemfunctionid#&batchno=#url.BatchNo#','status')
				
			</script>
		
		</cfoutput>	
	
	</cfcase>

</cfswitch>
