
<!--- Hanno 8/7/2013 use the parent association of the line to reconstruct for the same account so we do not have
repeated debits and credits if not needed --->

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#GLedgerCompress"> 
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

<cfquery name="Phase0" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT   H.Journal AS BaseJournal, 
		         H.JournalSerialNo AS BaseJournalSerialNo, 
		         H.Journal, 
		         H.JournalSerialNo, 
				 H.TransactionId,
				 H.TransactionPeriod as HeaderTransactionPeriod,
		         H.JournalTransactionNo, 
				 H.TransactionReference,
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
		<!---
		<cfif url.currency neq "">
		AND  L.Currency = '#url.currency#'
		</cfif>
		--->
		<cfif url.find neq "">
			AND    (J.JournalTransactionNo LIKE '%#url.find#%' 
						OR J.JournalSerialNo LIKE '%#url.find#%'
						OR J.TransactionReference  LIKE '%#url.find#%'
						OR J.Description LIKE '%#url.find#%'
						OR J.ReferenceName LIKE '%#url.find#%' )

		</cfif>
		<cfif url.pap neq "">
		    <cfif GLaccount.accountclass eq "Result">
			 AND  L.TransactionPeriod = '#url.pap#'
			<cfelse>
			 AND  H.TransactionPeriod <= '#url.pap#'
			</cfif> 
	    </cfif>
		<cfif url.class eq "Debit">
		AND    L.AmountDebit > 0
		<cfelseif url.class eq "Credit">
		AND    L.AmountCredit > 0
		</cfif>
		<cfif URL.Period neq "All">
		AND    H.AccountPeriod = '#URL.Period#' 
		<cfelse>
		AND    J.Journal NOT IN (SELECT Journal FROM Journal WHERE SystemJournal = 'Opening')		
		</cfif>
		AND    L.ParentJournal IS NULL		 
		
		<!---RFUENTES 21/5/2015 adding: CC for the accounts that are Result Class  ---->
		<cfif url.costcenter neq "All">
		AND	   L.OrgUnit IN ('#URL.costcenter#')
		</cfif>

		<cfif url.owner neq "All">
		AND	   H.OrgUnitOwner IN ('#URL.owner#')			
		</cfif>

		<!--- RFUENTES 12/10/2015 added: to filter only valid transactions ----->
		AND H.RecordStatus   != '9'
		AND H.ActionStatus 	 != '9'

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
				HeaderTransactionPeriod,
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
			   H.TransactionPeriod,
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
		AND    H.Mission   = '#URL.Mission#' 
		
		AND    (L.TransactionLineId NOT IN
		            (SELECT   TransactionLineId
		             FROM     userQuery.dbo.#SESSION.acc#GLedgerCompress))					 
		</cfquery>			 
					 
</cfloop>

<!--- now we collapse --->

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
				   SUM(L.AmountDebit)      AS AmountDebit, 
				   SUM(L.AmountCredit)     AS AmountCredit, 
				   SUM(L.AmountBaseDebit)  AS AmountBaseDebit, 
				   SUM(L.AmountBaseCredit) AS AmountBaseCredit, 
				   A.TransactionDate, 
				   A.AccountPeriod,
				   A.TransactionPeriod as HeaderTransactionPeriod,
				   A.Created
		FROM       userQuery.dbo.#SESSION.acc#GLedgerCompress L INNER JOIN
		           TransactionHeader A ON L.BaseJournal = A.Journal AND L.BaseJournalSerialNo = A.JournalSerialNo AND L.Currency = A.Currency
		
		GROUP BY  A.Journal,
		          A.JournalSerialNo, 
				  A.Description, 
				  A.JournalTransactionNo, 
				  L.Currency, 
				  L.GLAccount, 
				  A.TransactionDate, 
				  A.AccountPeriod, 
				  A.TransactionPeriod,
				  A.Created
</cfquery>
