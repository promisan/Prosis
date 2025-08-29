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
<!--- submit the billing --->
<!--- ------------------ --->

<!--- 
   1. identify the shipment lines to be billed based on the value form.selected billing 
   
   they are booked as COGS and stock
   
   2. currency of the workorder drives the selection of the journal
   
    SELECT     *
	FROM         Journal
	WHERE     (Mission = 'HSA') AND (TransactionCategory = 'Receivables') AND (Currency = 'USD')
   
   2. create header  with the total amount to be matched !
      
   3. create lines aggregated by booking of the itemtransactions
   
	   - Income from workorderledger otherwise from 
	   - AR to be taken from the selected journal
   
   4. update ItemTransactionShipping.InvoiceId
   
   5.  open the invoice dialog
       refresh the lines (less lines)
	   set billed with new total
	   
	      	   
--->   

<cfparam name="Form.selected" default="">

<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      WorkOrder
	WHERE     WorkOrderId = '#url.workorderid#'	
</cfquery>  

<cfquery name="workorderline" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      WorkOrderLine
	WHERE     WorkOrderId = '#url.workorderid#'	
	AND       WorkOrderLine = '#url.workorderline#'
</cfquery>  


<cfquery name="WorkorderReceivable" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      WorkOrderGLedger
	WHERE     WorkOrderId = '#url.workorderid#'	
	AND       Area        = 'Receivable'
	AND       GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
</cfquery>  

<cfquery name="AdvanceJournal" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Journal
	WHERE     Mission = '#workorder.mission#'	
	AND       Currency = '#workorder.currency#'
	AND       TransactionCategory = 'Advances'	
</cfquery>  

<cfif AdvanceJournal.recordcount eq "0">

	<cfoutput>
	<script>
		 alert("No ADVANCE journal set for currency : #workorder.currency#")
		 Prosis.busy("no")
	</script>
	</cfoutput>
	<cfabort>
	
