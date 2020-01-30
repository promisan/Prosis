
<cfparam name="FORM.recordno" default="0">
<cfparam name="FORM.selected" default="">
<cfparam name="URL.mode"      default="AR">

<cfquery name="HeaderSelect"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT * 
	FROM #SESSION.acc#GledgerHeader_#client.sessionNo#
</cfquery>

<cfquery name="Prior" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Max(TransactionSerialNo) as Last
	FROM #SESSION.acc#GLedgerLine_#client.sessionNo#
	</cfquery>
	
	<cfset SerNo = 0>
	
	<cfoutput query = "Prior">
	  <cfif Last neq "">
	     <cfset SerNo = Last>
	  </cfif>	 
	</cfoutput>
		
<cfloop index="itm" list="#Form.selected#" delimiters=",">

	<!--- Select select reconciliation lines --->
	<cfquery name="SearchResult"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT   P.*, 
	           H.TransactionId as TransactionIdHeader, 
			   H.Description
	  FROM     TransactionLine P, TransactionHeader H
	  WHERE    P.Journal = H.Journal
	  AND      P.JournalSerialNo = H.JournalSerialNo
	  AND      P.GLAccount IN  (SELECT   GLAccount
	                            FROM   Ref_Account
	                            WHERE  BankReconciliation = 1)
		<!--- 						
	    AND    P.Currency = '#HeaderSelect.Currency#' 							 
		--->
		<!---
	    AND    P.ParentLineId IS NULL 
		--->
		AND    P.TransactionLineId = '#preserveSingleQuotes(itm)#' 
	</cfquery>	
	
				
	<cfoutput query="SearchResult">
			  		 
		<cfset serNo = serNo + 1> 
		
		<!--- 5/1/2008 : define current exchange rate in order to be consistent
		I decided to take the exchange rate as used in the underlying transaction
		--->
		
		<cfset insert = 1>
		
		
		<cfset fld = left(TransactionLineId,8)>				
				
		<cfparam name="Form.val_#fld#" 
		    default="#amountdebit#">
		<cfparam name="Form.cur_#fld#" 
		    default="#TransactionCurrency#">	
		<cfparam name="Form.off_#fld#" 
		    default="#amountdebit#">
		<cfparam name="Form.exc_#fld#" 
		    default="1">		
			
		<cfset tracur = evaluate("Form.cur_#fld#")>	
		<cfset tracur  = replace(tracur,' ','',"ALL")>
		<cfset tracur  = replace(tracur,',','',"ALL")>
		
		<!--- the values are presented and entered by the user in the currency of the journal with an exchange to the transaction
		amount of the underlying transaction --->
		
		<cf_exchangeRate CurrencyFrom="#HeaderSelect.Currency#" CurrencyTo="#APPLICATION.BaseCurrency#">				
		<cfset exch = exc>		
		
		<cf_exchangeRate CurrencyFrom="#tracur#" CurrencyTo="#APPLICATION.BaseCurrency#">		
		<cfset bseexc = exc>
		
		<cfoutput>
			<cfsilent>
				<cf_logpoint filename="exchange.txt" mode="append">
					currency from: #HeaderSelect.Currency#
					currency to : #APPLICATION.BaseCurrency#
					exch:#exch# 
					
					
					CurrencyFrom : #tracur# 
					CurrencyTo : #APPLICATION.BaseCurrency#
					bseexc:#bseexc#
					
				</cf_logpoint>	
			</cfsilent>
		</cfoutput>	
		
		
		<cfset traamt = evaluate("Form.off_#fld#")>	
		<cfset traamt  = replace(traamt,',','',"ALL")>
		<cfset traamt  = replace(traamt,' ','',"ALL")>
		
		<cfset traexc = evaluate("Form.exc_#fld#")>	
		<cfset traexc  = replace(traexc,' ','',"ALL")>
		<cfset traexc  = replace(traexc,',','',"ALL")>
				
		<cfif amountdebit gt 0>		
					
			<cfparam name="Form.val_#fld#" default="#amountdebit#">		
			<cfset deb        = evaluate("Form.val_#fld#")>
			<cfset deb        = replace(deb,',','',"ALL")>
			<cfset deb        = replace(deb,' ','',"ALL")>
			<cfset crd        = 0>
			<cfif LSIsNumeric(deb)>
				<cfset debitbase  = deb/exch>
				<cfset creditbase = 0>
			<cfelse>					
			     <cfset insert = 0>				
			</cfif>
			<cfset amt        = deb>
		
		<cfelse>
							
			<cfparam name="Form.val_#fld#" default="#amountcredit#">		
			<cfset deb = 0>
			<cfset crd = evaluate("Form.val_#fld#")>
			<cfset crd        = replace(crd,',','',"ALL")>
			<cfset crd        = replace(crd,' ','',"ALL")>
			<cfif LSIsNumeric(crd)>
				<cfset debitbase  = 0>
				<cfset creditbase = crd/exch>
			<cfelse>						
			    <cfset insert = 0>				
			</cfif>	
			<cfset amt        = crd>
		
		</cfif>
						
		<cfif insert eq "1">  <!--- check if amount is valid amount --->
						
			<cfif transactionType is "Contra-Account">
			  <cfif len(description) gt 100> 
				  <cfset des = left(Description,100)>
			  <cfelse>
			      <cfset des = Description>
			  </cfif>	  
			<cfelse>
			  <cfset des = Reference>  
			</cfif>
			
			<!--- Hanno : added provision to prevent incorrect posting 6/11/2016 --->
			
			<cfif crd eq 0>
				<cfset creditbase = 0>
			<cfelse>
				<cfset debitbase  = 0>	
			</cfif>
				
			<cfquery name="Insert" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			INSERT INTO dbo.#SESSION.acc#GLedgerLine_#client.sessionNo#
			   (Journal, 
			   JournalSerialNo,  
			   TransactionSerialNo, 
			   TransactionLineId,
			   ParentLineId,
			   ReconciliationPointer,
			   TransactionDate,
			   GLAccount,
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
			   AmountCredit,
			   AmountDebit,
			   ExchangeRateBase,
			   AmountBaseCredit,
			   AmountBaseDebit,
			   TransactionTaxCode,
			   Created)
			VALUES 
			   ('#URL.Journal#',
			   '#serNo#',
			   '#serNo#',
			   newid(),
			   '#TransactionLineId#',
			   '0',
			   getDate(),
			   '#glaccount#',
			   '#memo#',
			   '#URL.AccountPeriod#',
			   '#TransactionType#',
			   '#des#',
			   '#referencename#',
			   '#referenceno#',	   			  
			   '#Journal#', 
			   '#JournalSerialNo#',  
			   '#TransactionIdHeader#', 
			   '#tracur#',
			   '#traamt#',
			   
			   '#traexc#',
			   '#HeaderSelect.Currency#',
			   '#deb#',
			   '#crd#',
			   
			   '#bseexc#',
			   '#debitbase#',
			   '#creditbase#',			   
			   '00',
			   getDate())
			</cfquery>
		
			<!--- correction if lines comes from the existing transaction (edit) --->
			
			<cfif Journal eq HeaderSelect.Journal and
			      JournalSerialNo  eq HeaderSelect.JournalSerialNo>
				  
				<cfquery name="Update" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE dbo.#SESSION.acc#GLedgerLine_#client.sessionNo#
					SET    ParentLineId = '#ParentLineId#'
					WHERE  JournalSerialNo = '#SerNo#'
				</cfquery>
			
			</cfif>
			
		</cfif>	
				
	</cfoutput>
	
</cfloop>	

<cfinclude template="TransactionDetailLines.cfm">

<script>
	refselect();	
</script>


