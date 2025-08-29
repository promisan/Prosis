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

<!--- removed this is optional as it can be done in the AR approval process

<cfif form.ActionReference1 eq "">

	<cf_tl id="Please enter an Invoice No">
	
	<cfoutput>
			
	<script>
		alert("#lt_text#")
		Prosis.busy('no')
	</script>
	
	</cfoutput>
	
	<cfabort>	
	
</cfif>

--->


<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      WorkOrder
	WHERE     WorkOrderId = '#url.workorderid#'	
</cfquery>  


<cfquery name="customer" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Customer
	WHERE     CustomerId = '#workorder.customerid#'	
</cfquery> 

<cfquery name="workorderline" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      WorkOrderLine
	WHERE     WorkOrderId = '#url.workorderid#'	
</cfquery>  

<cfquery name="WorkorderReceivable" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      WorkOrderGLedger
	WHERE     WorkOrderId = '#url.workorderid#'	
	AND       Area        = 'Receivable'
	AND       GLAccount IN (SELECT GLAccount 
	                        FROM   Accounting.dbo.Ref_Account)
</cfquery>  

<cfif url.id eq "STA">

	<cfquery name="WorkorderLedger" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      WorkOrderGLedger
		WHERE     WorkOrderId = '#url.workorderid#'	
		AND       Area        = 'Income'
		AND       GLAccount IN (SELECT GLAccount 
		                        FROM   Accounting.dbo.Ref_Account)
	</cfquery>  

<cfelse>

	<cfquery name="WorkorderLedger" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      WorkOrderGLedger
			WHERE     WorkOrderId = '#url.workorderid#'	
			AND       Area        = 'Return'
			AND       GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
	</cfquery>  

	<cfif WorkOrderLedger.recordcount eq "0">
	
		<cfquery name="WorkorderLedger" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      WorkOrderGLedger
			WHERE     WorkOrderId = '#url.workorderid#'	
			AND       Area        = 'Income'
			AND       GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
		</cfquery>  
		
	</cfif>

</cfif>

