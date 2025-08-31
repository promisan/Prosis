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
<cfparam name="url.mode"    default="AR">
<cfparam name="url.orgunit" default="">

<cfquery name="Accounts"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT     R.GLAccount
				   
		FROM       Ref_Account R  INNER JOIN
				   Ref_AccountMission M ON R.GLAccount = M.GLAccount							   
		WHERE      M.Mission       = '#url.mission#' 				
		AND        R.AccountClass       = 'Balance' <!--- balance --->			
		<cfif url.mode eq "AD">
	    AND     AccountType        = 'Credit' 
		AND     AccountCategory    = 'Advance'
		<cfelseif url.mode eq "AR"> 	
			AND    AccountType        = 'Debit'   
			AND    ((BankReconciliation = 1 AND AccountCategory IN ('Vendor','Neutral')) OR AccountCategory = 'Vendor')
		<cfelse>	
			AND     AccountType        = 'Credit' 
			AND     AccountCategory    = 'Customer'
		</cfif>
						 		   
</cfquery>		

<cfset selaccount = quotedvalueList(Accounts.GLAccount)> 

<cfif url.mode eq "AP">
    <!---
    <cfset journalfilter = "'Payables','Payment','DirectPayment'">
	--->
	<cfset journalfilter = "'Payables','Direct Payment'">
<cfelseif url.mode eq "AD">	
    <cfset journalfilter = "'Advances'">
<cfelse>
    <cfset journalfilter = "'Receivables'">
</cfif>	

<cfif url.orgunit eq "">		
	<CF_DropTable dbName="AppsQuery" tblName="Inquiry_#url.mode#_#session.acc#">	
<cfelse>
	<CF_DropTable dbName="AppsQuery" tblName="Inquiry_#url.mode#_#session.acc#_#url.orgunit#">	
</cfif>

<cf_wfpending entityCode="GLTransaction"  
      table="#SESSION.acc#wfLedger" mailfields="No" IncludeCompleted="No">		

