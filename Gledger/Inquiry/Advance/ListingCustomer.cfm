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
<cfoutput>

<cfsavecontent variable="myquery">	
	
	SELECT        Journal, JournalSerialNo,
	              TransactionId, JournalTransactionNo, JournalBatchNo, JournalBatchDate, Mission, 
				  Description, TransactionSource, TransactionCategory, TransactionSourceNo, TransactionSourceId, 
				  TransactionReference, TransactionDate, 
	              TransactionPeriod, Currency, 
	              CASE WHEN TransactionCategory = 'Advances' THEN Amount*-1 ELSE Amount END as Amount, 
	              CASE WHEN TransactionCategory = 'Advances' THEN AmountOutstanding*-1 ELSE AmountOutstanding END as AmountOutstanding, 	               
				  OfficerUserId, OfficerLastName, OfficerFirstName, Created
	FROM          TransactionHeader
	WHERE         TransactionCategory IN ('Advances', 'Receivables') 
	AND           ReferenceId = '#url.customerid#' 
	AND           ActionStatus <> '9' 
	AND           RecordStatus <> '9' 
	AND           AmountOutstanding > 0 
	AND           Mission = '#url.mission#'

</cfsavecontent>

</cfoutput>

<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cf_tl id="Date" var="1">

<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "#lt_text#",                  
					  field         = "TransactionDate",
					  filtermode    = "2",
					  displayfilter = "Yes",
					  search        = "date",
					  formatted     = "dateformat(TransactionDate,'#CLIENT.DateFormatShow#')"}>	

  

<cf_tl id="Transaction" var="1">		
<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "#lt_text#",                  
					  field         = "JournalTransactionNo",					  
					  display		= "Yes",
					  displayfilter = "Yes",
					  search        = "text"}>	
					  
<cf_tl id="Officer" var="1">						  
<cfset itm = itm+1>		
<cfset fields[itm] = {label       = "#lt_text#",                  
					  field       = "OfficerUserId"}>					  

<cf_tl id="Category" var="1">						  
<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "#lt_text#",                  
					  field         = "TransactionCategory",
					  filtermode    = "2",
					  display		= "Yes",
					  displayfilter = "Yes",
					  search        = "text"}>	

<cf_tl id="Description" var="1">						  
<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "#lt_text#",                  
					  field         = "Description",					
					  display		= "Yes",
					  displayfilter = "Yes",					  					  					  					  	
					  search        = "text"}>
					  

<cf_tl id="Currency" var="1">					  
<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "#lt_text#",                  
					  field         = "Currency",
				      filtermode    = "2",
					  displayfilter = "Yes",
					  search        = "text"}>	

<cf_tl id="Amount" var="1">						  
<cfset itm = itm+1>							
<cfset fields[itm] = {label         = "#lt_text#",  					
					  field         = "Amount",
					  align 		= "right",
					  width         = "20",
					  formatted     = "NumberFormat(Amount,',.__')"}>
					  
<cf_tl id="Outstanding" var="1">						  
<cfset itm = itm+1>							
<cfset fields[itm] = {label         = "#lt_text#",  					
					  field         = "Amount",
					  align 		= "right",
					  width         = "20",
					  formatted     = "NumberFormat(AmountOutstanding,',.__')"}>					  

					  
<table width="100%" height="100%">
<tr><td style="padding:10px">	
		
	<cf_listing
	    header         = "Outstanding"
	    box            = "Outstanding"
		link           = "#SESSION.root#/gledger/inquiry/Advance/ListingCustomer.cfm?customerid=#url.customerid#&systemfunctionid=#url.systemfunctionid#&mission=#url.mission#"
	    html           = "No"
	    show           = "250"				
		datasource     = "AppsLedger"
		listquery      = "#myquery#"		
		listorder      = "TransactionDate"
		listorderfield = "TransactionDate"
		listorderdir   = "DESC"		
		headercolor    = "ffffff"
		listlayout     = "#fields#"
		filterShow     = "yes"
		excelShow      = "Yes"
		drillmode      = "tab"	
		drillargument  = "940;1190;false;false"	
		drillstring    = ""	
		drilltemplate  = "Gledger/Application/Transaction/View/TransactionView.cfm?id="
		drillkey       = "TransactionId">		
	</td></tr>
</table>		