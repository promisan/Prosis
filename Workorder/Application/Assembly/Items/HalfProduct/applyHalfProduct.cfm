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

<!--- apply the assembly production 

add a provision if this is going to be reapplied so it is first removed from itemtransaction based on the 
workorderid and workorderline association

--->

<cfparam name="Object.ObjectId" default="">

<cfif Object.ObjectId neq "">

	<cfquery name="workorder" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT   *
	   FROM     WorkOrder.dbo.WorkOrder 
	   WHERE    WorkOrderId = '#Object.ObjectId#' 
	</cfquery>
				
	<!--- we create the lot --->

	<cfquery name="param" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT   *
	   FROM     Ref_ParameterMission
	   WHERE    Mission = '#workorder.mission#' 
	</cfquery>
	
	<!--- to be defined --->
						
	<cfif Param.LotManagement eq "1">
									
		<cfinvoke component   = "Service.Process.Materials.Lot"  
		   method             = "addlot" 					 
		   mission            = "#Object.Mission#" 
		   transactionlot     = "#form.TransactionLot#"
		   TransactionLotDate = "#dateFormat(date, CLIENT.DateFormatShow)#">	
	   
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
		
	<cfquery name="line" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT * 
		   FROM   Organization.dbo.WorkorderLine
		   WHERE  WorkorderId = '#workorder.workorderid#'
		   AND    Operational = 1
	</cfquery>  
		
	<cfloop query="Line">
	
	    <!--- we remove any batches that already have the batch Id ---> 
		
		<cf_assignid>
		
		<cfquery name="Insert" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO WarehouseBatch
						    (Mission,
							 Warehouse, 
							 BatchWarehouse,
							 TransactionLot,		
							 BatchReference,		
							 BatchClass,
						 	 BatchNo, 	
							 BatchId,
							 BatchDescription,						
							 TransactionDate,
							 TransactionType, 					
							 ActionStatus,
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName)
				VALUES 	   ('#mission#',
					        '#url.warehouse#',
							'#url.warehouse#',
							'#TransactionLot#',		
							'#Form.BatchReference#',
							'Production',
							'#batchNo#',	
							'#workorderlineid#',
							'Workorder production',										
							#date#,
							'9',					
							'0',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#')
			</cfquery>
					
			
			<!--- select 
					the items from WorkOrderLineItem : 9		
					the resource items WorkOrderLineResource : BOM 2
			--->
			
			<cfloop query="Items">
																
				<!--- link with ledger --->
			
			 	<cfquery name="AccountStock"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT  GLAccount
						FROM    Ref_CategoryGLedger
						WHERE   Category = '#Category#' 
						AND     Area     = 'Stock'
						AND     GLAccount IN (SELECT GLAccount 
						                      FROM   Accounting.dbo.Ref_Account)
				</cfquery>	
				
				<cfloop index="row" from="1" to="4">
						
					<cfparam name="Form.Reference_#row#_#left(RequirementId,8)#" default="">	
					<cfparam name="Form.Quantity_#row#_#left(RequirementId,8)#"  default="">
					<cfparam name="Form.Location_#row#_#left(RequirementId,8)#"  default="">			
				
					<cfset ref = evaluate("Form.Reference_#row#_#left(RequirementId,8)#")>	
					<cfset qty = evaluate("Form.Quantity_#row#_#left(RequirementId,8)#")>
					<cfset loc = evaluate("Form.Location_#row#_#left(RequirementId,8)#")>		
													
					<cfif isValid("numeric",qty)>		
											
						<cfif qty gt 0 and loc neq "">			
										
							<!--- first step we can look at the workorder account --->
							
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
							
							<cfif AccountProduction.GLAccount eq "">
							
								<!--- then we defined the default income account for the production based on the category --->
											
								<cfquery name="AccountProduction"
										datasource="AppsMaterials" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
									    SELECT  GLAccount
										FROM    Ref_CategoryGLedger
										WHERE   Category = '#Category#' 
										AND     Area     = 'Production'
										AND     GLAccount IN (SELECT GLAccount 
										                      FROM   Accounting.dbo.Ref_Account)
								</cfquery>	
							
							</cfif>
					
							<cfif AccountProduction.GLAccount eq "" or AccountStock.GLAccount eq "">
							   
							   <table align="center">
							   	<tr><td class="labelmedium" align="center"><font color="FF0000">Attention : GL Account for stock and/or workorder production has not been defined yet</td></tr>
							   </table>
							   <cfabort>
							
							</cfif>
													
						<cf_assignid>
						
						<!--- posting --->			
						
						<cfif receiptmode eq "FP">
										
							<cfset prc = SaleAmountIncome/Quantity>
							<cfset cur = Currency>
						
						<cfelse>
										
							<cfset prc    = "">	 <!--- it will assign the standard cost from ItemUoMMission/ItemUoM --->
							<cfset cur    = Application.BaseCurrency>
						
						</cfif>
						
						<cf_StockTransact 
						    DataSource            = "AppsMaterials" 
							TransactionId         = "#rowguid#"	
						    TransactionType       = "0"  <!--- production --->
							TransactionSource     = "WarehouseSeries"
							ItemNo                = "#ItemNo#" 
							Mission               = "#url.Mission#" 
							Warehouse             = "#url.Warehouse#" 
							TransactionLot        = "#Form.TransactionLot#" 						
							Location              = "#Loc#"
							TransactionReference  = "#ref#"
							TransactionCurrency   = "#cur#"
							TransactionCostPrice  = "#prc#"		
							TransactionQuantity   = "#qty#"
							TransactionUoM        = "#UoM#"						
							ReceiptCurrency       = "#cur#"
							ReceiptPrice          = "#prc#"
							ReceiptCostPrice      = "#prc#"
							TransactionLocalTime  = "Yes"
							TransactionDate       = "#dateformat(date,CLIENT.DateFormatShow)#"
							TransactionTime       = "#timeformat(date,'HH:MM')#"
							TransactionBatchNo    = "#batchno#"												
							GLTransactionNo       = "#batchNo#"
							WorkOrderId           = "#workorderid#"
							WorkOrderLine         = "#workorderline#"	
							RequirementId         = "#RequirementId#"				
							OrgUnit               = "#workorderline.orgunitimplementer#"
							GLAccountDebit        = "#AccountStock.GLAccount#"
							GLAccountCredit       = "#AccountProduction.GLAccount#">
							
						</cfif>
			
					</cfif> 
			
				</cfloop>
		
		  </cfloop>
		
	</cfloop>	

</cfif>


