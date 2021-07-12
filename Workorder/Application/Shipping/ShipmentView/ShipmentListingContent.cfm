
<!---
1. Batch
2. Customer
3. Date
4. Item
5. UoM
6. Classification
7. Description
8. Quantity
9. COGS total
10. Sales totale
--->


<cfparam name="url.systemfunctionid"    default="">
<cfparam name="url.mission"             default="">
<cfparam name="url.status"              default="all">
	
<cfoutput>

<cfquery name="Topic" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    Code
	FROM      Ref_Topic
	WHERE     Operational = 1 
	AND       Code <> 'UOM'
</cfquery>	

<cfsavecontent variable="myquery">

	SELECT * --, TransactionDate
	FROM (
	
	SELECT     	C.CustomerName, 
	            W.Reference, 
				T.TransactionBatchNo, 
				B.TransactionDate, 
				B.ActionStatus,
				T.ItemNo, 
				T.ItemDescription, 
				I.Classification, 
				
				<!--- item classification details included --->
				
				<cfloop query="Topic">
				
				 (SELECT    (SELECT  ListValue
                             FROM    Purchase.dbo.Ref_TopicList AS p
                             WHERE   Code     = ic.Topic 
							 AND     ListCode = ic.ListCode) 
                  FROM       ItemClassification AS ic
                  WHERE      Topic = '#code#' 
				  AND        ItemNo = T.ItemNo) AS Classification#Code#,
								
				</cfloop>			
										
				
	            T.TransactionQuantity * - 1 AS TransactionQuantity, 
				T.TransactionCostPrice, 				
				T.TransactionLot,
				T.TransactionReference,
				TS.Journal,
				TS.JournalSerialNo,
				(SELECT JournalTransactionNo
				 FROM   Accounting.dbo.TransactionHeader H
				 WHERE  Journal = TS.Journal
				 AND    JournalSerialNo = TS.JournalSerialNo) as JournalTransactionNummer,
				TS.SalesCurrency, 
				
				TS.SalesPrice, 
				TS.SalesAmount, 
				TS.SalesTax, 
				TS.SalesTotal
				
					
	FROM        ItemTransaction T 
				INNER JOIN ItemTransactionShipping TS ON T.TransactionId = TS.TransactionId 
				INNER JOIN WorkOrder.dbo.WorkOrder W ON T.WorkOrderId = W.WorkOrderId 
				INNER JOIN WorkOrder.dbo.Customer C ON W.CustomerId = C.CustomerId 
				INNER JOIN Item I ON T.ItemNo = I.ItemNo 
				INNER JOIN WarehouseBatch B ON T.TransactionBatchNo = B.BatchNo
								
	WHERE       T.WorkOrderId IS NOT NULL 
	AND         T.Mission         = '#url.mission#' 
	AND         T.TransactionType IN ('2','3') 
	
	<!--- pending transactions only --->
	-- AND         B.ActionStatus    = '0'   
	<cfif url.id1 eq "today">
	AND         T.TransactionDate > getDate()-1
	<cfelseif url.id1 eq "week">
	AND         T.TransactionDate > getDate()-30
	<cfelseif url.id1 eq "year">
	AND         YEAR(T.TransactionDate) = #year(now())#	
	<cfelseif url.id1 eq "lastyear">
	AND         YEAR(T.TransactionDate) = #year(now())-1#	
	</cfif>
	
	) D
	WHERE 1=1
	--condition

</cfsavecontent>

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
								
<cfset itm = itm+1>

<cf_tl id="DocumentNo" var="vShipmentNo">
<cfset fields[itm] = {label      = "#vShipmentNo#",                    
    				field        = "TransactionBatchNo",																					
					filtermode   = "2",								
					search       = "text"}>		

<cfset itm = itm+1>				
<cf_tl id="Customer" var="vCustomer">
<cfset fields[itm] = {label     = "#vCustomer#",                    
    				field       = "CustomerName",																																								
					searchfield  = "CustomerName",
					filtermode   = "2",		
					search       = "text"}>		
					
<cfif url.id1 eq "today" or url.id1 eq "week">					
									
<cfset itm = itm+1>					
<cf_tl id="Date" var="vDate">
<cfset fields[itm] = {label     = "#vDate#",
					field       = "TransactionDate", 						
					formatted   = "dateformat(TransactionDate,CLIENT.DateFormatShow)",		
					align       = "center"}>						
					
<cfset 	filter = "Yes">				

