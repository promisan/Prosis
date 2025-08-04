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

	SELECT     Journal, 
	           JournalSerialNo, 
			   JournalTransactionNo, 
			   JournalBatchNo, 
			   Mission, 
			   OrgUnitOwner, 
			   Description, 
			   TransactionSource, 
			   TransactionDate, 
               TransactionId, 
			   AccountPeriod, 
			   TransactionCategory, 
			   MatchingRequired, 
			   ReferenceOrgUnit, 
			   ReferencePersonNo, 
			   Reference, 
			   ReferenceName, 
               ReferenceNo, 
			   ReferenceId, 
			   DocumentCurrency, 
			   DocumentAmount, 
			   DocumentDate, 
			   ExchangeRate, 
			   Currency, 
			   Amount, 
			   AmountOutstanding, 
			   ActionType, 
               ActionTerms, 
			   ActionDiscountDays, 
			   ActionDiscount, 
			   ActionDiscountDate, 
			   ActionBefore, 
			   ActionBankId, 
			   ActionAccountNo, 
			   ActionAccountName, 
               ActionStatus
	FROM       TransactionHeader P
	<!---
	WHERE     (Journal IN
                          (SELECT     Journal
                            FROM      Journal
                            WHERE     TransactionCategory = 'Payables')) 
							
		--->
		WHERE  TransactionCategory IN (#preservesinglequotes(journalfilter)#)
		AND    ActionStatus IN ('0','1')
		AND    RecordStatus = '1'  <!--- not voided --->
		<!---
		AND    AccountPeriod IN (SELECT AccountPeriod FROM Period WHERE ActionStatus = '0')		
		--->
		AND    ReferenceOrgUnit = '#url.id2#'	
		<!---					
		AND abs(AmountOutstanding) > 0.05
		--->
		AND   P.Journal IN (SELECT Journal 
		                  FROM   Journal 
						  WHERE  GLCategory = 'Actuals')		
		
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
<cf_tl id="Posted" var="vPosted">		
<cfset fields[itm] = {label      = "#vPosted#", 					
					field      = "TransactionDate",
					formatted  = "dateformat(TransactionDate,CLIENT.DateFormatShow)",
					search     = "date"}>		
										
<cfset itm = itm+1>	
<cf_tl id="Due" var="vDue">			
<cfset fields[itm] = {label      = "#vDue#", 					
					field      = "ActionBefore",
					formatted  = "dateformat(ActionBefore,CLIENT.DateFormatShow)",
					search     = "date"}>							
<!---
<cfset itm = itm+1>		
<cfset fields[itm] = {label       = "Period",                   
					field       = "AccountPeriod"}>	
--->					
		
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
									
<cfset itm = itm+1>		
<cf_tl id="Outstanding" var="vOutstanding">						
<cfset fields[itm] = {label   = "#vOutstanding#", 					
					field   = "AmountOutstanding",
					align   = "right",
					formatted  = "numberformat(AmountOutstanding,'__,__.__')",
					search  = "number"}>	
									
<cf_listing
    header        = "<b><font size='2'>Payables</font></b>"
    box           = "setting"
	link          = "#SESSION.root#/System/Organization/Application/AR/InvoiceListingContent.cfm?systemfunctionid=#url.systemfunctionid#&id1=VED&id2=#URL.ID2#&mission=#url.mission#"
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
