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
<cfparam name="url.customerid"  default="">	
<cfparam name="url.workorderid" default="">

<cfquery name="getCustomer" 
		datasource="appsWorkOrder"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     WorkOrder W INNER JOIN ServiceItem S ON W.ServiceItem = S.Code
			<cfif url.workOrderId neq "">
			WHERE    W.WorkOrderId = '#url.WorkOrderId#'	
			<cfelse>
			WHERE    W.CustomerId = '#url.CustomerId#'	
			</cfif>
			ORDER BY W.Created DESC
</cfquery>	

<cfif url.workorderid neq "">
    <cfset mode = "order">
	<cfset url.customerid  = getCustomer.customerid>			
<cfelse>	
    <cfset mode = "customer">
	<cfset url.workorderid = getCustomer.workorderid>	
</cfif>	
	
<cfoutput>
	
	<!--- pass the result to the script --->
	<cfsavecontent variable="myquery">
	
	    SELECT * --,TransactionDate
		FROM (
	
		SELECT  TH.Journal, 
		        TH.JournalSerialNo, 
				TH.JournalTransactionNo, 
				TH.JournalBatchDate, 
				TH.DocumentDate, 
				TH.TransactionDate, 
				TH.Mission, 
				TH.AccountPeriod,				
                TH.TransactionSource, 
				S.Description, 
				W.Reference,
				TH.Currency, 				
				TH.Amount,
				TH.AmountOutstanding,
				TH.ReferenceNo, 
				TH.ReferenceName,
				TH.ActionStatus,
				TransactionId,
				TH.OfficerUserId,
				TH.OfficerLastName,
				TH.OfficerFirstName
        FROM    Accounting.dbo.TransactionHeader AS TH INNER JOIN
                WorkOrder AS W INNER JOIN
                Customer AS C ON W.CustomerId = C.CustomerId ON TH.TransactionSourceId = W.WorkOrderId INNER JOIN
				ServiceItem AS S ON W.ServiceItem = S.Code
        <cfif url.workOrderId neq "">
		WHERE    W.WorkOrderId = '#url.WorkOrderId#'	
		<cfelse>
		WHERE    W.CustomerId = '#url.CustomerId#'	
		</cfif>
		AND     TH.DocumentAmount <> 0
		) as W

	</cfsavecontent>

</cfoutput>
	
<!--- show person, status processing color and filter on raise by me --->

<cfparam name="client.header" default="">

<cfset itm = 0>
<cfset fields=ArrayNew(1)>

<cf_tl id="InvoiceNo" var="vInvoiceNo">
<cfset itm = itm+1>					
<cfset fields[itm] = {label       = "#vInvoiceno#",                   
					field         = "JournalTransactionNo",								
					search        = "text"}>	
					
<cfif mode eq "customer">					
					
<cf_tl id="Order" var="vOrder">
<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "#vOrder#",
					field      = "Reference",					
					search     = "text"}>									
					
<cfelse>

<cf_tl id="Officer" var="vOfficer">
<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "#vOfficer#",
					field      = "OfficerLastName",					
					search     = "text"}>	

</cfif>					
					

<cf_tl id="Service" var="vService">
<cfset itm = itm+1>								
<cfset fields[itm] = {label    = "#vService#",
					field      = "Description",
					column     = "common",					
					filtermode = "2",
					search     = "text"}>		

<cfif getCustomer.ServiceMode eq "Workorder">

	<cf_tl id="Period" var="vDate">
	<cfset itm = itm+1>					
	<cfset fields[itm] = {label      = "#vDate#",  					
						field        = "AccountPeriod",
						search       = "text",
						filtermode = "2"}>		
						
<cfelse>
	
	<!--- provision for posting doing charges billing --->				

	<cf_tl id="Period" var="vDate">
	<cfset itm = itm+1>					
	<cfset fields[itm] = {label      = "#vDate#",  					
						field        = "DocumentDate",	
						labelfilter  = "#vDate#",				
						formatted    = "dateformat(DocumentDate,'#client.dateformatshow#')",
						search       = "date"}>			
					
	<cf_tl id="Closing" var="vClosing">
	<cfset itm = itm+1>					
	<cfset fields[itm] = {label    = "#vClosing#",  					
						field      = "JournalBatchDate",					
						formatted  = "dateformat(JournalBatchDate,'#client.dateformatshow#')",
						search     = "date"}>		
					
</cfif>																		
										
<cf_tl id="Posting" var="vPosting">
<cfset itm = itm+1>					
<cfset fields[itm] = {label        = "#vPosting#",  					
					field          = "TransactionDate",		
					column         = "month",				
					formatted      = "dateformat(TransactionDate,'#client.dateformatshow#')",
					search         = "date"}>		
					
	
<cf_tl id="Cur" var="vCur">
<cfset itm = itm+1>								
<cfset fields[itm] = {label        = "#vCur#.",
					field          = "Currency",
					filtermode     = "2",
					labelfilter    = "Currency",
					search         = "text"}>	
								
<cf_tl id="Amount" var="vAmount">
<cfset itm = itm+1>										
<cfset fields[itm] = {label        = "#vAmount#",  
					field          = "Amount",
					search         = "number",	
					aggregate      = "sum",				
					align          = "right",
					formatted      = "numberformat(Amount,',.__')"}>	
					
<cf_tl id="Balance" var="vOutstanding">
<cfset itm = itm+1>										
<cfset fields[itm] = {label        = "#vOutstanding#",  
					field          = "AmountOutstanding",
					search         = "number",
					aggregate      = "sum",
					align          = "right",
					formatted      = "numberformat(AmountOutstanding,',.__')"}>						

<cfset itm = itm+1>	
<cf_tl id="Status" var="vStatus">					
<cfset fields[itm] = {label        = "S", 	
                    LabelFilter    = "Status",				
					field          = "ActionStatus",					
					filtermode     = "3", 
					width          = "8",
					search         = "text",
					align          = "center",
					formatted      = "Rating",
					ratinglist     = "0=Yellow,1=Green,9=Red"}>						

<cfset itm = itm+1>					
<cfset fields[itm] = {label        = "key",    					
					display        = "No",					
					field          = "TransactionId"}>		

<cftry>
								
	<cf_listing
	    header        = "lsTransaction"
	    box           = "lsTransaction_#url.customerid#"
		link          = "#SESSION.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Charges/InvoiceListingContent.cfm?customerid=#url.customerid#&systemfunctionid=#url.systemfunctionid#"
	    html          = "No"
		show          = "42"
		datasource    = "AppsWorkorder"
		listquery     = "#myquery#"
		listkey       = "TransactionId"		
		listorder     = "JournalBatchDate"
		listorderdir  = "DESC"
		headercolor   = "ffffff"
		listlayout    = "#fields#"
		filterShow    = "Hide"
		excelShow     = "Yes"
		annotation    = "GLTransaction"
		drillmode     = "tab"
		drillargument = "900;1200;false;false"	
		drilltemplate = "Gledger/Application/Transaction/View/TransactionView.cfm?id="
		drillkey      = "TransactionId">
	
	<cfcatch>
	
	 <cf_message width="100%"
			height="80"
			message="An error has occurred retrieving your data <br>#CFCatch.Message# - #CFCATCH.Detail#" return="no">
	
	</cfcatch>		
	
</cftry>		
	