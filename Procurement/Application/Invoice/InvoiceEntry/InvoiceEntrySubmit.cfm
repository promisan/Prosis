
<cf_screentop height="100%" html="No" scroll="Yes">

<cfif Form.EntityClass eq "" and Form.InvoiceWorkflow eq "1">
		
	 <cf_alert message = "You may not register an invoice without associating it to a processing workflow."
		  return = "back">
	  <cfabort>
			
</cfif>

<cfif Form.DocumentAmount eq "0">
		
	 <cf_alert message = "You can not register an invoice with a 0 amount. Operation not allowed."
		  return = "back">
	  <cfabort>
			
</cfif>

<cfif Len(Form.Description) gt 400>

	 <cf_alert message = "Your entered a memo that exceeded the allowed size of 400 characters."
		  return = "back">
	  <cfabort>
		  
</cfif>

<!--- no longer needed
<cfparam name="Form.Selected" default="#URL.PurchaseNo#">
--->

<cfparam name="Form.Period"   default="#URL.Period#">

<!--- this is the mode for CMP matching on the purchase line execution --->

<cfif ParameterExists(Form.Requisition)> 
	
	<cfquery name="Lines" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    PL.*, R.Mission, J.CaseNo
			FROM      PurchaseLine PL INNER JOIN
	                  RequisitionLine R ON PL.RequisitionNo = R.RequisitionNo LEFT OUTER JOIN
	                  Job J ON R.JobNo = J.JobNo
			WHERE     PL.PurchaseNo = '#Form.PurchaseNo#'
			AND       PL.OrderAmount <> 0
			ORDER BY  PL.ListingOrder,
			          R.RequisitionNo			
	</cfquery>
	
	<cfif lines.recordcount gt "1">	
	
		<cfset t = "0.00">
		
		<cfoutput query="Lines">
		
			<cfparam name="Form.req#currentrow#" default="">
			<cfset v = evaluate("Form.req#currentrow#")>
			<cfset v = replace(v,",","","ALL")>
			<cfset v = replace(v," ","","ALL")>
			<cfif v eq "">
			   <cfset v = 0>			   
			</cfif>
			
			<cfif not LSIsNumeric(v)>
			
				 <cf_alert message = "You entered an invalid/incorrect amount: #v#  Operation not allowed."
					return = "back">
	
				 <cfabort>
			
			</cfif>			
			
			<cfif v neq "">
				<cfset v=round(v*100)/100>
			   	<cfset t=round(t*100)/100>
				<cfset t = t+v>
			</cfif>
			
		</cfoutput>

		<cfset amount    = round(t*100)/100>			
		<cfset remaining = amount-t>
		
		<cfif remaining gte 0.001 or remaining lte -0.001>
		
			 <cf_alert message = "You must assign the invoiced amount accross one or more lines. #t# #Form.DocumentAmount#  re: #remaining# Operation not allowed."
					return = "back">
			  <cfabort>
			
		</cfif>
	
	</cfif>

</cfif>

<!--- assign a unique identifier --->
<cf_AssignId>
<cfset Guid = RowGuid>

<!--- verify if entry can be made --->

<cf_verifyOperational 
         module="Accounting" 
		 Warning="No">

   <cfif operational eq "1">

    <!--- retrieve posting information --->  
 	
	<cfquery name="Journal" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
			SELECT    *
			FROM      Journal
			WHERE     Mission       = '#Form.IssuedMission#' 
			AND       SystemJournal = 'Procurement'
			AND       Currency      = '#Form.IssuedCurrency#' 
	</cfquery>
	
	<cfif Journal.recordcount eq "0">
	   									
		<cf_alert message = "Procurement journal (#Form.IssuedCurrency#) has not been recorded. Operation not allowed."
		  return = "back">
		  <cfabort>
	  
	</cfif>  
	
	<!--- convert to journal currency --->
	
	<cfquery name="IssuedCurr" 
      datasource="AppsLedger" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	      SELECT    TOP 1 *
	      FROM      CurrencyExchange
		  WHERE     Currency = '#Form.IssuedCurrency#'
		  AND       EffectiveDate <= getDate()
		  ORDER BY  EffectiveDate DESC
	</cfquery>
					
	<cfquery name="InvoiceCurr" 
      datasource="AppsLedger" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	      SELECT    TOP 1 *
	      FROM      CurrencyExchange
		  WHERE     Currency = '#Form.Currency#'
		  AND       EffectiveDate <= getDate()
		  ORDER BY  EffectiveDate DESC
	</cfquery>
	
	<cfset exc = InvoiceCurr.ExchangeRate/IssuedCurr.ExchangeRate>
   		
	<cfif InvoiceCurr.recordcount eq "0" or IssuedCurr.recordcount eq "0">
								
		<cf_alert  message = "An Exchange rate has not been recorded for #Form.Currency#. Operation not allowed.">
		  <cfabort>
	  
	</cfif>  		
	
	<!--- Lines - difference --->
	
	<cfquery name="Difference" 
	   datasource="AppsLedger" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	      SELECT    *
		  FROM      Ref_AccountMission
		  WHERE     Mission       = '#Form.Mission#'
		  AND       SystemAccount = 'ExchangeDifference' 
	</cfquery>
						
	<cfif Difference.recordcount neq "1">
								
		<cf_alert message = "System Account: Exchange Rate Difference has not been defined for #Form.Mission#. Operation not allowed.">
		  <cfabort>
	  
	</cfif>  
			
