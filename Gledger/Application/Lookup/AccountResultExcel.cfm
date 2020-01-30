
<CF_DropTable dbName="AppsQuery" tblName="vwListingGLAccount#SESSION.acc#">

<cfif url.id eq "Transaction">

	<cfquery name="SearchResult" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT     A.Journal, 
			           A.JournalSerialNo, 
					   A.Description, 
					   A.JournalTransactionNo,
					   L.Currency, 
					   A.TransactionDate, 
					   A.AccountPeriod,
					   A.Created
					   L.GLAccount AS GLAccount, 					   
					   SUM(L.AmountDebit) AS AmountDebit, 
					   SUM(L.AmountCredit) AS AmountCredit, 
					   SUM(L.AmountBaseDebit) AS AmountBaseDebit, 
					   SUM(L.AmountBaseCredit) AS AmountBaseCredit					  
			INTO       userQuery.dbo.vwListingGLAccount#SESSION.acc#		   
			FROM       userQuery.dbo.#SESSION.acc#GLedgerCompress L INNER JOIN
			           TransactionHeader A ON L.BaseJournal = A.Journal AND L.BaseJournalSerialNo = A.JournalSerialNo AND L.Currency = A.Currency			
			GROUP BY A.Journal, A.JournalSerialNo, A.Description, A.JournalTransactionNo, L.Currency, L.GLAccount, A.TransactionDate, A.AccountPeriod, A.Created
	</cfquery>
		 
<cfelseif url.id eq "JournalTransactionNo">
	
	<cfquery name="SearchResult" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT     *
			INTO       userQuery.dbo.vwListingGLAccount#SESSION.acc#
			FROM       userQuery.dbo.#SESSION.acc#GLedgerAggregate	
			ORDER BY   TransactionDate				
	</cfquery>
	
<cfelse>

	<cfparam name="url.account" default="">

	<cfparam name="ids" default="">
	<cfset ids = Session["rowsSelected_#url.account#"]>
	
	<cfquery name="SearchResult"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT T.Journal, 
				       T.JournalSerialNo, 
					   T.TransactionSerialNo, 
					   T.GLAccount, 
					   T.JournalTransactionNo, 
					   T.Memo, 
					   T.Fund, 
					   T.ProgramCode, 
					   T.ProgramPeriod, 
		               T.ObjectCode, 
					   T.AccountPeriod, 
					   T.TransactionDate,
					   
					   <!--- header --->
					   J.TransactionPeriod,
					   
					   T.TransactionType, 
					   T.Reference, 
					   T.ReferenceName, 
					   T.ReferenceNo, 
					   T.Warehouse, T.WarehouseItemNo, T.WarehouseItemUoM, T.WarehouseQuantity, 
					   T.TransactionCurrency, 
					   T.TransactionAmount, 
					   T.TransactionTaxCode, 
		               T.ExchangeRate,
					   T.AmountDebit, 
					   T.AmountCredit, 
					   T.ExchangeRateBase, 
					   T.AmountBaseDebit, 
					   T.AmountBaseCredit,
					   T.OfficerUserId, 
		               T.OfficerLastName, 
					   T.OfficerFirstName,
				       J.TransactionCategory, 
					   J.Description as DescriptionHeader,
					   J.ReferenceId			   
				INTO   userQuery.dbo.vwListingGLAccount#SESSION.acc#			   
				FROM   TransactionLine T INNER JOIN TransactionHeader J ON T.Journal = J.Journal and T.JournalSerialNo = J.JournalSerialNo
				WHERE  T.GLAccount = '#URL.Account#'		
				<cfif ids eq "">
				AND 1=0
				<cfelse>
				AND  T.TransactionLineId IN (#preservesinglequotes(ids)#)				
				</cfif>
				ORDER BY T.Created
	</cfquery>
	

</cfif>			
		
<cfset client.table1   = "vwListingGLAccount#SESSION.acc#">		



