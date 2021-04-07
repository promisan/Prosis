<cfparam name="URL.Mission" default="HSA">
<cfparam name="URL.ID1"     default="">

<cfsavecontent variable="myquery">

	<cfoutput>	
	
	SELECT *, AmountPending
	FROM (
	
	    SELECT *, (AmountSale - AmountBilled) as AmountPending
		FROM (  	
		SELECT        W.WorkOrderId,
		              WL.WorkOrderLine, 
					  WL.WorkOrderLineId, 
					  C.CustomerName, 
					  W.Reference, 
					  W.OrderDate, 
					  W.Currency,
					  WL.ActionStatus, 
					  W.Mission, 
					  W.ServiceItem, 
		              S.Description,
		              
	                 ( SELECT    ISNULL(ROUND(SUM(SaleAmountIncome), 2), 0)
                       FROM      WorkOrderLineItem
                       WHERE     WorkOrderId   = WL.WorkOrderId 
					   AND       WorkOrderLine = WL.WorkOrderLine) AS AmountSale,
							 
                     ( SELECT    ISNULL(ROUND(SUM(TS.SalesAmount), 2), 0) 
                       FROM      Materials.dbo.ItemTransactionShipping AS TS INNER JOIN
                                 Materials.dbo.ItemTransaction AS T ON TS.TransactionId = T.TransactionId
                       WHERE     T.WorkOrderId   = WL.WorkOrderId 
					   AND       T.WorkOrderLine = WL.WorkOrderLine 
					   AND       T.TransactionType = '2') AS AmountShipped,
					   
                     ( SELECT    ISNULL(ROUND(SUM(TS.SalesAmount), 2), 0) 
                       FROM      Materials.dbo.ItemTransactionShipping AS TS INNER JOIN
                                 Materials.dbo.ItemTransaction AS T ON TS.TransactionId = T.TransactionId
                       WHERE     T.WorkOrderId   = WL.WorkOrderId 
					   AND       T.WorkOrderLine = WL.WorkOrderLine 
					   AND       T.TransactionType = '2'
					   AND       EXISTS (     SELECT      'X'
	                                          FROM        Accounting.dbo.TransactionHeader
	                                          WHERE       TransactionId = TS.InvoiceId 
											  AND         RecordStatus <> '9' 
											  AND         ActionStatus <> '9')
										  
					   ) AS AmountBilled
					   									   		   
					  						 
		FROM        WorkOrderLine AS WL INNER JOIN
		            WorkOrder AS W ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
		            Customer AS C ON W.CustomerId = C.CustomerId INNER JOIN
		            ServiceItem AS S ON W.ServiceItem = S.Code INNER JOIN
		            Ref_ServiceItemDomainClass AS R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code
					
		WHERE       W.Mission = '#URL.Mission#' 
		AND         W.ActionStatus <= '3' 
		AND         WL.Operational = 1 
		AND         R.PointerSale = 1		
		) as tab
		
		<cfif find("Pending",  url.id1)>
		WHERE AmountSale <> 0
		</cfif>
				
		) as D
		
		WHERE 1=1 
		--condition
	</cfoutput>	
	
</cfsavecontent>


<cfset itm = 0>

<cfset fields=ArrayNew(1)>
							
	<cfset itm = itm+1>
	<cf_tl id="Customer" var = "1">			
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "CustomerName",					
						alias         = "",							
						width         = "40",																	
						search        = "text",
						filtermode    = "2"}>		
				
	<cfset itm = itm+1>
	<cf_tl id="Reference" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "Reference",						
						width         = "20",																		
						search        = "text"}>												

	<cfset itm = itm+1>
	<cf_tl id="Date" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    	                   
	     				field       = "OrderDate",																																												
						search      = "date",
						formatted   = "dateformat(OrderDate,client.dateformatshow)"}>
	
	<!---
	<cfset itm = itm+1>
	<cf_tl id="ServiceItem" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "ServiceItem",						
						width         = "30",																		
						search        = "text"}>	
						
						--->							

	<cfset itm = itm+1>
	<cf_tl id="Description" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "Description",						
						width         = "40",																		
						search        = "text",
						filtermode    = "2"}>	
						
	<cfset itm = itm+1>
	<cf_tl id="Currency" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "Currency",						
						width         = "7",																		
						search        = "text",
						filtermode    = "2"}>											


	<cfset itm = itm+1>
	<cf_tl id="Sale" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "AmountSale",
	     				align         = "right",						
						width         = "20",																		
						search        = "number",
						formatted     = "numberformat(AmountSale,',__')"}>
													

	<cfset itm = itm+1>
	<cf_tl id="Shipped" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "AmountShipped",
	     				align         = "right",						
						width         = "20",																		
						search        = "number",
						formatted     = "numberformat(AmountShipped,',__')"}>

	<cfset itm = itm+1>
	<cf_tl id="Billed" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "AmountBilled",
	     				align         = "right",						
						width         = "20",																		
						search        = "number",
						formatted     = "numberformat(AmountBilled,',__')"}>
																		
	<cfset itm = itm+1>
	<cf_tl id="Pending" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "AmountPending",						
	     				align         = "right",	
						aggregate     = "sum",					
						width         = "20",																		
						search        = "number",
						formatted     = "numberformat(AmountPending,',__')"}>

	<cfset itm = itm+1>		
	<cf_tl id="Status" var = "1">		
	<cfset fields[itm] = {label       = "S",      
						LabelFilter = "#lt_text#", 
						field       = "ActionStatus",  
						width       = "4",    											
						formatted   = "Rating",
						ratinglist  = "9=Red,0=white,1=Green,3=Green"}>		
																
<cfset menu=ArrayNew(1)>	

<cf_listing
	    header              = "event"
	    box                 = "eventlisting"
		link                = "#SESSION.root#/WorkOrder/Application/Shipping/WorkOrderView/WorkOrderListingContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		font                = "Calibri"
		datasource          = "AppsWorkOrder"
		listquery           = "#myquery#"		
		listgroup           = "Currency"	
		listorderfield      = "OrderDate"
		listorder           = "OrderDate"
		listorderdir        = "ASC"				
		menu                = "#menu#"
		filtershow          = "Yes"
		excelshow           = "Yes" 					
		listlayout          = "#fields#"
		drillmode           = "tab" 
		drilltemplate       = "WorkOrder/Application/WorkOrder/ServiceDetails/ServiceLineView.cfm?drillid="		
		drillkey            = "WorkOrderLineId"
		drillargument       = "#client.height-90#;#client.width-90#;false;false">
