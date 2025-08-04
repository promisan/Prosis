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
	
				<!--- generate a batch so at the end we can sum the TransactionValue for all of the postings to add as part of the Activation --->
	
				<!--- check if batch exists --->
				
				<cfquery name="getReceipt" 
				   datasource="AppsLedger" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					   SELECT   TOP 1 *
					   FROM     Purchase.dbo.PurchaseLineReceipt
					   WHERE    ReceiptNo    = '#Object.ObjectKeyValue1#'
				</cfquery>
				
				<cfquery name="getBatch" 
				   datasource="AppsLedger" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					   SELECT   TOP 1 *
					   FROM     Materials.dbo.WarehouseBatch
					   WHERE    Warehouse = '#getReceipt.Warehouse#'
					   AND      BatchClass = 'StockAuCon'
					   AND      BatchId    = '#getReceipt.ReceiptId#'
					   ORDER BY BatchNo DESC
				</cfquery>
				
				<cfif getBatch.recordcount eq "1">
				
					<cfset batchNo = getBatch.BatchNo>
					<!---- must activate this batch that already exists------>
					<cfquery name="activateBatch" 
				   		datasource="AppsLedger" 
				   		username="#SESSION.login#" 
				   		password="#SESSION.dbpw#">
					   		UPDATE 	Materials.dbo.WarehouseBatch
					   		SET    	ActionStatus 	= '1'
					   		WHERE    BatchId  		= '#getBatch.BatchId#'
					   		AND    	BatchNo  		= '#getBatch.BatchNo#'
					</cfquery>
					
				<cfelse>			
										
					<cfquery name="Parameter" 
					   datasource="AppsLedger" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						   SELECT   TOP 1 *
						   FROM     Materials.dbo.WarehouseBatch
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
						
						
					<cfquery name="Insert" 
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Materials.dbo.WarehouseBatch
							    (Mission,
								 Warehouse, 
								 BatchWarehouse,					
								 BatchReference,	
								 BatchDescription,	
							 	 BatchNo,
								 BatchClass, 	
								 BatchId,					 					
								 TransactionDate,
								 TransactionType, 					
								 ActionStatus,						
								 OfficerUserId, 
								 OfficerLastName, 
								 OfficerFirstName)
						VALUES 	('#getWo.mission#',
							     '#getReceipt.Warehouse#',
								 '#getReceipt.Warehouse#',					
								 'Stock Auto Consumption',
								 'Consumption of Production supplies',
								 '#batchNo#',	
								 'StockAuCon',	
								 '#getReceipt.ReceiptId#',					 														 
								 '#dateformat(getReceipt.DeliveryDate,CLIENT.DateSQL)#',
								 '2',					
								 '1',					 
								 '#SESSION.acc#',
								 '#SESSION.last#',
								 '#SESSION.first#')
					</cfquery>
					
				</cfif>
				
				<!--- End of batch handling --->
				
		  
