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

<cfoutput>

<cfsavecontent variable="myquery">
	
	SELECT	*, TransactionDate
	FROM     dbo.Inquiry_#url.mode#_#session.acc#_#url.orgunit# P		
			
</cfsavecontent>

</cfoutput>

<cfset fields=ArrayNew(1)>

<cfset itm = 1>
<cf_tl id="Batch No" var="vBatchNo">
<cfset fields[itm] = {label       = "#vBatchNo#",
					field         = "JournalTransactionNo",
					search        = "text"}>

<cfset itm = itm+1>				
<cf_tl id="Invoice No" var="vInvoice">		
<cfset fields[itm] = {label       = "#vInvoice#", 					
					field         = "TransactionReference",
					search        = "text"}>	
					
<cfset itm = itm+1>
<cf_tl id="Memo" var="vMemo">
<cfset fields[itm] = {label       = "#vMemo#",
					field         = "Description",
					search        = "text"}>					
					
<cfset itm = itm+1>	
<cf_tl id="Account" var="vAccount">			
<cfset fields[itm] = {label       = "#vAccount#", 					
					field         = "GLAccount",					
					search        = "text",
					column        = "common",
					display       = "no",
					filtermode    = "2"}>								
					
<cfset itm = itm+1>		
<cf_tl id="Posted" var="vPosted">		
<cfset fields[itm] = {label       = "#vPosted#", 					
					field         = "TransactionDate",					
					column        = "month",					
					formatted     = "dateformat(TransactionDate,CLIENT.DateFormatShow)",
					search        = "date"}>	
					
<cfset itm = itm+1>	
<cf_tl id="Officer" var="vOfficer">			
<cfset fields[itm] = {label       = "#vOfficer#", 					
					field         = "OfficerLastName",					
					search        = "text",
					column        = "common",
					display       = "no",
					filtermode    = "3"}>													
					
<cfset itm = itm+1>	
<cf_tl id="Due" var="vDue">			
<cfset fields[itm] = {label       = "#vDue#", 					
					field         = "ActionBefore",
					formatted     = "dateformat(ActionBefore,CLIENT.DateFormatShow)",
					search        = "date"}>							

<cfset itm = itm+1>		
<cf_tl id="Days" var="vDays">	
<cfset fields[itm] = {label       = "#vDays#",
                    align         = "right",                   
					field         = "Days",
					search        = "number"}>		

<cfset itm = itm+1>		
<cf_tl id="Status" var="vSta">							
<cfset fields[itm] = {label       = "#vSta#",                   
					field         = "ActionStatus",				
					formatted     = "Rating",
					column        = "common",
					align         = "center",
					ratinglist    = "0=yellow,1=Green"}>		
		
<cfset itm = itm+1>		
<cf_tl id="Curr" var="vCurr">							
<cfset fields[itm] = {label      = "#vCurr#",                   
					field        = "Currency",
					column       = "common",
					search       = "text",
					filtermode   = "2"}>					

<cfset itm = itm+1>							
<cf_tl id="Amount" var="vAmount">		
<cfset fields[itm] = {label      = "#vAmount#", 					
					field        = "Amount",
					align        = "right",
					aggregate    = "sum",
					formatted    = "numberformat(Amount,',.__')",
					search       = "number"}>	
									
<cfset itm = itm+1>		
<cf_tl id="Outstanding" var="vOutstanding">						
<cfset fields[itm] = {label     = "#vOutstanding#", 					
					field       = "AmountOutstanding",
					align       = "right",
					aggregate   = "sum", 
					formatted   = "numberformat(AmountOutstanding,',.__')",
					search      = "number"}>	

									

<cf_listing
    header           = "Payables"
    box              = "#url.mode#_listing_#url.mission#_#url.orgunit#"
	link             = "#SESSION.root#/System/Organization/Application/AP/APListingContent.cfm?orgunit=#url.orgunit#&mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
	systemfunctionid = "#url.systemfunctionid#"
    html             = "No"	
	datasource       = "AppsQuery"
	calendar         = "9"
	tablewidth       = "98%"	
	filtershow       = "hide"
	excelshow        = "Yes"			
	listquery        = "#myquery#"
	listkey          = "TransactionId"
	listorder        = "TransactionDate"
	listorderdir     = "DESC"
	headercolor      = "ffffff"
	listlayout       = "#fields#"
	annotation       = "GLTransaction"
	drillmode        = "tab"
	drillargument    = "920;1180;false;false"	
	drilltemplate    = "Gledger/Application/Transaction/View/TransactionView.cfm?id="
	drillkey         = "TransactionId">		
	
