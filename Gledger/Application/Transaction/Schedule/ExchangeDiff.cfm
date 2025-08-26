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

<cfquery name="Mission"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   Ref_ParameterMission
</cfquery>

<!--- -----------------------------------------------------------------------  --->
<!--- Accounts that are defined a monetary, its balance should be revaluated-  ---> 
<!--- if the debit <> credit in the journal currency transaction               --->
<!--- ------------------------------------------------------------------------ --->

<!--- example

Invoices received in QTZ are valued in USD for pending payment, its value needs
to be revaluated once the QTZ would change in value against the dollar

Invoice Booking QTZ 100 = 7.7 = 13 USD
then the exchange rate changes to 8.0 which means the value is to be corrected to 12.5 USD
by a transaction that lowers the balance on the monetary account only with 0.5

Applies only to transaction of journals that are not in base currency

--->

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Initialize">

<cfloop query="Mission">

	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Exchange">
	
	<!--- dev this is the proposed new code for defining the base to calculate exchange rate differences for a GLaccount, which correctly
	applies the balance to be revaluated in case a transactionaction is settled with a different currency as it was originally raised. 
	like invoice in Euro, but paid in dollars, contract in dollars but received in Euros
	--->

	<cfquery name="Transact"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT      Line.TransactionCurrency as Currency, <!--- this one is usually the same as currency but will be different in case of reconcile --->
		            Line.GLAccount, 					
					ROUND(SUM(Line.AmountDebit*Line.ExchangeRate) - SUM(Line.AmountCredit*Line.ExchangeRate),2) AS Amount,
					ROUND(SUM(Line.AmountBaseDebit) - SUM(Line.AmountBaseCredit),2) AS AmountBase,
					1.00 as ExchangeRate,
					ROUND(SUM(Line.AmountBaseDebit) - SUM(Line.AmountBaseCredit),2) AS AmountBaseNew
		INTO        userQuery.dbo.#SESSION.acc#Exchange		 			
		FROM        TransactionLine Line INNER JOIN
		            Ref_Account R ON Line.GLAccount = R.GLAccount INNER JOIN
		            TransactionHeader H ON Line.Journal = H.Journal AND Line.JournalSerialNo = H.JournalSerialNo
		WHERE       R.MonetaryAccount         = 1 
		<!--- added 8/1/2016 --->
		AND         R.RevaluationMode         = 1
		AND         R.AccountClass            = 'Balance' 
		AND         Line.TransactionCurrency != '#APPLICATION.BaseCurrency#' 
		AND         H.Mission                 = '#Mission.Mission#' 
		AND         H.Journal IN (SELECT Journal
		                          FROM   Journal 
								  WHERE  GLCategory = 'Actuals')
		AND         Line.AccountPeriod      = '#CurrentAccountPeriod#'
		
		GROUP BY    Line.TransactionCurrency, 
		            Line.GLAccount
					
		HAVING      ABS(ROUND(SUM(Line.AmountDebit*Line.ExchangeRate),2)- ROUND(SUM(Line.AmountCredit*Line.ExchangeRate),2)) > 0.10  
		            OR ABS(ROUND(SUM(Line.AmountBaseDebit) - SUM(Line.AmountBaseCredit),2)) > 0.10 
	</cfquery>	
	
	<!--- 6/10 change AND to OR in the HAVING with the advance example that Karin showed --->	
				
	<cfquery name="Transact"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       userQuery.dbo.#SESSION.acc#Exchange		 			
	</cfquery>
	
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "#Mission#: #Transact.recordcount# line(s)">
			
	<cfif Transact.currency neq "">
			
		<cfloop query="transact">
		
				<!--- today's exchange rate --->	
				
				<cfquery name="Exchange" 
				     datasource="AppsLedger" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     SELECT    TOP 1 *
					     FROM      CurrencyExchange
					     WHERE     Currency = '#Currency#'
					     AND       EffectiveDate <= getDate()
					     ORDER BY  EffectiveDate DESC
				</cfquery>
				
				<cfif Exchange.recordcount gte "1" and Exchange.ExchangeRate gt "0">
				
					<cfquery name="Update" 
					     datasource="AppsQuery" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						     UPDATE #SESSION.acc#Exchange	
							 SET     ExchangeRate   =  '#Exchange.ExchangeRate#',
							         AmountBaseNew  =  ROUND(Amount/#Exchange.ExchangeRate#,2)
							 WHERE   Currency       =  '#Currency#'
							 AND     GLAccount      =  '#GLAccount#'
					</cfquery>
				
				</cfif>
							
		 </cfloop>	
		 
		 <cfquery name="Header" 
		     datasource="AppsQuery" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     SELECT ROUND(SUM(AmountBaseNew)-SUM(AmountBase),2) as Amount
				 FROM  #SESSION.acc#Exchange	
		</cfquery>	
			
		<cfif Header.recordcount eq "1" and abs(Header.Amount) gte "0.1">
		
				<cftransaction>
		
				 	<cfquery name="Journal"
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   Journal
							WHERE  Mission       = '#Mission#' 
							AND    SystemJournal = 'ExchangeRate'
					</cfquery>			
					
					<cf_GledgerEntryHeader
					    Mission               = "#Mission#"
					    OrgUnitOwner          = "0"
					    Journal               = "#Journal.Journal#"
						JournalTransactionNo  = "Exchange Rate"
						Description           = "Revaluation #DateFormat(now(),CLIENT.DateFormatShow)#"
						TransactionSource     = "ExchangeRate"
						AccountPeriod         = "#CurrentAccountPeriod#"
						TransactionCategory   = "Memorial"
						MatchingRequired      = "0"
						DocumentCurrency      = "#Journal.Currency#"
						DocumentDate          = "#DateFormat(now(),CLIENT.DateFormatShow)#"
						DocumentAmount        = "#Header.Amount#">		
						
						<!--- contra-line --->
						
						<cfquery name="Account"
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   Ref_AccountMission
							WHERE  Mission = '#Mission#'
							AND    SystemAccount = 'ExchangeDifference'
						</cfquery>	
																
						<cfif Account.recordcount eq "0">
						
							<cf_ScheduleLogInsert
								Datasource     = "AppsLedger" 
							   	ScheduleRunId  = "#schedulelogid#"
								StepStatus     = "9"
								StepException  = "Invalid [ExchangeDifference] account for #Mission#"
								Description    = "Exchange Difference Ledger Account">												
						
						</cfif>							
						
						<!--- capital transaction --->
									    
						<cfif Header.Amount gt 0>
						    <cfset class = "credit">
							<cfset amt = Header.Amount>
						<cfelse>
						    <cfset class = "debit">
							<cfset amt = Header.Amount*-1>							
						</cfif>
						
						<!--- lines --->
									
						<cfquery name="DebitLines"
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO TransactionLine
								 (Journal, 
								  JournalSerialNo, 
								  GLAccount, 
								  Memo,
								  JournalTransactionNo,
								  TransactionSerialNo, 
								  AccountPeriod, 
								  TransactionDate, 
								  TransactionPeriod,
								  TransactionType, 
								  TransactionCurrency,
								  Currency,
								  AmountDebit,
								  AmountCredit,
						          AmountBaseDebit,AmountBaseCredit,
								  OfficerUserId,
								  OfficerLastName,
								  OfficerFirstName)
							VALUES
								('#Journal.Journal#',
								 '#JournalTransactionNo#',
								 '#Account.GLAccount#', 
								 'Revaluation #DateFormat(now(),CLIENT.DateFormatShow)#',
								 '#Journal.Journal#-#JournalTransactionNo#',
								 '0',
								 '#CurrentAccountPeriod#',
								 '#DateFormat(now(),CLIENT.DateSQL)#',
								 <cfif month(now()) lt 10>
								 '#year(now())#0#month(now())#',
								 <cfelse>
								 '#year(now())##month(now())#',
								 </cfif>								 
								 'Revaluation',
								 '#Journal.Currency#',
								 '#Journal.Currency#',
								 0,0,
								 <cfif class eq "Debit">
								 #amt#,0,
								 <cfelse>
								 0,#amt#,
								 </cfif>
								 '#SESSION.acc#',
								 '#SESSION.last#',
								 '#SESSION.first#')							
						</cfquery>							
						
						<!--- lines, first the debit lines --->
										
						<cfquery name="DebitLines"
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO TransactionLine
								 (Journal, 
								  JournalSerialNo, 
								  GLAccount, 
								  Memo,
								  JournalTransactionNo,
								  TransactionSerialNo, 
								  AccountPeriod, 
								  TransactionDate, 
								  TransactionPeriod,
								  TransactionType, 
								  TransactionCurrency,								  
								  Currency,
								  AmountDebit,
								  AmountCredit,
						          AmountBaseDebit,
								  AmountBaseCredit,
								  OfficerUserId,
								  OfficerLastName,
								  OfficerFirstName)
							SELECT '#Journal.Journal#',
								   '#JournalTransactionNo#',
								   GLAccount,
								   'Revaluation #DateFormat(now(),CLIENT.DateFormatShow)#',
								   '#Journal.Journal#-#JournalTransactionNo#',
								   '1',
								   '#CurrentAccountPeriod#',
								   '#DateFormat(now(),CLIENT.DateSQL)#',
								   <cfif month(now()) lt 10>
								   '#year(now())#0#month(now())#',
								   <cfelse>
								   '#year(now())##month(now())#',
								   </cfif>
								   'Revaluation',
								   Currency, 
								   Currency, 
								   0,0,
					   	           round(AmountBaseNew-AmountBase,2),
								   0,
								   '#SESSION.acc#',
								   '#SESSION.last#',
								   '#SESSION.first#'
						    FROM userQuery.dbo.#SESSION.acc#Exchange
							WHERE AmountBaseNew > AmountBase				
						</cfquery>						
						
						<!--- then the credit lines --->	
						
						<cfquery name="CreditLines"
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO TransactionLine
								 (Journal, 
								  JournalSerialNo, 
								  GLAccount, 
								  Memo,
								  JournalTransactionNo,
								  TransactionSerialNo, 
								  AccountPeriod, 
								  TransactionDate, 
								  TransactionType, 
								  TransactionCurrency,
								  Currency,
								  AmountDebit,
								  AmountCredit,
								  AmountBaseDebit,
						          AmountBaseCredit,
								  OfficerUserId,
								  OfficerLastName,
								  OfficerFirstName)
						SELECT   '#Journal.Journal#',
							     '#JournalTransactionNo#',
							     GLAccount,
							     'Revaluation',
							     '#Journal.Journal#-#JournalTransactionNo#',
							     '1',
							     '#CurrentAccountPeriod#',
							     '#DateFormat(now(),CLIENT.DateSQL)#',
							     'Revaluation',
								 Currency,
							     Currency, 
							     '0',
								 '0',
							     '0',
				   	             round(AmountBase-AmountBaseNew,2),
							     '#SESSION.acc#','#SESSION.last#','#SESSION.first#'
					    FROM     userQuery.dbo.#SESSION.acc#Exchange
						WHERE    AmountBaseNew < AmountBase				
						</cfquery>	
					
				</cftransaction>				
		
		</cfif>
			
	</cfif>
		 
</cfloop>

