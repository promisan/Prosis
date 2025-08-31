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
<cfparam name="client.header" default="">

<cfset itm = 0>
<cfset fields=ArrayNew(1)>

<cfif url.id1 neq "VED">
	
	<cf_tl id="Issued By" var="vIssued">
	<cfset itm = itm+1>
	<cfset fields[itm] = {label      = "#vIssued#",                   
						field      = "IssuedBy",
						filtermode = "2",
						width      = "40",	
						search     = "text"}>
					
</cfif>			

<cf_tl id="InvoiceNo" var="vInvoiceNo">
<cfset itm = itm+1>								
<cfset fields[itm] = {label        = "#vInvoiceNo#",                   
					 field         = "InvoiceNo",		
					 width         = "30",			
					 search        = "text"}>		
										

<cf_tl id="PurchaseNo" var="vPurchaseNo">
<cfset itm = itm+1>					
<cfset fields[itm] = {label        = "#vPurchaseNo#",                   
					field          = "PurchaseReference",		
					functionscript = "ProcPOEdit",
					width          = "30",	
					functionfield  = "PurchaseNo",			
					search         = "text"}>	
					
<cf_tl id="Nos" var="vNos">
<cfset itm = itm+1>					
<cfset fields[itm] = {label        = "#vNos#",                   
					field          = "PurchaseNos",							
					width          = "10"}>														

<!---					
<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Period",                   
					field      = "Period",	
					filtermode = "2",				
					search     = "text"}>						
--->					

<cf_tl id="Date" var="vDate">
<cfset itm = itm+1>					
<cfset fields[itm] = {label       = "#vDate#",  					
					field         = "DocumentDate",						
					column        = "month",				
					formatted     = "dateformat(DocumentDate,'DD/MM/YY')",
					search        = "date"}>


<cf_tl id="Officer" var="vOfficer">
<cfset itm = itm+1>					
<cfset fields[itm] = {label       = "#vOfficer#",	
					field         = "OfficerLastName",
					search        = "text"}>	
					
	
					
<cf_tl id="Cur" var="vCur">
<cfset itm = itm+1>								
<cfset fields[itm] = {label       = "#vCur#.",
					field         = "DocumentCurrency",
					filtermode    = "2",
					labelfilter   = "Currency",
					search        = "text"}>	
								
<cf_tl id="Invoice" var="vAmount">
<cfset itm = itm+1>										
<cfset fields[itm] = {label       = "#vAmount#",  
					field         = "DocumentAmount",
					search        = "number",
					aggregate     = "sum",
					align         = "right",
					formatted     = "numberformat(DocumentAmount,',.__')"}>	

<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "S", 	
                    LabelFilter   = "Status",				
					field         = "ActionStatus",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=Yellow,1=Green,9=Red"}>								

<cf_tl id="Stage" var="vStage">
<cfset itm = itm+1>						
<cfset fields[itm] = {label      = "#vStage#",	
					field        = "ActionDescriptionDue",
					formatted    = "left(ActionDescriptionDue,30)",				
					filtermode   = "2",    
					search       = "text"}>			
										
<cf_tl id="Posted" var="vPosted">
<cfset itm = itm+1>										
<cfset fields[itm] = {label      = "#vPosted#",  
					field        = "Payable",
					search       = "number",
					aggregate    = "sum",
					align        = "right",
					formatted    = "numberformat(Payable,',.__')"}>		
					
					
					
<cf_tl id="Pending" var="vPending">
<cfset itm = itm+1>										
<cfset fields[itm] = {label      = "#vPending#",  
					field        = "Pending",
					search       = "number",
					aggregate    = "sum",
					align        = "right",
					formatted    = "numberformat(Pending,',.__')"}>																		
	

<cf_tl id="Invoice" var="vInvoice">
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "#vInvoice#",    					
					display      = "No",					
					field        = "InvoiceId"}>		
					
<cfif url.id1 eq "Locate">
    <cfset s = "No">
<cfelseif url.id1 eq "VED">	
     <cfset s = "Hide">
<cfelse>
    <cfset s = "Yes"> 
</cfif>			
	
<cftry>

<cf_wfpending entityCode="ProcInvoice"  
      table="#SESSION.acc#wfInvoice" mailfields="No" IncludeCompleted="No">		
	  
<cfoutput>
	
	<!--- pass the result to the script --->
	<cfsavecontent variable="myquery">
		 SELECT I.*, DocumentDate,
				V.ActionDescriptionDue
		 FROM   lsInvoice_#SESSION.acc# I LEFT OUTER JOIN #SESSION.acc#wfInvoice V ON ObjectkeyValue4 = I.InvoiceId	
		 WHERE 1=1 <!--- needed for the query in the listing --->	
	</cfsavecontent>

</cfoutput>	  					

<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center">
<tr><td style="padding-left:8px;padding-right:8px;padding-bottom:6px">
							
<cf_listing
    header        = "lsInvoice_#URL.ID1#"
    box           = "lsinvoice_#URL.ID1#"
	link          = "#SESSION.root#/Procurement/Application/Invoice/InvoiceView/InvoiceViewListingContent.cfm?#cgi.query_string#"
    html          = "No"
	show          = "42"
	datasource    = "AppsQuery"
	listquery     = "#myquery#"
	listkey       = "InvoiceId"		
	listorder     = "DocumentDate"
	listorderdir  = "ASC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "#s#"
	excelShow     = "Yes"
	height        = "100%"
	annotation    = "ProcInvoice"
	drillmode     = "tab"
	drillargument = "920;1200;false;false"	
	drilltemplate = "Procurement/Application/Invoice/Matching/InvoiceMatch.cfm?id="
	drillkey      = "Invoiceid">
	
	<cfcatch>
	
	 <cf_message width="100%"
			height="80"
			message="An error has occurred retrieving your data <br>#CFCatch.Message# - #CFCATCH.Detail#" return="no">
	
	</cfcatch>	
	
	</td>
	</tr>
</table>		
	
</cftry>	