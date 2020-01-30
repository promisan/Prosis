
<cfparam name="url.workorderid"   default="">
<cfparam name="url.workorderline" default="">

<cfoutput>
<cfsavecontent variable="myquery">

	SELECT   WLA.WorkActionId,
	         R.Description,
	         WLA.SerialNo, 
			 WLA.DateTimePlanning, 
			 WLA.DateTimeActual, 
			 WLA.ActionOfficerUserId, 
			 WLA.ActionOfficerLastName, 
			 WLA.ActionOfficerFirstName
	FROM     WorkOrderLineAction WLA INNER JOIN
             WorkOrder W ON WLA.WorkOrderId = W.WorkOrderId INNER JOIN
             Ref_Action R ON WLA.ActionClass = R.Code
	WHERE    WLA.WorkOrderId   = '#url.WorkOrderId#'	
	AND      WLA.WorkorderLine = '#url.workorderline#'					 					 

</cfsavecontent>
</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
					
<cfset itm = itm+1>
<cfset fields[itm] = {label       = "Description",                   		
					  field       = "Description",					
					  alias       = "R",														
					  filtermode  = "2",
					  search      = "text"}>			

<cfset itm = itm+1>								
<cfset fields[itm] = {label     = "Planning",                    
					field       = "DateTimePlanning", 		
					formatted   = "dateformat(DateTimePlanning,CLIENT.DateFormatShow)",		
					align       = "center",		
					search      = "date"}>	
					
<cfset itm = itm+1>								
<cfset fields[itm] = {label     = "Time",                    
					field       = "DateTimePlanning", 		
					formatted   = "timeformat(DateTimePlanning,'HH:MM')",		
					align       = "center"}>						
					

<cfset itm = itm+1>								
<cfset fields[itm] = {label     = "Completion",                    
					field       = "DateTimeActual", 		
					formatted   = "dateformat(DateTimeActual,CLIENT.DateFormatShow)",		
					align       = "center",		
					search      = "date"}>							
					
<cfset itm = itm+1>								
<cfset fields[itm] = {label     = "Time",                    
					field       = "DateTimeActual", 		
					formatted   = "timeformat(DateTimeActual,'HH:MM')",		
					align       = "center"}>	
					
<cfset itm = itm+1>
<cfset fields[itm] = {label     = "FirstName",                   		
					field       = "ActionOfficerFirstName",					
					alias       = "",																	
					search      = "text"}>																	
		
<cfset itm = itm+1>
<cfset fields[itm] = {label     = "LastName",                   		
					field       = "ActionOfficerLastName",					
					alias       = "",																	
					search      = "text"}>							

<!---
						
<cfset itm = itm+1>					
					
<cfset fields[itm] = {label     = "Officer",                    
					field       = "OfficerlastName", 	
					alias       = "T.",				
					search      = "text"}>		
		
<cfset itm = itm + 1>										
					
<cfset fields[itm] = {label    = "Quantity", 					
					field      = "TransactionQuantityBase",		
					align      = "right",	
					formatted  = "numberformat(-TransactionQuantityBase,'__,__')",													
					search     = "text"}>						
	
<cfset itm = itm + 1>										
					
<cfset fields[itm] = {label    = "Price", 					
					field      = "SalesPrice",	
					align      = "right",		
					formatted  = "numberformat(SalesPrice,'__,__.__')",													
					search     = "text"}>						
					
<cfset itm = itm + 1>										
					
<cfset fields[itm] = {label    = "Amount", 					
					field      = "SalesAmount",	
					align      = "right",		
					formatted  = "numberformat(SalesAmount,'__,__.__')",					
					search     = "number"}>						

--->

<cfset menu = "">		
<cfset dt = "">
<cfset dk = "workactionid">		

<!--- define access 

<cfinvoke component = "Service.Access"  
	method          = "WorkorderProcessor" 
	mission         = "#workorder.mission#" 
	serviceitem     = "#workorder.serviceitem#"
	returnvariable  = "access">	    
					
	<cfif access eq "EDIT" or access eq "ALL">		
													
		<cfset menu[1] = {label  = "Add Record", 
		                  icon   = "insert.gif", 
						  script = "addsupply('#workorder.mission#','#url.workorderid#','#url.workorderline#')"}>				 
						  
		<cfset dt = "ItemTransaction">
		<cfset dk = "TransactionId">   				  
						  
	<cfelse>	
	
		<cfset menu = "">		
		
		<cfset dt = "">
		<cfset dk = "">			  
			
	</cfif>		
	
--->			
							
<cf_listing
	    header         = "actionlist"
	    box            = "actionlist"
		link           = "#SESSION.root#/WorkOrder/Application/Workorder/ServiceDetails/Action/WorkActionContent.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#"
	    html           = "No"		
		tableheight    = "100%"
		tablewidth     = "100%"
		datasource     = "AppsWorkOrder"
		listquery      = "#myquery#"
		listorderfield = "DateTimePlanning"
		listorderalias = ""
		listorder      = "DateTimePlanning"
		listorderdir   = "DESC"
		headercolor    = "ffffff"
		show           = "40"			
		menu           = "#menu#"			
		filtershow     = "Hide"
		excelshow      = "Yes" 		
		listlayout     = "#fields#"
		drillmode      = "workflow" 
		drillargument  = "630;580;true;true"			
		drilltemplate = "#SESSION.root#/WorkOrder/Application/Workorder/ServiceDetails/Action/WorkActionWorkflow.cfm?ajaxid="
		drillkey       = "#dk#"		
		deletetable    = "#dt#"
		drillbox       = "addworkorder">	
							  