<cfelse>

								
<cfset itm = itm+1>					
<cf_tl id="Date" var="vDate">
<cfset fields[itm] = {label     = "#vDate#",
					field       = "TransactionDate", 						
					formatted   = "dateformat(TransactionDate,CLIENT.DateFormatShow)",		
					align       = "center",		
					search      = "date"}>			

<cfset 	filter = "Yes">	

</cfif>		

				
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "S", 	
                    LabelFilter   = "Status",				
					field         = "ActionStatus",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=Yellow,1=Green,9=Red"}>		
											
						
<cfset itm = itm+1>				
<cf_tl id="Code" var="vCode">
<cfset fields[itm] = {label      = "#vCode#",                    
    				field        = "Classification",																								
					filtermode   = "2",					
					search       = "text"}>		
					
<cfset itm = itm+1>				
<cf_tl id="Product" var="vProduct">
<cfset fields[itm] = {label      = "#vProduct#",                    
    				field        = "ItemDescription",																					
					filtermode   = "2",					
					search       = "text"}>		
					
<cfset itm = itm+1>				
<cf_tl id="Quantity" var="vQuantity">
<cfset fields[itm] = {label      = "#vQuantity#",                    
    				field        = "TransactionQuantity",																					
					align        = "center",					
					search       = "number"}>	
					
<cfset itm = itm+1>				
<cf_tl id="Currency" var="vCurrency">
<cfset fields[itm] = {label      = "#vCurrency#",                    
    				field        = "SalesCurrency"}>																		
					
<cfset itm = itm+1>				
<cf_tl id="Price" var="vPrice">
<cfset fields[itm] = {label      = "#vPrice#",                    
    				field        = "SalesPrice",		
					align        = "right",		
					formatted    = "numberformat(SalesPrice,'.__')"}>		
					
<cfset itm = itm+1>				
<cf_tl id="Tax" var="vTax">
<cfset fields[itm] = {label      = "#vTax#",                    
    				field        = "SalesTax",	
					align        = "right",		
					formatted    = "numberformat(SalesTax,'.__')"}>							
										
<cfset itm = itm+1>				
<cf_tl id="Total" var="vTotal">
<cfset fields[itm] = {label      = "#vTotal#",                    
    				field        = "SalesTotal",	
					align        = "right",		
					formatted    = "numberformat(SalesTotal,'.__')"}>					
					
<!--- hidden key field --->
<cfset itm = itm+1>				
<cf_tl id="TrenasactionId" var="vId">
<cfset fields[itm] = {label     = "#vId#",                    
    				field       = "TransactionId",																
					alias       = "T",	
					display     = "No",
					align       = "center"}>						

<!--- adding is currently done from the finishe product line --->

<!---
		
<cfif filter eq "active">
		
	<!--- define access as requisitioner --->
	
	<cfinvoke component = "Service.Access"  
		   method           = "WorkorderProcessor" 
		   mission          = "#mission#"	  		  
		   returnvariable   = "access">	
					
		<cfif access eq "EDIT" or access eq "ALL">		
		
				<cf_tl id="Add Requisition" var="vAdd">
				
				<cfset menu[1] = {label = "#vAdd#", icon = "insert.gif",	script = "requisitionadd('#mission#','#url.workorderid#','#url.workorderline#','')"}>				 
				
		</cfif>						
	
</cfif>						

--->

<cfset menu = "">
	
<!--- embed|window|dialogajax|dialog|standard --->

							
<cf_listing
	    header            = "shipment"
	    box               = "lineshipment"
		link              = "#SESSION.root#/WorkOrder/Application/Shipping/ShipmentView/ShipmentListingContent.cfm?id1=#url.id1#&systemfunctionid=#url.systemfunctionid#&Status=#url.status#&Mission=#URL.Mission#"
	    html              = "No"						
		datasource        = "AppsMaterials"		
		listquery         = "#myquery#"		
		listgroup         = "CustomerName"
		listorderfield    = "TransactionDate"		
		listorderdir      = "ASC"
		headercolor       = "ffffff"
		show              = "60"				
		filtershow        = "#filter#"
		excelshow         = "Yes" 	
		screentop         = "No"	
		listlayout        = "#fields#"
		drillmode         = "tab" 
		drillargument     = "920;1250;true;true"	
		drilltemplate     = "Warehouse/Application/Stock/Batch/BatchView.cfm?systemfunctionid=#url.systemfunctionid#&header=1&mode=process&batchno="
		drillkey          = "TransactionBatchNo"
		drillbox          = "blank">	
		
