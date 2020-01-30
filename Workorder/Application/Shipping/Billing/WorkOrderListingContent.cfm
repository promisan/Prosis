
<cfparam name="url.systemfunctionid"    default="">
<cfparam name="url.mission"             default="">
<cfparam name="url.status"              default="all">
<cfparam name="url.transactionlot"      default="">
	
<cfoutput>

<cfsavecontent variable="myquery">

SELECT  *
FROM (

	
	SELECT     W.WorkOrderId,
	           C.CustomerName,
	           C.City, 
			   W.Reference, 
			   W.ActionStatus, 
			   
			   (SELECT StatusDescription
			    FROM   Organization.dbo.Ref_EntityStatus R
				WHERE  EntityCode   = 'WrkStatus'
				AND    EntityStatus = W.ActionStatus) as ActionStatusName,				
				
			   S.Description, 
			   W.OrderDate,
			   
			   			   
	           (SELECT    MAX(DateExpiration)
	            FROM      WorkOrderLine
	            WHERE     WorkorderId = W.WorkorderId AND Operational = 1) AS DueDate, 
								
				<!--- ------------------------------------------------------- --->
				<!--- ----determine transaction quantity pending billing ---- --->
				<!--- ------------------------------------------------------- --->				
			   
				   (
				   
				     SELECT SUM(Pending)
					 FROM (
					  
						     SELECT  (T.TransactionQuantity*-1) 
									   
									 - 
									 
									 <!--- transactions that were returned before being billed have no shipping record 
									 and need to be excluded in the comparison --->
			
						   			 (
										 SELECT ISNULL(SUM(TransactionQuantity),0) as Returned
				            			 FROM   Materials.dbo.ItemTransaction IT
										 WHERE  ParentTransactionId = T.TransactionId 
										 AND    TransactionType = '3'
										 AND    TransactionId NOT IN (SELECT TransactionId 
															          FROM   Materials.dbo.ItemTransactionShipping 
																	  WHERE  TransactionId = IT.Transactionid)
									  ) as Pending
									 			  
							FROM      Materials.dbo.ItemTransaction T INNER JOIN
				                      Materials.dbo.ItemTransactionShipping TS ON T.TransactionId = TS.TransactionId
									  
						    WHERE     T.WorkOrderId = W.WorkOrderId 
							
							AND       TS.ActionStatus != '9'
							
							<!--- line is not billed yet --->
							
							AND       (TS.InvoiceId IS NULL OR TS.InvoiceId NOT IN
								                          (SELECT  TransactionId
				                				           FROM    Accounting.dbo.TransactionHeader
								                           WHERE   TransactionId = TS.InvoiceId AND RecordStatus = '1')) 
			
							<!--- final product --->							   
						    AND  T.RequirementId IS NOT NULL 
							
							<!--- issuance lines and return lines if return lines are shipping lines --->	
										
							AND  T.TransactionType IN ('2','3')
							
						    ) Derrived 
						
					) as PendingBilling,	
										
			    W.Created
				
	FROM        WorkOrder W INNER JOIN
	            Customer C ON W.CustomerId = C.CustomerId INNER JOIN
	            ServiceItem S ON W.ServiceItem = S.Code
	WHERE       W.Mission = '#URL.Mission#'
	AND         W.ActionStatus IN ('0','1','3')
	
	<!--- Condition added by Armin on 3/31/2014 --->
	<cfif url.transactionlot neq "">
		AND        W.WorkorderId IN 
		                        (SELECT WorkOrderId 
								 FROM   Materials.dbo.Itemtransaction 
								 WHERE  WorkOrderId = W.WorkOrderId 
						         AND    Mission     = '#url.mission#' 
								 AND    TransactionLot LIKE ('%#url.transactionlot#%'))
		
	</cfif>
		
) as Derrived

<cfif url.id eq "CRE">

<!--- if on saldo we have negative item quantity we show this under Credit note --->

WHERE  PendingBilling <= 0

<cfelse>

