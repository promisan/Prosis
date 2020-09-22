
<cfparam name="url.mission" default="">

<cfsavecontent variable="myquery">		
	<cfoutput>

		SELECT      C.Mission, 
		            C.CustomerId, 		            
					C.CustomerName,
					B.BatchNo, 
					CB.CustomerInvoiceName, 
					C.MobileNumber, 
					C.EMailAddress,
					C.Reference, 
					B.Warehouse, 
					W.WarehouseName, 
					B.BatchReference, 
					B.TransactionDate, 
                    B.TransactionType, 
					B.BatchId, 
					
					ISNULL((
					   SELECT SUM(TL.AmountDebit - TL.AmountCredit)
					   FROM   Accounting.dbo.TransactionLine as TL INNER JOIN Accounting.dbo.TransactionHeader as TH ON TL.Journal = TH.Journal
						   AND TL.JournalSerialNo = TH.JournalSerialNo
						   AND TH.ReferenceId IN (
								  SELECT TransactionID 
								  FROM   Materials.dbo.ItemTransaction 
								  WHERE  TransactionBatchNo = B.BatchNo 
								  AND     TransactionType = '2'
					   ) WHERE TL.Reference ='COGS'
					),0) as AmountCOGS,
					
					ISNULL((
					   SELECT SUM(TL.AmountDebit - TL.AmountCredit)
					   FROM   Accounting.dbo.TransactionLine as TL INNER JOIN Accounting.dbo.TransactionHeader as TH  ON TL.Journal = TH.Journal
					   		  AND TL.JournalSerialNo = TH.JournalSerialNo
							  AND TH.TransactionSourceId = B.BatchId
							  AND TH.Reference = 'Receivables'
					   WHERE  TL.TransactionSErialNo ='0'
					),0) as AmountSALE,
					
					ISNULL((
					   SELECT ABS(SUM(TL.AmountDebit - TL.AmountCredit))
					   FROM   Accounting.dbo.TransactionLine as TL INNER JOIN Accounting.dbo.TransactionHeader as TH ON TL.Journal = TH.Journal
							   AND TL.JournalSerialNo = TH.JournalSerialNo
							   AND TH.TransactionSourceId = B.BatchId
							   AND TH.Reference = 'Receivables'
					   WHERE   TL.Reference = 'Sales Tax'
					),0) as AmountTAX,
					
					ISNULL((
					   SELECT ABS(SUM(TL.AmountDebit - TL.AmountCredit))
					   FROM   Accounting.dbo.TransactionLine as TL INNER JOIN Accounting.dbo.TransactionHeader as TH ON TL.Journal = TH.Journal
							   AND TL.JournalSerialNo = TH.JournalSerialNo
							   AND TH.TransactionSourceId = B.BatchId
							   AND TH.Reference = 'Settlement'
					   WHERE   TL.TransactionSerialNo ='0'					   
					),0) as AmountSettled,
					
					ISNULL((
					   SELECT TOP 1 TH.Currency
					   FROM   Accounting.dbo.TransactionLine as TL INNER JOIN Accounting.dbo.TransactionHeader as TH ON TL.Journal = TH.Journal
					   		   AND TL.JournalSerialNo = TH.JournalSerialNo
   							   AND TH.TransactionSourceId = B.BatchId
							   AND TH.Reference = 'Settlement'					   
					),0) as SettleCurrency,
					
					B.OfficerUserId, 
					B.OfficerLastName, 
					B.OfficerFirstName, 
					B.Created										
					
		FROM        Materials.dbo.WarehouseBatch AS B 
					INNER JOIN  (SELECT CustomerID, CustomerName as CustomerInvoiceName 
								 FROM Materials.dbo.Customer ) as CB ON CB.CustomerID = B.CustomerIdInvoice 
					INNER JOIN   Materials.dbo.Customer AS C ON B.CustomerId = C.CustomerId 
					INNER JOIN   Materials.dbo.Warehouse AS W ON B.Warehouse = W.Warehouse
		WHERE       B.CustomerId = '#url.customerid#' 
		<cfif url.mission neq "">
		AND         B.Mission = '#url.mission#'
		</cfif>
		AND         B.ActionStatus != '9'
		ORDER BY    B.TransactionDate DESC
	</cfoutput>