</cfif>	

<cfquery name="Parameter1" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#Form.Mission#' 
</cfquery>

<!--- check for double invoiceNo + vendor --->

<!--- 

Incase of EnforceCurrency, check if PurchaseOrder currency differs from Invoice currency

check invoice currency versus PO currency 
How to handle an invoice in a currency that is different from the invoice currency in case of matching.

Situation 
- Currently all purchase lines has same currency 
- Receipt lines may have different currency from po for open contract [and only if allowed parameter]
- Invoice can be entered with any different currency (if allowed)

Matching 
a. in case of Enforce Currency = 0 convert receipt to invoice currency, allow for exchange difference
b. in case of Enforce Currency = 1 on purchase amount

--->

<!--- attachment --->

<cfset dateValue = "">
<cfif Form.DocumentDateReceived neq ''>
    <CF_DateConvert Value="#Form.DocumentDateReceived#">
    <cfset DTERCT = #dateValue#>
<cfelse>
    <cfset DTERCT = 'NULL'>
</cfif>	

<cfset dateValue = "">
<cfif Form.DocumentDate neq ''>
    <CF_DateConvert Value="#Form.DocumentDate#">
    <cfset DTEDOC = dateValue>
<cfelse>
    <cfset DTEDOC = 'NULL'>
</cfif>	

<cfset dateValue = "">
<cfif Form.ActionBefore neq ''>
    <CF_DateConvert Value="#Form.ActionBefore#">
    <cfset DTEDUE = dateValue>
<cfelse>
    <cfset DTEDUE = 'NULL'>
</cfif>	

<cfparam name="fORM.ActionDiscount" default="0">
<cfparam name="FORM.ActionDiscountDays" default="0">

<cfset dateValue = "">
<cfif Form.actiondiscount neq ''>
    <CF_DateConvert Value="#Form.ActionDiscountDate#">
    <cfset DTEDIS = dateValue>
<cfelse>
    <cfset DTEDIS = 'NULL'>
</cfif>	

<cfif form.entityclass neq "">

<cfset dateValue = "">
<cfif Form.schedule eq "Later" and Form.workflowdate neq "">
    <CF_DateConvert Value="#Form.WorkFlowDate#">
    <cfset DTEWRK = dateValue>
<cfelse>
    <cfset DTEWRK = dateformat(now(),client.dateSQL)>
</cfif>	

</cfif>

<cfquery name="Check" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
	 FROM   InvoiceIncoming
	 WHERE  Mission       = '#Form.Mission#'
	 AND    OrgUnitVendor = '#Form.OrgUnit#'  
	 AND    InvoiceNo     = '#Form.invoiceNo#'	 
</cfquery>

<cfif Check.recordcount gte "1">
 
  <cf_alert message = "An incoming invoice with No: #Form.InvoiceNo# already exists \n\nIt was registered by #check.OfficerLastName# on #dateformat(check.created,client.dateformatshow)#. \n\nThis Operation not allowed." return = "back">
  <cfabort>

</cfif>

<!--- 20/4/2016 
      no longer needed as we allow for this now in the mode of Purchase, not the one for PurchaseLine/Requisition 	
	 
	<cfset row = 0>
	<cfset onl = 0>
	
	<cfloop index="po" list="#Form.Selected#" delimiters=",">
	
			<cfset row = row+1>
			
			<cfquery name="Check" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     SELECT * 
				 FROM    Purchase
				 WHERE   PurchaseNo = '#po#'
				 AND     OrderType IN (SELECT Code 
				                       FROM   Ref_OrderType 
									   WHERE  InvoiceWorkflow = 1)
			</cfquery>
			
			<cfif Check.recordcount eq "1">
			     <cfset onl = 1>
			</cfif>
			
			<cfif onl eq "1" and row gt "1">
			    
				 <cf_alert message = "I am sorry you may not associate this invoice to more than one Purchase Order. Operation not allowed.">
				 <cfabort>
			
			</cfif>
			
	</cfloop>

--->

<cfparam name="Form.AmountPayable"   default="#form.documentamount#">
<cfparam name="Form.AmountExemption" default="0">
<cfparam name="Form.Tax"             default="0">

<cfset documentamount  = replace("#form.documentamount#",",","","ALL")>
<cfset documentamount  = replace(documentamount," ","","ALL")>
<cfset documentamount  = replace(documentamount,"$","","ALL")>

<cfif documentamount eq "0" or not LSIsNumeric(documentamount)>
	 <cf_alert message = "You may not register an invoice with a 0.00 (zero) amount."
		  return = "back">
	  <cfabort>
