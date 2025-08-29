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
					   A.Created,
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

	<!---
	<cfparam name="ids" default="">
	<cfset ids = Session["rowsSelected_#url.account#"]>
	--->
	
				
	<cfquery name="SearchResult"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT   *
			INTO     userQuery.dbo.vwListingGLAccount#SESSION.acc#			   
			FROM     userQuery.dbo.#SESSION.acc#GLedgerStandard						
			ORDER BY TransactionDate
			
	</cfquery>	

</cfif>			
		
<cfset client.table1   = "vwListingGLAccount#SESSION.acc#">		