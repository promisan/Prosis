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

<cfquery name="Batch"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     WarehouseBatch B,
	         Ref_TransactionType R 
	WHERE    B.TransactionType = R.TransactionType
	AND      BatchNo           = '#URL.BatchNo#'
</cfquery>

<cfif Batch.actionStatus eq "1">
	
	<cfinvoke component   = "Service.Access"  
		   method         = "RoleAccess" 
		   Role           = "'WhsPick'"
		   Parameter      = "#url.systemfunctionid#"
		   Mission        = "#Batch.mission#"  	
		   Warehouse      = "#Batch.Warehouse#"  	  
		   AccessLevel    = "'2'"
		   returnvariable = "FullAccess">	
	   		   
	<cfif (getAdministrator(batch.mission) eq "1" or fullaccess eq "GRANTED") and url.systemfunctionid neq "">	   
		
		<cftransaction>
			
			<cfquery name="Update0"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE WarehouseBatch
					SET    ActionStatus           = '0',
					<!--- 2/7/2023 disabled
						   CustomerId             = NULL, 	
						   CustomerIdInvoice      = NULL, 	
						   --->
						   ActionOfficerDate      = getDate(),
						   ActionOfficerUserId    = '#SESSION.acc#',
						   ActionOfficerLastName  = '#SESSION.last#',
						   ActionOfficerFirstName = '#SESSION.first#',
						   ActionMemo             = 'Undo confirmation action' 		
					WHERE  BatchNo     = '#URL.BatchNo#'
			</cfquery>
				
			<cfquery name="RevertTransaction"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE    ItemTransaction
				SET       ActionStatus = '0'
				WHERE     TransactionBatchNo = '#URL.BatchNo#'	
			</cfquery>
			
			<cfquery name="RevertTransaction"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE    ItemTransactionShipping
				SET       ActionStatus = '0'
				WHERE     TransactionId IN
			                   (SELECT  TransactionId
			                    FROM    ItemTransaction
			                    WHERE   TransactionBatchNo = '#URL.BatchNo#')
			</cfquery>
			
			<!--- 20/7/2015 added we void the sale transaction posting --->
			
			<cfif Batch.CustomerId neq "">
			
				<cfinvoke component = "Service.Process.Materials.POS"  
					   method           = "purgeTransaction" 
					   mode             = "void"
					   status           = "0"
					   batchid          = "#Batch.batchid#"
					   terminal         = "">
		
			</cfif>
		</cftransaction>
		
		<cfoutput>	
		
			<script>
			
			    // refresh summary
						    			
				try { opener.stockbatchsummary('#url.systemfunctionid#') } catch(e) {}
				
				// refresh calendar
			    										
			    try { 
				 	
			     if (opener.document.getElementById('calendarrefresh')) {		    
				    try { opener.document.getElementById('calendarrefresh').click() } catch(e) {}			
				 } else {   				    					
	    		    try { opener.stockbatch('x','#url.systemfunctionid#','','#batch.warehouse#') } catch(e) {}
				 }
				 
				 } catch(e) {}		
				 
				 // reload batch
				Prosis.busy('yes') 			
				ptoken.open('BatchView.cfm?systemfunctionid=#url.systemfunctionid#&mode=process&BatchNo=#url.batchno#','_self')
			</script>	
			
		</cfoutput>
		
	<cfelse>
	
		<script>
		   alert("You do not have access to this function")
		</script>
	
	</cfif>	
	
