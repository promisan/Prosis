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
<cfparam name="url.parentItemNo" default="">

<cfquery name="Warehouse"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Warehouse
	WHERE  Warehouse = '#url.whs#'	
</cfquery>		

<cfquery name="Lines"
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    *,
		      (SELECT TOP 1 ClearanceMode 
					  FROM  Materials.dbo.ItemWarehouseLocationTransaction
					  WHERE Warehouse   = S.Warehouse
					  AND   Location    = S.Location
					  AND   ItemNo      = S.ItemNo
					  AND   UoM         = S.UoM
					  AND   Operational = 1
					  AND   TransactionType = '#url.tpe#') as ItemClearanceMode
	FROM      StockInventory#url.whs#_#SESSION.acc# S 
	WHERE     ActualStock is not NULL
	AND       Location     = '#url.loc#'
	AND       Category     = '#url.category#'
	AND       CategoryItem = '#url.categoryitem#'
	<cfif URL.parentItemNo neq "">
		AND ParentItemNo = '#URL.ParentItemNo#'
	</cfif>	
	ORDER BY  EntityClass  
</cfquery>	

<cfparam name="Form.description_#url.loc#" default="">	
<cfset memo = evaluate("Form.description_#url.loc#")>	

<cfset date = evaluate("Form.transaction_#url.loc#_date")>	
<cfset hour = evaluate("Form.transaction_#url.loc#_hour")>	
<cfset minu = evaluate("Form.transaction_#url.loc#_minute")>	

<CF_DateConvert Value = "#date#">
<cfset dte = dateValue>		

<cfset dte = DateAdd("h","#hour#", dte)>
<cfset dte = DateAdd("n","#minu#", dte)>
	