</cfsavecontent>


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

<cf_tl id="Time" var="1">
					  
<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "#lt_text#",                  
					  field         = "TransactionDate",					 
					  displayfilter = "No",					 
					  formatted     = "timeformat(TransactionDate,'HH:MM')"}>						  

<cf_tl id="Store" var="1">					  

<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "#lt_text#",                  
					  field         = "WarehouseName",
					  filtermode    = "2",
					  display		= "Yes",
					  displayfilter = "Yes",
					  search        = "text"}>	
					  
<cf_tl id="Officer" var="1">						  
<cfset itm = itm+1>		
<cfset fields[itm] = {label       = "#lt_text#",                  
					  field       = "OfficerUserId"}>					  

<cf_tl id="Invoice" var="1">						  
<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "#lt_text#",                  
					  field         = "BatchReference",
					  filtermode    = "1",
					  display		= "Yes",
					  displayfilter = "Yes",
					  search        = "text"}>	

<cf_tl id="SalesNo" var="1">						  
<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "#lt_text#",                  
					  field         = "BatchNo",
					  filtermode    = "1",
					  display		= "Yes",
					  displayfilter = "Yes",					  					  
					  functionscript    = "batch",
					  functionfield     = "BatchNo",								  	
					  search        = "text"}>
					  
<cf_tl id="Bill To" var="1">						  
<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "#lt_text#",                  
					  field         = "CustomerInvoiceName",
					  displayfilter = "Yes",
					  search        = "text"}>	

<cf_tl id="Currency" var="1">					  
<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "#lt_text#",                  
					  field         = "SettleCurrency",
				      filtermode    = "2",
					  displayfilter = "Yes",
					  search        = "text"}>	

<cf_tl id="COGS" var="1">						  
<cfset itm = itm+1>							
<cfset fields[itm] = {label         = "#lt_text#",  					
					  field         = "AmountCOGS",
					  align 		= "right",
					  width         = "20",
					  formatted     = "NumberFormat(AmountCOGS,',.__')"}>

<cf_tl id="Tax" var="1">	
<cfset itm = itm+1>							
<cfset fields[itm] = {label         = "#lt_text#",  					
					  field         = "AmountTAX",
					  align 		= "right",
					  width         = "20",
					  formatted     = "NumberFormat(AmountTAX,',.__')"}>

<cf_tl id="Sale" var="1">						  
<cfset itm = itm+1>							
<cfset fields[itm] = {label         = "#lt_text#",  					
					  field         = "AmountSALE",
					  align 		= "right",
					  width         = "20",
					  formatted     = "NumberFormat(AmountSALE,',.__')"}>

<cf_tl id="Settled" var="1">						  
<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "#lt_text#",                  
					  field         = "AmountSettled",
					  align 		= "right",
					  width         = "25",
					  formatted     = "NumberFormat(AmountSALE,',.__')"}>	


					  
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr><td style="padding:10px">	
		
	<cf_listing
	    header         = "Invoices"
	    box            = "Invoices"
		link           = "#SESSION.root#/warehouse/Application/Customer/History/RecordListing.cfm?customerid=#url.customerid#&systemfunctionid=null"
	    html           = "No"
	    show           = "40"		
		datasource     = "AppsQuery"
		listquery      = "#myquery#"		
		listorder      = "BatchReference"
		listorderfield = "BatchReference"
		listorderdir   = "DESC"		
		headercolor    = "ffffff"
		listlayout     = "#fields#"
		filterShow     = "yes"
		excelShow      = "Yes"
		drillmode      = "embed"	
		drillargument  = "940;1190;false;false"	
		drillstring    = ""	
		drilltemplate  = "Warehouse/Application/Customer/History/RecordListingDetail.cfm"
		drillkey       = "BatchID">		
	</td></tr>
</table>		