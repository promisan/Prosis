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

<!--- use the parent association of the line to reconstruct for the same account --->

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#GLedgerCompress"> 

<cfquery name="Phase0" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT   H.Journal AS BaseJournal, 
		         H.JournalSerialNo AS BaseJournalSerialNo, 
		         H.Journal, 
		         H.JournalSerialNo, 
				 H.TransactionId,
		         H.JournalTransactionNo, 
				 L.TransactionLineId,
		         L.GLAccount, 
		         L.Currency AS Currency, 
		         L.AmountDebit AS AmountDebit, 
		         L.AmountCredit AS AmountCredit, 
		         L.AmountBaseDebit AS AmountBaseDebit, 
		         L.AmountBaseCredit AS AmountBaseCredit
		INTO     userQuery.dbo.#SESSION.acc#GLedgerCompress	 
		FROM     TransactionHeader H INNER JOIN
		         TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
		WHERE    L.GLAccount = '#URL.Account#'
		<cfif Category.recordcount eq "1">
		AND      H.Journal IN (SELECT Journal 
		                  FROM   Journal 
						  WHERE  GLCategory = '#URL.GLCategory#')
		</cfif>
		AND      H.Mission = '#URL.Mission#'
		<cfif url.currency neq "">
		AND  L.Currency = '#url.currency#'
		</cfif>
		<cfif url.find neq "">
		AND    (H.JournalTransactionNo LIKE '%#url.find#%'
		        OR J.JournalSerialNo LIKE '%#url.find#%')
		</cfif>
		<cfif DTE LTE now()>
	    AND  H.TransactionDate <= #dte#
	    </cfif>
		<cfif url.class eq "Debit">
		AND    L.AmountDebit > 0
		<cfelseif url.class eq "Credit">
		AND    L.AmountCredit > 0
		</cfif>
		<cfif URL.Period neq "All">
		     AND L.AccountPeriod = '#URL.Period#' 
		</cfif>
		 AND     L.ParentJournal IS NULL		 
</cfquery>		 

<cfloop index="itm" from="1" to="3" step="1">

		<cfquery name="Init" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
		INSERT INTO userQuery.dbo.#SESSION.acc#GLedgerCompress
			  (BaseJournal, 
			  BaseJournalSerialNo, 
			  Journal, 
			  JournalSerialNo, 
			  TransactionId, 
			  JournalTransactionNo, 
			  TransactionLineId,
			  GLAccount, 
			  Currency, 
			  AmountDebit, 
			  AmountCredit, 
			  AmountBaseDebit,
			  AmountBaseCredit)
		SELECT DISTINCT 
		       T.BaseJournal AS BaseJournal, 
			   T.BaseJournalSerialNo AS BaseJournalSerialNo, 
			   H.Journal, 
			   H.JournalSerialNo, 
			   H.TransactionId,
			   H.JournalTransactionNo, 
			   L.TransactionLineId,
		       L.GLAccount, 
			   L.Currency AS Currency, 
			   L.AmountDebit AS AmountDebit, 
			   L.AmountCredit AS AmountCredit, 
		       L.AmountBaseDebit AS AmountBaseDebit, 
			   L.AmountBaseCredit AS AmountBaseCredit
		FROM   TransactionHeader H INNER JOIN
		       TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
		       userQuery.dbo.#SESSION.acc#GLedgerCompress T ON L.ParentJournal = T.Journal AND L.ParentJournalSerialNo = T.JournalSerialNo
		WHERE  L.GLAccount = '#URL.Account#' 
		AND    H.Mission = '#URL.Mission#' 
		
		AND    (L.TransactionLineId NOT IN
		            (SELECT     TransactionLineId
		             FROM          userQuery.dbo.#SESSION.acc#GLedgerCompress))					 
		</cfquery>			 
					 
</cfloop>

<cfquery name="SearchResult" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT     A.Journal, 
		           A.JournalSerialNo, 
				   A.Description, 
				   A.JournalTransactionNo,
				   L.Currency, 
				   L.GLAccount AS GLAccount, 
				   SUM(L.AmountDebit) AS AmountDebit, 
				   SUM(L.AmountCredit) AS AmountCredit, 
				   SUM(L.AmountBaseDebit) AS AmountBaseDebit, 
				   SUM(L.AmountBaseCredit) AS AmountBaseCredit, 
				   A.TransactionDate, 
				   A.AccountPeriod,
				   A.Created
		FROM       userQuery.dbo.#SESSION.acc#GLedgerCompress L INNER JOIN
		           TransactionHeader A ON L.BaseJournal = A.Journal AND L.BaseJournalSerialNo = A.JournalSerialNo AND L.Currency = A.Currency
		
		GROUP BY A.Journal, A.JournalSerialNo, A.Description, A.JournalTransactionNo, L.Currency, L.GLAccount, A.TransactionDate, A.AccountPeriod, A.Created
</cfquery>