<!--- if on saldo we have postive quantity we show this under to be billed --->

WHERE  PendingBilling >  0

</cfif>


<!--- condition to show only workorders that have confirmed shipment pending to be invoiced,
Hanno 23/3/2014 : technically we sould also filter to take only WorkOrderLine that are meant for sale !!
--->

</cfsavecontent>

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
								
<cfset itm = itm+1>

<cf_tl id="WorkOrder" var="vReference">
<cfset fields[itm] = {label     = "#vReference#",                    
    				field       = "Reference",	
					fieldsort    = "Reference",																		
					searchfield  = "Reference",					
					search       = "text"}>		

<cfset itm = itm+1>				
<cf_tl id="Description" var="vDescription">
<cfset fields[itm] = {label     = "#vDescription#",                    
    				field       = "Description",	
					fieldsort    = "Description",																		
					searchfield  = "Description",
					search       = "text"}>			
								

					
<cfset itm = itm+1>				
<cf_tl id="Customer" var="vCustomer">
<cfset fields[itm] = {label      = "#vCustomer#",                    
    				field        = "CustomerName",	
					filtermode   = "2",					
					search       = "text"}>		
					
<cfset itm = itm+1>				
<cf_tl id="City" var="vCity">
<cfset fields[itm] = {label      = "#vCity#",                    
    				field        = "City",	
					filtermode   = "2",					
					search       = "text"}>		
					
<cfset itm = itm+1>				
<cf_tl id="Status" var="vStatus">
<cfset fields[itm] = {label      = "#vStatus#",                    
    				field        = "ActionStatusName",	
					filtermode   = "2",					
					search       = "text"}>			
					
<cfset itm = itm+1>				
<cf_tl id="Item Qty" var="vPending">
<cfset fields[itm] = {label     = "#vPending#",                    
    				field       = "PendingBilling",	
					align       = "right",
					width       = "30",
					formatted   = "numberformat(PendingBilling,',')"}>															
					
<cfset itm = itm+1>					
<cf_tl id="Date" var="vDate">
<cfset fields[itm] = {label     = "#vDate#",
					field       = "OrderDate", 		
					formatted   = "dateformat(OrderDate,CLIENT.DateFormatShow)",		
					align       = "center",		
					search      = "date"}>		
					
<cfset itm = itm+1>					
<cf_tl id="Due" var="vDue">
<cfset fields[itm] = {label     = "#vDue#",
					field       = "DueDate", 		
					formatted   = "dateformat(DueDate,CLIENT.DateFormatShow)",		
					align       = "center"}>							
					
				
																																	

<!--- hidden key field --->
<cfset itm = itm+1>				
<cf_tl id="WorkOrderId" var="vId">
<cfset fields[itm] = {label     = "#vId#",                    
    				field       = "WorkOrderId",	
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
<tr><td valign="top">
							
<cf_listing
	    header            = "purchase"
	    box               = "linepurchase"
		link              = "#SESSION.root#/WorkOrder/Application/Shipping/Billing/WorkOrderListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&Status=#url.status#&id=#url.id#"
	    html              = "No"		
		classheader       = "labelit"
		classline         = "label"
		tableheight       = "99%"
		tablewidth        = "99%"
		datasource        = "AppsWorkorder"		
		listquery         = "#myquery#"		
		listgroup         = "CustomerName"
		listorderfield    = "OrderDate"
		listorderalias    = "W"		
		listorderdir      = "ASC"
		headercolor       = "ffffff"
		show              = "35"				
		filtershow        = "Yes"
		excelshow         = "Yes" 	
		screentop         = "No"	
		listlayout        = "#fields#"
		drillmode         = "window" 
		drillargument     = "960;1200;true;true"	
		drilltemplate     = "WorkOrder/Application/Shipping/Billing/BillingView.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&header=1&mode=listing&id=#url.id#&workorderid="
		drillkey          = "WorkorderId"
		drillbox          = "blank">	
		
</td></tr></table>		