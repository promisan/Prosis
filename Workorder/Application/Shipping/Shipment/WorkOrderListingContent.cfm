
<cfparam name="url.systemfunctionid"    default="">
<cfparam name="url.mission"             default="">
<cfparam name="url.transactionlot"      default="">
<cfparam name="url.status"              default="0">

<!--- update workorder line which have been completely shipped --->
	
<cfoutput>

<!--- check if status exists in workflow --->

<cfquery name="status" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT  * 
	FROM    Ref_EntityStatus 
	WHERE   EntityCode = 'WrkStatus'	
</cfquery>  

<cfsavecontent variable="myquery">
	
	SELECT     W.WorkOrderId,
	           C.CustomerName,
	           C.City, 
			   W.Reference, 
			   <cfif status.recordcount gte "1">
			   E.StatusDescription,
			   <cfelse>
			   W.ActionStatus, 
			   </cfif>
			   S.Description, 
			   W.OrderDate,	
			   <!---		  
			   T.TransactionLot,
			   --->
	           (SELECT    MAX(DateExpiration)
	            FROM      WorkOrderLine
	            WHERE     WorkorderId = W.WorkorderId AND Operational = 1) AS DueDate, 
				
			   (SELECT    CASE WHEN (Count(*) = 0) THEN 'N' ELSE 'Y' END
	            FROM      Materials.dbo.ItemTransaction IT
				WHERE     WorkOrderId = W.WorkOrderId
				AND       TransactionType = '2'
				AND       TransactionId IN (SELECT TransactionId
				                            FROM    Materials.dbo.ItemTransactionShipping 
											WHERE  TransactionId = IT.TransactionId)
				) AS Shipped, 
				
			    W.Created
	FROM        WorkOrder W 
				INNER JOIN      Customer C ON W.CustomerId = C.CustomerId 
				INNER JOIN      ServiceItem S ON W.ServiceItem = S.Code 	
				<cfif status.recordcount gte "1">
				INNER JOIN      Organization.dbo.Ref_EntityStatus E ON E.EntityStatus = W.ActionStatus AND EntityCode = 'WrkStatus'	
				</cfif>							
				<!--- added to show any lots associated to this workorder
				LEFT OUTER JOIN Materials.dbo.ItemTransaction T ON W.WorkOrderId = T.WorkorderId
				--->
	WHERE       W.Mission = '#URL.Mission#'
	
	<cfif url.status eq "Pending">
	AND         W.ActionStatus IN ('0','1')
	</cfif>	
	
	<cfif url.transactionlot neq "">
	AND        W.WorkorderId IN 
	                        (SELECT WorkOrderId 
							 FROM   Materials.dbo.Itemtransaction 
							 WHERE  WorkOrderId = W.WorkOrderId 
					         AND    Mission = '#url.mission#' 
							 AND    TransactionLot LIKE ('%#url.transactionlot#%'))
	
	</cfif>
		
	<!--- ------------------------------------------------ --->
	<!--- only workorders meant for external/sale shipment --->
	<!--- ------------------------------------------------ --->
	
	AND    W.WorkOrderId IN (
	
		    SELECT DISTINCT WOLI.WorkOrderId
			FROM   WorkOrderLineItem WOLI INNER JOIN
		           WorkOrderLine WL ON WOLI.WorkOrderId = WL.WorkOrderId AND WOLI.WorkOrderLine = WL.WorkOrderLine INNER JOIN
		           Ref_ServiceItemDomainClass R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code INNER JOIN
		           WorkOrder W ON WL.WorkOrderId = W.WorkOrderId
			<!--- only workorders that are meant for sale --->	   
			WHERE  R.PointerSale = '1' 
			<!--- not completed or cancelled workorder lines --->
			AND    WL.ActionStatus NOT IN ('3','9')
			AND    WL.Operational = 1
			AND    W.Mission = '#url.mission#'
			
			)	 		

</cfsavecontent>

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

<cfset itm = itm+1>				
<cf_tl id="Description" var="vDescription">
<cfset fields[itm] = {label     = "#vDescription#",                    
    				field       = "Description",																
					alias        = "S",	
					fieldsort    = "Description",																		
					searchfield  = "Description",
					search       = "text"}>				
													
<cfset itm = itm+1>
<cf_tl id="Reference" var="vReference">
<cfset fields[itm] = {label       = "#vReference#",                    
    				field         = "Reference",		
					functionscript = "workorderview",
					functionfield = "workorderid",															
					alias         = "W",	
					fieldsort     = "Reference",																		
					searchfield   = "Reference",
					searchalias   = "W",
					search        = "text"}>		
				
<cfset itm = itm+1>				
<cf_tl id="Customer" var="vCustomer">
<cfset fields[itm] = {label      = "#vCustomer#",                    
    				field        = "CustomerName",																
					alias        = "C",	
					filtermode   = "2",					
					search       = "text"}>		

<cfset itm = itm+1>					
<cf_tl id="Prior" var="vPrior">
<cfset fields[itm] = {label     = "#vPrior#",
					field       = "Shipped", 							
					align       = "center"}>	
										
<cfset itm = itm+1>				
<cf_tl id="City" var="vCity">
<cfset fields[itm] = {label      = "#vCity#",                    
    				field        = "City",																
					alias        = "C",	
					filtermode   = "2",					
					search       = "text"}>		

			
										
<cfset itm = itm+1>

<cfif status.recordcount gte "1">
			
<cf_tl id="Status" var="vStatus">
<cfset fields[itm] = {label      = "#vStatus#",                    
    				field        = "StatusDescription",																
					alias        = "E",	
					filtermode   = "2",					
					search       = "text"}>		

<cfelse>					
				
<cf_tl id="Status" var="vStatus">
<cfset fields[itm] = {label      = "#vStatus#",                    
    				field        = "ActionStatus",																
					alias        = "W",	
					filtermode   = "2",					
					search       = "text"}>			
</cfif>					
		
<!---					
<cfset itm = itm+1>				
<cf_tl id="Lot" var="vLot">
<cfset fields[itm] = {label     = "#vLot#",                    
    				field       = "TransactionLot",																
					alias        = "T",																						
					searchfield  = "TransactionLot",		
					filtermode   = "4",			
					search       = "text"}>		
					
--->					
							
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
					alias       = "W",	
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
		link              = "#SESSION.root#/WorkOrder/Application/Shipping/Shipment/WorkOrderListingContent.cfm?systemfunctionid=#url.systemfunctionid#&Status=#url.status#&Mission=#URL.Mission#"
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
		filtershow        = "hide"
		excelshow         = "Yes" 	
		screentop         = "No"	
		listlayout        = "#fields#"
		drillmode         = "tab" 
		drillargument     = "950;1050;true;true"	
		drilltemplate     = "WorkOrder/Application/Shipping/Shipment/ShipmentEntry.cfm?systemfunctionid=#url.systemfunctionid#&header=1&mode=listing&workorderid="
		drillkey          = "WorkorderId"
		drillbox          = "blank">	
		
</td></tr></table>		