<cfoutput query="Lines" group="EntityClass">

	<cftransaction>
					
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
		
		<cf_assignid>
		<cfset batchid = rowguid>
				
		<cfquery name="Insert" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO  WarehouseBatch
				  (Mission,
				   Warehouse, 
				   BatchWarehouse,
				   Location, 
				   BatchNo, 
				   BatchId,
				   BatchClass,
				   BatchDescription, 
				   BatchMemo,	
				  <cfif ItemClearanceMode eq "0">					 
						  ActionStatus, 
		      			  ActionOfficerUserId,
					      ActionOfficerLastName,
					      ActionOfficerFirstName,
				          ActionOfficerDate,
						  ActionMemo,						
					 </cfif>			 
				   TransactionDate,
				   TransactionType, 
				   OfficerUserId, 
				   OfficerLastName, 
				   OfficerFirstName)
			VALUES ('#url.mis#',
			        '#url.whs#',
					'#url.whs#',
					'#url.loc#',
			        '#batchNo#',
					'#batchid#',
					'WhsInvent',
					'Stock Inventory',
					'#memo#',					
					 <cfif ItemClearanceMode eq "0">	
						 '1', 
					     '#SESSION.acc#',
					     '#SESSION.last#',
				         '#SESSION.first#',
				         getDate(),
				         'Auto Clearance',
					 </cfif>
					#dte#, 
					'#url.tpe#',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#') 
		</cfquery>
		
		<cf_verifyOperational 
		     datasource= "AppsMaterials"
		     module    = "Accounting" 
			 Warning   = "No">
					
		<cfoutput>
		
			<!---
			 (SELECT TOP 1 ClearanceMode 
					  FROM  Materials.dbo.ItemWarehouseLocationTransaction
					  WHERE Warehouse   = S.Warehouse
					  AND   Location    = S.Location
					  AND   ItemNo      = S.ItemNo
					  AND   UoM         = S.UnitOfMeasure
					  AND   Operational = 1
					  AND   TransactionType = '#url.tpe#') as ItemClearanceMode,
			--->
			
		  <!--- link with ledger --->
   
		   <cfif ItemClearanceMode eq "0">	
			  <cfset actionStatus = "1">
		   <cfelse>
			  <cfset actionStatus = "0">
		   </cfif>  
			  
		  <cfif Operational eq "1"> 
		  
			<cfquery name="AccountStock"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT  GLAccount
				FROM    Ref_CategoryGLedger
				WHERE   Category = '#Category#' 
				AND     Area     = 'Stock'
			</cfquery>	
					
			<cfquery name="AccountTask"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT  GLAccount
				FROM    Ref_CategoryGLedger
				WHERE   Category = '#Category#' 
				AND     Area     = 'Variance'
			</cfquery>	
					
			<cfif AccountStock.recordcount lt "0" or AccountTask.Recordcount lt "0">
	
				<cf_tl id="GL Account information is not available." var="1" class="Message">
				<cfset msg1=#lt_text#>
	
				<cf_tl id="Operation not allowed." var="1" class="Message">
				<cfset msg2=#lt_text#>			
											
				<cf_message 
				  message = "#msg1# #msg2#"
				  return = "no">
				  <cfabort>
			
			</cfif>
			
			<cfif onhand eq "">			
			    <cfset diff = actualstock>
			<cfelse>			
			    <cfset diff = actualstock-onhand>
			</cfif>
										
			<cfif diff gt 0>
			
			    <cfset debit  = AccountStock.GLAccount>
				<cfset credit = AccountTask.GLAccount>
				
			<cfelse>
			
				<cfset credit  = AccountStock.GLAccount>
				<cfset debit   = AccountTask.GLAccount>
			
			</cfif>				
			
			<cfif TransactionReference neq "">
				<cfset ref = TransactionReference>
			<cfelse>
				<cfset ref = "Stock discrepancy">
			</cfif>	
			
			<cfif requirementId eq "00000000-0000-0000-0000-000000000000" or requirementid eq "">			
				<cfset req = "">		
			<cfelse>
				<cfset req = requirementid>		
		    </cfif>			
											  
		    <cf_StockTransact 
		        TransactionId          = "#transactionid#" 
			    DataSource             = "AppsMaterials" 
			    TransactionType        = "#url.tpe#"
				TransactionIdOrigin    = "#TransactionidOrigin#"
				TransactionSource      = "WarehouseSeries"
				GLTransactionSourceId  = "#batchid#"
				ItemNo                 = "#ItemNo#" 
				Mission                = "#url.mis#" 
				Warehouse              = "#Warehouse#" 
				TransactionLot         = "#TransactionLot#"
				Location               = "#Location#"		
				WorkOrderId            = "#workorderid#"
				WorkOrderLine          = "#workorderLine#"
				RequirementId          = "#req#"	
				ActionStatus           = "#actionstatus#"
				TransactionCurrency    = "#APPLICATION.BaseCurrency#"
				TransactionQuantity    = "#diff#"
				TransactionUoM         = "#UoM#"
				TransactionMetric      = "#metric#"				
				TransactionCostPrice   = "#StandardCost#"
				
				TransactionDate        = "#dateformat(dte,CLIENT.DateFormatShow)#"
				TransactionTime        = "#timeformat(dte,'HH:MM')#"							
				TransactionLocalTime   = "Yes"	
				
				TransactionBatchNo     = "#batchno#"
				TransactionReference   = "#ref#"
				GLTransactionNo        = "#batchNo#"
				GLCurrency             = "#APPLICATION.BaseCurrency#"
				GLAccountDebit         = "#debit#"
				GLAccountCredit        = "#credit#">	
							
		  <cfelse>
		  
		    <cfif onhand eq "">
			    <cfset diff = actualstock>
			<cfelse>
			    <cfset diff = actualstock-onhand>
			</cfif>
		  
		   	<cf_StockTransact 
			    TransactionId          = "#transactionid#"
			    DataSource             = "AppsMaterials" 
			    TransactionType        = "#url.tpe#"
				TransactionIdOrigin    = "#TransactionidOrigin#"
				TransactionSource      = "WarehouseSeries"
				GLTransactionSourceId  = "#batchid#"
				ItemNo                 = "#ItemNo#" 
				Mission                = "#URL.mis#" 
				Warehouse              = "#Warehouse#" 
				TransactionLot         = "#TransactionLot#"
				Location               = "#Location#"		
				WorkOrderId            = "#workorderid#"
				WorkOrderLine          = "#workorderLine#"
				RequirementId          = "#req#"		
				ActionStatus           = "#actionstatus#"
				TransactionCurrency    = "#APPLICATION.BaseCurrency#"
				TransactionQuantity    = "#diff#"
				TransactionUoM         = "#UoM#"
				TransactionMetric      = "#metric#"	
				TransactionCostPrice   = "#StandardCost#"				
				TransactionDate        = "#dateformat(dte,CLIENT.DateFormatShow)#"
				TransactionTime        = "#timeformat(dte,'HH:MM')#"							
				TransactionLocalTime   = "Yes"					
				TransactionBatchNo     = "#batchno#"
				TransactionReference   = "Stock discrepancy">			
			
		  </cfif>
			  	
		</cfoutput>	
					
	</cftransaction>

</cfoutput>

<!--- check --->

<cfparam name="batchno" default="">

<cfif batchno neq "">

	<cfquery name="check"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   ItemTransaction
		WHERE  TransactionBatchNo = '#batchno#'	
	</cfquery>	
	
	<cfif check.recordcount eq "0">
		
		<cfquery name="remove"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE WarehouseBatch
			SET ActionStatus = '9'
			WHERE  BatchNo = '#batchno#'
		</cfquery>	
			
		<script language="JavaScript">
		  alert("No modification were recorded. Action was logged but aborted.")		
		</script>
	
	<cfelse>
		
		<!--- clean the records --->
	
		<cfquery name="Clean"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    DELETE FROM UserTransaction.dbo.StockInventory#url.whs#_#SESSION.acc# 
			WHERE     ActualStock is not NULL
			AND       Location     = '#url.loc#'
			AND       Category     = '#url.category#'
			AND       CategoryItem = '#url.categoryitem#'
		</cfquery>	
		
		<!--- ------------------------------------------------------------------------------ --->		
		<!--- workflow record to be added which is done currently outside of the transaction --->
		<!--- ------------------------------------------------------------------------------ --->
		
		<cfloop query="Lines">
			
			<cfif entityclass neq "" and ItemClearanceMode eq "1">
			
			      <cfset link = "Warehouse/Application/Stock/Batch/BatchView.cfm?mission=#Warehouse.Mission#&batchno=#batchno#">
							
				  <cf_ActionListing 
					    EntityCode       = "WhsTransaction"
						EntityClass      = "#EntityClass#"
						EntityGroup      = ""
						EntityStatus     = ""
						Mission          = "#Warehouse.Mission#"															
						ObjectReference  = "Stock Discrepancy #warehouse.warehousename#"
						ObjectReference2 = "#ItemDescription#" 											   
						ObjectKey4       = "#transactionid#"
						ObjectURL        = "#link#"
						Show             = "No">				
			
			</cfif>
		
		</cfloop>
		
		<cfoutput>
			
			<cf_tl id="Inventory was submitted for clearance and stock levels were successfully adjusted" var = "tSubmit">
			<cf_tl id="Your manager will need to clear this transaction" var = "tManager">
			
			<script language="JavaScript">
			  alert("#tSubmit#. \n\n #tManager#.")
			  locshow('#url.loc#','#url.category#','#url.categoryitem#','#url.box#','#url.systemfunctionid#','1','',document.getElementById('hidezero').checked,'#URL.ParentItemNo#')
			</script>
		
		</cfoutput>
		
	</cfif>	

<cfelse>
	
	<cfoutput>
			
			<cf_tl id="No modifications were detected." var = "1">
			
			<script language="JavaScript">
			  alert("#lt_text#")
			  locshow('#url.loc#','#url.category#','#url.categoryitem#','#url.box#','#url.systemfunctionid#','1',document.getElementById('hidezero').checked,'#URL.ParentItemNo#')
			</script>
		
	</cfoutput>
	
</cfif>