<cftransaction isolation="READ_UNCOMMITTED">

	<cfquery name="InitTable" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
					
			SELECT   DISTINCT P.Journal, 
			         P.JournalSerialNo, 
					 P.JournalTransactionNo, 
					 P.JournalBatchNo, 
					 P.Mission, 
					 P.OrgUnitOwner, 
					 
					 (SELECT V.ActionDescriptionDue
      				   FROM   userQuery.dbo.#SESSION.acc#wfLedger V WHERE ObjectkeyValue4 = P.TransactionId) as ActionDescriptionDue,	 
					 
					 P.TransactionSource, 
					 P.TransactionDate, 
		             P.TransactionId, 
					 P.AccountPeriod, 
				     P.TransactionCategory, 
				     P.MatchingRequired, 
				     P.ReferenceOrgUnit, 
				     O.OrgUnitName AS ReferenceOrgUnitName,
				     P.ReferencePersonNo, 
				     P.Reference, 
					 
					 (CASE WHEN TransactionSource = 'SalesSeries' THEN
                                (SELECT    TOP 1 CustomerName
                                 FROM      Materials.dbo.Customer C INNER JOIN
                                           Materials.dbo.WarehouseBatch B ON C.Customerid = B.CustomerId
                                 WHERE     BatchId = P.TransactionSourceId) 
						   
					   ELSE P.ReferenceName END) AS ReferenceName,

					 LEFT(P.Description,35) as Description,
					 
					 (	 SELECT TOP 1 GLAccount
						 FROM   TransactionLine
						 WHERE  Journal = P.Journal 
						 AND    JournalSerialNo = P.JournalSerialNo 
						 AND    TransactionSerialNo = '0') as GLAccount,
																 
					 (	SELECT SUM(AmountCredit-AmountDebit)
					 	FROM   TransactionLine 
					 	WHERE  Journal = P.Journal 
					 	AND    JournalSerialNo = P.JournalSerialNo 
					 	AND    TransactionSerialNo = '0') as GLAmount,
					
					<cfif url.mode neq "AR">
						
					 TransactionReference,
					 
					 <cfelse>
					 
					 <!--- invoice reference --->
					 ISNULL(TransactionReference,
							(SELECT   TOP 1 T.ActionReference1
										FROM     TransactionHeaderAction T, Ref_Action R
										WHERE    T.ActionCode      = R.Code
										AND      T.ActionReference1 IS NOT NULL
										AND      T.Journal         = P.Journal
										AND      T.JournalSerialNo = P.JournalSerialNo
										AND      T.ActionCode      = 'Invoice'
										ORDER BY R.Code, ActionDate DESC)) AS TransactionReference,				 
															
					 <!--- -------------------------------- --->
					 
					 </cfif>
					 	
		             P.ReferenceNo, 
				     P.ReferenceId, 
				     P.DocumentCurrency, 
				     P.DocumentAmount, 
				     P.DocumentDate, 
				     P.ExchangeRate, 
				     P.Currency, 
				     P.Amount, 
				     P.AmountOutstanding, 				 
					 
				     P.ActionType, 
		             P.ActionTerms, 
				     P.ActionDiscountDays, 
				     P.ActionDiscount, 
				     P.ActionDiscountDate, 
				     P.ActionBefore, 
				     P.ActionBankId, 
				     P.ActionAccountNo, 
				     P.ActionAccountName, 
		             P.ActionStatus,
					 P.OfficerUserId,
					 P.OfficerLastName,
					 P.OfficerFirstName,
					 P.Created,
					 <!--- overdue --->
					 DATEDIFF(dd,CASE WHEN ActionBefore = '' THEN ActionBefore ELSE DocumentDate END,CONVERT(datetime,getDate())) - 0 as Days
						 
				<cfif url.orgunit eq "">		 
										 
				INTO     userQuery.dbo.Inquiry_#url.mode#_#session.acc#
				
				<cfelse>
				
				INTO     userQuery.dbo.Inquiry_#url.mode#_#session.acc#_#url.orgunit#
				
				</cfif>
						 
				FROM     TransactionHeader P LEFT OUTER JOIN Organization.dbo.Organization O 
							ON O.OrgUnit = P.ReferenceOrgUnit		
							
				<cfif url.orgunit neq "">
				<!--- relation view --->
				WHERE    P.ReferenceOrgUnit = '#url.orgunit#'
				<cfelse>
				<!--- normal AP view --->
				WHERE    P.Mission = '#URL.Mission#'
				AND      abs(P.AmountOutstanding) > 0.5
				</cfif>													 
									
				AND      P.Journal IN (SELECT Journal 
				                       FROM   Journal 
								       WHERE  GLCategory = 'Actuals')
				
				<cfif url.orgunit neq "">
				<!--- relation view --->
				AND      P.ReferenceOrgUnit = '#url.orgunit#'
				<cfelse>
				<!--- normal AP view --->
				AND      abs(P.AmountOutstanding) > 0.5
				</cfif>
							
				AND      P.TransactionCategory IN (#preservesinglequotes(journalfilter)#) 
							
				<!--- has a base booking on the accounts with AR or AP --->
				AND      P.Journal IN (SELECT Journal 
				                       FROM   TransactionLine 
							           WHERE  Journal         = P.Journal 
			    				       AND    JournalSerialNo = P.JournalSerialNo
			    				       <cfif Accounts.recordcount gt 0>
				    				   AND    GLAccount IN (#preserveSingleQuotes(selaccount)#)
			    				      </cfif>
						    	      AND    TransactionSerialNo = '0')
				
				AND      P.ActionStatus IN ('0','1')
				AND      P.RecordStatus != '9'  <!--- not voided --->
				
				<cfif getAdministrator(url.mission) eq "0">
				 AND    P.Journal IN (SELECT ClassParameter 
				                      FROM   Organization.dbo.OrganizationAuthorization
				                      WHERE  UserAccount = '#SESSION.acc#' 
			                          AND    Role        = 'Accountant'
								      AND    Mission     = '#url.Mission#'
									  )
			    </cfif>		
				
				<!--- exclude credit notes --->
				AND EXISTS (
							SELECT	'X'
							FROM	TransactionLine
							WHERE	Journal = P.Journal
							AND		JournalSerialNo = P.JournalSerialNo
							AND 	ParentJournalSerialNo IS NULL
							AND		ParentJournal IS NULL
						  )
				
	</cfquery>
	
	<!---
	<cfoutput>#cfquery.executiontime#</cfoutput>		
	--->

</cftransaction>