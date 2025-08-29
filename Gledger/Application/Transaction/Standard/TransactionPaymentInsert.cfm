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
<cfparam name="FORM.recordno" default="0">
<cfparam name="FORM.selected" default="">

<cfquery name="Parameter"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Parameter
</cfquery>

<cfquery name="HeaderSelect"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM #SESSION.acc#GledgerHeader_#client.sessionNo#_#session.mytransaction#
</cfquery>

<cfif url.accountPeriod neq "">

	<cfset dateValue = "">
	<CF_DateConvert Value="#url.transactionDate#">
	<cfset tradte = dateValue>
	
	<cfquery name="apply"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    UPDATE #SESSION.acc#GledgerHeader_#client.sessionNo#_#session.mytransaction#
		SET AccountPeriod     = '#url.accountPeriod#',
		    TransactionDate   = #tradte#
	</cfquery>

</cfif>

<cfquery name="Discount"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
 SELECT *
 FROM   Ref_AccountMission
 WHERE  Mission = '#HeaderSelect.Mission#' 
 AND    SystemAccount = 'Discount'
</cfquery>

<cfif discount.recordcount eq "0">

	 <tr><td class="labelmedium2" style="font-size:20px">
	   <font style="color: B22222;">Problem, discount gl account was not been defined</font>
	 </td></tr>	 
	 <cfabort>
  
</cfif>

<cfset SerNo = 0>

<cfquery name="Prior" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT MAX(TransactionSerialNo) as Last
		FROM #SESSION.acc#GLedgerLine_#client.sessionNo#_#session.mytransaction#
</cfquery>
	
<cfoutput query = "Prior">
  <cfif Last neq "">
     <cfset SerNo = Last>
  </cfif>	 
</cfoutput>

