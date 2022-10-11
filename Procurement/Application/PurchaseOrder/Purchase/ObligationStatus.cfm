
<cfparam name="url.setstatus" default="">
<cfparam name="SESSION.isAdministrator" default="Yes">

<!--- processing 

1. Set ObligationStatus in Purchase to new value
		1a. Set ActionStatus to 4 if ObligationStatus = 0 	
		1b. Set ActionStatus to 3 if ObligationStatus = 1 	
		
2. if status = 0 define total invoiced and determine a percentage of completion
       2a. update the PurchaseLineBaseObligated with new value

3. if status = 1 reset PurchaseLineBaseObligated with Base Value of the line
  	   
--->

<!--- check invoices --->

 <cfquery name="PO" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Purchase 
		WHERE  PurchaseNo = '#URL.Id1#'		
</cfquery>	

<!--- check pending invoices --->

<cfquery name="PendingInvoices" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    * 
        FROM      Invoice
		WHERE     InvoiceId IN (SELECT InvoiceId 
		                        FROM   InvoicePurchase 
								WHERE  PurchaseNo = '#URL.ID1#') 								
		AND       ActionStatus = '0'		
</cfquery>  

<!--- check pending receipts --->

<cfquery name="PendingReceipts" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    * 
        FROM      PurchaseLineReceipt
		WHERE     RequisitionNo IN (SELECT RequisitionNo 
		                        FROM   Purchaseline 
								WHERE  PurchaseNo = '#URL.ID1#') 								
		AND       ActionStatus IN ('0','1')		
</cfquery>  

<cfif getAdministrator(PO.mission) eq "1">
	
		<!--- no filtering --->

<cfelse>

	<!--- administrator can set the status to disbursed no matter what.
	Hanno 12/9/2011 --->
	
	<cfif PendingInvoices.recordcount gte "1" and 
	      PendingReceipts.recordcount gte "1"  and 
		  PO.ObligationStatus eq "0">
	   
	      <!--- reset obligation status to active 
		  as there are pending invoices found --->	
	      <cfset url.setstatus = "1">
		  
	</cfif>

</cfif>

