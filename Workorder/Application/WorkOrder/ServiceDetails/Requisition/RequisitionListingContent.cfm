
<cfparam name="url.systemfunctionid"    default="">
<cfparam name="url.workorderid"         default="">
<cfparam name="url.workorderline"       default="">
<cfparam name="url.mission"             default="">
<cfparam name="url.operational"         default="1">
<cfparam name="url.filter"              default="active">

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	     SELECT * FROM 	WorkOrder WHERE WorkOrderId = '#url.workorderid#'			 
	</cfquery>

<cfset mission = get.Mission>
	
<cfoutput>

<cfsavecontent variable="myquery">
	SELECT   L.*, 
	         left(RequestDescription,40) as RequestDescriptionShort, 
			 R.Description as ItemMasterName,
			 P.PurchaseNo,
			 <!--- take requisition or order amount --->
			 (CASE WHEN OrderAmountBase is NULL THEN RequestAmountBase ELSE OrderAmountBase END) as OrderAmountBase,
										  
			 (CASE WHEN RequirementId IN (SELECT WorkOrderItemId 
			                              FROM   Workorder.dbo.WorkOrderLineItem 
										  WHERE  WorkOrderItemId = RequirementID) THEN 'FP' ELSE 'BOM' END) as Class
    FROM     RequisitionLine L 
	         INNER JOIN ItemMaster R ON L.ItemMaster = R.Code 
	         LEFT OUTER JOIN PurchaseLine P ON L.RequisitionNo = P.RequisitionNo AND P.ActionStatus != '9'
			 
	WHERE    L.Mission       = '#mission#'	
    AND      L.WorkOrderId   = '#url.workorderid#'
	AND      L.WorkOrderLine = '#url.workorderline#'		
	AND      L.ActionStatus != '9' and L.actionStatus >= '1'
</cfsavecontent>

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
								
<cfset itm = itm+1>

<cf_tl id="Reference" var="vReference">
<cfset fields[itm] = {label     = "#vReference#",                    
    				field       = "Reference",																
					alias        = "L",	
					fieldsort    = "Reference",																		
					searchfield  = "Reference",
					search       = "text"}>		
					
<cfset itm = itm+1>				
<cf_tl id="Class" var="vClass">
<cfset fields[itm] = {label     = "#vClass#",   
                    search      = "text",
					filtermode  = "2",                 
    				field       = "Class"}>								

<cfset itm = itm+1>				
<cf_tl id="Description" var="vDescription">
<cfset fields[itm] = {label     = "#vDescription#",                    
    				field       = "RequestDescriptionShort",																
					alias        = "L",	
					fieldsort    = "RequestDescription",																		
					searchfield  = "RequestDescription",
					search       = "text"}>		

<cfset itm = itm+1>							
<cf_tl id="PurchaseNo" var="vPurchaseNo">
<cfset fields[itm] = {label     = "#vPurchaseNo#",                    
    				field       = "PurchaseNo",																
					alias        = "P",						
					search       = "text"}>								
								
<cfset itm = itm+1>					
<cf_tl id="Date" var="vDate">
<cfset fields[itm] = {label     = "#vDate#",
					field       = "RequestDate", 		
					formatted   = "dateformat(RequestDate,CLIENT.DateFormatShow)",		
					align       = "center",		
					search      = "date"}>								

<cfset itm = itm+1>				
<cf_tl id="Quantity" var="vQuantity">
<cfset fields[itm] = {label     = "#vQuantity#",                    
    				field       = "RequestQuantity",																
					alias        = "L",	
					align       = "right",	
					fieldsort    = "RequestQuantity",																		
					searchfield  = "RequestQuantity",
					search       = "number"}>			
									
<cfset itm = itm+1>				
<cf_tl id="Amount" var="vAmount">
<cfset fields[itm] = {label      = "#vAmount#",                    
    				field        = "OrderAmountBase",																
					alias        = "L",	
					align        = "right",	
					formatted    = "numberformat(RequestAmountBase,',.__')",	
					fieldsort    = "RequestAmountBase",																		
					searchfield  = "RequestAmountBase",
					search       = "number"}>	

<!--- hidden key field --->
<cfset itm = itm+1>				
<cf_tl id="RequisitionNo" var="vReqNo">
<cfset fields[itm] = {label     = "#vReqNo#",                    
    				field       = "RequisitionNo",																
					alias       = "L",	
					display     = "No",
					align       = "center"}>	
					

<!--- adding is currently done from the finishe product line --->
		
<cfif filter eq "active">
		
	<!--- define access as requisitioner --->
	
	<cfinvoke component = "Service.Access"  
		   method           = "WorkorderProcessor" 
		   mission          = "#mission#"	  		  
		   returnvariable   = "access">	
		   
		<cfset itm = 0>   
		
		<!--- not needed here as the scope is missing for which line			
		<cfif access eq "EDIT" or access eq "ALL">	
		
				<cfset itm = itm+1>	
		
				<cf_tl id="Add Requisition" var="vAdd">
				
				<cfset menu[itm] = {label = "#vAdd#", icon = "insert.gif",	script = "requisitionadd('#mission#','#url.workorderid#','#url.workorderline#','')"}>				 
				
		</cfif>		
		--->
								
		<cfquery name="get" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_ModuleControl
			WHERE    SystemModule = 'Procurement' 
			AND      FunctionClass = 'Application' AND (FunctionName = 'Requisition Management')
		</cfquery>	
		
		<cfset itm = itm+1>	
		
		<cf_tl id="Requisition Management" var="vOpt">				
		<cfset menu[itm] = {label = "#vOpt#", icon = "insert.gif",	script = "ptoken.open('#SESSION.root#/Procurement/Application/Requisition/RequisitionView/RequisitionView.cfm?mission=#mission#&systemfunctionid=#get.systemfunctionid#&workorderId=#url.workorderid#','#url.workorderid#_req')"}>				 
	
</cfif>						
	
<!--- embed|window|dialogajax|dialog|standard --->
							
<cf_listing
	    header            = "purchase"
	    box               = "workrequisition"
		link              = "#SESSION.root#/WorkOrder/Application/Workorder/ServiceDetails/Requisition/RequisitionListingContent.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#url.workorderid#&workorderline=#url.workorderline#"
	    html              = "No"				
		tableheight       = "99%"
		tablewidth        = "99%"
		datasource        = "AppsPurchase"		
		listquery         = "#myquery#"		
		listgroup         = "ItemMasterName"
		listorderfield    = "RequestDate"
		listorderalias    = "L"		
		listorderdir      = "ASC"
		headercolor       = "ffffff"
		show              = "100"		
		menu              = "#menu#"		
		filtershow        = "Hide"
		excelshow         = "Yes" 	
		screentop         = "No"	
		listlayout        = "#fields#"
		drillmode         = "securewindow" 
		drillargument     = "880;1050;true;true"	
		drilltemplate     = "Procurement/Application/Requisition/Requisition/RequisitionEdit.cfm?header=1&mode=listing&id="
		drillkey          = "RequisitionNo"
		drillbox          = "blank">	
		
	