<cfloop index="itm" list="#Form.selected#" delimiters=",">
	
	<!--- Select TransactionHeader --->
	
	<cfset serNo = serNo + 1>
	
	<cfquery name="SearchResult"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 	SELECT  P.*, 
			        L.GLAccount, 
					J.AccountType, 
					J.Currency, 
					C.ExchangeRate
			 FROM   TransactionHeader P 
	                INNER JOIN TransactionLine L ON P.Journal             = L.Journal 
					                            AND P.JournalSerialNo     = L.JournalSerialNo 
										        AND L.TransactionSerialNo = 0 
			        INNER JOIN Ref_Account A     ON L.GlAccount  = A.GlAccount
	                INNER JOIN Journal J         ON P.Journal    = J.Journal 	
			        INNER JOIN Currency C        ON J.Currency     = C.Currency							
			 WHERE 	P.AmountOutstanding > 0
			 AND    A.AccountClass     = 'Balance' 
			 AND    P.TransactionId    = '#preserveSingleQuotes(itm)#' 	
					   	   
	</cfquery>
			
	<!--- Add TransactionHeader in a loop to the temp table --->
	
	
	
	<cfoutput query="SearchResult">
							
		<!--- ---------------  --->
		<!--- offset advances --->
		<!--- --------------- --->
		
		<cfif ReferenceId neq "" or TransactionSourceNo neq "">
				
		    <!--- Obtain advances :
			      check advance based on the entry in the system journal advance with the same reference 
			                       or
				  determine if we have an advance recorded for this PO order based on the invoice->PO association  				   
			 --->
										
			<cfquery name="Advance" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				<cfif TransactionSourceNo neq "">
						
					<!--- 1/2 look for advance related to the ReferenceNo of the invoice of the accounting module --->
				
					SELECT   TL.TransactionCurrency, TL.Currency, '' as Reference, TH.TransactionSourceNo, TL.GLAccount, 
					         AmountDebit * TL.ExchangeRate AS Advance
					FROM     TransactionHeader AS TH INNER JOIN
	                         TransactionLine AS TL ON TH.Journal = TL.Journal AND TH.JournalSerialNo = TL.JournalSerialNo
					<!--- linking PIN from real Invoice to the advance a source entry--->		 
					WHERE    TH.TransactionSource   = 'AccountSeries'
					AND      TH.TransactionSourceNo = '#TransactionSourceNo#' <!--- linking PIN from real Invoice to the advance --->
					AND      TH.Journal IN (SELECT Journal FROM Journal WHERE SystemJournal = 'Advance' AND Mission = '#mission#') 
					AND      TL.TransactionSerialNo != '0'
					AND      TH.Journal != '#Journal#'
					AND      ParentLineId is NULL		
									
					<cfif ReferenceId neq "">
				          UNION
					</cfif>
				
				</cfif>
																
				<cfif referenceId neq "">
				
				<!--- 2/2 look for advance related to any of the 1..n POs of the invoice recorded  --->
				
				
				
				SELECT   TL.TransactionCurrency, TL.Currency,  TL.Reference, TH.TransactionSourceNo, TL.GLAccount,
				         AmountDebit * TL.ExchangeRate AS Advance
				FROM     TransactionHeader AS TH INNER JOIN
                         TransactionLine AS TL ON TH.Journal = TL.Journal AND TH.JournalSerialNo = TL.JournalSerialNo
				<!--- an invoice can relate to different PO's each with its own advance issue --->		 
				WHERE    TH.TransactionSource = 'PurchaseSeries'
				AND      TH.TransactionSourceNo IN ( SELECT    IP.PurchaseNo
										             FROM      Purchase.dbo.InvoicePurchase IP 
										             WHERE     IP.InvoiceId = '#ReferenceId#' )	<!--- referenceId refers to the invoice can also be : TransactionSourceId --->
				AND      TH.Journal IN ( SELECT Journal FROM Journal WHERE SystemJournal = 'Advance' AND Mission = '#mission#' ) 						  		 
				AND      TransactionSerialNo != '0'						
				AND      ParentLineId is NULL		
												
				</cfif>	
												
			</cfquery>
						
			<!--- SUM the total of the advances --->
			
			<cfquery name="Advance" dbtype="query">
						
				SELECT   TransactionCurrency, Currency, Reference, TransactionSourceNo, GLAccount, SUM(Advance) as Advance
				FROM     Advance
				GROUP BY TransactionCurrency, Currency, Reference, TransactionSourceNo, GLAccount
			
			</cfquery>		
		
			
			<cfif Advance.recordcount gte "1">
													
			    <!--- determine how much was consumed for the found advance for the object (ReferenceNo) --->
						
				<cfquery name="Offsetted" 
					    datasource="AppsLedger" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">						
					    SELECT SUM(AmountCredit*ExchangeRate) as Total 
						FROM   TransactionLine
						WHERE  ReferenceNo = '#Advance.TransactionSourceNo#'							
						AND    GLAccount   = '#Advance.GLAccount#'		
						AND    Journal IN (SELECT   Journal
                                           FROM     Journal
                                           WHERE    Mission      = '#mission#') 				
						AND    ParentJournal         is not NULL
						AND    ParentJournalSerialNo is not NULL																														
						<!--- this is the transaction base --->
										
				</cfquery>  
																								
				<cfset val = 0>
				
				<cfif Offsetted.Total neq "">
				  <cfset val = val+Offsetted.Total>
				</cfif>
				
				<!--- ALSO determine how much is in process of offset as it is selected in this run-time transaction --->
				
				<cfquery name="OffsettedSelected" 
					    datasource="AppsQuery" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">						
					    SELECT SUM(AmountCredit*ExchangeRate) as Total 
						FROM   #SESSION.acc#GLedgerLine_#client.sessionNo#_#session.mytransaction#
						WHERE  ReferenceNo        = '#Advance.TransactionSourceNo#'	
						AND    GLAccount          = '#Advance.GLAccount#'							
						AND    ParentJournal         is not NULL
						AND    ParentJournalSerialNo is not NULL												
						<!--- this is the transaction base --->
				</cfquery> 
				
				<cfif OffsettedSelected.Total neq "">
				  <cfset val = val+OffsettedSelected.Total>
				</cfif>  
													
				<cfset offset    = 0>
				<cfset payment   = amountOutstanding>
				
				<!--- we assume here the advance and offset
				    found is of the same calculated currency --->
				 												
				<cfset diff = abs(Advance.Advance-val)>
										
				<cfif diff gte 0.05>
					
					<cfif Advance.TransactionCurrency eq currency>
					
						<!--- advance currency = currency of the invoice --->
									
						<cfif amountOutstanding gte diff>											
							<cfset offset = diff>								
						<cfelse>												
							<cfset offset = payment>						
						</cfif>								
					
					<cfelse>
					
						<!--- advance currency is different of the invoice currency --->
					
						<cf_exchangeRate CurrencyFrom="#Advance.TransactionCurrency#" CurrencyTo="#currency#">	
					    <cfset adv = NumberFormat(diff/exc,'.__')>	
				        			
						<cfif amountOutstanding gte adv>					
							<!--- offset in the currency of the advance --->
							<cfset offset = advance.advance>								
						<cfelse>						
							<!--- offset in the currency of the advance --->
							<cf_exchangeRate CurrencyFrom="#Currency#" CurrencyTo="#Advance.TransactionCurrency#">	
							<cfset offset = payment/exc>						
						</cfif>					
							
					</cfif>		
						
				</cfif>								
								
				<cfif offset gt "0">			
				
					<!--- advance offset determination --->
						
					<cfif Advance.currency eq HeaderSelect.currency>
									
						<cfset cur  = currency>		
						<cfset tra  = NumberFormat(offset,'.__')>	
										
						<cfset amt  = NumberFormat(offset,'.__')>
						<cfset jexc  = 1>
						
						<cfif Parameter.BaseCurrency eq HeaderSelect.currency>
						
							<!--- journal currency = base currency exchange == 1--->				
							<cfset amtB = NumberFormat(offset,'.__')>
							<cfset bexc  = 1>
						
						<cfelse>			
						
							<cf_exchangeRate CurrencyFrom="#currency#" CurrencyTo="#Parameter.BaseCurrency#">	
						    <cfset amtB = NumberFormat(offset/exc,'.__')>	
					        <cfset bexc  = exc>
						
						</cfif>			
						
					<cfelse>	
									
						<!--- you may initiate pay for an invoice posted in currency QTZ, 
						using a payment order in lets say currency USD as it will make the adjustment in payment order
					    --->
					
					   <cfset cur  = currency>	
					   <cfset tra  = NumberFormat(offset,'.__')>
					   	
					   <cf_exchangeRate CurrencyFrom="#Advance.TransactionCurrency#" CurrencyTo="#HeaderSelect.currency#">	
					   <cfset amt = NumberFormat(offset/exc,'.__')>
					   <cfset jexc = NumberFormat(offset/amt,'.______')>
					  			   	   
					   <cf_exchangeRate CurrencyFrom="#Advance.TransactionCurrency#" CurrencyTo="#Parameter.BaseCurrency#">	
					   <cfset amtB = NumberFormat(offset/exc,'.__')>	
					   
					   <cf_exchangeRate CurrencyFrom="#HeaderSelect.currency#" CurrencyTo="#Parameter.BaseCurrency#">			
					   <cfset bexc  = exc>
					
					</cfif>
					
										
					<cfset credit      = amt>
					<cfset debit       = 0>
					<cfset creditbase  = amtB>
					<cfset debitbase   = 0> 
					<cfset accounttype = "Credit"> 				
							
					<!--- offset transaction entry --->
									
					<cfquery name="Insert" 
					datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
															
						INSERT INTO dbo.#SESSION.acc#GledgerLine_#client.sessionNo#_#session.mytransaction# 
						   (Journal,
						   JournalSerialNo,
						   TransactionSerialNo, 
						   TransactionLineId,						   
						   ParentLineId,	<!--- maybe we can point this to the advance --->	  						   
						   TransactionDate,
						   GLAccount,
						   ReconciliationPointer,
						   Memo,
						   AccountPeriod,
						   TransactionType,
						   Reference, 
						   ReferenceName,
						   ReferenceNo,
						   ParentJournal,
						   ParentJournalSerialNo,  
						   ParentTransactionId,
						   TransactionCurrency,
						   TransactionAmount,
						   ExchangeRate,
						   Currency,
						   AmountDebit,
						   AmountCredit,
						   ExchangeRateBase,
						   AmountBaseDebit,
						   AmountBaseCredit,
						   TransactionTaxCode,
						   Created)
						VALUES 
						   ('#URL.Journal#',
						   '#serNo#',
						   '#serNo#',
						   newid(),
						   <!--- removed 14/10/2014 based on the fact that this is not a line but a header reference 
						        16/9/2016 reverted by Hanno with issue for CICIG mode --->
						   '#TransactionId#', 
						   #tradte#,
						   '#Advance.GLAccount#',            <!--- offset against the same account --->
						   '0',
						   'Payment Order',
						   '#URL.AccountPeriod#', 
						   'Offset Advance',
						   'Offset Advance',
						   'Offset Advance',
						   '#Advance.TransactionSourceNo#',   <!--- line reference to the source --->
						   '#Journal#', 
						   '#JournalSerialNo#',  
						   '#TransactionId#', 			
						   '#cur#',
						   '#tra#',
						   '#jexc#',
						   '#headerselect.currency#',
						   '#debit#',
						   '#credit#',
						   '#bexc#',
						   '#debitbase#',
						   '#creditbase#',
						   '00',
						   getDate()) 
						   
					</cfquery>
								
				</cfif>
				
			</cfif>	
			
		</cfif>			
		
		<cfset fld = left(TransactionId,8)>		
		
		<cfset payment = evaluate("Form.off_#fld#")>	
		<cfset payment= replace("#payment#",",","","ALL")>
										
		<!--- ------------------------------- --->				
		<!--- remaining payment determination --->
		<!--- ------------------------------- --->
				
		<cfif currency eq HeaderSelect.currency>
						
			<cfset cur  = currency>		
			<cfset tra  = NumberFormat(payment,'.__')>					
			<cfset amt  = NumberFormat(payment,'.__')>
			<cfset jexc  = 1>
			
			<cfif Parameter.BaseCurrency eq HeaderSelect.currency>
			
				<!--- journal currency = base currency exchange == 1--->				
				<cfset amtB = NumberFormat(payment,'.__')>
				<cfset bexc  = 1>
			
			<cfelse>			
			
				<cf_exchangeRate CurrencyFrom="#currency#" CurrencyTo="#Parameter.BaseCurrency#">	
			    <cfset amtB = NumberFormat(payment/exc,'.__')>	
		        <cfset bexc  = exc>
			
			</cfif>			
			
		<cfelse>	
						
			<!--- you may initiate pay for an invoice posted in currency QTZ, 
			using a payment order in lets say currency USD as it will make the adjustment in payment order
		    --->
		
		   <cfset cur  = currency>	
		   <cfset tra  = NumberFormat(payment,'.__')>
		   	
		   <cf_exchangeRate CurrencyFrom="#currency#" CurrencyTo="#HeaderSelect.currency#">	
		   <cfset amt  = NumberFormat(payment/exc,'.__')>
		   <cfset jexc = NumberFormat(payment/amt,'.______')>
		   
		   <!---
		   <cfset jexc = exc>	   
		   --->
		   	   
		   <cf_exchangeRate CurrencyFrom="#currency#" CurrencyTo="#Parameter.BaseCurrency#">	
		   <cfset amtB = NumberFormat(payment/exc,'.__')>	
		   
		   <cf_exchangeRate CurrencyFrom="#HeaderSelect.currency#" CurrencyTo="#Parameter.BaseCurrency#">			  
		   <cfset bexc  = exc>
		
		</cfif>		
								
		<cfif AccountType eq "Debit">  <!--- this is now a reverse teneinde de correctie te maken !! --->
		
			  <cfset debit       = amt>
			  <cfset credit      = 0>
		  	  <cfset debitbase   = amtB>
		      <cfset creditbase  = 0>
		      <cfset accounttype = "Debit">		
			 			
		<cfelse>
				
			  <cfset credit      = amt>
			  <cfset debit       = 0>
			  <cfset creditbase  = amtB>
			  <cfset debitbase   = 0> 
			  <cfset accounttype = "Credit"> 
			  			 
		</cfif>		
												
		<cfif payment gt "0">	
							
			<cfquery name="Insert" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
												
				INSERT INTO dbo.#SESSION.acc#GledgerLine_#client.sessionNo#_#session.mytransaction# 
					   (Journal,
					   JournalSerialNo,
					   TransactionSerialNo, 
					   TransactionLineId,
					   ParentLineId,		  
					   TransactionDate,
					   GLAccount,
					   ReconciliationPointer,
					   Memo,
					   AccountPeriod,
					   TransactionType,
					   Reference, 
					   ReferenceName,
					   ReferenceNo,
					   ParentJournal,
					   ParentJournalSerialNo,  
					   ParentTransactionId,
					   TransactionCurrency,
					   TransactionAmount,
					   ExchangeRate,
					   Currency,
					   AmountDebit,
					   AmountCredit,
					   ExchangeRateBase,
					   AmountBaseDebit,
					   AmountBaseCredit,
					   TransactionTaxCode,Created)
				VALUES ('#URL.Journal#',
					   '#serNo#',
					   '#serNo#',
					   newid(),
					   '#TransactionId#',
					   #tradte#,
					   '#glaccount#',
					   '0',
					   'Payment Order',
					   '#URL.AccountPeriod#',
					   'Invoice Payment',
					   'Invoice Payment',
					   '#referencename#',
					   '#referenceno#',
					   '#Journal#', 
					   '#JournalSerialNo#',  
					   '#TransactionId#', 			
					   '#cur#',
					   '#tra#',
					   '#jexc#',
					   '#headerselect.currency#',
					   '#debit#',
					   '#credit#',
					   '#bexc#',
					   '#debitbase#',
					   '#creditbase#',
					   '00',
					   getDate())
			</cfquery>
					
		</cfif>	
		
		<!--- ------------------- --->
		<!--- discount correction --->
		<!--- ------------------- --->
						
		<cfif ActionDiscountDate gte now()>
		
		  <cf_exchangeRate CurrencyFrom="#currency#" CurrencyTo="#HeaderSelect.Currency#">		
		
		  <cfset amtdis  = NumberFormat((AmountOutstanding*ActionDiscount)/exc,'.__')>
		  
		  <cf_exchangeRate CurrencyFrom="#currency#" CurrencyTo="#Parameter.BaseCurrency#">	
		  <cfset amtdisB = NumberFormat(((AmountOutstanding*ActionDiscount)/exc),'.__')>
		  
		  <cfif AccountType is "Credit">  <!--- this is now a reverse teneinde de correctie te maken !! --->
		    						
		    <cfset debitdis       = 0>
		    <cfset creditdis      = amtdis>
		    <cfset debitbasedis   = 0>
		    <cfset creditbasedis  = amtdisB>
		    <cfset accounttypedis = "Credit">
		    
		  <cfelse>
		  		    
		    <cfset creditdis       = 0>
		    <cfset debitdis        = amtdis>
		    <cfset creditbasedis   = 0>
		    <cfset debitbasedis    = amtdisB>
		    <cfset accounttypedis  = "Debit">
		    
		  </cfif>
		
		</cfif> 
				
				
		<cfif ActionDiscountDate gte now() and abs(amtdis) gt 0>
		
			<cfquery name="Insert" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO dbo.#SESSION.acc#GLedgerLine_#client.sessionNo#_#session.mytransaction#
			   (Journal,
			   JournalSerialNo,
			   TransactionSerialNo, 
			   TransactionLineId,
			   ParentLineId,	
			   TransactionDate,
			   GLAccount,
			   Memo,
			   AccountPeriod,
			   TransactionType,
			   Reference, 
			   ReferenceName,
			   ReferenceNo,
			   <!--- added 14/1/2009 --->
			   ReconciliationPointer,
			   ParentJournal,
			   ParentJournalSerialNo,  
			   ParentTransactionId,
			   TransactionCurrency,
			   TransactionAmount,
			   ExchangeRate,
			   Currency,
			   AmountDebit,
			   AmountCredit,
			   ExchangeRateBase,
			   AmountBaseDebit,
			   AmountBaseCredit,
			   TransactionTaxCode,Created)
			VALUES 
			   ('#URL.Journal#',
			   '#serNo#',
			   '#serNo#',
			   newid(),
			   '#TransactionId#',
			   #tradte#,
			   '#Discount.GLAccount#',
			   'Payment Order',
			   '#URL.AccountPeriod#',
			   'Invoice Discount',
			   '#reference#',
			   '#referencename#',
			   '#referenceno#',
			   <!--- added 14/1/2009 --->
			   '0',
			   '#Journal#', 
			   '#JournalSerialNo#',  
			   '#TransactionId#', 
			   '#currency#',
			   '#amtdis#',
			   '#jexc#',
			   '#headerselect.currency#',
			   '#debitdis#',
			   '#creditdis#',
			   '#bexc#',
			   '#debitbasedis#',
			   '#creditbasedis#',
			   '00',getDate())
			</cfquery>
		
		</cfif>
	
	</cfoutput>

</cfloop>

<cfinclude template="TransactionDetailLines.cfm">

<script>
	refselect();	
</script>