<cfelseif Batch.ActionStatus eq "9">
	
	<!--- revert the batch --->
	
	<!--- loop 
	1. delete transactions 
	2. reset requisition status
	3. set batch = 9
	--->
	
	<cftransaction>
	
		<cfquery name="Reset"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Request
			SET    Status = '2'
			WHERE  RequestId IN (SELECT RequestId 
			                     FROM   ItemTransaction 
								 WHERE  TransactionBatchNo = '#URL.BatchNo#')
		</cfquery>
		
		<cfquery name="List"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   ItemTransactionDeny
			WHERE  TransactionBatchNo = '#URL.BatchNo#'
			AND    Source != 'Log'
			ORDER BY ParentTransactionId
		</cfquery>
		
		<cfloop query="List">	
		
			<cfquery name="getshipping"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT * FROM ItemTransactionShippingDeny
				WHERE  TransactionId = '#TransactionId#'
			</cfquery>
			
			<cfif getShipping.recordcount eq "1">
			
			<!--- added a provision to also restore the shipping records if they exist --->			
					
			<cf_StockTransact 
			    DataSource            = "AppsMaterials" 
				TransactionId         = "#transactionid#"	
			    TransactionType       = "#TransactionType#"
				TransactionIdOrigin   = "#TransactionIdOrigin#"        
				TransactionSource     = "WarehouseSeries"
				ItemNo                = "#ItemNo#" 
				Mission               = "#Mission#" 
				Warehouse             = "#Warehouse#" 
				BillingMode           = "#BillingMode#"
				Location              = "#Location#"
				TransactionLot        = "#TransactionLot#"  
				TransactionReference  = "#transactionreference#"
				TransactionCurrency   = "#APPLICATION.BaseCurrency#"
				TransactionQuantity   = "#TransactionQuantity#"
				TransactionUoM        = "#TransactionUoM#"
				TransactionCostPrice  = "#TransactionCostPrice#"
				TransactionLocalTime  = "Yes"
				TransactionDate       = "#dateformat(TransactionDate,CLIENT.DateFormatShow)#"
				TransactionTime       = "#timeformat(TransactionDate,'HH:MM')#"
				TransactionBatchNo    = "#TransactionBatchno#"
				Remarks               = "#remarks#"			
				GLTransactionNo       = "#TransactionbatchNo#"
				WorkOrderId           = "#workorderid#"
				WorkOrderLine         = "#workorderline#"	
				RequirementId         = "#RequirementId#"
				OrgUnit               = "#orgunit#"
				OrgUnitCode           = "#orgunitcode#"
				OrgUnitName           = "#orgunitName#"
				AssetId               = "#assetid#"
				PersonNo              = "#personno#"	
				BillingUnit           = "#billingunit#"
				ProgramCode           = "#ProgramCode#"
				ParentTransactionId   = "#ParentTransactionId#"										
															
				SalesPersonNo         = "#getshipping.SalesPersonNo#"
				SalesCurrency         = "#getshipping.salesCurrency#"		
				SchedulePrice         = "#getshipping.SchedulePrice#"	
				SalesPrice            = "#getshipping.SalesPrice#"
				TaxCode               = "#getshipping.taxCode#"
				TaxPercentage         = "#getshipping.taxPercentage#"
				TaxExemption          = "#getshipping.taxExemption#"
				TaxIncluded           = "#getshipping.taxIncluded#" 
				SalesAmount           = "#getshipping.SalesAmount#"
				SalesTax              = "#getshipping.SalesTax#"	
				ARJournal             = "#getShipping.Journal#" 
				ARJournalSerialNo     = "#getShipping.JournalSerialNo#"
				
				GLCurrency            = "#APPLICATION.BaseCurrency#"
				GLAccountDebit        = "#GLAccountDebit#"
				GLAccountCredit       = "#GLAccountCredit#">					
			
			<cfelse>
			    
			<!--- pending restore observation by this transaction --->
					
			<cf_StockTransact 
			    DataSource            = "AppsMaterials" 
				TransactionId         = "#transactionid#"	
			    TransactionType       = "#TransactionType#"
				TransactionIdOrigin   = "#TransactionIdOrigin#"        
				TransactionSource     = "WarehouseSeries"
				ItemNo                = "#ItemNo#" 
				Mission               = "#Mission#" 
				Warehouse             = "#Warehouse#" 
				BillingMode           = "#BillingMode#"
				Location              = "#Location#"
				TransactionLot        = "#TransactionLot#"  
				TransactionReference  = "#transactionreference#"
				TransactionCurrency   = "#APPLICATION.BaseCurrency#"
				TransactionQuantity   = "#TransactionQuantity#"
				TransactionUoM        = "#TransactionUoM#"
				TransactionCostPrice  = "#TransactionCostPrice#"
				TransactionLocalTime  = "Yes"
				TransactionDate       = "#dateformat(TransactionDate,CLIENT.DateFormatShow)#"
				TransactionTime       = "#timeformat(TransactionDate,'HH:MM')#"
				TransactionBatchNo    = "#TransactionBatchno#"
				Remarks               = "#remarks#"			
				GLTransactionNo       = "#TransactionbatchNo#"
				WorkOrderId           = "#workorderid#"
				WorkOrderLine         = "#workorderline#"	
				RequirementId         = "#RequirementId#"
				OrgUnit               = "#orgunit#"
				OrgUnitCode           = "#orgunitcode#"
				OrgUnitName           = "#orgunitName#"
				AssetId               = "#assetid#"
				PersonNo              = "#personno#"	
				BillingUnit           = "#billingunit#"
				ProgramCode           = "#ProgramCode#"
				ParentTransactionId   = "#ParentTransactionId#"
				GLCurrency            = "#APPLICATION.BaseCurrency#"
				GLAccountDebit        = "#GLAccountDebit#"
				GLAccountCredit       = "#GLAccountCredit#">	
				
			</cfif>	
			
			<cfquery name="Delete"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				DELETE FROM ItemTransactionDeny
				WHERE  TransactionId = '#TransactionId#'
			</cfquery>
			
		</cfloop>
		
		<cfquery name="Update"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE WarehouseBatch
			SET    ActionStatus           = '0', 
			       ActionOfficerUserId    = '#SESSION.acc#',
			       ActionOfficerLastName  = '#SESSION.last#',
				   ActionOfficerFirstName = '#SESSION.first#',
				   ActionOfficerDate      = getDate(),
				   ActionMemo             = 'Reverted to draft'
			WHERE  BatchNo                = '#URL.BatchNo#'
		</cfquery>
		
		<cfquery name="set"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO WarehouseBatchAction
				(BatchNo,ActionCode,ActionDate,ActionStatus,OfficerUserId,OfficerLastName,OfficerFirstName)
				VALUES ('#URL.BatchNo#',
				        'Reinstate',
						getdate(),
						'1',
						'#session.acc#',
						'#session.last#','#session.first#')							
		</cfquery>		
		
		<!--- we alread reset related sales transactions to become active again --->
		
		<!--- terchnically we should check if there 
		     is a settlement done as well (very unlikely) and 
			 see if the workflow is closed to reset to the correct stage 0 or 1 --->
		
		<cfquery name="getHeader"
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">			  
			  UPDATE    Accounting.dbo.TransactionHeader
			  SET       RecordStatus = '1', ActionStatus = '0'
			  WHERE     TransactionSourceId = '#Batch.BatchId#' 
	    </cfquery>
		
	
	</cftransaction>
		
	<cfoutput>	
	<script>
		ptoken.open('#session.root#/Warehouse/Application/Stock/Batch/BatchView.cfm?systemfunctionid=#url.systemfunctionid#&mode=process&BatchNo=#url.batchno#','_self')
	</script>	
	</cfoutput>

</cfif>	