<cfif WorkorderLedger.recordcount eq "0">

	<cfoutput>
		<cf_tl id="No income gender ledger account set for workorder">
		<script>
			 alert("#lt_text#")
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
	
	<cfquery name="getTotal" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     ROUND(SUM(SalesTotal),2)  AS Total,
		           ROUND(SUM(SalesTax),2)    AS SaleTax,
				   ROUND(SUM(SalesAmount),2) AS SaleIncome
		FROM       ItemTransactionShipping
		<cfif form.selected neq "">
		WHERE      TransactionId IN (#preservesinglequotes(Form.Selected)#) 	
		<cfelse>
		WHERE 1=0
		</cfif>
	</cfquery>  	
	
	<cfif getTotal.Total eq "">
			
		<script>
			alert("No lines selected")
			Prosis.busy('no')
		</script>
		<cfabort>	
	
	</cfif>
	
	<cfset sale    = getTotal.SaleIncome>
	
	<cfif sale neq "0" and sale neq "" and customer.taxexemption eq "0">
		<cfset sale    = getTotal.SaleIncome>		
		<cfset tax     = getTotal.SaleTax>		
	    <cfset taxrate = round(tax*1000 / sale)/1000>  <!--- line 0.12 --->
	<cfelseif customer.taxexemption eq "1">		
	    <cfset sale    = sale + getTotal.SaleTax>	
		<cfset tax     = 0>		
	    <cfset taxrate = 0>		   
	<cfelse>   
		<cfset tax     = 0>		
	    <cfset taxrate = 0>
	</cfif>
		
	<cfset total   = sale + tax>	
	
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
												  
				  	<cfset sale = sale + val>		
					
					<cfif applyTax eq "1" and customer.taxexemption eq "0">
					
					    <cfset tax = tax + (val * taxrate)>
						
					</cfif>
					
					<cfset total = sale + tax>							 					 
			  	 				
					<!--- capture posting --->
					<cfset ar[row][1] = description>
					<cfset ar[row][2] = gla>				
					<cfset ar[row][3] = val>		
											 
			 </cfif> 	     
		 
		 </cfif>
	 	
	</cfloop>

	<cfif form.selected eq "">
	
		<script>
		
		alert("Probkem : No shipments were selected for billing.")
		Prosis.busy("no")
		</script>
		<cfabort>
		
	<cfelse>
	
	<cfquery name="Journal" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT     *
			FROM       Journal
			WHERE      Journal = '#form.journal#' 
	</cfquery>
	
	<cfquery name="JournalAccount" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT      TOP 1 *
			FROM        JournalAccount
			WHERE       Journal = '#form.journal#' 
			AND         Mode    = 'Contra'		    
			ORDER BY    ListDefault DESC
	</cfquery>
	
	<cfquery name="Terms" 
			datasource="AppsWorkOrder"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
	   	    SELECT   *
			FROM     Ref_Terms							
			WHERE    Code = '#Form.Terms#'
	</cfquery> 	

	<cfquery name="Parameter" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT   *
		    FROM     Purchase.dbo.Ref_ParameterMission
			WHERE    Mission = '#workorder.Mission#' 
	</cfquery>
										
	<!--- 3. cross reference the lines to the GL transaction header as being covered --->
	
	<cftransaction>
	
	<CF_DateConvert Value="#Form.TransactionDate#">	
	<cfset due = dateAdd("d",Terms.PaymentDays,dateValue)>
	
	<cfif form.ActionReference2 neq "" and form.ActionReference1 neq "">
	
		<cfset joutrano = "#form.ActionReference2#-#form.ActionReference1#">
		
		<!--- check if posting exists --->		
		
		<cfquery name="Check" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT    TOP 1 *
			FROM      Accounting.dbo.TransactionHeader
			WHERE     Journal = '#form.journal#' 
			AND       JournalTransactionNo = '#joutrano#'		    		
		</cfquery>
				
		<cfif check.recordcount gte "1">
	
			<script>
			alert("Problem : InvoiceNo has been posted already for this journal.")
			Prosis.busy("no")
			</script>
			<cfabort>
		
		</cfif>
			
	<cfelse>
	
		<cfset joutrano = form.ActionReference1>
		
	</cfif>
	
	<cfif url.id eq "STA">
	
		<cfset cat = "Receivables">
	
	<cfelse>
	
		<cfset cat = Journal.TransactionCategory>
		
	</cfif>
				
	<cf_GledgerEntryHeader
		    Mission               = "#WorkOrder.Mission#"
			DataSource            = "AppsOrganization"
		    OrgUnitOwner          = "#Form.OrgUnitOwner#"
		    Journal               = "#form.Journal#"	
			JournalTransactionNo  = "#joutrano#"			
			Description           = "#form.Memo#"
			TransactionSource     = "WorkOrderSeries"
			TransactionSourceId   = "#url.workorderid#"
			AccountPeriod         = "#Form.AccountPeriod#"			 
			TransactionCategory   = "#cat#"
			MatchingRequired      = "1"
			ActionStatus          = "0"
			Workflow              = "Yes"
			ReferenceOrgUnit      = "#Customer.orgUnit#"  <!--- customer orgunit --->		
			Reference             = "Billing"       
			ReferenceName         = "#customer.customername#"  <!--- customer id   --->
			ReferenceId           = "#customer.customerid#"    <!--- customer name --->
			ReferencePersonNo     = "#workorderline.personno#" <!--- usually the person responsible for the sales workorder --->			
			ReferenceNo           = "#workorder.reference#"    <!--- order reference --->					
			DocumentCurrency      = "#Workorder.Currency#"
			TransactionDate       = "#Form.TransactionDate#"
			DocumentDate          = "#Form.TransactionDate#"
			DocumentAmount        = "#Total#"
			DocumentAmountVerbal  = "1"
			ParentJournal         = ""
			ParentJournalSerialNo = ""										
			ActionBefore          = "#DateFormat(due,CLIENT.DateFormatShow)#"			
			ActionTerms           = "#Terms.Code#"
			ActionDescription     = "#Terms.Description#"
			ActionDiscountDays    = "#Terms.DiscountDays#"
			ActionDiscount        = "#Terms.Discount#"
			ActorRole             = "Owner"
			ActorPersonNo         = "#workorderline.personno#"
			ActionCode            = "Invoice"
			ActionReference1      = "#form.ActionReference1#"
			ActionReference2      = "#form.ActionReference2#">
						
	<!--- Lines - invoice itself --->
		 
	<cfset row = 0>
	
	<cfif WorkorderReceivable.glaccount neq "">
			<cfset recv = WorkorderReceivable.glaccount> 
	<cfelse>
			<cfset recv = JournalAccount.GLAccount>
	</cfif>
		
	<cf_GledgerEntryLine
		Lines                    = "1"
		DataSource               = "AppsOrganization"
	    Journal                  = "#Journal.Journal#"
		JournalNo                = "#JournalTransactionNo#"
		TransactionDate          = "#Form.TransactionDate#"
		AccountPeriod            = "#Form.AccountPeriod#"		
		Currency                 = "#WorkOrder.Currency#"		
		TransactionSerialNo1     = "#row#"
		Class1                   = "Debit"
		Reference1               = "Receivable"       
		ReferenceName1           = "#customer.customername#"  <!--- customer name --->
		Description1             = ""
		GLAccount1               = "#recv#"
		Costcenter1              = ""
		ProgramCode1             = ""
		ProgramPeriod1           = ""
		ReferenceId1             = "#url.workorderid#"
		ReferenceNo1             = "#workorder.reference#"		
		TransactionType1         = "Contra-Account"
		Amount1                  = "#total#">
		
		<!--- this now shows information on a more detailed level matching the POS 16/5/2021 --->
		
		<cfquery name="getLines" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT     T.WorkOrderId,
			           WL.OrgUnitImplementer,
					   T.TransactionId,
					   W.Reference,
					   T.ItemNo,
					   T.ItemDescription,
					   S.SalesQuantity,
					   S.TaxCode,	
					   <cfif customer.taxexemption eq "0">					   
			           S.SalesTotal    AS Total, 
			           S.SalesTax      AS Tax, 
					   S.SalesAmount   AS Sale
					   <cfelse>
					   S.SalesTotal    AS Total, 
			           '0'             AS Tax, 
					   S.SalesAmount+S.SalesTax AS Sale
					   </cfif>
			FROM       Materials.dbo.ItemTransactionShipping S 
			           INNER JOIN Materials.dbo.ItemTransaction T ON S.TransactionId = T.TransactionId 
					   INNER JOIN WorkOrder.dbo.WorkOrderLine  WL ON T.WorkOrderId   = WL.WorkOrderId AND T.WorkOrderLine = WL.WorkOrderLine 
					   INNER JOIN WorkOrder.dbo.WorkOrder W       ON T.WorkOrderId   = W.WorkOrderId					   
		    <cfif form.selected neq "">
			WHERE      S.TransactionId IN (#preservesinglequotes(Form.Selected)#) 	<!--- this could be from different workorders to be combined with the main one !! --->
			<cfelse>
			WHERE      1=0
			</cfif>			
			
								
		</cfquery>  
		
		<!--- 15/1/2016 single amount once discount was recorded --->
				
		<cfif Tax neq "0">
			
				<cfset row = row+1>				
								
				<cfquery name="TaxCode" 
				    datasource="AppsOrganization" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					    SELECT    *
					    FROM      Accounting.dbo.Ref_Tax
						WHERE     TaxCode = '#getLines.TaxCode#' 
						AND       GLAccountReceived IN (SELECT GLAccount 
						                                FROM   Accounting.dbo.Ref_Account)
				</cfquery>	
				
				<cfif TaxCode.recordcount eq "0">
					
					<cfoutput>		
					<script>
						alert("Invalid tax code #TaxCode# for accounts receivables")
						Prosis.busy("no")
					</script>
					</cfoutput>	
					<cfabort>
									
				</cfif>			
				
				<cf_GledgerEntryLine
				Lines                 = "1"
				DataSource            = "AppsOrganization"
			    Journal               = "#Journal.Journal#"
				JournalNo             = "#JournalTransactionNo#"
				AccountPeriod         = "#Form.AccountPeriod#"		
				TransactionDate       = "#Form.TransactionDate#"
				Currency              = "#WorkOrder.Currency#"				
				TransactionSerialNo1  = "#row#"
				Class1                = "Credit"
				Reference1            = "Sales Tax"       
				ReferenceName1        = "#customer.customername#"  <!--- customer name --->
				Description1          = ""
				GLAccount1            = "#TaxCode.GLAccountReceived#"
				Costcenter1           = "#getLines.OrgUnitImplementer#"
				ProgramCode1          = ""
				ProgramPeriod1        = ""
				ReferenceId1          = "#workorderid#"
				ReferenceNo1          = "#getLines.reference#"
				TransactionType1      = "Standard"
				Amount1               = "#Tax#">
							
		</cfif>
			
		<cfloop query="getLines">		
					
			<cfset row = row + 1>
		
			<cf_GledgerEntryLine
				Lines                 = "1"
				DataSource            = "AppsOrganization"
			    Journal               = "#Journal.Journal#"
				JournalNo             = "#JournalTransactionNo#"
				AccountPeriod         = "#Form.AccountPeriod#"		
				TransactionDate       = "#Form.TransactionDate#"
				Currency              = "#WorkOrder.Currency#"			
				TransactionSerialNo1  = "#row#"
				Class1                = "Credit"
				Reference1            = "Sales Income"    
				ReferenceNo1          = "#ItemNo#"   
				ReferenceName1        = "#left(Itemdescription,100)#"  <!--- customer name --->
				ReferenceQuantity1    = "#SalesQuantity#"
				ReferenceId1          = "#TransactionId#"
				Description1          = ""
				GLAccount1            = "#WorkOrderLedger.GLAccount#"
				CostCenter1           = "#OrgUnitImplementer#"
				ProgramCode1          = ""
				ProgramPeriod1        = ""					
				TransactionType1      = "Standard"
				Amount1               = "#Sale#">
			
		</cfloop>	
	
	    <!--- 3. cross reference the lines to the GL transaction header as being covered --->
					
		<cfquery name="getLines" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE  Materials.dbo.ItemTransactionShipping	
				SET     Journal         = '#Journal.journal#', 
				        JournalSerialNo = '#JournalTransactionNo#',		
						InvoiceId       = '#JournalTransactionid#'    
				<cfif form.selected neq "">
				WHERE   TransactionId IN (#preservesinglequotes(Form.Selected)#) 	
				<cfelse>
				WHERE   1=0
				</cfif>
		</cfquery>  
		
		<!--- post other charges --->
		
		<cfloop index="charges" array="#ar#">
		
			<cfset row = row + 1>
		
			<cf_GledgerEntryLine
				Lines                 = "1"
				DataSource            = "AppsOrganization"
			    Journal               = "#Journal.Journal#"
				JournalNo             = "#JournalTransactionNo#"
				AccountPeriod         = "#Form.AccountPeriod#"		
				TransactionDate       = "#Form.TransactionDate#"
				Currency              = "#WorkOrder.Currency#"			
				TransactionSerialNo1  = "#row#"
				Class1                = "Credit"
				Reference1            = "#charges[1]#"       
				ReferenceName1        = "#charges[1]#"  <!--- service cost --->
				ReferenceNo1          = "#workorder.reference#"
				ReferenceQuantity1    = "1"
				ReferenceId1          = "#url.workorderid#"  <!--- charged against the base workorder --->	
				Description1          = ""
				GLAccount1            = "#charges[2]#"
				CostCenter1           = ""
				ProgramCode1          = ""
				ProgramPeriod1        = ""							
				TransactionType1      = "Standard"
				Amount1               = "#charges[3]#">	
			
		</cfloop>	
		
		<cfoutput>
		
		<script language="JavaScript">		
		
			ShowTransaction('#Journal.journal#','#JournalTransactionNo#','0');
			
			_cf_loadingtexthtml='';	
			ptoken.navigate('BillingEntryDetail.cfm?workorderid=#url.workorderid#&systemfunctionid=#url.systemfunctionid#','mycontent');
			ptoken.navigate('BillingEntryWorkOrder.cfm?workorderid=#url.workorderid#','workorder');				
			Prosis.busy("no");	
			
		</script>
		
		</cfoutput>	
						
		</cftransaction>
	
	</cfif>

</cfif>
