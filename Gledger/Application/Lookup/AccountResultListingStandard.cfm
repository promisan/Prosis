<cfparam name="URL.CostCenter" default="All">
<cfif URL.costcenter eq "undefined" or LEN(TRIM(URL.costcenter)) lte 0>
	<cfset URL.costcenter  = "All">
</cfif>

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#GLedgerStandard">

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
				
		    SELECT 
			       T.*, 
				   J.TransactionId,
			       J.TransactionPeriod as HeaderTransactionPeriod,
			       J.TransactionCategory, 
				   J.TransactionReference,
				   J.Description as DescriptionHeader,
				   J.JournalTransactionNo as JournalNo,
				   CONVERT(int, T.Created) AS CreatedInt,
				   J.DocumentDate,
				   
				   <!--- get the valid exchange rate on the transaction date --->
				   
				   (SELECT   TOP 1 ExchangeRate
				    FROM     CurrencyExchange
				    WHERE    Currency       = '#curr#'
					AND      EffectiveDate <= T.TransactionDate
					ORDER BY EffectiveDate DESC) as DateExchangeRate
					
			INTO  userQuery.dbo.#SESSION.acc#GLedgerStandard
				   
			FROM   TransactionLine T INNER JOIN TransactionHeader J ON T.Journal = J.Journal and T.JournalSerialNo = J.JournalSerialNo
			
			WHERE  T.GLAccount = '#URL.Account#'
			
			<cfif Category.recordcount eq "1">
			AND    J.Journal IN (SELECT Journal 
			                     FROM   Journal 
							     WHERE  GLCategory = '#URL.GLCategory#')
			</cfif>
			
			<cfif URL.Period neq "All">
			AND    J.AccountPeriod = '#URL.Period#' 
			<cfelse>
			AND    J.Journal NOT IN (SELECT Journal FROM Journal WHERE SystemJournal = 'Opening')
			</cfif>
			
			<cfif url.find neq "">
				AND    (
				        J.JournalTransactionNo LIKE '%#url.find#%' 
						OR J.JournalSerialNo LIKE '%#url.find#%'
						OR J.TransactionReference  LIKE '%#url.find#%'
						OR J.Description LIKE '%#url.find#%'
						OR J.Journal LIKE '%#url.find#%'
						OR J.ReferenceName LIKE '%#url.find#%'
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
			
			AND  J.RecordStatus    IN ( '1')
	   	    AND  J.ActionStatus    IN ('0','1')
			
			<cfif URL.ID eq "Created">
			ORDER BY T.Created 
			<cfelseif URL.ID eq "DocumentDate">
			ORDER BY J.DocumentDate 
			<cfelseif URL.ID eq "JournalTransactionNo">
			ORDER BY J.JournalTransactionNo, T.ReferenceId
			<cfelseif URL.ID eq "TransactionPeriod">
			ORDER BY J.TransactionPeriod, J.TransactionDate
			<cfelse>
			ORDER BY T.#URL.ID#, J.TransactionDate 
			</cfif>	
			
						
		</cfquery>
						
<!--- now we pass --->

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
			ORDER BY HeaderTransactionPeriod, TransactionDate
		<cfelse>
			ORDER BY #URL.ID# 
		</cfif>				
</cfquery>		
		
		