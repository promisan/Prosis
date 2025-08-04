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

<!--- ---------------------- --->
<!--- ---submit the return-- --->
<!--- ---------------------- --->

<!--- 

   1. make a booking for the selected transaction but in the reverse using 3
   2. transfer stock (8) from this workorder/line/requirement to NULL
   3. open the batch screen and refresh the screen
   	      	   
--->   

<cfparam name="Form.selected" default="">

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      WorkOrder
	WHERE     WorkOrderId = '#url.workorderid#'	
</cfquery>  

<!--- create batch --->

<cfset date = evaluate("Form.transactionDate_date")>	

<CF_DateConvert Value = "#date#">
<cfset dte = dateValue>		

<cfquery name="param" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   	   SELECT   *
	   FROM     Ref_ParameterMission
	   WHERE    Mission = '#get.mission#' 
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

<cf_assignid>

<cftransaction>

<!--- record the batch --->
				
<cfquery name="Insert" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO WarehouseBatch
		    (Mission,
			 Warehouse, 
			 BatchWarehouse,					
			 BatchReference,	
			 Location,	
		 	 BatchNo,
			 BatchClass, 	
			 BatchId,
			 BatchDescription,						
			 TransactionDate,
			 TransactionType, 					
			 ActionStatus,
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
	VALUES 	('#get.mission#',
		     '#form.warehouse#',
			 '#form.warehouse#',					
			 '#Form.BatchReference#',
			 '#form.Location#',
			 '#batchNo#',	
			 'WOReturn',
			 '#rowguid#',
			 'Workorder return shipment',										
			 #dte#,
			 '3',					
			 '0',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')
</cfquery>

<cfparam name="Form.selected" default="">
			
<cfquery name="LinesToBeReturn" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    T.*, 
	          I.Category,
	          R.StockControlMode AS StockControlMode,
			  (SELECT TransactionId
               FROM    Accounting.dbo.TransactionHeader
               WHERE   TransactionId = TS.InvoiceId
   	           AND     RecordStatus != '9') as Billed
			   
	FROM      ItemTransaction T INNER JOIN
              Item I ON T.ItemNo = I.ItemNo INNER JOIN
              Ref_Category R ON I.Category = R.Category INNER JOIN
			  ItemTransactionShipping TS ON T.TransactionId = TS.TransactionId
	<cfif form.selected neq "">
	WHERE     T.TransactionId IN (#preservesinglequotes(Form.Selected)#) 	
	<cfelse>
	WHERE 1=0
	</cfif>
</cfquery>	

<cfloop query="LinesToBeReturn">	

		<cfquery name="AccountStock"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT  GLAccount
				FROM    Ref_CategoryGLedger
				WHERE   Category  = '#Category#' 
				AND     Area      = 'Stock'
				AND     GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
		</cfquery>		
		
		<!--- first step we can look at the workorder account --->
																		
		<cfquery name="AccountCOGS"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT  GLAccount
				FROM    Ref_CategoryGLedger
				WHERE   Category = '#Category#' 
				AND     Area     = 'COGS'
				AND     GLAccount IN (SELECT GLAccount 
				                      FROM   Accounting.dbo.Ref_Account)
		</cfquery>	
		
		<!--- first step we can look at the workorder account --->
																		
		<cfquery name="AccountVariance"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT  GLAccount
				FROM    Ref_CategoryGLedger
				WHERE   Category = '#Category#' 
				AND     Area     = 'Variance'
				AND     GLAccount IN (SELECT GLAccount 
				                      FROM   Accounting.dbo.Ref_Account)
		</cfquery>	
		
		<cfquery name="AccountDisposal"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT  GLAccount
				FROM    Ref_CategoryGLedger
				WHERE   Category = '#Category#' 
				AND     Area     = 'WriteOff'
				AND     GLAccount IN (SELECT GLAccount 
				                      FROM   Accounting.dbo.Ref_Account)
		</cfquery>	
		
		<cfif AccountDisposal.GLAccount eq "">
		
			<cfquery name="AccountDisposal"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT  GLAccount
					FROM    Ref_CategoryGLedger
					WHERE   Category = '#Category#' 
					AND     Area     = 'Variance'
					AND     GLAccount IN (SELECT GLAccount 
					                      FROM   Accounting.dbo.Ref_Account)
			</cfquery>	
		
		</cfif>
							
		<cfif AccountVariance.recordcount eq "0" or AccountCOGS.recordcount eq "0" or AccountStock.recordcount eq "0" or AccountDisposal.recordcount eq "0">
		   
		   <table align="center">
		      	<tr>
				   <td class="labelit" align="center"><font color="FF0000">Attention : GL Account for stock and/or COGS production has not been defined</td>
				</tr>
		   </table>
		   <cfabort>
		
		</cfif>	
		
		<cfparam name="Form.Quantity_#TransactionSerialNo#" default="0">
	
		<cfset qty = evaluate("Form.Quantity_#TransactionSerialNo#")>		
		
		<!--- -------------------------------------------------------------------------------- --->
		<!--- if the shipping action is completely return and NOT billed yet, this is -voided- --->
		<!--- -------------------------------------------------------------------------------- --->
				
		<cfif qty eq (transactionquantity * -1) and Billed eq "">
		
			<cfset void = 1>
			
		<cfelse>
		
			<cfset void = "0">	
		
		</cfif>
					
		<cfif StockControlMode eq "stock">
		
				<!--- -------------------- --->
				<!--- -return earmarked--- --->
				<!--- -------------------- --->	
				
				<cf_assignid>
				
				<cfif void eq "1">
				
					<cf_StockTransact 
					    DataSource            = "AppsMaterials" 
						TransactionId         = "#rowguid#"	
					    TransactionType       = "3"  <!--- return to stock --->
						TransactionSource     = "WorkorderSeries"
						ItemNo                = "#ItemNo#" 
						Mission               = "#Mission#" 
						Warehouse             = "#Form.Warehouse#" 
						TransactionLot        = "#TransactionLot#" 						
						Location              = "#Form.Location#"
						TransactionReference  = "#Form.BatchReference#"
						TransactionCurrency   = "#APPLICATION.BaseCurrency#"
						TransactionCostPrice  = "#TransactionCostPrice#" 
						TransactionQuantity   = "#qty#"
						TransactionUoM        = "#TransactionUoM#"						
						TransactionLocalTime  = "Yes"
						TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
						TransactionTime       = "#timeformat(now(),'HH:MM')#"
						TransactionBatchNo    = "#batchno#"												
						GLTransactionNo       = "#batchNo#"
						ParentTransactionId   = "#transactionid#"	
						WorkOrderId           = "#workorderid#"
						WorkOrderLine         = "#workorderline#"	
						RequirementId         = "#requirementid#"	
						GLAccountDebit        = "#AccountStock.GLAccount#"															
						GLAccountCredit       = "#AccountCOGS.GLAccount#">
						
				<cfelse>
				
					<cfquery name="getWorkOrderLine"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT  *
							FROM    WorkOrder.dbo.WorkOrderLineItem
							WHERE   WorkOrderItemId = '#requirementid#'
					</cfquery>	
					
					<cf_StockTransact 
					    DataSource            = "AppsMaterials" 
						TransactionId         = "#rowguid#"	
					    TransactionType       = "3"  <!--- return to stock --->
						TransactionSource     = "WorkorderSeries"
						ItemNo                = "#ItemNo#" 
						Mission               = "#Mission#" 
						Warehouse             = "#Form.Warehouse#" 
						TransactionLot        = "#TransactionLot#" 						
						Location              = "#Form.Location#"
						TransactionReference  = "#Form.BatchReference#"
						TransactionCurrency   = "#APPLICATION.BaseCurrency#"
						TransactionCostPrice  = "#TransactionCostPrice#" 
						TransactionQuantity   = "#qty#"
						TransactionUoM        = "#TransactionUoM#"						
						TransactionLocalTime  = "Yes"
						TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
						TransactionTime       = "#timeformat(now(),'HH:MM')#"
						TransactionBatchNo    = "#batchno#"												
						GLTransactionNo       = "#batchNo#"						
						WorkOrderId           = "#workorderid#"
						WorkOrderLine         = "#workorderline#"	
						RequirementId         = "#requirementid#"	
						GLAccountDebit        = "#AccountStock.GLAccount#"															
						GLAccountCredit       = "#AccountCOGS.GLAccount#"		
						ParentTransactionId   = "#transactionid#"		
						Shipping              = "Yes"
						SalesCurrency         = "#getWorkOrderLine.currency#"
						SalesPrice            = "#getWorkOrderLine.SalePrice#"
						TaxPercentage         = "#getWorkOrderLine.SaleTax#"
						TaxCode               = "#getWorkOrderLine.TaxCode#"
						TaxExemption          = "#getWorkOrderLine.TaxExemption#"
						TaxIncluded           = "#getWorkOrderLine.TaxIncluded#"
						SalesTax              = "0">
				
				</cfif>		
					
				<cfif form.ReturnMode eq "unearmarked">
	
					<cf_assignid>
					
					<!--- -------------------- --->
					<!--- -lower unearmarked-- --->
					<!--- -------------------- --->	
					
					<cf_StockTransact 
					    DataSource            = "AppsMaterials" 
						TransactionId         = "#rowguid#"	
					    TransactionType       = "8"  <!--- Transfer from --->
						TransactionSource     = "WorkorderSeries"
						ItemNo                = "#ItemNo#" 
						Mission               = "#Mission#" 
						Warehouse             = "#Form.Warehouse#" 
						TransactionLot        = "#TransactionLot#" 						
						Location              = "#Form.Location#"
						TransactionReference  = "#Form.BatchReference#"
						TransactionCurrency   = "#APPLICATION.BaseCurrency#"
						TransactionQuantity   = "#-qty#"
						TransactionUoM        = "#TransactionUoM#"						
						TransactionLocalTime  = "Yes"
						TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
						TransactionTime       = "#timeformat(now(),'HH:MM')#"
						TransactionBatchNo    = "#batchno#"												
						GLTransactionNo       = "#batchNo#"
						WorkOrderId           = "#workorderid#"
						WorkOrderLine         = "#workorderline#"	
						RequirementId         = "#requirementid#"																
						GLAccountDebit        = "#AccountVariance.GLAccount#"
						GLAccountCredit       = "#AccountStock.GLAccount#">
					
					<!--- -------------------------- --->	
					<!--- -----higher unearmarked--- --->	
					<!--- -------------------------- --->
				
					<cfset parid = rowguid>
					<cf_assignid>
					
					<cf_StockTransact 
					    DataSource            = "AppsMaterials" 
						TransactionId         = "#rowguid#"	
					    TransactionType       = "8"  <!--- Transfer to --->
						TransactionSource     = "WorkorderSeries"
						ItemNo                = "#ItemNo#" 
						Mission               = "#Mission#" 
						Warehouse             = "#Form.Warehouse#" 
						TransactionLot        = "#TransactionLot#" 						
						Location              = "#Form.Location#"
						TransactionReference  = "#Form.BatchReference#"
						TransactionCurrency   = "#APPLICATION.BaseCurrency#"
						TransactionQuantity   = "#qty#"
						TransactionUoM        = "#TransactionUoM#"						
						TransactionLocalTime  = "Yes"
						TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
						TransactionTime       = "#timeformat(now(),'HH:MM')#"
						TransactionBatchNo    = "#batchno#"												
						GLTransactionNo       = "#batchNo#"
						ParentTransactionId   = "#parid#"	
						GLAccountDebit        = "#AccountStock.GLAccount#"							
						GLAccountCredit       = "#AccountVariance.GLAccount#">					
				
				<cfelse>
				
					<cf_assignid>
					
					<!--- -------------------- --->
					<!--- -----disposal------- --->
					<!--- -------------------- --->	
					
					<cfset parid = rowguid>
										
					<cf_StockTransact 
					    DataSource            = "AppsMaterials" 
						TransactionId         = "#rowguid#"	
					    TransactionType       = "4"  <!--- Disposal --->
						TransactionSource     = "WorkorderSeries"
						ItemNo                = "#ItemNo#" 
						Mission               = "#Mission#" 
						Warehouse             = "#Form.Warehouse#" 
						TransactionLot        = "#TransactionLot#" 						
						Location              = "#Form.Location#"
						TransactionReference  = "#Form.BatchReference#"
						TransactionCurrency   = "#APPLICATION.BaseCurrency#"
						TransactionQuantity   = "#-qty#"
						TransactionUoM        = "#TransactionUoM#"						
						TransactionLocalTime  = "Yes"
						TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
						TransactionTime       = "#timeformat(now(),'HH:MM')#"
						TransactionBatchNo    = "#batchno#"												
						GLTransactionNo       = "#batchNo#"
						ParentTransactionId   = "#parid#"	
						WorkOrderId           = "#workorderid#"
						WorkOrderLine         = "#workorderline#"	
						RequirementId         = "#requirementid#"																
						GLAccountDebit        = "#AccountDisposal.GLAccount#"
						GLAccountCredit       = "#AccountStock.GLAccount#">								
				
				</cfif>
			
		<cfelse>
				
				<!--- -------------------- --->
				<!--- -return earmarked--- --->
				<!--- -------------------- --->	
				
				<cf_assignid>
				<cfset parid = rowguid>
				
				<cfif void eq "1">
				
					<cf_StockTransact 
					    DataSource            = "AppsMaterials" 
						TransactionId         = "#rowguid#"	
					    TransactionType       = "3"  <!--- return to stock --->
						TransactionSource     = "WorkorderSeries"
						ItemNo                = "#ItemNo#" 
						Mission               = "#Mission#" 
						Warehouse             = "#Form.Warehouse#" 
						TransactionLot        = "#TransactionLot#" 						
						Location              = "#Form.Location#"
						TransactionReference  = "#TransactionReference#"
						TransactionCurrency   = "#APPLICATION.BaseCurrency#"
						TransactionCostPrice  = "#TransactionCostPrice#" 
						TransactionQuantity   = "#qty#"
						TransactionUoM        = "#TransactionUoM#"						
						TransactionLocalTime  = "Yes"
						TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
						TransactionTime       = "#timeformat(now(),'HH:MM')#"
						TransactionBatchNo    = "#batchno#"												
						GLTransactionNo       = "#batchNo#"
						ParentTransactionId   = "#parent#"	
						WorkOrderId           = "#workorderid#"
						WorkOrderLine         = "#workorderline#"	
						RequirementId         = "#requirementid#"		
						GLAccountDebit        = "#AccountStock.GLAccount#"														
						GLAccountCredit       = "#AccountCOGS.GLAccount#">
						
				<cfelse>
				
					<cfquery name="getWorkOrderLine"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT  *
							FROM    WorkOrder.dbo.WorkOrderLineItem
							WHERE   WorkOrderItemId = '#requirementid#'
					</cfquery>	
					
				
					<cf_StockTransact 
					    DataSource            = "AppsMaterials" 
						TransactionId         = "#rowguid#"	
					    TransactionType       = "3"  <!--- return to stock --->
						TransactionSource     = "WorkorderSeries"
						ItemNo                = "#ItemNo#" 
						Mission               = "#Mission#" 
						Warehouse             = "#Form.Warehouse#" 
						TransactionLot        = "#TransactionLot#" 						
						Location              = "#Form.Location#"
						TransactionReference  = "#TransactionReference#"
						TransactionCurrency   = "#APPLICATION.BaseCurrency#"
						TransactionCostPrice  = "#TransactionCostPrice#" 
						TransactionQuantity   = "#qty#"
						TransactionUoM        = "#TransactionUoM#"						
						TransactionLocalTime  = "Yes"
						TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
						TransactionTime       = "#timeformat(now(),'HH:MM')#"
						TransactionBatchNo    = "#batchno#"												
						GLTransactionNo       = "#batchNo#"					
						WorkOrderId           = "#workorderid#"
						WorkOrderLine         = "#workorderline#"	
						RequirementId         = "#requirementid#"		
						GLAccountDebit        = "#AccountStock.GLAccount#"														
						GLAccountCredit       = "#AccountCOGS.GLAccount#"
						ParentTransactionId   = "#transactionid#"	
						Shipping              = "Yes"
						SalesCurrency         = "#getWorkOrderLine.currency#"
						SalesPrice            = "#getWorkOrderLine.SalePrice#"
						TaxPercentage         = "#getWorkOrderLine.SaleTax#"
						TaxCode               = "#getWorkOrderLine.TaxCode#"
						TaxExemption          = "#getWorkOrderLine.TaxExemption#"
						TaxIncluded           = "#getWorkOrderLine.TaxIncluded#"
						SalesTax              = "0">
						
				
				</cfif>	
					
				<cfif form.mode eq "unearmarked">
	
					<!--- -------------------- --->
					<!--- -lower unearmarked-- --->
					<!--- -------------------- --->	
					
					<cf_assignid>
					
					<cf_StockTransact 
					    DataSource            = "AppsMaterials" 
						TransactionId         = "#rowguid#"	
						TransactionIdOrigin   = "#parid#"
					    TransactionType       = "8"  <!--- Transfer from --->
						TransactionSource     = "WorkorderSeries"
						ItemNo                = "#ItemNo#" 
						Mission               = "#Mission#" 
						Warehouse             = "#Form.Warehouse#" 
						TransactionLot        = "#TransactionLot#" 						
						Location              = "#Form.Location#"
						TransactionReference  = "#TransactionReference#"
						TransactionCurrency   = "#APPLICATION.BaseCurrency#"
						TransactionQuantity   = "#-qty#"
						TransactionUoM        = "#TransactionUoM#"						
						TransactionLocalTime  = "Yes"
						TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
						TransactionTime       = "#timeformat(now(),'HH:MM')#"
						TransactionBatchNo    = "#batchno#"												
						GLTransactionNo       = "#batchNo#"
						WorkOrderId           = "#workorderid#"
						WorkOrderLine         = "#workorderline#"	
						RequirementId         = "#requirementid#"																
						GLAccountDebit        = "#AccountVariance.GLAccount#"
						GLAccountCredit       = "#AccountStock.GLAccount#">
					
					<!--- -------------------------- --->	
					<!--- -----higher unearmarked--- --->	
					<!--- -------------------------- --->
					
					<cfset parid = rowguid>
					
					<cf_assignid>
					
					<cf_StockTransact 
					    DataSource            = "AppsMaterials" 
						TransactionId         = "#rowguid#"	
					    TransactionType       = "8"  <!--- Transfer to --->
						TransactionSource     = "WorkorderSeries"
						ItemNo                = "#ItemNo#" 
						Mission               = "#Mission#" 
						Warehouse             = "#Form.Warehouse#" 
						TransactionLot        = "#TransactionLot#" 						
						Location              = "#Form.Location#"
						TransactionReference  = "#TransactionReference#"
						TransactionCurrency   = "#APPLICATION.BaseCurrency#"
						TransactionQuantity   = "#qty#"
						TransactionUoM        = "#TransactionUoM#"						
						TransactionLocalTime  = "Yes"
						TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
						TransactionTime       = "#timeformat(now(),'HH:MM')#"
						TransactionBatchNo    = "#batchno#"												
						GLTransactionNo       = "#batchNo#"
						ParentTransactionId   = "#parid#"	
						GLAccountDebit        = "#AccountStock.GLAccount#"							
						GLAccountCredit       = "#AccountVariance.GLAccount#">				
						
				<cfelse>
				
					<!--- -------------------- --->
					<!--- -disposal----------- --->
					<!--- -------------------- --->	
					
					<cf_assignid>
					
					<cf_StockTransact 
					    DataSource            = "AppsMaterials" 
						TransactionId         = "#rowguid#"	
						TransactionIdOrigin   = "#parid#"
					    TransactionType       = "4"  <!--- Disposal --->
						TransactionSource     = "WorkorderSeries"
						ItemNo                = "#ItemNo#" 
						Mission               = "#Mission#" 
						Warehouse             = "#Form.Warehouse#" 
						TransactionLot        = "#TransactionLot#" 						
						Location              = "#Form.Location#"
						TransactionReference  = "#Form.BatchReference#"
						TransactionCurrency   = "#APPLICATION.BaseCurrency#"
						TransactionQuantity   = "#-qty#"
						TransactionUoM        = "#TransactionUoM#"						
						TransactionLocalTime  = "Yes"
						TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
						TransactionTime       = "#timeformat(now(),'HH:MM')#"
						TransactionBatchNo    = "#batchno#"												
						GLTransactionNo       = "#batchNo#"
						WorkOrderId           = "#workorderid#"
						WorkOrderLine         = "#workorderline#"	
						RequirementId         = "#requirementid#"																
						GLAccountDebit        = "#AccountDisposal.GLAccount#"
						GLAccountCredit       = "#AccountStock.GLAccount#">								
				
				</cfif>			
							
		</cfif>
		
</cfloop>

</cftransaction>

<cfoutput>

	<!--- ----------------------------------- --->
	<!--- refresh the screen in the full mode --->
	<!--- ----------------------------------- --->
	
	<script>
	    batch('#batchno#','#get.mission#','process','#url.systemfunctionid#','workorder')	    		
		_cf_loadingtexthtml='';	
		ptoken.navigate('ReturnEntryDetail.cfm?workorderid=#url.workorderid#&systemfunctionid=#url.systemfunctionid#','content');
		Prosis.busy("no");	
	</script>
	
</cfoutput>
		
		