<cfif url.setstatus neq "">

    <!--- should return just one line --->

	<cfquery name="Line" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		    SELECT Currency, 
			       sum(OrderAmount) as Amount
			FROM   PurchaseLine 			
			WHERE  PurchaseNo = '#URL.Id1#'
			GROUP BY Currency
	</cfquery>	

	<cfif url.setstatus eq "0">		
		
		<!--- sum the invoices --->
			
		<cf_verifyOperational 
	         module    = "Accounting" 
			 Warning   = "No">
			 
		<cfif operational eq "1">
		
			<!--- take transaction currency which is the same as PO currency here --->
						
			<cfquery name="Posted" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    Pur.InvoiceId,
						  Pur.DocumentAmountMatched as Amount,
						  GLL.TransactionDate, 
				          GLL.currency, 
						  SUM(GLL.AmountCredit) AS PaidAmount
				FROM      InvoicePurchase Pur INNER JOIN
	                  	  Invoice I ON Pur.InvoiceId = I.InvoiceId INNER JOIN
	                      Accounting.dbo.TransactionHeader GL ON I.InvoiceId = GL.ReferenceId INNER JOIN
	      		          Accounting.dbo.TransactionLine GLL ON GL.JournalSerialNo = GLL.JournalSerialNo AND GL.Journal = GLL.Journal
				 WHERE    PurchaseNo = '#url.id1#'  
				 AND      I.ActionStatus != '9'
				 AND      GLL.Reference = 'Invoice' 
				 AND      (GLL.ParentJournal = '' or GLL.ParentJournal is NULL)
				 GROUP BY Pur.InvoiceId,
						  Pur.DocumentAmountMatched,
						  GLL.TransactionDate,
				          GLL.Currency		
								  
			</cfquery>
						
			<!--- ATTENTION if Invoice is not issued in same currency as PO, the docoument amount is
			corrected for the base currency of the PO to give a balance figure ysing current
			exchange rates --->
			
			<cfset exp = 0>
						
			<cfloop query="Posted">			
			
				<!--- correction for multi PO paymwnts --->
				
				<cfquery name="getRatio" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT Sum(DocumentAmountMatched) as Total
					FROM   InvoicePurchase Pur
					WHERE  InvoiceId = '#invoiceid#'
				</cfquery> 						
							
				<cfif PaidAmount gt "0">
					<cfset amt = PaidAmount * (Amount / getRatio.Total)>
				<cfelse>
				    <cfset amt = 0>
				</cfif>	
				
				<cf_exchangeRate 
			        CurrencyFrom = "#Currency#" 
			        CurrencyTo   = "#Line.Currency#"
					EffectiveDate = "#dateformat(TransactionDate,CLIENT.DateFormatShow)#">
							
				<cfif Exc eq "0" or Exc eq "">
					<cfset exc = 1>
				</cfif>								
																							
				<cfset exp = exp+(amt/Exc)>			
				
			
			</cfloop>
			
			<CFSET exp = numberformat(exp,"_.__")>
			
						
		<cfelse>
		
			<cfquery name="Pending" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  SUM(DocumentAmount) AS Amount, 
				        DocumentCurrency
				FROM    InvoicePurchase Pur INNER JOIN
                   		Invoice I ON Pur.InvoiceId = I.InvoiceId 
				WHERE   PurchaseNo = '#url.id1#' 									
				AND     I.ActionStatus != '9' 
				GROUP BY DocumentCurrency
			</cfquery>
					
			<!--- ATTENTION if Invoice is not issued in same currency as PO, the docoument amount is
						corrected for the base currency of the PO to give a balance figure ysing current
						exchange rates --->
								
			<cfset exp = "0">
				
			<cfloop query="Pending">
				
				<cf_exchangeRate 
			        CurrencyFrom = "#DocumentCurrency#" 
			        CurrencyTo   = "#Line.Currency#">
							
					<cfif Exc eq "0" or Exc eq "">
						<cfset exc = 1>
					</cfif>								
																							
					<cfset exp = exp+(Amount/Exc)>
															
			</cfloop>		
					
			<CFSET exp = numberformat(exp,"_.__")>
				
		</cfif>	 
						
		<cfset ratio = exp/line.amount>
		
		<cftransaction>
		
			<cfquery name="Update" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			    UPDATE Purchase 
				SET    ActionStatus          = '4',  <!--- disbursed --->
				       ObligationStatus      = '0',
					   ObligationStatusDate  = getDate(),
					   ObligationStatusActor = '#SESSION.acc#'
				WHERE  PurchaseNo            = '#URL.Id1#'
		   </cfquery>			
		
		   <cfquery name="setPO" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			    UPDATE PurchaseLine 
				SET    OrderAmountBaseObligated  = ceiling(OrderAmountBase*#ratio#*100)/100, 		
				       OrderAmountBaseLiquidated = ceiling(OrderAmountBase*#ratio#*100)/100 		       
				WHERE  PurchaseNo            = '#URL.Id1#'
		   </cfquery>	
		
		</cftransaction>
	
	<cfelse>
	
		<cftransaction>
	
		<cfquery name="Update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE Purchase 
				SET    ActionStatus          = '3', 				
				       ObligationStatus      = '1',
					   ObligationStatusDate  = getDate(),
					   ObligationStatusActor = '#SESSION.acc#'
				WHERE  PurchaseNo ='#URL.Id1#'
		</cfquery>
		
		<cfquery name="PO" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE PurchaseLine 
				SET    OrderAmountBaseObligated = OrderAmountBase 				       
				WHERE  PurchaseNo ='#URL.Id1#'
		</cfquery>		
		
		</cftransaction>
		
	</cfif>

</cfif>

<cfquery name="PO" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Purchase 
		WHERE  PurchaseNo ='#URL.Id1#'
</cfquery>	

<cfoutput>
	
	<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr><td height="20" class="labelmedium" style="padding-right:4px"><cf_tl id="Status">: </td>
			<td class="labelmedium"><cfif PO.ObligationStatus eq "0"><font color="red"><cf_tl id="Completed"><cfelse><font color="008000"><cf_tl id="Open"></cfif></td>
			
			<td class="labelmedium" style="padding-left:4px">			
			
			<cfif (PendingInvoices.recordcount eq "0" and PendingReceipts.recordcount eq "0") or getAdministrator(PO.mission) eq "1">
				
				<cfif PO.ObligationStatus eq "1">
				<a href="javascript:ptoken.navigate('ObligationStatus.cfm?id1=#url.id1#&setstatus=0','obligation')">
				[<cf_tl id="Press to close">]
				</a>
				<cfelse>
				<a href="javascript:ptoken.navigate('ObligationStatus.cfm?id1=#url.id1#&setstatus=1','obligation')">
				[<cf_tl id="Press to re-open">]
				</a>
				</cfif>
								
				<cfif Pendinginvoices.recordcount gte "1">
				<b>#PendingInvoices.recordcount#</b> <cfif PendingInvoices.recordcount gte "2"> <cf_tl id="Pending Invoices"> <cfelse> <cf_tl id="Pending Invoice">  </cfif>	
				<cfelseif PendingReceipts.recordcount gte "1">
				<b>#PendingReceipts.recordcount#</b> <cfif PendingReceipts.recordcount gte "2"> <cf_tl id="Pending Receipts"> <cfelse> <cf_tl id="Pending Receipt"> </cfif>
				</cfif>
				</font>
				
			<cfelse>
			
			    <cfif Pendinginvoices.recordcount gte "1">
				[<b>#PendingInvoices.recordcount#</b> <cfif PendingInvoices.recordcount gte "2"> <cf_tl id="Pending Invoices"> <cfelse> <cf_tl id="Pending Invoice">  </cfif>]	
				<cfelseif PendingReceipts.recordcount gte "1">
				[<b>#PendingReceipts.recordcount#</b> <cfif PendingReceipts.recordcount gte "2"> <cf_tl id="Pending Receipts"> <cfelse> <cf_tl id="Pending Receipt"> </cfif>]
				</cfif>
			
			</cfif>	
			</font>
			</td>					
		</tr>
	</table>

</cfoutput>