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
<cfparam name="URL.CostCenter" default="All">
<cfif URL.costcenter eq "undefined" or LEN(TRIM(URL.costcenter)) lte 0>
	<cfset URL.costcenter  = "All">
</cfif>

<cfif url.prepare neq "quick">
	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#GLedgerStandard">		
</cfif>	

<cftransaction isolation="READ_UNCOMMITTED">

<cfquery name="GLAccount"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_Account G
	WHERE  G.GLAccount = '#URL.Account#'
</cfquery>

<cfif url.prepare neq "quick">

	<!--- regenerate content if other than page selection changes --->

	<cfquery name="SearchResult"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
								
			    SELECT J.Journal,
				       J.JournalSerialNo,				      
					   J.TransactionId,				       
				       J.TransactionCategory, 
					   J.TransactionReference,
					   J.JournalTransactionNo,
					   J.Reference,
					   J.ReferenceName,
					   J.Description           as DescriptionHeader,
					   J.JournalTransactionNo  as JournalNo,
					   CONVERT(int, T.Created) as CreatedInt,
					   
					   <cfif GLaccount.accountclass eq "Result">
					   T.TransactionPeriod,
					   T.TransactionDate, 
					   <cfelse>
					   J.TransactionPeriod,
					   J.TransactionDate,
					   </cfif>
					   
					   J.DocumentDate,				   
					   
					   <!--- get the valid exchange rate on the transaction date --->
					   
					   <cfif application.BaseCurrency neq curr>
					   
					   (SELECT   TOP 1 ExchangeRate
					    FROM     CurrencyExchange
					    WHERE    Currency       = '#curr#'
						AND      EffectiveDate <=  <cfif GLaccount.accountclass eq "Result">T.TransactionDate<cfelse>J.TransactionDate</cfif>
						ORDER BY EffectiveDate DESC) as DateExchangeRate,
						
					   <cfelse>
					   
					   1 as DateExchangeRate,
					   
					   </cfif>					 				 
					   
					   T.GLAccount,
					   T.Memo,					   
					   T.Reference      as ReferenceLine,					  
					   
					   T.Currency,					   
					   T.AmountDebit, 
		               T.AmountCredit,		
			           T.AmountBaseDebit,
		               T.AmountBaseCredit,
					   J.Created					  
						
				INTO   userQuery.dbo.#SESSION.acc#GLedgerStandard
					   
				FROM   TransactionLine T INNER JOIN TransactionHeader J ON T.Journal = J.Journal and T.JournalSerialNo = J.JournalSerialNo
				
				WHERE  T.GLAccount = '#URL.Account#'
				
				AND    J.Mission = '#URL.Mission#'
				
				<cfif Category.recordcount eq "1">
				AND    J.Journal IN (SELECT Journal 
				                     FROM   Journal 
									 WHERE  Journal = J.Journal 
									 AND    JournalType = 'General' 
								     AND    GLCategory = '#URL.GLCategory#')
				</cfif>
				
				<!--- fiscal year --->
				<cfif URL.Period neq "All">
				AND    J.AccountPeriod = '#URL.Period#' 
				<cfelse>
				<!--- crossing fiscal years, then exclude the opening balance as it would double it --->
				AND    J.Journal NOT IN (SELECT Journal FROM Journal WHERE Journal = J.Journal AND SystemJournal = 'Opening')
				</cfif>
				
				<cfif url.find neq "">
					AND    (
					        J.JournalTransactionNo     LIKE '%#url.find#%' 
							OR J.JournalSerialNo       LIKE '%#url.find#%'
							OR J.TransactionReference  LIKE '%#url.find#%'
							OR J.Description           LIKE '%#url.find#%'
							OR J.Journal               LIKE '%#url.find#%'
							OR J.ReferenceName         LIKE '%#url.find#%'
						   ) 
				</cfif>
				
				<cfif url.class eq "Debit">
					AND  T.AmountDebit != 0
				<cfelseif url.class eq "Credit">
					AND  T.AmountCredit != 0
				</cfif>
				
				<cfif url.pap neq "">
				
			    	<cfif GLaccount.accountclass eq "Result">
					 AND  T.TransactionPeriod = '#url.pap#'
					<cfelse>
					 AND  J.TransactionPeriod = '#url.pap#'
					</cfif> 
					
		        </cfif>
							
				<!---RFUENTES 21/5/2015 adding: CC for the accounts that are Result Class  ---->
				<cfif url.costcenter neq "All" and url.costcenter neq "" and url.costcenter neq "undefined">
				AND	   T.OrgUnit IN ('#URL.costcenter#')			
				</cfif>
	
				<cfif url.owner neq "All" and url.owner neq "" and url.owner neq "undefined" and curPeriod.AdministrationLevel neq "Tree">
				AND	   J.OrgUnitOwner IN ('#URL.owner#')			
				</cfif>
				
				AND  J.RecordStatus    IN ( '1')
		   	    AND  J.ActionStatus    IN ('0','1')
																		
			</cfquery>
								
</cfif>		
										
<!--- now we pass --->

<cfif url.aggregate eq "0">


	<cfquery name="SearchResult" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT     *
			FROM       userQuery.dbo.#SESSION.acc#GLedgerStandard	
			<cfif URL.ID eq "Created">
				ORDER BY Created 
			<cfelseif URL.ID eq "DocumentDate">
				ORDER BY DocumentDate 
			<cfelseif URL.ID eq "JournalTransactionNo">
				ORDER BY JournalTransactionNo, ReferenceId
			<cfelseif URL.ID eq "TransactionPeriod">			
				ORDER BY TransactionPeriod, TransactionDate, Created
			<cfelse>
				ORDER BY #URL.ID# 
			</cfif>				
	</cfquery>		

<cfelse>
	
	<cfquery name="SearchResult" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT   Journal, 
			         TransactionCategory, 
					 Reference, 					 
					 #URL.ID#, 
					 <cfif URL.ID eq "Created">
					 CreatedInt, 
					 </cfif>
					 DateExchangeRate,
					 Currency,					   
					 SUM(AmountDebit)      as AmountDebit, 
		             SUM(AmountCredit)     as AmountCredit,		
			         SUM(AmountBaseDebit)  as AmountBaseDebit,
		             SUM(AmountBaseCredit) as AmountBaseCredit  
			
			
			FROM     userQuery.dbo.#SESSION.acc#GLedgerStandard	
			
			GROUP BY Journal, 
			   
			         TransactionCategory, 
					 Reference, 					 
					 #URL.ID#,
					 <cfif URL.ID eq "Created">
					 CreatedInt, 
					 </cfif> 
					 DateExchangeRate,
					 Currency 
			
			<cfif URL.ID eq "Created">
				ORDER BY CreatedInt 			
			<cfelse>
				ORDER BY #URL.ID# 
			</cfif>				
	</cfquery>		


</cfif>
		
</cftransaction>		