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

<cfparam name="url.mission"     default="">
<cfparam name="url.OrgUnit"     default="">

<cf_screenTop jQuery="Yes" height="100%" border="0" html="No" scroll="no">
<cf_listingscript>

<!---

<cfquery name="First"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT       MIN(THA.Created) AS StartDate
	FROM         TransactionHeaderAction AS THA INNER JOIN
	             TransactionHeader ON THA.Journal = TransactionHeader.Journal AND THA.JournalSerialNo = TransactionHeader.JournalSerialNo
	WHERE        THA.ActionCode = 'Invoice' 
	AND          TransactionHeader.Mission = '#url.mission#'
	AND          DocumentCurrency    = '#url.currency#'
	AND          THA.ActionMode = '2'
	
</cfquery>


<cfif first.startdate eq "">

<cfoutput>
    <table height="100%" width="100%">
       <tr class="labelmedium"><td align="center" style="font-size:20px;padding-top:40px" valign="top">No tax declarations found for #url.mission# and #url.currency#</td></tr>
    </table>	
</cfoutput>

<cfelse>
--->

<cfoutput>
<cfsavecontent variable="vwPayables">
	
	SELECT        TH.Journal, 
	              TH.JournalSerialNo, 
				  L.GLAccount, 
				  TH.JournalTransactionNo, 
				  TH.ReferenceName, TH.ReferenceNo, TH.OrgUnitOwner, TH.TransactionSource, TH.TransactionSourceNo, TH.TransactionReference, TH.TransactionDate, 
	              TH.TransactionPeriod, TH.AccountPeriod, 
				  TH.TransactionCategory, 
				  TH.ReferenceOrgUnit, 
				  TH.ReferencePersonNo, 
				  TH.Reference, 
				  TH.DocumentDate, 
				  TH.ExchangeRate, 
				  TH.Currency, 
				  TH.Amount, 
				  TH.AmountOutstanding
	FROM          TransactionHeader AS TH INNER JOIN
	              TransactionLine AS L ON TH.Journal = L.Journal AND TH.JournalSerialNo = L.JournalSerialNo
	WHERE         L.TransactionSerialNo  = '0' 
	AND           TH.TransactionCategory = 'Payables'
	AND           TH.Mission             = '#url.mission#'
	AND           TH.AccountPeriod       = '#url.Period#'
	AND           TH.ActionStatus != '9'
	AND           TH.RecordStatus <> '9' 	
	<cfif url.orgunit neq "">
	AND           TH.OrgUnitOwner        = '#url.OrgUnit#'
	</cfif>
	AND           TH.Currency            = '#url.currency#' 

</cfsavecontent>

