
<cfparam name="url.mission" default="">
<cfparam name="url.account" default="">

<cfquery name="Last"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     TransactionHeader
	WHERE    Mission = '#url.mission#'
	AND      Journal IN (SELECT Journal FROM Journal WHERE SystemJournal = 'Opening')
	ORDER BY AccountPeriod DESC
</cfquery>

<!---

<cftransaction isolation="READ_UNCOMMITTED">

<cfquery name="Accounts"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT     R.GLAccount, 
			   R.Description,		
			   <!---
			   L.Currency,
			   --->
			   SUM(AmountDebit-AmountCredit) as Amount,	   			   
			   SUM(AmountBaseDebit-AmountBaseCredit) as AmountBase
			   
	FROM       TransactionLine L INNER JOIN
			   Ref_Account R ON L.GLAccount = R.GLAccount INNER JOIN
			   TransactionHeader H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo INNER JOIN 
			   Journal J ON J.Journal = H.Journal
						   
	WHERE      H.Mission       = '#url.mission#' 
		
	AND        H.ActionStatus IN ('0','1')
	AND        H.RecordStatus != '9'
		
	AND        R.Operational        = 1
		
	<cfif url.mode eq "AR">  
	AND        R.AccountClass       = 'Balance'
	AND        R.AccountType        = 'Debit'   
	AND        (R.BankReconciliation = 1 OR R.AccountCategory = 'Vendor')
	<cfelse>	
	AND        R.AccountClass       = 'Balance'
	AND        R.AccountType        = 'Credit' 
	AND        R.AccountCategory    = 'Customer'
	</cfif>	
	
	AND        J.GLCategory = 'Actuals'	

	AND        H.AccountPeriod = '#Last.AccountPeriod#'
		
	GROUP BY   R.GLAccount, 
	           R.Description
			   <!--- ,
			   L.Currency --->
			   
	ORDER BY   R.GLAccount		
			 		   
</cfquery>		

<cfoutput>#cfquery.executiontime#</cfoutput>

</cftransaction>

<cfset selaccount = quotedvalueList(Accounts.GLAccount)> 

--->

<cfoutput>

<cfsavecontent variable="myquery">

	SELECT * 
	
	FROM (

		SELECT H.Journal, 
		       J.Description, 
			   TransactionSource, 
			   AccountPeriod, 
			   TransactionPeriod, 
			   SUM(D.Amount) as AmountBase
			   
		FROM TransactionHeader H, 
		
		
		          (SELECT    CASE WHEN L.ParentJournal IS NULL THEN L.Journal ELSE L.ParentJournal END AS Journal, 
				             CASE WHEN L.ParentJournalSerialNo IS NULL THEN L.JournalSerialNo ELSE L.ParentJournalSerialNo END AS JournalSerialNo,
							  
							 ROUND(SUM(L.AmountBaseDebit - L.AmountBaseCredit), 2) AS Amount

                   FROM      TransactionLine AS L INNER JOIN
                             TransactionHeader AS H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo
                   WHERE     L.GLAccount = '#url.account#' 
				   AND       H.Mission   = '#url.mission#'
				   AND       H.ActionStatus IN ('0', '1') 
				   AND       H.RecordStatus <> '9'
				   
				   AND       H.AccountPeriod <= '#last.AccountPeriod#'	
				   
				   <!--- ignore opening balances --->
				   AND       H.Journal NOT IN (SELECT Journal
				                               FROM   Journal WHERE  Mission = '#url.mission#' AND SystemJournal = 'Opening')
											   
                   GROUP BY  CASE WHEN L.ParentJournal IS NULL THEN L.Journal ELSE L.ParentJournal END, 
				             CASE WHEN L.ParentJournalSerialNo IS NULL THEN L.JournalSerialNo ELSE L.ParentJournalSerialNo END
															
					)	AS D, 
					
					Journal J
		
		WHERE D.Journal = H.Journal 
		AND   D.JournalSerialNo = H.JournalSerialNo 
		AND   D.Amount <> 0 
		AND   H.Journal = J.Journal
		
		GROUP BY H.Journal, 
		         J.Description, 
				 TransactionSource, 
				 TransactionPeriod, 
				 AccountPeriod
				 
				 ) as T
				 
		WHERE 1=1		 
		 -- condition		
		 	 
		    		
</cfsavecontent>

<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cfset itm = itm+1>	
<cf_tl id="Fiscal" var="vFiscal">			
<cfset fields[itm] = {label      = "#vFiscal#", 					
					field        = "AccountPeriod",					
					search       = "text",					
					filtermode   = "2"}>		
					
<cfset itm = itm+1>	
<cf_tl id="Period" var="vPeriod">			
<cfset fields[itm] = {label      = "#vPeriod#", 					
					field        = "TransactionPeriod",					
					search       = "text",					
					filtermode   = "2"}>		

<cfset itm = itm+1>	
<cf_tl id="Journal" var="vJournal">
<cfset fields[itm] = {label      = "#vJournal#",                  
					field        = "Journal",
					display      = "0",
					search       = "text",
					filtermode   = "2"}>
					
<cf_tl id="Name" var="vName">
<cfset fields[itm] = {label      = "#vJournal#",                  
					field        = "Description",
					search       = "text",
					filtermode   = "2"}>					

<cfset itm = itm+1>				
<cf_tl id="Source" var="vSource">		
<cfset fields[itm] = {label      = "#vSource#", 					
					field        = "TransactionSource",
					column       = "common",  
					search       = "text",
					filtermode   = "2"}>										
					
<cfset itm = itm+1>							
<cf_tl id="Amount" var="vAmount">		
<cfset fields[itm] = {label      = "#vAmount#", 					
					field        = "AmountBase",
					align        = "right",
					aggregate    = "sum", 
					formatted    = "numberformat(AmountBase,',.__')",
					search       = "number"}>	
					
<cfoutput>
		<table width="100%" height="100%">
			<tr><td height="3"></td></tr>
			<tr height="10">
				<td class="labellarge"><cf_tl id="Breakdown by Journal of the running balance"><cfoutput>: #url.account#</cfoutput></td>
			</tr>
			<tr><td height="3"></td></tr>
			<tr><td>
			
			<cf_listing
			    header             = "Listing"
			    box                = "setting"
				link               = "#SESSION.root#/Gledger/Inquiry/AP_AR/InquiryAccount.cfm?mission=#url.mission#&account=#url.account#&mode=#url.mode#&systemfunctionid=#url.systemfunctionid#"				
			    html               = "No"	
				datasource         = "AppsLedger"
				tablewidth         = "100%"	
				filtershow         = "yes"
				excelshow          = "Yes"					
				listquery          = "#myquery#"	
				listorder          = "Journal"
				listorderdir       = "DESC"
				listlayout         = "#fields#">
	
			</td></tr>
		</table>
	</cfoutput>	
	
</cfoutput>	
