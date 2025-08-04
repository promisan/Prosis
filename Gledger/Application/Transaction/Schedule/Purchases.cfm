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

<!--- ---------------------------------------------------------------------------- --->
<!--- ----------------correct invoice transactions-------------------------------- --->
<!--- ---------------------------------------------------------------------------- --->

<cfquery name="Entity"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   DISTINCT Mission 
	FROM     TransactionHeader
	WHERE    AccountPeriod IN (SELECT AccountPeriod FROM Period WHERE ActionStatus = '0') 		
	AND      Journal IN (SELECT Journal 
		                 FROM   Journal 
						 WHERE  GLCategory = 'Actuals')								 				 
	ORDER BY Mission
</cfquery>

<cfquery name="Purchases"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT GLAccount
	FROM   Materials.dbo.Ref_CategoryGledger
	WHERE  Area = 'Receipt'
</cfquery>	
	
<cfif Purchases.recordcount gt "1">

	<cfabort>
	
</cfif>	
		
<cfloop query="Entity">
	
	<cfquery name="PriceDifference" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT    *
	    FROM      Ref_AccountMission
		WHERE     SystemAccount = 'Correction'
		AND       Mission       = '#Mission#'
	</cfquery>
	
	<cf_ScheduleLogInsert   
		    ScheduleRunId  = "#schedulelogid#"
		    Description    = "Invalid price difference GL account"
			Datasource     = "AppsLedger"
		    StepStatus     = "9">				
	
	<cfquery name="getLines"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT    Journal, JournalSerialNo, 
		          AccountPeriod, TransactionDate, 
				  ReferenceId, 
		          Currency, 
				  ROUND(SUM(AmountDebit), 2)       AS InvoiceDebit, 
				  ROUND(SUM(AmountBaseDebit), 2)   AS InvoiceDebitBase, 
				  ReceiptId, 
				  ReceiptCurrency, 
				  ROUND(SUM(ReceiptCredit), 2)     AS ReceiptCredit, 
				  ROUND(SUM(ReceiptBaseCredit), 2) AS ReceiptCreditBase, 
				  ROUND(SUM(AmountBaseDebit-AmountBaseCredit) - SUM(ReceiptBaseCredit-ReceiptBaseDebit), 2) AS Correction
							 
		FROM      (	
		
						SELECT        TH.ReferenceId, TH.Journal, TH.JournalSerialNo, TH.AccountPeriod, TH.TransactionDate,
						              TL.ReceiptId, TL.GLAccount, TL.Currency, 
									  TL.AmountDebit, TL.AmountCredit, 
									  TL.AmountBaseDebit, TL.AmountBaseCredit, 
									  RL.Currency         AS ReceiptCurrency, 
									  RL.AmountDebit      AS ReceiptDebit, 
									  RL.AmountCredit     AS ReceiptCredit, 
                                      RL.AmountBaseDebit  AS ReceiptBaseDebit, 
									  RL.AmountBaseCredit AS ReceiptBaseCredit
									  
                          FROM        dbo.TransactionHeader AS TH INNER JOIN
						  
                                           (SELECT    Journal, JournalSerialNo, 
										              ReferenceId as ReceiptId, GLAccount, Currency, 
													  ROUND(SUM(AmountDebit), 2)      AS AmountDebit, 
													  ROUND(SUM(AmountCredit), 2)     AS AmountCredit, 
													  ROUND(SUM(AmountBaseDebit), 2)  AS AmountBaseDebit, 
                                                      ROUND(SUM(AmountBaseCredit), 2) AS AmountBaseCredit
													  
                                             FROM     dbo.TransactionLine AS R
                                             WHERE    (ReferenceId IN (SELECT    ReceiptId
                                                                       FROM      Purchase.dbo.PurchaseLineReceipt
                                                                       WHERE     ReceiptId = R.ReferenceId)) 
										     AND      GLAccount = '#Purchases.GLAccount#'  <!--- purchases --->
                                             GROUP BY Journal, JournalSerialNo, ReferenceId, Currency, GLAccount) 
											 
											 AS TL ON 
											 
											 TH.Journal = TL.Journal AND TH.JournalSerialNo = TL.JournalSerialNo INNER JOIN
                                       dbo.TransactionLine AS RL INNER JOIN
                                       dbo.TransactionHeader AS RF ON RL.Journal = RF.Journal AND RL.JournalSerialNo = RF.JournalSerialNo INNER JOIN
                                       Materials.dbo.ItemTransaction AS PT ON RF.ReferenceId = PT.TransactionId ON TL.ReceiptId = PT.ReceiptId
                          WHERE        TH.ReferenceId IN
                                                        (SELECT       InvoiceId
                                                          FROM        Purchase.dbo.Invoice
                                                          WHERE       Mission = '#mission#') 
						  AND          RL.GLAccount = '#Purchases.GLAccount#'		
						  <!--- we are not applying this if it is clear that the price differences is because of additional invoices --->
						  AND          abs(PT.ReceiptCostPrice - PT.ReceiptPrice) < 0.01
		
					) AS subtable
						 
		 GROUP BY   Journal, JournalSerialNo, Currency, ReceiptCurrency, ReferenceId, AccountPeriod, TransactionDate, ReceiptId
		 
		 HAVING     ABS(ROUND(SUM(AmountBaseDebit-AmountBaseCredit) - SUM(ReceiptBaseCredit-ReceiptBaseDebit), 2)) > 0.01
		 
		 ORDER BY   Journal, JournalSerialNo 
		 	
	</cfquery>	
	
	<cfloop query="getLines">
		
	<!--- 1. take the base amount and convert into the currency amount of the journal
		   2. Create header transaction
		   3. If amount is positive we book to purchases as credit, otherwise we book debit and reverse.
		   4. 		
		--->
		<cfquery name="last"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    MAX(TransactionSerialNo) AS Last
				FROM      TransactionLine
				WHERE     Journal         = '#Journal#' 
				AND       JournalSerialNo = '#JournalSerialNo#'
		</cfquery>
		
		<cfset row = last.last>	
		<cfset amtB = abs(Correction)>
		
		<cfif currency neq application.basecurrency>
		
			<cf_exchangeRate 
			    EffectiveDate = "#dateformat(TransactionDate,client.dateformatshow)#"				 
		        CurrencyFrom  = "#Application.BaseCurrency#" 
		        CurrencyTo    = "#Currency#">					
		
		<cfelse>
		
			<cfset exc = "1">
			
		</cfif>
		
		<cfset amt = amtB / exc>
		
		<cfif correction gt "0">
		
			<cfset glcredit = Purchases.GLAccount>
			<cfset gldebit  = PriceDifference.GLAccount>
		
		<cfelse>
		
			<cfset gldebit  = Purchases.GLAccount>
			<cfset glcredit = PriceDifference.GLAccount>
					
		</cfif>					
		
		<cf_GledgerEntryLine
			Lines                 = "2"
		    Journal               = "#Journal#"
			JournalNo             = "#JournalSerialNo#"
			AccountPeriod         = "#AccountPeriod#"
			TransactionDate       = "#dateformat(TransactionDate,client.dateformatshow)#"
			Currency              = "#Currency#"
																			
			TransactionSerialNo1  = "#row+1#"
			TransactionAmount1    = "#Round(amt*100)/100#" 
			Class1                = "Debit"
			ReferenceId1          = "#ReceiptId#"			
			Reference1            = "Correction"       
			ReferenceName1        = "Administrative Correction Purchases"			
			GLAccount1            = "#gldebit#"			
			TransactionType1      = "Standard"
			Amount1               = "#Round(amt*100)/100#"
			
			TransactionSerialNo2  = "#row+2#"
			TransactionAmount2    = "#Round(amt*100)/100#" 
			Class2                = "Credit"
			ReferenceId2          = "#ReceiptId#"
			Reference2            = "Correction"       
			ReferenceName2        = "Administrative Correction"			
			GLAccount2            = "#glcredit#"						
			TransactionType2      = "Standard"
			Amount2               = "#Round(Amt*100)/100#">	
				
			<cf_ScheduleLogInsert   
			    ScheduleRunId  = "#schedulelogid#"
			    Description    = "Correction recorded for #Journal# #JournalSerialNo# : #Correction#"
				Datasource     = "AppsLedger"
			    StepStatus     = "1">	
		
	</cfloop>	
	
</cfloop>	

