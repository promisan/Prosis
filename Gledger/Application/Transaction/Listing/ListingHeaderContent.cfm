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
<cfparam name="url.id1" default="">
<cfparam name="url.idstatus" default="">

<cfquery name="Journal" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
	
		SELECT   *
		FROM     Journal
		WHERE    Journal       = '#url.journal#' 
				
</cfquery>	

<cf_wfpending entityCode="GLTransaction"  
      table="#SESSION.acc#wfLedger" mailfields="No" IncludeCompleted="No">		
	
<cfoutput>
	
	<!--- pass the result to the script --->
	<cfsavecontent variable="myquery">	
	
	    SELECT *, TransactionDate, Created <cfif journal.TransactionCategory eq "Receivables">, DocumentDate</cfif>
		
		FROM (	
	
		SELECT    H.Journal, 
		          H.JournalSerialNo, 
				  H.TransactionId, H.JournalTransactionNo, H.JournalBatchNo, H.JournalBatchDate, 
				  H.Mission, 
				  H.OrgUnitSource, H.OrgUnitOwner, H.OrgUnitTax, 
				  H.Description, 
	              H.TransactionSource, H.TransactionSourceNo, H.TransactionSourceId, 
				  H.TransactionReference, 
				  
				  (SELECT V.ActionDescriptionDue
				   FROM   userQuery.dbo.#SESSION.acc#wfLedger V WHERE ObjectkeyValue4 = H.TransactionId) as ActionDescriptionDue,	 
				  
				  <cfif journal.TransactionCategory eq "Receivables">
				  
				  (CASE WHEN (SELECT  COUNT(DISTINCT JournalSerialNo)
				   FROM    TransactionHeaderAction
				   WHERE   ActionCode      = 'Invoice' 
				   AND     ActionMode      = '2' 
				   AND     Journal         = H.Journal 
				   AND     JournalSerialNo = H.JournalSerialNo) = 1 THEN 'Issued' ELSE 'NA' END) AS Invoiced,
								  
				  </cfif>
				  
				  H.TransactionDate, H.TransactionPeriod, H.AccountPeriod, 
				  H.TransactionCategory, 
	              H.MatchingRequired, H.ReferenceOrgUnit, H.ReferencePersonNo, H.Reference, H.ReferenceName, H.ReferenceNo, H.ReferenceId, 
				  H.DocumentCurrency, H.DocumentAmount, H.DocumentAmountVerbal, H.DocumentDate, 
				  H.ExchangeRate, H.Currency, H.Amount, H.AmountOutstanding, 
				  H.ActionStatus, 
				  H.RecordStatus, H.RecordStatusDate, H.RecordStatusOfficer, 
	              H.OfficerUserId, H.OfficerLastName, H.OfficerFirstName, H.Created
		FROM      TransactionHeader H
		WHERE     H.Journal       = '#url.journal#' 
		<cfif url.id1 neq "">
		AND       H.OrgUnitOwner  = '#url.id1#'
		</cfif>
		AND       H.AccountPeriod = '#url.period#'
		AND       H.ActionStatus != '9'
		AND       H.RecordStatus != '9'
		<cfif idstatus eq "outstanding">
		AND       abs(H.AmountOutstanding) > 0.05 and MatchingRequired = 1
		<cfelseif idstatus eq "pending">
		AND       H.ActionStatus = '0'
		</cfif>
		
		) as D
		
		WHERE 1=1
		--condition
	
	</cfsavecontent>
	 
</cfoutput>


<cfquery name="outstanding" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
	
		SELECT   TOP 1 *
		FROM      TransactionHeader H
		WHERE     H.Journal       = '#url.journal#' 
		AND       H.AccountPeriod = '#url.period#'
		AND       H.ActionStatus != '9'
		AND       H.RecordStatus != '9'
		AND       H.AmountOutstanding > 0		
				
</cfquery>		


	
<!--- show person, status processing color and filter on raise by me --->

<cfparam name="client.header" default="">

<cfset itm = 0>
<cfset fields=ArrayNew(1)>

<cfset itm = itm+1>
<cfset fields[itm] = {label      = "Ser",  
                    labelfilter  = "SerialNo",                 
					field        = "JournalSerialNo",					
					align        =  "center",
					search       = "text"}>	

<cfset itm = itm+1>
<cfset fields[itm] = {label      = "No",    
                    labelfilter  = "TransactionNo",                  
					field      = "JournalTransactionNo",	
					align      = "center",				
					search     = "text"}>	
					
<cfset itm = itm+1>
<cf_tl id="Recorded" var="1">								
<cfset fields[itm] = {label      = "#lt_text#",                   
					field      = "Created",								
					column     = "month",	
					width      = "20",
					align      = "center",
					formatted  = "dateformat(Created,CLIENT.DateFormatShow)",
					search     = "date"}>	
								
<cfset itm = itm+1>

<cf_tl id="Source" var="1">
<cfset fields[itm] = {label      = "#lt_text#",                   
					field        = "TransactionSource",
					filtermode   = "2",
					column       = "common",
					display      =  "No",
					search       = "text"}>						
					
<cfset itm = itm+1>
<cf_tl id="Date" var="1">								
<cfset fields[itm] = {label       = "#lt_text#",                   
					field         = "TransactionDate",								
					column        = "month",	
					width         = "20",
					align         = "center",
					formatted     = "dateformat(TransactionDate,CLIENT.DateFormatShow)",
					search        = "date"}>			
					
<cfset itm = itm+1>		
<cf_tl id="Period" var="1">							
<cfset fields[itm] = {label       = "#lt_text#",                   
					field         = "TransactionPeriod",								
					column        = "common",									
					align         = "center",
					display       = "No"}>												
								
<cfif journal.TransactionCategory eq "Receivables">

    <cfset itm = itm+1>		
	<cf_tl id="Step" var="1">				
	<cfset fields[itm] = {label   = "#lt_text#",                    
					field         = "ActionDescriptionDue",					
					labelfilter   = "#lt_text#",
					filtermode    = "3",    
					search        = "text",
					search        = "text"}>		

   <cfset itm = itm+1>
   <cf_tl id="Document" var="1">								
   <cfset fields[itm] = {label    = "#lt_text#",                   
					field         = "DocumentDate",								
					column        = "month",						
					align         = "center",
					formatted     = "dateformat(DocumentDate,CLIENT.DateFormatShow)",
					search        = "date"}>		
					
	<cfif url.idStatus neq "pending">								
						
	<cfset itm = itm+1>	
	<cf_tl id="Invoice" var="1">						
	<cfset fields[itm] = {label       = "I", 	
	                    LabelFilter   = "#lt_text#",				
						field         = "Invoiced",					
						filtermode    = "3",    
						column       = "common",						
						search        = "text",
						align         = "center",
						formatted     = "Rating",
						ratinglist    = "NA=Yellow,Issued=silver"}>							
						
	</cfif>					
					
</cfif>		

				

<cfset itm = itm+1>		
<cf_tl id="Relation" var="1">				
<cfset fields[itm] = {label      = "#lt_text#",                    
					field        = "ReferenceName",					
					labelfilter  = "#lt_text#",
					search       = "text"}>	
				
<cfset itm = itm+1>		
<cf_tl id="Reference" var="1">				
<cfset fields[itm] = {label      = "#lt_text#",                    
					field        = "TransactionReference",					
					labelfilter  = "Reference",
					display      = "No"}>	
					
<cfset itm = itm+1>		
<cf_tl id="Reference" var="1">				
<cfset fields[itm] = {label      = "#lt_text#",                    
					field        = "ReferenceNo",					
					labelfilter  = "#lt_text#",
					search       = "text"}>					
															
<cfset itm = itm+1>		
<cf_tl id="Amount" var="1">									
<cfset fields[itm] = {label      = "#lt_text#",  
					field      = "Amount",
					search     = "number", 
					aggregate  = "sum",
					width      = "25",
					align      = "right",
					formatted  = "numberformat(Amount,',.__')"}>	
		

<cfif outstanding.recordcount gte "1">
					
	<cfset itm = itm+1>										
	<cf_tl id="Outstanding" var="1">	
	<cfset fields[itm] = {label      = "#lt_text#",  
						field      = "AmountOutstanding",
						search     = "number",  
						aggregate  = "sum",
						align      = "right",
						width      = "25",
						formatted  = "numberformat(AmountOutstanding,',.__')"}>						
					
</cfif>		

<cfif url.idstatus neq "Pending">
	
	<cfset itm = itm+1>	
	<cf_tl id="Status" var="1">						
	<cfset fields[itm] = {label       = "S", 	
	                    LabelFilter   = "#lt_text#",				
						field         = "ActionStatus",					
						filtermode    = "3",    
						width         = "8",					
						align         = "center",
						formatted     = "Rating",
						ratinglist    = "0=Yellow,1=Green,9=Red"}>		
						
	<cfset itm = itm+1>		
	<cf_tl id="Description" var="1">				
	<cfset fields[itm] = {label      = "#lt_text#",    
	                    rowlevel     = "2",
					    colspan      = "9",                
						field        = "Description",					
						labelfilter  = "#lt_text#",
						search       = "text"}>										

</cfif>
				
<cfset itm = itm+1>					
<cfset fields[itm] = {label     = "Id",    					
					display    = "No",					
					field      = "TransactionId"}>		

	
<cftry>

<cfif url.idstatus eq "">
   <cfset auto = "manual">
   <cfset cach = "false">
<cfelse>
   <cfset auto = "auto">	
   <cfset cach = "true">
</cfif>

						
<cf_listing
    header        = "Header#url.journal#"
    box           = "Header#url.journal#_#url.id1#_#url.idstatus#"
	link          = "#SESSION.root#/Gledger/Application/Transaction/Listing/ListingHeaderContent.cfm?#cgi.query_string#"
    html          = "No"
	show          = "300"
	autofilter    = "#auto#"	
	cachedisable  = "#cach#"
	datasource    = "AppsLedger"
	listquery     = "#myquery#"
	listkey       = "TransactionId"		
	listorder     = "JournalSerialNo"
	listorderdir  = "DESC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"
	annotation    = "GLTransaction"
	drillmode     = "tab"
	drillargument = "1030;#client.widthfull#;false;false"	
	drilltemplate = "Gledger/Application/Transaction/View/TransactionView.cfm?id="
	drillkey      = "TransactionId">
	
	<cfcatch>
	
	 <cf_message width="100%"
			height="80"
			message="An error has occurred retrieving your data <br>#CFCatch.Message# - #CFCATCH.Detail#" return="no">
	
	</cfcatch>		
	
</cftry>	