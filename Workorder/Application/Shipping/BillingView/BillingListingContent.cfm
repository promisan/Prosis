
<!---
1. Journal
2. SerialNo
3. TraNo
4. Date
5. Period
6. Currency
7. Amount
8. Outstanding
--->

<cfparam name="url.systemfunctionid"    default="">
<cfparam name="url.mission"             default="">
<cfparam name="url.status"              default="all">
	
<cfoutput>

<cfsavecontent variable="myquery">
	
     SELECT     Journal, 
	            JournalSerialNo, 
				TransactionId, 
				JournalTransactionNo, 
				TransactionDate, 
				ReferenceName, 
				TransactionPeriod, 
				Currency, 
				Amount, 
				AmountOutstanding, 
                ActionStatus, 
				RecordStatus,
				OfficerUserId, 
				OfficerLastName, 
				OfficerFirstName
	FROM        TransactionHeader H
	WHERE       TransactionSource   = 'WorkOrderSeries' 
	AND         TransactionCategory = 'Receivables' 
	AND         Created >= GETDATE() - 360 	
	AND         Mission = '#url.mission#' 
    AND         (
					ReferenceId IN (SELECT WorkOrderId FROM WorkOrder.dbo.WorkOrder WHERE Mission = H.Mission)
					OR EXISTS
					(
					    SELECT  'X'
					    FROM	  TransactionLine
					    WHERE	  Journal = H.Journal
					    AND	  JournalSerialNo = H.JournalSerialNo
					    AND	  ReferenceId IN (SELECT WorkOrderId FROM WorkOrder.dbo.WorkOrder WHERE Mission = H.Mission)	
					)
				)
	AND         ActionStatus != '9' 
	AND         RecordStatus != '9'				  

	
</cfsavecontent>

</cfoutput>

<!--- pending --->

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
								
<cfset itm = itm+1>

<cf_tl id="Journal" var="vJournal">
<cfset fields[itm] = {label      = "#vJournal#",                    
    				field        = "Journal",																
					alias        = "H",
					filtermode   = "2",								
					search       = "text"}>		
					
<cfset itm = itm+1>		
<cf_tl id="SerialNo" var="vSerialNo">
<cfset fields[itm] = {label      = "#vSerialNo#",                    
    				field        = "JournalSerialNo",																
					alias        = "H"}>			
					
			
				
<cfset itm = itm+1>		
<cf_tl id="Status" var="vStatus">										
<cfset fields[itm] = {label       = "S", 					
                    LabelFilter   = "#vStatus#",	
					field         = "RecordStatus",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "1=Green,9=Red"}>														

<cfset itm = itm+1>				
<cf_tl id="InvoiceNo" var="vJournalTransactionNo">
<cfset fields[itm] = {label     = "#vJournalTransactionNo#",                    
    				field       = "JournalTransactionNo",																
					alias        = "H",	
					search       = "text"}>		
				
									
<cfset itm = itm+1>					
<cf_tl id="Issued" var="vDate">
<cfset fields[itm] = {label     = "#vDate#",
					field       = "TransactionDate", 	
					alias        = "H",						
					formatted   = "dateformat(TransactionDate,CLIENT.DateFormatShow)",		
					align       = "center",		
					search      = "date"}>		
					
<cfset itm = itm+1>		
<cf_tl id="Workflow" var="vStatus">										
<cfset fields[itm] = {label       = "Wf", 					
                    LabelFilter   = "#vStatus#",	
					field         = "ActionStatus",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=Yellow,1=gray"}>	
																		
						
					
<cfset itm = itm+1>				
<cf_tl id="Customer" var="vCustomer">
<cfset fields[itm] = {label      = "#vCustomer#",                    
    				field        = "ReferenceName",																
					alias        = "H",						
					filtermode   = "2",					
					search       = "text"}>		
					
<cfset itm = itm+1>				
<cf_tl id="Currency" var="vCurrency">
<cfset fields[itm] = {label      = "#vCurrency#",                    
    				field        = "Currency",																									
					alias        = "H"}>																		
					
<cfset itm = itm+1>				
<cf_tl id="Amount" var="vAmount">
<cfset fields[itm] = {label      = "#vAmount#",                    
    				field        = "Amount",		
					align        = "right",		
					formatted    = "numberformat(Amount,'__.__')",																			
					alias        = "H"}>		
							
<!--- hidden key field --->
<cfset itm = itm+1>				
<cf_tl id="TranssactionId" var="vId">
<cfset fields[itm] = {label     = "#vId#",                    
    				field       = "TransactionId",																
					alias       = "H",	
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

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr><td valign="top" height="700">
							
<cf_listing
	    header            = "billing"
	    box               = "lineshipment"
		link              = "#SESSION.root#/WorkOrder/Application/Shipping/BillingView/BillingListingContent.cfm?systemfunctionid=#url.systemfunctionid#&Status=#url.status#&Mission=#URL.Mission#"
	    html              = "No"		
		classheader       = "labelit"
		classline         = "label"
		tableheight       = "99%"
		tablewidth        = "99%"
		datasource        = "AppsLedger"		
		listquery         = "#myquery#"		
		listgroup         = "ReferenceName"
		listorderfield    = "TransactionDate"
		listorderalias    = "H"		
		listorderdir      = "ASC"
		headercolor       = "ffffff"
		show              = "35"				
		filtershow        = "Yes"
		excelshow         = "Yes" 	
		screentop         = "No"	
		listlayout        = "#fields#"
		drillmode         = "window" 
		drillargument     = "950;1150;true;true"	
		drilltemplate     = "/Gledger/Application/Transaction/View/TransactionView.cfm?id="
		drillkey          = "TransactionId"
		drillbox          = "blank">	
		
</td></tr></table>	
