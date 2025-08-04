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

<!--- configuration file --->

<cfset journalfilter = "'Receivables'">

<cfoutput>

<cfsavecontent variable="myquery">

		SELECT *
		FROM (

		SELECT  HL.Journal, 
		        HL.JournalSerialNo, 
				H.JournalTransactionNo, 
				HL.JournalTransactionNo as ReceiptNo,
				H.JournalBatchNo, 
				HL.Mission, 
				HL.OrgUnitOwner, 
				HL.Description, 
				HL.TransactionSource, 
				HL.TransactionDate, 
	            HL.TransactionId, 
				HL.AccountPeriod, 
				HL.TransactionCategory, 
				HL.MatchingRequired, 
				H.ReferenceOrgUnit, 
				HL.ReferencePersonNo, 
				H.Reference, 
				H.ReferenceName, 
	            HL.ReferenceNo, 
				HL.ReferenceId, 
				HL.DocumentCurrency, 
				HL.DocumentAmount, 
				HL.DocumentDate, 
				HL.ExchangeRate, 
				L.Currency, 
				L.AmountBaseCredit-L.AmountBaseDebit as Amount, 				  				
				HL.ActionBankId, 
				HL.ActionAccountNo, 
				HL.ActionAccountName, 
	            HL.ActionStatus
				  
		FROM    TransactionLine L INNER JOIN
				TransactionHeader HL ON L.Journal = HL.Journal AND L.JournalSerialNo = HL.JournalSerialNo INNER JOIN
               	TransactionHeader H ON L.ParentJournal = H.Journal AND L.ParentJournalSerialNo = H.JournalSerialNo 
		
		<!--- the parent is an accounts receivable. but data is from the child --->							
		WHERE   H.TransactionCategory IN (#preservesinglequotes(journalfilter)#)
		AND     H.ActionStatus IN ('0','1')
		AND     H.RecordStatus = '1'  <!--- not voided --->
		AND     L.TransactionSerialNo <> '0' 
				
		AND     H.ReferenceOrgUnit = '#url.id2#'	
		
		AND    H.Journal IN (SELECT Journal 
		                  FROM   Journal 
						  WHERE  GLCategory = 'Actuals')		
		
		) as C
							

	
</cfsavecontent>

<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cfset itm = itm+1>		

<cf_tl id="Creditor" var="vLabel">		

<cfset fields[itm] = {label = "#vLabel#",                  
					field   = "ReferenceName",
					search  = "text"}>

<cfset itm = itm+1>				
<cf_tl id="Invoice No" var="vInvoice">		
<cfset fields[itm] = {label      = "#vInvoice#", 					
					field      = "JournalTransactionNo"}>			
					
<cfset itm = itm+1>				
<cf_tl id="Receipt No" var="vReceipt">		
<cfset fields[itm] = {label      = "#vReceipt#", 					
					field      = "ReceiptNo"}>											

<cfset itm = itm+1>		
<cf_tl id="Posted" var="vPosted">		
<cfset fields[itm] = {label      = "#vPosted#", 					
					field      = "TransactionDate",					
					formatted  = "dateformat(TransactionDate,CLIENT.DateFormatShow)",
					search     = "date"}>		
										
<cfset itm = itm+1>		
<cfset fields[itm] = {label       = "Period",                   
					field       = "AccountPeriod"}>					
		
<cfset itm = itm+1>		
<cf_tl id="Curr" var="vCurr">							
<cfset fields[itm] = {label   = "#vCurr#",                   
					field   = "Currency"}>					

<cfset itm = itm+1>							
<cf_tl id="Amount" var="vAmount">		
<cfset fields[itm] = {label   = "#vAmount#", 					
					field   = "Amount",
					align   = "right",
					formatted  = "numberformat(Amount,'__,__.__')",
					search  = "number"}>	
<!---
									
<cfset itm = itm+1>		
<cf_tl id="Outstanding" var="vOutstanding">						
<cfset fields[itm] = {label   = "#vOutstanding#", 					
					field   = "AmountOutstanding",
					align   = "right",
					formatted  = "numberformat(AmountOutstanding,'__,__.__')",
					search  = "number"}>	
					--->
									
<cf_listing
    header        = "<b><font size='2'>Payables</font></b>"
    box           = "setting"
	link          = "#SESSION.root#/System/Organization/Application/AR/ReceiptListingContent.cfm?systemfunctionid=#url.systemfunctionid#&id1=VED&id2=#URL.ID2#&mission=#url.mission#"
    html          = "No"	
	datasource    = "AppsLedger"
	tablewidth    = "100%"	
	filtershow    = "Hidden"
	excelshow     = "Yes"	
	listquery     = "#myquery#"
	listkey       = "TransactionId"
	listorder     = "TransactionDate"
	listorderdir  = "DESC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	annotation    = "GLTransaction"
	drillmode     = "window"
	drillargument = "880;960;false;false"	
	drilltemplate = "Gledger/Application/Transaction/View/TransactionViewDetail.cfm?id="
	drillkey      = "TransactionId">
	
	
</cfoutput>	
