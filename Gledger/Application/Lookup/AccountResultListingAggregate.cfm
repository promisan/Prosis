

<cfparam name="URL.CostCenter" default="All">
<cfif URL.costcenter eq "undefined" or LEN(TRIM(URL.costcenter)) lte 0>
	<cfset URL.costcenter  = "All">
</cfif>

<cfif url.prepare neq "quick">
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#GLedgerAggregate">	
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

	<cfquery name="SearchResult"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
										
			    SELECT newid() as TransactionLineId,
				
				       <cfif GLaccount.accountclass eq "Result">
					   T.TransactionPeriod,
					   T.TransactionDate, 
					   T.TransactionDate as Created,
					   CONVERT(int, T.TransactionDate) AS CreatedInt,
					   <cfelse>
					   J.TransactionPeriod,
					   J.TransactionDate,
					   J.TransactionDate as Created,
					   CONVERT(int, J.TransactionDate) AS CreatedInt,
					   </cfif>
					 
				       J.TransactionCategory, 				   
					   J.Description as DescriptionHeader,
					   J.Journal,
					   J.JournalTransactionNo,				
					   J.Reference,					 
					   T.Currency, 
					   J.DocumentDate,
					  					  
					   ROUND(SUM(AmountDebit), 2) AS AmountDebit, 
					   ROUND(SUM(AmountCredit), 2) AS AmountCredit, 
	                   ROUND(SUM(AmountBaseDebit), 2) AS AmountBaseDebit, 
					   ROUND(SUM(AmountBaseCredit), 2) AS AmountBaseCredit,
					   				   
					   <!--- get the valid exchange rate on the transaction date --->
					   
					   <cfif application.BaseCurrency neq curr>
					   
					   (SELECT   TOP 1 ExchangeRate
					    FROM     CurrencyExchange
					    WHERE    Currency       = '#curr#'
						<cfif GLaccount.accountclass eq "Result">
						AND      EffectiveDate <= T.TransactionDate
						<cfelse>
						AND      EffectiveDate <= J.TransactionDate
						</cfif>
						ORDER BY EffectiveDate DESC) as DateExchangeRate
						
						<cfelse>
						
						1 as DateExchangeRate
						
						</cfif>
						
				INTO     userQuery.dbo.#SESSION.acc#GLedgerAggregate
					   
				FROM   TransactionLine T INNER JOIN TransactionHeader J ON T.Journal = J.Journal and T.JournalSerialNo = J.JournalSerialNo
				
				WHERE  T.GLAccount = '#URL.Account#'
				
				
				<cfif Category.recordcount eq "1">
				AND   J.Journal IN (SELECT Journal 
				                    FROM   Journal 
									WHERE  Journal = J.Journal
									AND    JournalType = 'General' 
								    AND    GLCategory = '#URL.GLCategory#')
				</cfif>
				
				<cfif URL.Period neq "All">
					AND  J.AccountPeriod = '#URL.Period#' 
				<cfelse>
					AND  J.Journal NOT IN (SELECT Journal FROM Journal WHERE Journal = J.Journal AND SystemJournal = 'Opening')
				</cfif>
				
				<cfif url.find neq "">
					AND    (J.JournalTransactionNo     LIKE '%#url.find#%' 
							OR J.JournalSerialNo       LIKE '%#url.find#%'
							OR J.TransactionReference  LIKE '%#url.find#%'
							OR J.Description           LIKE '%#url.find#%'
							OR J.Journal               LIKE '%#url.find#%'
							OR J.ReferenceName         LIKE '%#url.find#%' )
	 
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
							
				AND  J.Mission = '#URL.Mission#'
				
				<!---RFUENTES 21/5/2015 adding: CC for the accounts that are Result Class  ---->
				<cfif url.costcenter neq "All" and url.costcenter neq "" and url.costcenter neq "undefined">
				AND	   T.OrgUnit IN ('#URL.costcenter#')							
				</cfif>
				
								
				<cfif url.owner neq "All" and url.owner neq "" and url.owner neq "undefined" and curPeriod.AdministrationLevel neq "Tree">
				AND	   J.OrgUnitOwner IN ('#URL.owner#')					
				</cfif>
							
				
				
				<!--- RFUENTES 12/10/2015 added: to filter only valid transactions ----->
				AND J.RecordStatus    != '9'
				AND J.ActionStatus 	  != '9'
									
				GROUP BY J.Journal,
						 <cfif GLaccount.accountclass eq "Result">
				         T.TransactionPeriod, 
						 T.TransactionDate,
						 <cfelse>
						 J.TransactionPeriod, 
						 J.TransactionDate, 
						 </cfif>
						 J.TransactionCategory, 
						 J.Reference,
						 J.Description, 
						 J.JournalTransactionNo, 
						 J.DocumentDate, 
						 T.Currency		
																						
			</cfquery>
		
			
</cfif>			
					
<!--- now we pass --->

<cfif url.aggregate eq "0">
	
	<cfquery name="SearchResult" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT     *
			FROM       userQuery.dbo.#SESSION.acc#GLedgerAggregate	
			<cfif URL.ID eq "Created">
			ORDER BY CreatedInt, 
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
			
			FROM     userQuery.dbo.#SESSION.acc#GLedgerAggregate
			
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
		