<cfsavecontent variable="myquery">

      SELECT *, OffsetTransactionDate 
	  FROM (


	      SELECT      TOP 100 PERCENT  H.TransactionCategory, 
		                H.Journal, 
						H.JournalSerialNo, 
						H.JournalTransactionNo, 
						H.TransactionReference, 
						H.ReferenceOrgUnit, 
						H.ReferenceName, 
						H.ReferenceNo, 
						H.TransactionDate, 
						H.TransactionPeriod, 
						H.Currency, 
						H.Amount, 
	                    H.AmountOutstanding, 
						
						LH.Journal             AS OffsetJournal, 
						J.Description          AS OffsetJournalName, 
						LH.JournalSerialNo     AS OffsetJournalSerialNo,
						LH.ReferenceNo         AS OffsetReferenceNo, 
						L.Currency             AS OffsetCurrency, 
						L.ExchangeRate         AS OffsetExchangeRate, 
						L.AmountDebit, 
	                    ROUND(L.AmountDebit * L.ExchangeRate, 2)  AS AmountDebitOffset, 
						L.AmountCredit, 
						ROUND(L.AmountCredit * L.ExchangeRate, 2) AS AmountCreditOffset, 
	                    ROUND(H.Amount - SUM ((L.AmountDebit - L.AmountCredit) * L.ExchangeRate ) OVER (PARTITION BY H.Journal, H.JournalSerialNo ORDER BY L.TransactionDate, L.Created),2) AS RunningBalance,
	                    LH.TransactionId        as OffsetTransactionId,
						LH.JournalTransactionNo AS OffsetTransactionNo, 
	                    LH.TransactionDate      AS OffsetTransactionDate, 
						LH.TransactionPeriod    AS OffsetTransactionPeriod, 
						LH.OfficerUserId, 
						LH.OfficerLastName, 
						LH.OfficerFirstName, 
						LH.Created
						
	    FROM            TransactionHeader AS LH 
		                INNER JOIN TransactionLine AS L ON LH.Journal = L.Journal AND LH.JournalSerialNo = L.JournalSerialNo 
						INNER JOIN Journal         AS J ON LH.Journal = J.Journal 
	                    RIGHT OUTER JOIN
						
	                             (SELECT      Journal, JournalSerialNo, GLAccount, JournalTransactionNo, 
								              ReferenceName, ReferenceOrgUnit, ReferenceNo, OrgUnitOwner, 
											  TransactionSource, TransactionSourceNo, TransactionReference, TransactionDate, 
	                                          TransactionPeriod, AccountPeriod, TransactionCategory, 
											  Reference, DocumentDate, 
											  ExchangeRate, Currency, Amount, AmountOutstanding
	                               FROM       (#preserveSingleQuotes(vwPayables)#) AS V ) as H
								   
								   ON L.GLAccount = H.GLAccount AND L.ParentJournal = H.Journal AND L.ParentJournalSerialNo = H.JournalSerialNo
	
	     WHERE          LH.ActionStatus <> '9' 
		 AND            LH.RecordStatus <> '9' 		 
	     ORDER BY       H.Journal, 
		                H.JournalSerialNo, 
						L.TransactionDate

		) as B
		WHERE 1=1
		-- condition	

</cfsavecontent>

</cfoutput>

<cfset itm = 1>
<cf_tl id="Journal" var="vJournal">
<cfset fields[itm] = {label    = "#vJournal#",                  
					field      = "Journal",
					search     = "text",
					filtermode = "2"}>
				
<cfset itm = itm+1>
<cf_tl id="Document" var="vDocDate">
<cfset fields[itm] = {label    = "#vDocDate#", 					
					field      = "TransactionDate",
					formatted  = "dateformat(TransactionDate,CLIENT.DateFormatShow)",
					search     = "date"}>

<cfset itm = itm+1>
<cf_tl id="Invoice" var="vCheckNo">
<cfset fields[itm] = {label    = "#vCheckNo#",
					field      = "TransactionReference",
					filtermode = "2",
					search     = "text"}>	
					
<cfset itm = itm+1>
<cf_tl id="Reference" var="vReference">
<cfset fields[itm] = {label    = "#vReference#",
					field      = "ReferenceName",
					filtermode = "2",
					search     = "text"}>						
					
<cfset itm = itm+1>							
<cf_tl id="Amount" var="vAmount">		
<cfset fields[itm] = {label    = "#vAmount#", 					
					field      = "Amount",
					align      = "right",
					formatted  = "numberformat(Amount,',.__')",
					search     = "number"}>

<!---					
<cfset itm = itm+1>							
<cf_tl id="Outstanding" var="vDocAmount">		
<cfset fields[itm] = {label    = "#vDocAmount#", 					
					field      = "DocumentAmount",
					align      = "right",
					formatted  = "numberformat(AmountOutstanding,',.__')"}>		
--->					
					
<cfset itm = itm+1>		
<cf_tl id="Settlement" var="vSettlement">
<cfset fields[itm] = {label    = "#vSettlement#",                  
					field      = "OffsetJournalName",
					column     = "common",
					search     = "text",
					filtermode = "2"}>	
					
<cfset itm = itm+1>
<cf_tl id="Offset No" var="vOffNo">
<cfset fields[itm] = {label    = "#vOffNo#",
					field      = "OffsetTransactionNo",
					search     = "text"}>	
					
<cfset itm = itm+1>
<cf_tl id="OffsetDate" var="vOffsetDate">
<cfset fields[itm] = {label    = "#vOffsetDate#", 					
					field      = "OffsetTransactionDate",
					column     = "month",	
					formatted  = "dateformat(OffsetTransactionDate,CLIENT.DateFormatShow)",
					search     = "date"}>	
					
<cfset itm = itm+1>							
<cf_tl id="Currency" var="vCurrency">		
<cfset fields[itm] = {label    = "#vCurrency#", 					
					field      = "OffsetCurrency",
					align      = "right"}>	
					
<cfset itm = itm+1>							
<cf_tl id="Amount" var="vAmount">		
<cfset fields[itm] = {label     = "#vAmount#", 					
					field       = "AmountCredit",
					align       = "right",					
					formatted   = "numberformat(AmountDebit,',.__')"}>											
					
<cfset itm = itm+1>							
<cf_tl id="Offset" var="vOffset">		
<cfset fields[itm] = {label    = "#vAmount#", 					
					field      = "AmountDebitOffset",
					align      = "right",
					aggregate   = "sum", 
					formatted  = "numberformat(AmountDebitOffset,',.__')",
					search     = "number"}>
					
<cfset itm = itm+1>							
<cf_tl id="Running Balance" var="vRunning">		
<cfset fields[itm] = {label    = "#vRunning#", 					
					field      = "Amount",
					align      = "right",
					formatted  = "numberformat(RunningBalance,',.__')"}>																											
										
			
														
	<cf_listing
	    header           = "PaymentOnPayables_#url.mission#"
	    box              = "PaymentOnPayables_#url.mission#"
		link             = "#SESSION.root#/Gledger/Inquiry/APPayment/PaymentListing.cfm?mission=#url.mission#&currency=#url.currency#&period=#url.period#&systemfunctionid=#url.systemfunctionid#"
		systemfunctionid = "#url.systemfunctionid#"
	    html             = "No"	
		datasource       = "AppsLedger"
		calendar         = "9"
		tablewidth       = "100%"	
		excelshow        = "Yes"
        filterShow       = "Yes"	
		listquery        = "#myquery#"
		listkey          = "OffsetTransactionId"
		listorder        = "OffsetTransactionDate"
		listorderdir     = "DESC"
		headercolor      = "ffffff"
		listlayout       = "#fields#"
		drillmode        = "tab"
		drillargument    = "920;1180;false;false"	
		drilltemplate    = "Gledger/Application/Transaction/View/TransactionView.cfm?id="
		drillkey         = "OffsetTransactionId">		
		

<script>
	Prosis.busy('no')	
</script>


