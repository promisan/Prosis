

<cfquery name="get"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT        TransactionLineid, Journal, JournalSerialNo, TransactionSerialNo, GLAccount, TransactionCurrency, TransactionAmount, TransactionTaxCode, ExchangeRate, Currency, 
                         AmountDebit, AmountCredit, ExchangeRateBase, AmountBaseDebit, AmountBaseCredit, ParentJournal, ParentJournalSerialNo, ParentTransactionId, 
                         TransactionCheckId, OfficerUserId, OfficerLastName, OfficerFirstName, Created
		FROM            TransactionLine
		WHERE        (Journal = '40004') and JournalSerialNo < 60
		ORDER BY JournalSerialNo, TransactionSerialNo
	</cfquery>
	
	<cfloop query="get">
	
	<cfif GLAccount eq "10603">
	
		<cfquery name="set"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE    TransactionLine
			SET    AmountDebit      = 0, 
			       AmountCredit     = '#amountDebit#', 
				   AmountBaseDebit  = '0', 
				   AmountBaseCredit = '#amountDebit#'
			WHERE  TransactionLineId = '#TransactionLineId#'		
		</cfquery>
	
	<cfelse>
	
	<cfquery name="set"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE    TransactionLine
			SET    AmountCredit      = 0, 
			       AmountDebit     = '#amountCredit#', 
				   AmountBaseCredit  = '0', 
				   AmountBaseDebit = '#amountCredit#'
			WHERE  TransactionLineId = '#TransactionLineId#'		
		</cfquery>
	
	</cfif>
	
	
	</cfloop>