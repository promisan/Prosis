
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#GLedgerAggregate">

<cfparam name="URL.CostCenter" default="All">
<cfif URL.costcenter eq "undefined" or LEN(TRIM(URL.costcenter)) lte 0>
	<cfset URL.costcenter  = "All">
</cfif>


<cfquery name="GLAccount"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_Account G
	WHERE  G.GLAccount = '#URL.Account#'
</cfquery>

<cfquery name="SearchResult"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				
		    SELECT newid() as TransactionLineId,
			       J.TransactionPeriod as TransactionPeriod,
			       J.TransactionCategory, 				   
				   J.Description as DescriptionHeader,
				   J.Journal,
				   J.JournalTransactionNo,				    
				   T.Currency, 
				   J.DocumentDate,
				   T.TransactionDate, 
				   T.TransactionDate as Created,
				   ROUND(SUM(AmountDebit), 2) AS AmountDebit, 
				   ROUND(SUM(AmountCredit), 2) AS AmountCredit, 
                   ROUND(SUM(AmountBaseDebit), 2) AS AmountBaseDebit, 
				   ROUND(SUM(AmountBaseCredit), 2) AS AmountBaseCredit,
				   				   
				   <!--- get the valid exchange rate on the transaction date --->
				   
				   (SELECT   TOP 1 ExchangeRate
				    FROM     CurrencyExchange
				    WHERE    Currency       = '#curr#'
					AND      EffectiveDate <= T.TransactionDate
					ORDER BY EffectiveDate DESC) as DateExchangeRate
					
			INTO     userQuery.dbo.#SESSION.acc#GLedgerAggregate
				   
			FROM   TransactionLine T INNER JOIN TransactionHeader J ON T.Journal = J.Journal and T.JournalSerialNo = J.JournalSerialNo
			
			WHERE  T.GLAccount = '#URL.Account#'
			
			
			<cfif Category.recordcount eq "1">
			AND   J.Journal IN (SELECT Journal 
			                    FROM   Journal 
							    WHERE  GLCategory = '#URL.GLCategory#')
			</cfif>
			
			<cfif URL.Period neq "All">
				AND  T.AccountPeriod = '#URL.Period#' 
			<cfelse>
				AND  J.Journal NOT IN (SELECT Journal FROM Journal WHERE SystemJournal = 'Opening')
			</cfif>
			
			<cfif url.find neq "">
				AND    (J.JournalTransactionNo LIKE '%#url.find#%' 
						OR J.JournalSerialNo LIKE '%#url.find#%'
						OR J.TransactionReference  LIKE '%#url.find#%'
						OR J.Description LIKE '%#url.find#%'
						OR J.ReferenceName LIKE '%#url.find#%' )
 
			</cfif>
			
			<cfif url.class eq "Debit">
				AND  T.AmountDebit != 0
			<cfelseif url.class eq "Credit">
				AND  T.AmountCredit != 0
			</cfif>
			
			<cfif url.pap neq "">
			
		    	<cfif GLaccount.accountclass eq "Result">
				 AND  J.TransactionPeriod = '#url.pap#'
				<cfelse>
				 AND  J.TransactionPeriod <= '#url.pap#'
				</cfif> 
				
	        </cfif>
						
			AND  J.Mission = '#URL.Mission#'
			
			<!---RFUENTES 21/5/2015 adding: CC for the accounts that are Result Class  ---->
			<cfif url.costcenter neq "All">
			AND	   T.OrgUnit IN ('#URL.costcenter#')			
			</cfif>

			<cfif url.owner neq "All">
			AND	   J.OrgUnitOwner IN ('#URL.owner#')			
			</cfif>
			
			<!--- RFUENTES 12/10/2015 added: to filter only valid transactions ----->
			AND J.RecordStatus    != '9'
			AND J.ActionStatus 	  != '9'
								
			GROUP BY J.Journal,J.TransactionPeriod, J.TransactionCategory, J.Description, J.JournalTransactionNo, J.DocumentDate, T.Currency, T.TransactionDate 
			ORDER BY T.TransactionDate
						
			
		</cfquery>
		
		
		
<!--- now we pass --->

<cfquery name="SearchResult" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT     *
		FROM       userQuery.dbo.#SESSION.acc#GLedgerAggregate	
		ORDER BY   TransactionDate	
</cfquery>
		