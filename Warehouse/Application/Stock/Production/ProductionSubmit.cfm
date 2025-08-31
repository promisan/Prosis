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
<cfparam name="Form.TransactionLot" default="">

<cfif Form.transactionLot eq "">
  <cfset TransactionLot = "0">
<cfelse>  
  <cfset TransactionLot = Form.TransactionLot>
</cfif>

<cfquery name="getMission" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT   *
   FROM     Warehouse
   WHERE    Warehouse = '#url.warehouse#' 
</cfquery>

<cfset mission = getmission.mission>

<cfset date = evaluate("Form.transactionDate_date")>	
<cfset hour = evaluate("Form.transactionDate_hour")>	
<cfset minu = evaluate("Form.transactionDate_minute")>	

<CF_DateConvert Value = "#date#">
<cfset dte = dateValue>		

<cfset dte = DateAdd("h","#hour#", dte)>
<cfset dte = DateAdd("n","#minu#", dte)>

<cfset date = dte>		

<cfquery name="param" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT   *
   FROM     Ref_ParameterMission
   WHERE    Mission = '#mission#' 
</cfquery>

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

<cfquery name="workorder" 
	datasource="AppsWorkOrder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   Workorder 
	   WHERE  WorkorderId = '#form.workorderid#'
</cfquery>  

<!--- create the production lot --->

<!--- submit --->

<cf_assignid>

<cftransaction>

	<!--- we create the lot --->

	<cfquery name="param" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT   *
	   FROM     Ref_ParameterMission
	   WHERE    Mission = '#mission#' 
	</cfquery>
					
	<cfif Param.LotManagement eq "1">
									
		<cfinvoke component   = "Service.Process.Materials.Lot"  
		   method             = "addlot" 					 
		   mission            = "#url.Mission#" 
		   transactionlot     = "#form.TransactionLot#"
		   TransactionLotDate = "#dateFormat(date, CLIENT.DateFormatShow)#">	
	   
	</cfif>   

	<!--- record the production lot --->
	
	<cfif receiptmode eq "FP">
					
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
						'#rowguid#',
						'Production',										
						#date#,
						'0',					
						'0',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#')
		</cfquery>
		
		<cfquery name="Items" 
			datasource="AppsMaterials"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		
				SELECT   WOL.WorkorderItemId as RequirementId,
						 WOL.WorkOrderId,
						 WOL.WorkOrderLine,   
						 I.ItemNo, 
						 I.ItemDescription,
						 U.UoM, 
						 I.Category,					
						 U.UoMDescription, 
						 WOL.Quantity, 
						 WOL.Currency, 
						 WOL.SalePrice, 
						 WOL.SaleAmountIncome, 
						 WOL.Created
				FROM     Workorder.dbo.WorkOrderLineItem WOL 
				         INNER JOIN Item I ON WOL.ItemNo = I.ItemNo 
						 INNER JOIN ItemUoM U ON WOL.ItemNo = U.ItemNo AND WOL.UoM = U.UoM
				WHERE	 WOL.WorkOrderId = '#form.workorderid#' 
				ORDER BY WorkorderLine			
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
						 TransactionLot,		
						 BatchReference,		
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
						'#batchNo#',	
						'#rowguid#',
						'Receipt from customer',										
						#date#,
						'0',					
						'0',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#')
		</cfquery>
		
		<cfquery name="Items" 
			datasource="AppsMaterials"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		
				SELECT  WOL.ResourceId as RequirementId,
						WOL.WorkOrderId,
						WOL.WorkOrderLine,   
						I.ItemNo, 
						I.ItemDescription,
						U.UoM, 
						I.Category,					
						U.UoMDescription, 
						WOL.Quantity, 						
						WOL.Created
				FROM    Workorder.dbo.WorkOrderLineResource WOL 
				        INNER JOIN Item I ON WOL.ResourceItemNo = I.ItemNo 
						INNER JOIN ItemUoM U ON WOL.ResourceItemNo = U.ItemNo AND WOL.ResourceUoM = U.UoM
				WHERE	WOL.WorkOrderId = '#form.workorderid#' 
				ORDER BY WorkorderLine			
		</cfquery>
	
	</cfif>	
	
	<!--- posting of the lines --->
			
	<cfloop query="Items">
			
		<cfquery name="workorderLine" 
			datasource="AppsMaterials"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT * 
			   FROM   Workorder.dbo.WorkorderLine 
			   WHERE  WorkorderId   = '#workorderid#'
			   AND    WorkOrderLine = '#workorderline#'
		</cfquery>   
		
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
					   	<tr><td class="labelit" align="center"><font color="FF0000">Attention : GL Account for stock and/or workorder production has not been defined yet</td></tr>
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
					<cfset cur    = "#Application.BaseCurrency#">
				
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
		
</cftransaction>

<!--- reload --->

<cfoutput>
<script>
    alert("Transaction was recorded under No #batchno#")
	ptoken.navigate('#SESSION.root#/Warehouse/Application/Stock/Production/getWorkorderItems.cfm?warehouse=#url.warehouse#&workorderid=#form.WorkOrderId#&receiptmode=#receiptmode#','itemcontent')
</script>
</cfoutput>

