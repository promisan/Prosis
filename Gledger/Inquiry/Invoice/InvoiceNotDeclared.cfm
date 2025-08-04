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

<cf_screenTop jQuery="Yes" height="100%" border="0" html="No" scroll="no">
<cf_listingscript>
<cf_layoutscript>

<cfoutput>

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

<cfsavecontent variable="myquery">

	SELECT *
	FROM (
	
		SELECT	Journal, JournalSerialNo, TransactionId, JournalTransactionNo, Mission, OrgUnitSource, OrgUnitOwner, OrgUnitTax, Description, TransactionSourceId, 
	            TransactionReference, TransactionDate, TransactionPeriod, AccountPeriod, TransactionCategory, MatchingRequired, ReferencePersonNo, 
	            Reference, ReferenceName, ReferenceNo, ReferenceId, DocumentDate, ExchangeRate, Currency, 
	            Amount, AmountOutstanding, 
				
				(SELECT   TOP 1 ActionMemo
                FROM     TransactionHeaderAction AS A
                WHERE    Journal = L.Journal 
			    AND      JournalSerialNo = L.JournalSerialNo 
				AND      ActionMode = '1' 
				AND      ActionCode = 'Invoice'
				ORDER  BY Created DESC) as taxException,
				
				ActionStatus, RecordStatus, OfficerLastName, OfficerFirstName, Created
				
		FROM    TransactionHeader AS L
		WHERE       TransactionSource   = 'SalesSeries' 
		AND         Mission             = '#url.mission#' 
		AND         TransactionDate     > '#first.startdate#' 
		AND         RecordStatus       <> '9' 
		AND         TransactionCategory = 'Receivables' 
		AND         Currency            = '#url.currency#'
		
		AND         OrgUnitTax in (SELECT OrgUnit FROM Organization.dbo.OrganizationTaxSeries)
		
		AND         NOT EXISTS  (SELECT   'X' AS Expr1
		                         FROM     TransactionHeaderAction AS A
		                         WHERE    Journal = L.Journal 
								 AND      JournalSerialNo = L.JournalSerialNo 
								 AND      ActionMode = '2' 
								 AND      ActionCode = 'Invoice')
		
         ) as B
	WHERE 1= 1
	-- condition			

</cfsavecontent>

<cfset itm = 1>
<cf_tl id="Journal" var="vJournal">
<cfset fields[itm] = {label = "#vJournal#",                  
					field   = "Journal",
					search  = "text",
					filtermode = "2"}>

<cfset itm = itm+1>
<cf_tl id="Document" var="vDocDate">
<cfset fields[itm] = {label      = "#vDocDate#", 					
					field      = "DocumentDate",
					formatted  = "dateformat(DocumentDate,CLIENT.DateFormatShow)",
					search     = "date"}>

<cfset itm = itm+1>
<cf_tl id="Sale No" var="vCheckNo">
<cfset fields[itm] = {label      = "#vCheckNo#",
					field      = "JournalTransactionNo",
					search     = "text"}>	

<cfset itm = itm+1>
<cf_tl id="Date" var="vSaleDate">
<cfset fields[itm] = {label      = "#vSaleDate#", 					
					field      = "TransactionDate",
					formatted  = "dateformat(TransactionDate,CLIENT.DateFormatShow)",
					search     = "date"}>

<cfset itm = itm+1>
<cf_tl id="Customer" var="vPayee">
<cfset fields[itm] = {label      = "#vPayee#",
					field      = "ReferenceName",
					search     = "text"}>
					
<cfset itm = itm+1>
<cf_tl id="Exception" var="vExcept">
<cfset fields[itm] = {label      = "#vExcept#",
					field      = "TaxException",
					search     = "text"}>					

<cfset itm = itm+1>							
<cf_tl id="Amount" var="vAmount">		
<cfset fields[itm] = {label   = "#vAmount#", 					
					field   = "Amount",
					align   = "right",
					formatted  = "numberformat(Amount,',.__')",
					search  = "number"}>

<cfset itm = itm+1>							
<cf_tl id="Outstanding" var="vDocAmount">		
<cfset fields[itm] = {label   = "#vDocAmount#", 					
					field   = "DocumentAmount",
					align   = "right",
					formatted  = "numberformat(AmountOutstanding,',.__')"}>
					
														
	<cf_listing
	    header           = "PendingDeclaration"
	    box              = "setting"
		link             = "#SESSION.root#/Gledger/Inquiry/Invoice/InvoiceNotDeclared.cfm?mission=#url.mission#&currency=#url.currency#&period=#url.period#&systemfunctionid=#url.systemfunctionid#"
		systemfunctionid = "#url.systemfunctionid#"
	    html             = "No"	
		datasource       = "AppsLedger"
		calendar         = "9"
		tablewidth       = "100%"	
		excelshow        = "Yes"
        filterShow       = "Yes"	
		listquery        = "#myquery#"
		listkey          = "TransactionId"
		listorder        = "TransactionDate"
		listorderdir     = "DESC"
		headercolor      = "ffffff"
		listlayout       = "#fields#"
		drillmode        = "tab"
		drillargument    = "920;1180;false;false"	
		drilltemplate    = "Gledger/Application/Transaction/View/TransactionView.cfm?id="
		drillkey         = "TransactionId">
		

</cfif>	
		
</cfoutput>	

<script>
	Prosis.busy('no')	
</script>