</cfif>		  

<cfset amountpayable   = replace("#form.amountpayable#",",","","ALL")>
<cfset amountpayable   = replace(amountpayable," ","","ALL")>
<cfset amountpayable   = replace(amountpayable,"$","","ALL")>

<cfif not LSIsNumeric(amountpayable)>
	 <cf_alert message = "Invalid payable amount."  return = "back">
	  <cfabort>
</cfif>		  

<cfset ExemptionAmount = documentamount-amountpayable>

<cftransaction>

	<cftry>
	
		<cf_assignId>
	
		<cfquery name="InsertIncoming" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO InvoiceIncoming
					 (OrgUnitVendor, 
					  Mission,
					  OrgUnitOwner,
					  InvoiceSeries,
					  InvoiceNo,
					  InvoiceClass,
					  <cfif Form.PersonNo neq "">
					  PersonNo,
					  </cfif>
					  Description,
					  InvoiceIssued,
					  InvoiceReference,
					  DocumentCurrency,
					  DocumentAmount,
					  ExemptionPercentage,
					  ExemptionAmount,
					  DocumentDate,
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
		  VALUES
				  ('#Form.orgunit#',
				   '#Form.Mission#',
				   '#Form.OrgUnitOwner#',
				   '#Form.InvoiceSeries#',
				   '#Form.invoiceNo#',
				   '#URL.InvoiceClass#',
				    <cfif Form.PersonNo neq "">
				   '#Form.PersonNo#',
				   </cfif>
				   '#Form.Description#',
				   '#Form.InvoiceIssued#',
				   '#Form.InvoiceReference#',
				   '#Form.Currency#',
				   '#DocumentAmount#',
				   '#Form.Tax/100#',
				   '#ExemptionAmount#',
				   #dteRct#,
				   '#SESSION.acc#',
				   '#SESSION.last#',
				   '#SESSION.first#') 
		</cfquery>
		
		<!--- ----------------------- --->
		<!--- record incoming details --->
		<!--- ----------------------- --->
			
		<cfquery name="Detail" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO InvoiceIncomingLine
				( Mission,
				  OrgUnitOwner,
				  OrgUnitVendor,
				  InvoiceNo,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName,
				  LineSerialNo,
				  LineDescription,
				  LineReference,
				  LineAmount )
		    SELECT    '#Form.Mission#',
					   '#Form.OrgUnitOwner#',
					   '#Form.orgunit#',
					   '#Form.invoiceNo#',
					   '#SESSION.acc#',
					   '#SESSION.last#',
					   '#SESSION.first#',
					    InvoiceLineNo,
					    LineDescription,
						LineReference,
					    LineAmount
			FROM   stInvoiceIncomingLine
			WHERE  InvoiceId = '#url.guid#'			
		</cfquery>
			
		<cfcatch>
			   
			  <cf_alert message = "Invoice could not be saved. It might be that this invoiceNo has been recorded already, otherwise contact your administrator."
				  return = "back">
			  <cfabort>
		
		</cfcatch>
	
	</cftry>	
	
	<!--- adjusted 20/4/2016 to support mutiple invlices for purchase mode, non CMP --->
	
	<cfparam name="Form.TaxExemption" default="0">
		
	<cfquery name="InsertPayable" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO Invoice (	     
				  OrgUnitVendor, 
				  Journal,
				  Mission,
				  Period,
				  OrgUnitOwner,
				  OrgUnit,
				  InvoiceNo,
				  InvoiceId,
				  Description,
				  DocumentCurrency,
				  DocumentAmount,
				  DocumentDate,		 
				  OrderType,		  
				  <cfif form.entityclass neq "">
					  EntityClass,
					  WorkFlowDate,
				  </cfif>
				  TaxExemption,
				  ActionBefore,
				  ActionTerms,
				  ActionDiscountDays,
				  ActionDiscount,
				  ActionDiscountDate,
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName) 
			  
		  VALUES ( '#Form.OrgUnit#',
		  			<cfif isDefined("URL.PostingJournal")>
						'#Form.PostingJournal#',
					<cfelse>
						NULL,
					</cfif>
				   '#Form.Mission#',
				   '#Form.Period#',
				   '#Form.OrgUnitOwner#',
				   '#Form.OrgUnitCenter#',
				   '#Form.InvoiceNo#',
				   '#URL.GUID#',
				   '#Form.Description#',
				   '#Form.Currency#',
				   '#AmountPayable#',
				   #dteDoc#,
				   '#Form.OrderType#',		   
				   <cfif form.entityclass neq "">
				   	  '#Form.EntityClass#',
					  #dtewrk#,
				   </cfif>		
				   '#Form.TaxExemption#',   
				   #dteDue#,
				   '#Form.ActionTerms#',
				   '#Form.ActionDiscountDays#',
				   '#Form.ActionDiscount#',								
				   <cfif Form.ActionDiscountDays gte "1">
					#dtedis#,
				   <cfelse>
				    #dteDoc#,
				   </cfif>			  
				   '#SESSION.acc#',
				   '#SESSION.last#',
				   '#SESSION.first#' ) 
	</cfquery>
	
	<!--- associate incoming lines to this invoice --->
			
	<cfquery name="Detail" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    INSERT INTO InvoiceLine
				( InvoiceId,InvoiceLineId,OfficerUserId,OfficerLastName, OfficerFirstName)
	    SELECT   '#URL.Guid#',
			     InvoiceLineId,				 
			     '#SESSION.acc#',
			     '#SESSION.last#',
			     '#SESSION.first#'
		FROM     InvoiceIncomingLine
		WHERE    Mission       = '#Form.Mission#'
		AND      OrgUnitOwner  = '#Form.OrgUnitOwner#'
		AND      OrgUnitVendor = '#Form.orgunit#'
		AND      InvoiceNo     = '#Form.invoiceNo#'			
	</cfquery>		
	
	<cfif url.InvoiceClass eq "warehouse" and url.warehouse neq "">
	
		<cfquery name="Associate" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				
		   UPDATE    Materials.dbo.ItemTransactionShipping 
		   SET       InvoiceId = '#URL.guid#'	   
	
		      FROM    Materials.dbo.ItemTransactionShipping S, 
			          Materials.dbo.ItemTransaction T, 
					  Materials.dbo.WarehouseBatch B
					  
			  WHERE   T.TransactionId      = S.TransactionId 
			  AND     T.TransactionBatchNo = B.BatchNo			  
			  AND     B.Mission            = '#Form.mission#'
		      AND     B.Warehouse          = '#url.warehouse#'
		  
			  <!--- status is approved = 1 --->
			  AND        B.ActionStatus    = '1'		  	  
			  AND        B.BillingStatus   = '1'			  
			  AND        T.BillingMode     = 'External'
			  	  	  
			  <!--- for billing we only take the outgoing negative transactions for now --->
			  AND        (( B.TransactionType = '8' and TransactionQuantity < 0) OR B.TransactionType = '2')
		    
			  AND      (
			            InvoiceId IS NULL 
			            OR 
						InvoiceId NOT IN (SELECT InvoiceId FROM Purchase.dbo.Invoice WHERE InvoiceId = S.InvoiceId)
					    )
				 	   
		  </cfquery>		
		
	</cfif>
	
	
<!--- associate invoice to the purchase order --->

<cfif ParameterExists(Form.Requisition)> 

		 <!--- check the currency --->
			   
		 <cfquery name="getPO" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Purchase
			WHERE    PurchaseNo = '#URL.PurchaseNo#'					
		 </cfquery>
		  
		 <cfquery name="getInv" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Invoice
			WHERE    InvoiceId = '#URL.Guid#'					
		 </cfquery>		
				
		<cfif Lines.Recordcount eq "0">		
		
			  <cfquery name="InsertInvoice" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 INSERT INTO InvoicePurchase
						 (InvoiceId,
						  PurchaseNo,
						  OfficerUserId, 
						  OfficerLastName, 
						  OfficerFirstName) 
				    VALUES
					  ('#URL.Guid#', 
					   '#URL.PurchaseNo#'
					   '#SESSION.acc#',
					   '#SESSION.last#',
					   '#SESSION.first#') 
			  </cfquery>	
			  
			  <!--- saeguard as otherwise it would not show for editing --->
		
		<cfelse>

			<cfoutput query="Lines">
	
				<cfparam name="Form.req#currentrow#" default="">
			
				<cfset v = evaluate("Form.req#currentrow#")>
				<cfset v = replace(v,",","","ALL")>  
				<cfset v = replace(v," ","","ALL")>
				
				<cfif v eq "">
				   <cfset v = 0>
				</cfif>
				
				<cfif v neq "" and (v gt "0" or v lt "0")>
				
					  <!--- auto assign --->			  
			  
					  <cfif getPO.Currency eq getInv.DocumentCurrency>
					  
					  	 <cfset doc   =   Round(v*100)/100>
					     <cfset pod   =   Round(v*100)/100>
											  			  
					  <cfelse>
					  
					  	<cfset doc   =   Round(v*100)/100>
						
					  	<cf_ExchangeRate DataSource="AppsPurchase" 
						                 CurrencyFrom="#getInv.DocumentCurrency#"
										 CurrencyTo="#getPO.Currency#"
										 EffectiveDate="#dateformat(dteDoc,client.dateformatshow)#">
					  
					  	 <cfset pod   =  Round((doc/exc)*100)/100>
						 
					  
					  </cfif>
				
					  <cfquery name="InsertInvoiceLine" 
					     datasource="AppsPurchase" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO InvoicePurchase
								 (InvoiceId,
								  PurchaseNo,
								  RequisitionNo,
								  DocumentAmountMatched,
								  AmountMatched,							  
								  OfficerUserId, 
								  OfficerLastName, 
								  OfficerFirstName) 
						  VALUES
							  ('#URL.Guid#', 
							   '#URL.PurchaseNo#',
							   '#RequisitionNo#',
							   '#doc#',  <!--- invoice currency --->
							   '#pod#',  <!--- purchase amount currency --->
							   '#SESSION.acc#',
							   '#SESSION.last#',
							   '#SESSION.first#') 
						 </cfquery>
						 		
				</cfif>
					
				<!--- ------------------ --->			
				<!--- verify overposting --->
				<!--- ------------------ --->
				
				<cfquery name="Allocated" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     SELECT SUM(AmountMatched) as Amount
					 FROM   InvoicePurchase IP
					 WHERE  RequisitionNo  = '#RequisitionNo#' 		
					 <!--- count only valid invoices --->
					 AND    InvoiceId IN (SELECT InvoiceId 
					                      FROM   Invoice 
										  WHERE  InvoiceId = IP.InvoiceId
										  AND    ActionStatus != '9')			
				</cfquery>
								
			   	<!--- expressed in the amount of the purchase --->
				
				<cfset allowed = OrderAmount + (OrderAmount * (parameter1.InvoiceMatchDifference/100))>				 
			   	<cfset line=round(allowed*100)/100>			
				
				<cfif allocated.amount eq "">
				   <cfset all = 0>
				<cfelse>  
				   <cfset all = round(Allocated.amount*100)/100> 
				</cfif>								
			  				 
				<cfif (line-all lte -0.5) >
				 	<cfif line gt 0>			 	 
					  <cf_alert message = "It is not permitted to overspend (amount : #currency# #numberformat(all,',.__')#) the line: #RequisitionNo# with an obligation amount of #currency# #numberformat(line,'__,__.__')#. \n\n #OrderItem# \n\n Please contact your administrator if this problem persists."
						return = "back">
					  <cfabort>
					 </cfif>
				</cfif>
				
				<!--- record the class specification here --->
				
				<cfif Parameter1.EnablePurchaseClass eq "1"> 
				
					<cfset guid = URL.Guid>
					<cfinclude template="InvoiceEntryMatchRequisitionClassSubmit.cfm">	
								
				</cfif>				
					
			</cfoutput>
		
		</cfif>
						
		<!--- check balance before --->
		
		<cfquery name="Clear" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     DELETE FROM InvoicePurchase
			 WHERE  InvoiceId  = '#URL.Guid#' 	
			 AND    PurchaseNo != '#URL.PurchaseNo#'				
   	    </cfquery>
		
		<cfquery name="CheckTotal" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT SUM(DocumentAmountMatched) as Amount, 
			        count(*) as Records
			 FROM   InvoicePurchase
			 WHERE  InvoiceId  = '#URL.Guid#' 	
			 AND    PurchaseNo = '#URL.PurchaseNo#'				
   	    </cfquery>
		
		<cfif checkTotal.amount eq "">
		   <cfset amt = 0>
		<cfelse>
		   <cfset amt = checkTotal.amount>   
		</cfif>
		
		<cfif abs(amt - amountpayable) gte 0.001>
				    
			  <cf_alert message = "You must proceed distributing the payable amount: #numberformat(amountpayable,',.__')# exactly over the available obligation lines. \n\nCurrently #numberformat(amt,'__,__.__')# is distributed over #checktotal.records# lines.">
			  <!--- removed the <cfabort> --->
		
		</cfif>

<cfelse>

		<!--- matching on Purchase Order Header level --->
				  
		<cfquery name="getInv" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Invoice
			WHERE    InvoiceId = '#URL.Guid#'					
		</cfquery>
		
		<cfset cnt = 0>
		<cfloop index="po" list="#Form.selectedpurchase#" delimiters=",">
			<cfset cnt = cnt+1>
		</cfloop>
			
		<cfset dtotal = "0">
						
		<cfloop index="po" list="#Form.selectedpurchase#" delimiters=",">
										
			 <cfquery name="getPO" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Purchase P
				WHERE    PurchaseSerialNo = '#po#'			
			</cfquery>
									
			<cfif cnt eq "1">
			
				<!--- only one record found to be funded --->
				
				<cfif getPO.Currency eq getInv.DocumentCurrency>
					  
					  	 <cfset doc   =   Round(AmountPayable*100)/100>
					     <cfset pod   =   Round(AmountPayable*100)/100>
											  			  
					  <cfelse>
					  
					  	<cfset doc   =   Round(AmountPayable*100)/100>
						
					  	<cf_ExchangeRate DataSource="AppsPurchase" 
						                 CurrencyFrom="#getInv.DocumentCurrency#"
										 CurrencyTo="#getPO.Currency#"										 
										 EffectiveDate="#dateformat(dteDoc,client.dateformatshow)#">
					  
					  	 <cfset pod   =  Round((doc/exc)*100)/100>						 
					  
			    </cfif>		
				
				<cfset dtotal = dtotal + doc>		
			
				<cfquery name="InsertInvoice" 
					 datasource="AppsPurchase" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
				     INSERT INTO InvoicePurchase
						 (InvoiceId,
						  PurchaseNo,
						  DocumentAmountMatched,	
						  AmountMatched, <!--- PO matched --->						  				  
						  OfficerUserId, 
						  OfficerLastName, 
						  OfficerFirstName) 
					  VALUES
						  ('#URL.Guid#', 
						   '#getPO.PurchaseNo#',
						   '#doc#',
						   '#pod#',						   
						   '#SESSION.acc#',
						   '#SESSION.last#',
						   '#SESSION.first#') 
				</cfquery>
			
			<cfelse>
			
				<cfparam name="Form.Purchase_#po#" default="">	
				<cfset val = evaluate("Form.Purchase_#po#")>
				
				<cfif IsNumeric(val)>	
				
					<cfif getPO.Currency eq getInv.DocumentCurrency>
					  
					  	 <cfset doc   =   Round(val*100)/100>
					     <cfset pod   =   Round(val*100)/100>
											  			  
					  <cfelse>
					  
					  	<cfset doc   =   Round(val*100)/100>
						
					  	<cf_ExchangeRate DataSource="AppsPurchase" 
						                 CurrencyFrom="#getInv.DocumentCurrency#"
										 CurrencyTo="#getPO.Currency#"										 
										 EffectiveDate="#dateformat(dteDoc,client.dateformatshow)#">
					  
					  	 <cfset pod   =  Round((doc/exc)*100)/100>						 
					  
				    </cfif>
					
					<cfset dtotal = dtotal + doc>	
				
					<!--- purchase correction --->
					
					<cfquery name="InsertInvoice" 
					     datasource="AppsPurchase" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO InvoicePurchase
							 (InvoiceId,
							  PurchaseNo,
							  DocumentAmountMatched,	
							  AmountMatched, <!--- PO matched --->						  				  
							  OfficerUserId, 
							  OfficerLastName, 
							  OfficerFirstName) 
						  VALUES
							  ('#URL.Guid#', 
							   '#getPO.PurchaseNo#',
							   '#doc#',
							   '#pod#',	
							   '#SESSION.acc#',
							   '#SESSION.last#',
							   '#SESSION.first#') 
					</cfquery>
					
				</cfif>	
				
			</cfif>	
			
			 <!--- --------------------------------------------- ---> 		
			 <!--- --verify overposting of the obligated amount- --->
			 <!--- --------------------------------------------- --->
							  
			 <cfquery name="PO" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   *
				FROM     Purchase P, Ref_OrderType T
				WHERE    P.OrderType = T.Code 
				AND      P.PurchaseNo = '#getPO.PurchaseNo#'
			</cfquery>
			
			<!--- this will have just one record as the lines should have the same purchase currency of the purchase order --->
			
			<cfquery name="Amount" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   Currency, SUM(ROUND(OrderAmount,2)) as OrderAmount
				FROM     PurchaseLine
				WHERE    PurchaseNo = '#getPO.PurchaseNo#'
				GROUP BY Currency
			</cfquery>
				  
			<cfif PO.ReceiptEntry neq "9">
					
					<!--- take transaction currency which is the same as PO currency here --->
					
					<cfquery name="Posted" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						SELECT     GLL.TransactionDate, 
						           GLL.currency, 
								   <!--- adjusted 20/4/2016 as the invoice may be split over various purchase orders  so we apply the ratio --->
								   SUM((GLL.AmountCredit-GLL.AmountDebit)*(P.DocumentAmountMatched/I.DocumentAmount)) AS PaidAmount
						FROM       InvoicePurchase P INNER JOIN
		                   		   Invoice I ON P.InvoiceId = I.InvoiceId INNER JOIN
			                       Accounting.dbo.TransactionHeader GL ON I.InvoiceId = GL.ReferenceId INNER JOIN
		       		               Accounting.dbo.TransactionLine GLL ON GL.JournalSerialNo = GLL.JournalSerialNo AND GL.Journal = GLL.Journal
						 WHERE     PurchaseNo = '#getPO.PurchaseNo#'  
						 AND       I.ActionStatus != '9'
						 AND       GLL.TransactionSerialNo = '0'
						 AND       GL.ActionStatus != '9'
						 AND       GL.RecordStatus != '9'
						 AND       (GLL.ParentJournal = '' or GLL.ParentJournal is NULL)
						 GROUP BY  GLL.TransactionDate,
						           GLL.Currency
								   
					</cfquery>
					
					<!--- ATTENTION if Invoice is not issued in same currency as PO, the docoument amount is
					corrected for the base currency of the PO to give a balance figure ysing current
					exchange rates --->
					
					<cfset exp = 0>
					
					<!--- purchase currency --->
					<cfset curr = Amount.currency>
					
					<cfloop query="Posted">
					
						<cfif PaidAmount gt "0">
							<cfset amt = PaidAmount>
						<cfelse>
						    <cfset amt = 0>
						</cfif>	
						
						<cf_exchangeRate 
									DataSource    = "AppsPurchase"
							        CurrencyFrom  = "#currency#" 
							        CurrencyTo    = "#Curr#"									
								    EffectiveDate = "#dateformat(dteDoc,client.dateformatshow)#">
									
						<cfif Exc eq "0" or Exc eq "">
							<cfset exc = 1>
						</cfif>								
																									
						<cfset exp = exp+(amt/Exc)>
					
					</cfloop>	
					
				<!--- not posted yet --->									
			
				<cfquery name="Pending" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   SUM(P.DocumentAmountMatched) AS Amount, 
					         I.DocumentCurrency
					FROM     InvoicePurchase P INNER JOIN
	                   		 Invoice I ON P.InvoiceId = I.InvoiceId 
					WHERE    I.InvoiceId NOT IN (SELECT ReferenceId FROM Accounting.dbo.TransactionHeader WHERE ReferenceId is not NULL)
					AND      P.PurchaseNo = '#getPO.PurchaseNo#' 
					AND      I.ActionStatus != '9' 
					GROUP BY DocumentCurrency
				</cfquery>
				
				<cfset curr = Amount.currency>
						
				<cfset pen = "0">
						
				<cfloop query="Pending">
						
					<cf_exchangeRate 
					        DataSource    = "AppsPurchase"
					        CurrencyFrom  = "#DocumentCurrency#" 
					        CurrencyTo    = "#Curr#"							
							EffectiveDate = "#dateformat(dteDoc,client.dateformatshow)#">
									
						<cfif Exc eq "0" or Exc eq "">
							<cfset exc = 1>
						</cfif>		
																				
						<cfset pen = pen+(Amount/Exc)>
																	
				</cfloop>				
				
				<cfset tot = exp+pen>
				<cfset amt = Amount.OrderAmount*(100+parameter1.InvoiceMatchDifference)/100>
				 					  
				<cfif amt lt tot>
							
				 <cf_alert message = "You are about to exceed the obligated Purchase Order Amount (#numberformat(amt,",.__")#) with a total amount of #numberformat(tot,",.__")#. The difference exceeds the threshold of #parameter1.InvoiceMatchDifference#%."
					return = "back">
					
					<cfquery name="RemoveInvoice" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     DELETE FROM InvoiceIncoming
						 WHERE  OrgUnitVendor   = '#Form.OrgUnit#'
						 AND    Mission         = '#Form.Mission#'
						 AND    InvoiceNo       = '#Form.InvoiceNo#' 
					</cfquery>						
				 			 	
				 	<cfabort>
				
				</cfif> 						  
				  
			</cfif>
			
		</cfloop>	
		
		<cfif abs(dtotal - AmountPayable) gte "0.01">
		
			<cf_alert message = "You have not completely distributed the amount of the received invoice accross the purchase orders" return = "back">
					
			<cfquery name="RemoveInvoice" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     DELETE FROM InvoiceIncoming
						 WHERE  OrgUnitVendor   = '#Form.OrgUnit#'
						 AND    Mission         = '#Form.Mission#'
						 AND    InvoiceNo       = '#Form.InvoiceNo#' 
					</cfquery>			
						
			<cfabort>
		
		</cfif>

</cfif>

<cfparam name="Form.ExecutionId" default="">
		
	<!--- ------------------------------- --->	
	<!--- -----record execution table---- --->
	<!--- ------------------------------- --->
	
	<cfif Form.ExecutionId neq "">
	
		<cf_exchangeRate 
		CurrencyFrom  = "#Form.Currency#" 
		CurrencyTo    = "#getPO.Currency#"
		Datasource    = "AppsPurchase"
		EffectiveDate = "#dateformat(dteDoc,CLIENT.DateFormatShow)#">
									
	  <cfif Exc eq "0" or Exc eq "">
		<cfset exc = 1>
	  </cfif>			
		
	  <cfquery name="InsertExecution" 
	     datasource="AppsPurchase" 
    	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 INSERT INTO InvoicePurchaseExecution
			     (InvoiceId,
				  PurchaseNo,
				  ExecutionId,
				  AmountInvoiced,
				  ExchangeRate,
				  Amount,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
				  
		 SELECT   InvoiceId, 
		          PurchaseNo,
				  '#Form.ExecutionId#',
				  SUM(AmountMatched),
				  '#exc#',
				  SUM(DocumentAmountMatched),
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#')	
		  FROM     InvoicePurchase
		  WHERE    InvoiceId = '#url.guid#'		
		  GROUP BY InvoiceId, 
		           PurchaseNo   				  
		</cfquery>	
	
	</cfif>
	
	<!--- populate the execution query has been adjusted --->
	
	
	<!---  disable subamount on 29/4/2016 
		
		<cfset amountexe   = replace("#form.executionamount#",",","","ALL")>
						
		<cfquery name="PO" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     PurchaseLine 
			WHERE    PurchaseNo = '#URL.PurchaseNo#'	
			ORDER BY RequisitionNo
		</cfquery>
	
	    <!--- exchange rate correction --->
		
		<cf_exchangeRate 
		        CurrencyFrom  = "#Form.Currency#" 
		        CurrencyTo    = "#PO.Currency#"
				Datasource    = "AppsPurchase"
				EffectiveDate = "#dateformat(dteDoc,CLIENT.DateFormatShow)#">
									
		<cfif Exc eq "0" or Exc eq "">
			<cfset exc = 1>
		</cfif>			
		
		<cfset amt = amountexe/exc>
		
		<cfquery name="InsertExecution" 
	     datasource="AppsPurchase" 
    	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 INSERT INTO InvoicePurchaseExecution
			     (InvoiceId,
				  PurchaseNo,
				  ExecutionId,
				  AmountInvoiced,
				  ExchangeRate,
				  Amount,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
		 VALUES
			    ('#URL.Guid#',
				 '#URL.PurchaseNo#',
				 '#Form.ExecutionId#',
				 '#amountexe#',
				 '#exc#',
				 '#amt#',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')		 
	    </cfquery>
				
	</cfif>

	--->

	<!--- ---------------------------------------------------------------------- --->
	<!--- ------- update funding summary table which is used for inquiry ------- --->
	<!--- ---------------------------------------------------------------------- --->
	<!--- -------------- adjusted to incorporate change multi purchase --------- --->
	
	<cfquery name="FundedRecord" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		   INSERT INTO InvoiceFunding
		            (InvoiceId,Fund,ProgramPeriod,ProgramCode,ActivityId,ObjectCode,Amount)		
					 
			SELECT  InvoiceId,
			        Fund,
					Period,
					ProgramCode,
					ActivityId,
					ObjectCode, 
					SUM(Amount) as Amount
			
			FROM   (						 
					 	 
					SELECT     I.InvoiceId, 
					           F.Fund, 
							   F.Period, 
							   F.ProgramCode, 
							   F.ActivityId, 
							   F.ObjectCode, ROUND(F.Amount /
		                          (SELECT    SUM(Amount) 
		                           FROM      PurchaseFunding
									<!---  20/4/2016 ---  WHERE      (PurchaseNo = IP.PurchaseNo)), 2) * I.DocumentAmount AS Amount --->
								   WHERE     (PurchaseNo = IP.PurchaseNo)) * IP.AmountMatched, 2) AS Amount
					FROM      Invoice AS I INNER JOIN
				              InvoicePurchase AS IP ON I.InvoiceId = IP.InvoiceId INNER JOIN
		        		      PurchaseFunding AS F ON IP.PurchaseNo = F.PurchaseNo
					WHERE     I.InvoiceId = '#URL.Guid#'
					
					GROUP BY  IP.PurchaseNo,
					          I.InvoiceId, 
							  F.Fund, 
							  F.Period, 
							  F.ProgramCode, 
							  F.ActivityId,
							  F.ObjectCode, 
							  F.Amount, 
							  IP.AmountMatched 
							  
					) as sub
					
			GROUP BY InvoiceId,Fund,Period,ProgramCode,ActivityId,ObjectCode
						  
		</cfquery>

</cftransaction>

<cfif form.entityclass neq "">

	<cfif dtewrk lte now()>
	
		<!--- otherwise delay invoice for processing --->

		<cfset link = "Procurement/Application/Invoice/Matching/InvoiceMatch.cfm?id=#URL.Guid#">
		
		<cfquery name="OrgUnit" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT * 
			 FROM    Organization.dbo.Organization
			 WHERE   OrgUnit = '#Form.OrgUnit#'
		</cfquery>
		
		 <cfquery name="Check" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Purchase
			WHERE    PurchaseNo = '#URL.PurchaseNo#'					
		 </cfquery>
		 					
		<cf_ActionListing 
		    EntityCode       = "ProcInvoice"
			EntityClass      = "#Form.EntityClass#"
			EntityGroup      = "#Check.OrderType#"
			EntityStatus     = ""					
			OrgUnit          = "#Form.OrgUnitOwner#"
			Mission          = "#Form.IssuedMission#"
			ObjectReference  = "#Form.InvoiceNo#"
			ObjectReference2 = "#OrgUnit.OrgUnitName#"
			ObjectKey4       = "#URL.Guid#"
		  	ObjectURL        = "#link#"
			Show             = "No"  
			DocumentStatus   = "0">
					
	</cfif>				
				
</cfif>		


<cfoutput>

<!--- direct invoice from warehouse --->

<cfif url.invoiceclass eq "warehouse" and url.warehouse neq "">	
			
	<cfoutput>
		<script>			    
		    try { parent.parent.payablerefresh('#Form.Mission#','#url.warehouse#','#Form.orgunit#')	} catch(e) {}
		</script>
	</cfoutput>
				
</cfif>

<script language="JavaScript">    
     parent.ptoken.location ( "../Matching/InvoiceMatch.cfm?html=#html#&Id=#url.guid#" )
	 // added by hanno 19/2/2015
	 try {
	 parent.parent.opener.history.go() } catch(e) {}
	 <!--- alert("Invoice has been recorded.") parent.document.getElementById("search").click()	--->
</script>

</cfoutput>
  	