
<!--- control list data content --->

<cfsavecontent variable="myquery">

	<cfoutput>
	   
		SELECT    *
	    FROM      userQuery.dbo.#SESSION.acc#_WorkOrder_item
				
	</cfoutput>	
	
</cfsavecontent>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>
	<cf_tl id="workorder" var = "1"> 			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "WorkOrderReference",					
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Date" var = "1"> 			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "OrderDate",					
						alias       = "",																			
						formatted  = "dateformat(OrderDate,CLIENT.DateFormatShow)",
						search      = "date"}>													

	<cfset itm = itm+1>
	<cf_tl id="Facility" var = "1"> 
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "WarehouseName",					
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>					
								
	<cfset itm = itm+1>
	<cf_tl id="UoM" var = "1"> 		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "UoMDescription",					
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>	
						
	<cfset itm = itm+1>
	<cf_tl id="Lot" var = "1"> 		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionLot",					
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>
						
	<cfset itm = itm+1>
	<cf_tl id="Type" var = "1"> 			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Reference",
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Line" var = "1"> 	
				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "WorkOrderLine",
						alias       = "",																			
						search      = "text",
						filtermode  = "0"}>							
						
	
	<!---
						
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "BatchNo",                    
	     				field       = "TransactionBatchNo",					
						alias       = "",		
						align       = "center",																	
						search      = "text"}>							
						
	--->						

	<cfset itm = itm+1>
	<cf_tl id="Quantity" var = "1"> 						
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "OnHand",	
						align       = "right",				
						alias       = "",					
						formatted   = "numberformat(OnHand,'__,__')",														
						search      = ""}>		
						
							
	<cfset itm = itm+1>
	<cf_tl id="Amount" var = "1"> 								
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Value",					
						align       = "right",
						alias       = "",					
						formatted   = "numberformat(Value,'__,__.__')",														
						search      = ""}>																														
	
	<cfset itm = itm+1>				
	
	<!--- hidden fields --->
	
	<cfset fields[itm] = {label     = "Id",                    
	     				field       = "WorkOrderLineId",					
						display     = "No",
						alias       = "",																			
						search      = "text"}>																																
		
<cfset menu=ArrayNew(1)>	
	
<!--- embed|window|dialogajax|dialog|standard --->
							
<cf_listing
	    header              = "workorderlist"
	    box                 = "listingreservation"
		link                = "#SESSION.root#/Warehouse/Maintenance/ItemMaster/WorkOrder/WorkOrderListingContent.cfm?systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		font                = "Verdana"
		datasource          = "AppsQuery"
		listquery           = "#myquery#"		
		listgroup           = "WarehouseName"
		listorderfield      = "TransactionLot"
		listorder           = "TransactionLot"
		listorderdir        = "ASC"
		headercolor         = "ffffff"
		show                = "35"		
		menu                = "#menu#"
		filtershow          = "Show"
		excelshow           = "Yes" 		
		listlayout          = "#fields#"
		drillmode           = "tab" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "WorkOrder/Application/WorkOrder/ServiceDetails/ServiceLineView.cfm?drillid="
		drillkey            = "WorkorderLineId"
		drillbox            = "addaddress">	