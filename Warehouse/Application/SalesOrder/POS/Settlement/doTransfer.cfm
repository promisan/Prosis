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
<cfparam name="url.tpe" default="8">
<cfset actiontype = "Transfer for Sale">

<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	  	FROM   Warehouse
	  	WHERE  Warehouse = '#URL.Warehouse#'
</cfquery>  

<cfset toWarehouse = get.Warehouse>
<cfset toLocation  = get.LocationReceipt>
			
<cfquery name="TransferLines"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    
	    SELECT   S.*, 
		
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
				  AND   ItemNo      = S.ItemNo
				  AND   UoM         = S.TransactionUoM
				  AND   Operational = 1
				  AND   TransactionType = '#url.tpe#') as ItemClearanceMode,
		
		    (SELECT TOP 1 EntityClass 
				  FROM Materials.dbo.ItemWarehouseLocationTransaction
				  WHERE Warehouse   = S.Warehouse
				  AND   ItemNo      = S.ItemNo
				  AND   UoM         = S.TransactionUoM
				  AND   Operational = 1
				  AND   TransactionType = '#url.tpe#') as ItemEntityClass						 			  					
				 
		FROM     CustomerRequestLineTransfer S
		
		WHERE    TransactionId IN (SELECT TransactionId 
		                           FROM   CustomerRequestLine
								   WHERE  RequestNo  = '#url.requestNo#')		
		ORDER BY Warehouse						   		
	</cfquery>		
			
	<cfoutput query="TransferLines" group="Warehouse">
		
		<cfif ItemClearanceMode eq "">
	
			<cfset clearance = ParentClearanceMode>
			<cfset level     = "parent">  
		
		<cfelse>
	
			<cfset clearance = ItemClearanceMode>		
			<cfset level     = "item">	
	
		</cfif>
						
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
		    				
			<cfquery name="Insert" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO  WarehouseBatch
					   ( Mission,
					     Warehouse, 
						 BatchWarehouse,
						 BatchClass,						 
					     BatchNo, 
						 CustomerId,						 
						 <cfif clearance eq "0">						 
						  ActionStatus, 
		      			  ActionOfficerUserId,
					      ActionOfficerLastName,
					      ActionOfficerFirstName,
				          ActionOfficerDate,
						  ActionMemo,						
						 </cfif>
					     BatchDescription, 
					     TransactionDate,
					     TransactionType, 
					     OfficerUserId, 
					     OfficerLastName, 
					     OfficerFirstName )
				VALUES ('#get.Mission#',
				        '#Warehouse#', 
						'#get.Warehouse#',
						'WhsTrSale',                						
				        '#batchNo#',
						'#url.CustomerId#',
						 <cfif clearance eq "0">	
							 '1', 
						     '#SESSION.acc#',
						     '#SESSION.last#',
					         '#SESSION.first#',
					         getDate(),
					         'Auto Clearance',
						 </cfif>
						'#actiontype#',
						getDate(),						
						'#url.tpe#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#')
			</cfquery>	
										
			<cfoutput>
			
				<cfif TransactionLocation neq "">
					<cfset toLocation = TransactionLocation>
				</cfif>
								
			    <cf_getWarehouseBilling 
				    FromWarehouse = "#Warehouse#" 
					FromLocation  = "#Location#" 
					ToWarehouse   = "#toWarehouse#" 
					ToLocation    = "#toLocation#">
					
			   		<cfset workorderid   = "">
					<cfset workorderline = "">
					<cfset requirementid = "">
					
				 <!--- get the orgUnit of the destination --->
				 
				 <cfquery name="OrgFrom"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT   TOP 1 OrgUnit
						FROM     Organization.dbo.Organization
						WHERE    MissionOrgUnitId = (SELECT MissionOrgUnitId 
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
													WHERE  Warehouse = '#toWarehouse#')								
						ORDER BY Created DESC							
				</cfquery>						 							
                  											
				<cf_verifyOperational 
			         datasource= "AppsMaterials"
			         module    = "Accounting" 
					 Warning   = "No">
			  
				  <cfif Operational eq "1"> 
				  
					  	<cfquery name="getSale"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    SELECT   *
							FROM     CustomerRequestLine
							WHERE    Transactionid = '#transactionid#'							
						</cfquery>	
				  						  
						<cfquery name="AccountStock"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    SELECT  GLAccount
							FROM    Ref_CategoryGLedger
							WHERE   Category = '#getSale.itemCategory#' 
							AND     Area     = 'Stock'
						</cfquery>	
								
						<cfquery name="AccountTask"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    SELECT  GLAccount
							FROM    Ref_CategoryGLedger
							WHERE   Category = '#getSale.itemCategory#' 
							AND     Area     = 'Variance'
						</cfquery>													
													
						<cfif AccountStock.recordcount lt "0" or AccountTask.Recordcount lt "0">
										
							<cf_alert message = "#msg1# #msg2#"
							  return = "no">
							  
							<cfabort>		
								 				
						</cfif>				
										
				   <cfset debit  = AccountStock.GLAccount>
				   <cfset credit = AccountTask.GLAccount>			 
				  				  				   
				   <!--- check the available stock again at this moment --->
				   
				   <cfinvoke component = "Service.Process.Materials.Stock"  
					   method           = "getStock" 
					   warehouse        = "#Warehouse#" 
					   location         = "#Location#"							  
					   ItemNo           = "#Itemno#"
					   UoM              = "#TransactionUoM#"							  
					   returnvariable   = "stock">		
				   				   	
				   <cfif stock.onhand lt TransactionTransfer>
				   
				   		<cfquery name="Item"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    SELECT  *
							FROM    Item
							WHERE   ItemNo = '#ItemNo#' 							
						</cfquery>		
										
						<cf_alert message = "Please revert Transfer for item #Item.Itemdescription#. There is not sufficient stock available to apply this transfer" return = "no">							  
						<cfabort>		
								 				
				   </cfif>			   
				   
				   <cf_assignid>
				   <cfset traid = rowguid>
				   
				   <cfset actionStatus = "0">				 				 			  
				   <cfset qty = -1*TransactionTransfer>		
				  				  
				   <cf_StockTransact 
				        TransactionId        = "#traid#"
						TransactionIdOrigin  = ""						
					    DataSource           = "AppsMaterials" 
					    TransactionType      = "#url.tpe#"
						TransactionSource    = "WarehouseSeries"
						ItemNo               = "#ItemNo#" 
						Mission              = "#get.Mission#" 
						Warehouse            = "#Warehouse#" 
						TransactionLot       = "#TransactionLot#"
						BillingMode          = "#billingmode#"
						Location             = "#Location#"
						TransactionCurrency  = "#APPLICATION.BaseCurrency#"
						TransactionQuantity  = "#qty#"
						TransactionUoM       = "#TransactionUoM#"						
						TransactionDate      = "#dateformat(now(),CLIENT.DateFormatShow)#"
						TransactionTime      = "#timeformat(now(),'HH:MM')#"							
						TransactionLocalTime = "Yes"
						TransactionBatchNo   = "#batchno#"
						CustomerId           = "#url.customerid#"
						workorderid          = "#workorderid#"
						workorderline        = "#workorderline#"
						requirementid        = "#requirementid#"
						Remarks              = "From POS"
						ActionStatus         = "#actionstatus#"
						DetailLineNo         = "1"
						OrgUnit              = "#OrgFrom.OrgUnit#"
						Shipping             = "No"  
						GLTransactionNo      = "#batchNo#"
						GLCurrency           = "#APPLICATION.BaseCurrency#"
						GLAccountDebit       = "#AccountTask.GLAccount#"
						GLAccountCredit      = "#AccountStock.GLAccount#">	
						
					 <!--- TO location --->	
						 
					<cfset ToItemNo = getSale.ItemNo>							
					<cfset ToUoM    = getSale.TransactionUoM>
																			
					<cfquery name="getUoMSale"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    SELECT  * 
							FROM    ItemUoM
							WHERE   ItemNo = '#toItemNo#' 
							AND     UoM    = '#toUoM#'									
					</cfquery>	
						
					<cfquery name="getUoMTransfer"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    SELECT  * 
							FROM    ItemUoM
							WHERE   ItemNo = '#toItemNo#' 
							AND     UoM    = '#TransactionUoM#'									
					</cfquery>	
					
					<!--- convert into the stock quantity of the sale --->
						
					<cfset multi = (getUoMTransfer.UoMMultiplier / getUoMSale.UoMMultiplier)>
												
					<cfset qty = multi * TransactionTransfer>													
												 
					<cf_assignid>
				    <cfset newid = rowguid>
					 								
				    <cf_StockTransact 
					    TransactionId        = "#newid#" 
					    ParentTransactionId  = "#traid#"
					    DataSource           = "AppsMaterials" 														
					    TransactionType      = "#url.tpe#"
						TransactionSource    = "WarehouseSeries"
						ItemNo               = "#ToItemNo#" 
						Mission              = "#get.Mission#" 
						Warehouse            = "#toWarehouse#" 
						TransactionLot       = "#TransactionLot#"
						BillingMode          = "#billingmode#"
						Location             = "#toLocation#"
						TransactionCurrency  = "#APPLICATION.BaseCurrency#"
						TransactionQuantity  = "#qty#"
						TransactionUoM       = "#ToUoM#"											
						TransactionDate      = "#dateformat(now(),CLIENT.DateFormatShow)#"
						TransactionTime      = "#timeformat(now(),'HH:MM')#"							
						TransactionLocalTime = "Yes"
						TransactionBatchNo   = "#batchno#"
						CustomerId           = "#url.customerid#"
						workorderid          = "#workorderid#"
						workorderline        = "#workorderline#"
						requirementid        = "#requirementid#"
						OrgUnit              = "#OrgTo.OrgUnit#"
						Remarks              = "From POS"
						ActionStatus         = "#actionstatus#"
						GLTransactionNo      = "#batchNo#"
						GLCurrency           = "#APPLICATION.BaseCurrency#"
						GLAccountDebit       = "#AccountStock.GLAccount#"
						GLAccountCredit      = "#AccountTask.GLAccount#">									
						
				  </cfif>
						
			</cfoutput>	
				
</cfoutput>		

<!--- we can keep this info, but for now we remove like before --->	

<cfquery name="CleanTransfer"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	    
	   DELETE FROM CustomerRequestLineTransfer 
	   WHERE    TransactionId IN (SELECT TransactionId 
		                          FROM   CustomerRequestLine
								  WHERE  RequestNo = '#url.RequestNo#')							   		
</cfquery>			
