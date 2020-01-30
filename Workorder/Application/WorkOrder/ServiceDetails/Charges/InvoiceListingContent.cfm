	
<cfquery name="getCustomer" 
	datasource="appsWorkOrder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 S.ServiceMode
		FROM   WorkOrder W, ServiceItem S
		WHERE  W.ServiceItem = S.Code
		AND    W.CustomerId = '#url.CustomerId#'	
		ORDER BY W.Created DESC
</cfquery>
	
<cfoutput>
	
	<!--- pass the result to the script --->
	<cfsavecontent variable="myquery">
	
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
				TransactionId
        FROM    Accounting.dbo.TransactionHeader AS TH INNER JOIN
                WorkOrder AS W INNER JOIN
                Customer AS C ON W.CustomerId = C.CustomerId ON TH.TransactionSourceId = W.WorkOrderId INNER JOIN
				ServiceItem AS S ON W.ServiceItem = S.Code
        WHERE   C.Customerid = '#url.customerid#'
		AND     TH.DocumentAmount <> 0

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
					
<cf_tl id="Order" var="vOrder">
<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "#vOrder#",
					field      = "Reference",
					alias      = "W",
					searchalias = "W",
					search     = "text"}>									
					

<cf_tl id="Service" var="vService">
<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "#vService#",
					field      = "Description",
					alias      = "S",
					searchalias = "S",
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
						formatted    = "dateformat(DocumentDate,'MM/YY')",
						search       = "date"}>			
					
	<cf_tl id="Closing" var="vClosing">
	<cfset itm = itm+1>					
	<cfset fields[itm] = {label      = "#vClosing#",  					
						field      = "JournalBatchDate",					
						formatted  = "dateformat(JournalBatchDate,'DD/MM/YY')",
						search     = "date"}>		
					
</cfif>			
																
										
<cf_tl id="Posting" var="vPosting">
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "#vPosting#",  					
					field      = "TransactionDate",					
					formatted  = "dateformat(TransactionDate,'DD/MM/YY')",
					search     = "date"}>		
					
	
<cf_tl id="Cur" var="vCur">
<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "#vCur#.",
					field      = "Currency",
					filtermode = "2",
					labelfilter = "Currency",
					search     = "text"}>	
								
<cf_tl id="Amount" var="vAmount">
<cfset itm = itm+1>										
<cfset fields[itm] = {label      = "#vAmount#",  
					field      = "Amount",
					search     = "number",					
					align      = "right",
					formatted  = "numberformat(Amount,',.__')"}>	
					
<cf_tl id="Balance" var="vOutstanding">
<cfset itm = itm+1>										
<cfset fields[itm] = {label      = "#vOutstanding#",  
					field      = "AmountOutstanding",
					search     = "number",
					aggregate  = "sum",
					align      = "right",
					formatted  = "numberformat(AmountOutstanding,',.__')"}>						

<cfset itm = itm+1>	
<cf_tl id="Status" var="vStatus">					
<cfset fields[itm] = {label       = "S", 	
                    LabelFilter   = "Status",				
					field         = "ActionStatus",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=Yellow,1=Green,9=Red"}>						

<cfset itm = itm+1>					
<cfset fields[itm] = {label     = "key",    					
					display    = "No",					
					field      = "TransactionId"}>		

<cftry>
							
<cf_listing
    header        = "lsTransaction"
    box           = "lsTransaction"
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
	filterShow    = "Yes"
	excelShow     = "Yes"
	annotation    = "GLTransaction"
	drillmode     = "securewindow"
	drillargument = "900;1200;false;false"	
	drilltemplate = "Gledger/Application/Transaction/View/TransactionViewDetail.cfm?id="
	drillkey      = "TransactionId">
	
	<cfcatch>
	
	 <cf_message width="100%"
			height="80"
			message="An error has occurred retrieving your data <br>#CFCatch.Message# - #CFCATCH.Detail#" return="no">
	
	</cfcatch>		
	
</cftry>		
	