<cfelse>
	
	<cfquery name="customer" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      Customer
		WHERE     CustomerId = '#workorder.customerid#'	
	</cfquery>  		
		
	<cfquery name="getLines" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT WorkOrderId, 
			   WorkOrderLine, 
			   WorkOrderItemId,
			   TaxCode,
			   Quantity-QuantityBilled as Quantity,
			   SaleAmountIncome * ((Quantity-QuantityBilled)/Quantity) as SaleIncome,
			   SaleAmountTax    * ((Quantity-QuantityBilled)/Quantity) as SaleTax,
			   SalePayable      * ((Quantity-QuantityBilled)/Quantity) as SalePayable,			   
	           ItemNo, 
			   ItemDescription, 
			   UoMCode, 
			   UoMDescription, 
			   ItemBarCode
			   
		FROM  (		
		
				SELECT   L.WorkOrderItemId, 
				         L.Quantity,
			             (SELECT     ISNULL(SUM(B.Quantity), 0)
			              FROM       WorkOrderLineItemBilling B
			              WHERE      B.WorkOrderItemId = L.WorkOrderItemId
						  AND        EXISTS  (SELECT 'X' 
						                      FROM  Accounting.dbo.TransactionHeader
						                      WHERE Journal         = B.Journal
											  AND   JournalSerialNo = B.JournalSerialNo
											  AND   RecordStatus != '9' AND ActionStatus !='9')) AS QuantityBilled, 
						 L.SaleAmountIncome, 
						 L.SaleAmountTax, 
						 L.SalePayable, 
						 L.WorkOrderId, 
						 L.WorkOrderLine, 
						 L.TaxCode,
			             I.ItemNo, 
						 I.ItemDescription, 
						 U.UoMCode, 
						 U.UoMDescription, 
						 U.ItemBarCode
				FROM     WorkOrderLineItem L INNER JOIN
			             Materials.dbo.Item I    ON L.ItemNo = I.ItemNo INNER JOIN
			             Materials.dbo.ItemUoM U ON L.ItemNo = U.ItemNo AND L.UoM = U.UoM
				WHERE    WorkOrderId   = '#url.workorderid#'
				AND      WorkorderLine = '#url.workorderline#'
				
				<cfif form.selected neq "">
				AND      WorkOrderItemId IN (#preservesinglequotes(Form.Selected)#) 	
				<cfelse>
				WHERE 1=0
				</cfif>		
		
			  ) as Tab
			  
	</cfquery>	
	
	<!--- totals for posting itself --->
	
	<cfquery name="getTotal" dbtype="query">
		SELECT   SUM(SaleIncome)  AS Income,
		         SUM(SaleTax)     AS Tax,
				 SUM(SalePayable) AS Sale
		FROM     getLines		
	</cfquery>  
	
	<cfset sales = getTotal.Income>
	<cfset taxes = getTotal.Tax>
	<cfset taxrate = round(taxes*1000 / sales)/1000>  <!--- line 0.12 --->
	
	<cfset total = sales + taxes>
		
	<!--- obtain additional entries to the costs --->
	
	<cfquery name="Entry" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			   SELECT   *
			   FROM     Ref_ParameterMissionGLedger G INNER JOIN
		                Ref_AreaGLedger R ON G.Area = R.Area
			   WHERE    R.BillingEntry = 1
			   AND      G.Mission = '#workorder.mission#'
			   ORDER BY R.ListingOrder
	</cfquery>
	
	<cfset row = "0">
	<cfset ar=ArrayNew(2)>	
	
	<cfloop query="Entry">
	
		 <!--- overruling account --->
		 
		 <cfquery name="getArea" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT   *
			   FROM     WorkOrderGLedger
			   WHERE    WorkOrderId = '#url.workorderid#'
			   AND      Area        = '#Area#'			 
		 </cfquery>
		 
		 <cfif getArea.GLAccount neq "">
		     <cfset gla = getArea.GLAccount>
		 <cfelse>
		     <cfset gla = glaccount>  
		 </cfif>
	
		 <cfset val   = evaluate("Form.Amount_#Area#")>
		 <cfset val   = replace(val,",","","ALL")>
		 
		 <cfif val neq "" and LSIsNumeric(val) and val neq "">
		 
			 <cfquery name="check" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					   SELECT   *
					   FROM     Accounting.dbo.Ref_Account
					   WHERE    GLAccount = '#gla#'			  
			 </cfquery>
			
			 <cfif check.recordcount eq "1">
			  
			  		<cfset row = row+1>
			  
			  		<cfset sales = sales + val>				 				
					<!--- capture posting --->
					<cfset ar[row][1] = description>
					<cfset ar[row][2] = gla>				
					<cfset ar[row][3] = val>	
					
					<cfif applyTax eq "1">				
					    <cfset taxes = taxes + (val * taxrate)>
					</cfif>						
											 
			 </cfif> 	     
		 
		 </cfif>
	 	
	</cfloop>
	
	<cfset total = sales + taxes>

	<cfif form.selected eq "">
	
		<script>		
		alert("Probkem : No items were selected for prebilling.")
		Prosis.busy("no")
		</script>
		<cfabort>
		
	<cfelse>	
		
	<cfquery name="JournalAccount" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT    TOP 1 *
		FROM      JournalAccount
		WHERE     Journal = '#AdvanceJournal.journal#' 
		AND       Mode    = 'Contra'		    
		ORDER BY  ListDefault DESC
	</cfquery>
	
	<cfquery name="Terms" 
		datasource="AppsWorkOrder"
		username="#SESSION.login#" 
			password="#SESSION.dbpw#">
	   	    SELECT     *
			FROM       Ref_Terms							
			WHERE      Code = '#Form.Terms#'
	</cfquery> 	

	<cfquery name="Parameter" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT  *
		    FROM    Purchase.dbo.Ref_ParameterMission
			WHERE   Mission = '#workorder.Mission#' 
	</cfquery>
									
	<!--- 3. cross reference the lines to the GL transaction header as being covered --->
	
	<cftransaction isolation="READ_UNCOMMITTED">
	
	<CF_DateConvert Value="#Form.TransactionDate#">	
	<cfset due = dateAdd("d",Terms.PaymentDays,dateValue)>
		
	<cf_GledgerEntryHeader
		    Mission               = "#WorkOrder.Mission#"
			DataSource            = "AppsOrganization"
		    OrgUnitOwner          = "#Form.OrgUnitOwner#"
		    Journal               = "#AdvanceJournal.Journal#"				
			Description           = "#form.Memo#"
			TransactionSource     = "WorkOrderSeries"
			AccountPeriod         = "#Form.AccountPeriod#"			 
			TransactionCategory   = "Receivables"
			MatchingRequired      = "1"
			Workflow              = "Yes"
			ReferenceOrgUnit      = "#Customer.orgUnit#"  <!--- customer orgunit --->		
			Reference             = "PreBilling"       
			ReferenceName         = "#customer.customername#"  <!--- customer name --->
			ReferenceId           = "#url.workorderid#" 
			ReferenceNo           = "#workorder.reference#" <!--- order reference --->		
			
			DocumentCurrency      = "#Workorder.Currency#"
			TransactionDate       = "#DateFormat(now(),CLIENT.DateFormatShow)#"
			DocumentDate          = "#Form.TransactionDate#"
			DocumentAmount        = "#Total#"
			DocumentAmountVerbal  = "1"
			ParentJournal         = ""
			ParentJournalSerialNo = ""								
			ActionBefore          = "#DateFormat(due,CLIENT.DateFormatShow)#"			
			ActionTerms           = "#Terms.Code#"
			ActionDescription     = "#Terms.Description#"
			ActionDiscountDays    = "#Terms.DiscountDays#"
			ActionDiscount        = "#Terms.Discount#">
			
	<!--- Lines - invoice itself --->
		 
	<cfset row = 0>
		
	<cf_GledgerEntryLine
		Lines                 = "1"
		DataSource            = "AppsOrganization"
	    Journal               = "#AdvanceJournal.Journal#"
		JournalNo             = "#JournalTransactionNo#"
		TransactionDate       = "#Form.TransactionDate#"
		AccountPeriod         = "#Form.AccountPeriod#"		
		Currency              = "#WorkOrder.Currency#"
		
		TransactionSerialNo1  = "#row#"
		Class1                = "Debit"
		Reference1            = "Receivable"       
		ReferenceName1        = "#customer.customername#"  <!--- customer name --->
		Description1          = ""
		GLAccount1            = "#JournalAccount.GLAccount#"
		Costcenter1           = ""
		ProgramCode1          = ""
		ProgramPeriod1        = ""
		ReferenceId1          = "#url.workorderid#"
		ReferenceNo1          = "#workorder.reference#"		
		TransactionType1      = "Contra-Account"
		Amount1               = "#total#">
							
			<cfif Taxes neq "0">
			
				<cfset row = row+1>										
								
				<cf_GledgerEntryLine
				Lines                 = "1"
				DataSource            = "AppsOrganization"
			    Journal               = "#AdvanceJournal.Journal#"
				JournalNo             = "#JournalTransactionNo#"
				AccountPeriod         = "#Form.AccountPeriod#"		
				TransactionDate       = "#Form.TransactionDate#"
				Currency              = "#WorkOrder.Currency#"
				
				TransactionSerialNo1  = "#row#"
				Class1                = "Credit"
				Reference1            = "Tax"       
				ReferenceName1        = "#customer.customername#"  <!--- customer name --->
				Description1          = ""
				GLAccount1            = "#JournalAccount.GLAccount#"
				Costcenter1           = "#workorderline.OrgUnitImplementer#"
				ProgramCode1          = ""
				ProgramPeriod1        = ""
				ReferenceId1          = "#workorderid#"
				ReferenceNo1          = "#workorder.reference#"
				TransactionType1      = "Standard"
				Amount1               = "#Taxes#">
							
			</cfif>
			
			<cfset row = row + 1>
		
			<cf_GledgerEntryLine
			Lines                 = "1"
			DataSource            = "AppsOrganization"
		    Journal               = "#AdvanceJournal.Journal#"
			JournalNo             = "#JournalTransactionNo#"
			AccountPeriod         = "#Form.AccountPeriod#"		
			TransactionDate       = "#Form.TransactionDate#"
			Currency              = "#WorkOrder.Currency#"
			
			TransactionSerialNo1  = "#row#"
			Class1                = "Credit"
			Reference1            = "Sale"       
			ReferenceName1        = "#customer.customername#"  <!--- customer name --->
			Description1          = ""
			GLAccount1            = "#JournalAccount.GLAccount#"
			CostCenter1           = "#workorderline.OrgUnitImplementer#"
			ProgramCode1          = ""
			ProgramPeriod1        = ""
			ReferenceId1          = "#workorderid#"
			ReferenceNo1          = "#workorder.reference#"
			TransactionType1      = "Standard"
			Amount1               = "#getTotal.Income#">
				
	    <!--- Popuate table --->
		
		<cfloop query="getLines">
					
			<cfquery name="setLines" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO WorkOrder.dbo.WorkOrderLineItemBilling	
				(WorkOrderItemId, Quantity, AmountTax, AmountSale, Journal, JournalSerialNo, OfficerUserId, OfficerLastName, OfficerFirstName)
				VALUES
					('#workorderitemid#',
					 '#quantity#',
					 '#saletax#',
					 '#saleincome#',
					 '#AdvanceJournal.Journal#',
					 '#JournalTransactionNo#',
					 '#session.acc#',
					 '#session.last#',
					 '#session.first#')			
			</cfquery>  
		
		</cfloop>
		
		<!--- post other charges --->
		
		<cfloop index="charges" array="#ar#">
		
			<cfset row = row + 1>
		
			<cf_GledgerEntryLine
				Lines                 = "1"
				DataSource            = "AppsOrganization"
			    Journal               = "#AdvanceJournal.Journal#"
				JournalNo             = "#JournalTransactionNo#"
				AccountPeriod         = "#Form.AccountPeriod#"		
				TransactionDate       = "#Form.TransactionDate#"
				Currency              = "#WorkOrder.Currency#"			
				TransactionSerialNo1  = "#row#"
				Class1                = "Credit"
				Reference1            = "#charges[1]#"       
				ReferenceName1        = "#customer.customername#"  <!--- customer name --->
				Description1          = ""
				GLAccount1            = "#JournalAccount.GLAccount#"
				CostCenter1           = ""
				ProgramCode1          = ""
				ProgramPeriod1        = ""
				ReferenceId1          = "#url.workorderid#"  <!--- charged against the base workorder --->
				ReferenceNo1          = "#workorder.reference#"
				TransactionType1      = "Standard"
				Amount1               = "#charges[3]#">	
			
		</cfloop>	
		
		<cfoutput>
		
		<script language="JavaScript">		
		
			ShowTransaction('#AdvanceJournal.journal#','#JournalTransactionNo#','0');			
			_cf_loadingtexthtml='';	
			ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/FinalProduct/Prebilling/PreBillingView.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&systemfunctionid=#url.systemfunctionid#','content');					
			Prosis.busy("no");	
			
		</script>
		
		</cfoutput>	
						
		</cftransaction>
	
	</cfif>

</cfif>

   


