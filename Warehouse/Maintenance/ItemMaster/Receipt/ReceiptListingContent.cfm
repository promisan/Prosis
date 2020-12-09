
<!--- control list data content --->

<cfquery name="Param"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#url.mission#'
</cfquery>

<cfsavecontent variable="myquery">

	<cfoutput>
	   
		SELECT    *
	    FROM      userQuery.dbo.ItemReceipt_#SESSION.acc#
				
	</cfoutput>	
	
</cfsavecontent>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>

	<cf_tl id="Status" var = "1">
	
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "StatusDescription",					
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>	

	<cfset itm = itm+1>
	
	<cf_tl id="Warehouse" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "WarehouseName",					
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>	
	
				
	<cfset itm = itm+1>
	
	<cf_tl id="Purchase" var = "1">	
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "PurchaseNo",	
						functionscript  = "ProcPOEdit",				
						alias       	= "",																			
						search      	= "text",
						filtermode  	= "0"}>						
								
	<cfset itm = itm+1>
	
	<cf_tl id="Vendor" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "VendorName",					
						alias       = "",		
						align       = "left",																	
						search      = "text",
						filtermode  = "2"}>							
						
	<cfif Param.LotManagement eq "1">
	
		<cfset itm = itm+1>
		<cf_tl id="Lot" var = "1">		
		<cfset fields[itm] = {label     = "#lt_text#",                    
		     				field       = "TransactionLot",					
							alias       = "",		
							align       = "left",																	
							search      = "text",
							filtermode  = "2"}>		
	
	</cfif>					
						
	<cfset itm = itm+1>
	
	<cf_tl id="Date" var = "1">	
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "DeliveryDate",					
						alias       = "",		
						align       = "center",		
						formatted   = "dateformat(DeliveryDate,CLIENT.DateFormatShow)",																	
						search      = "date"}>		
				
	<cfset itm = itm+1>
	
	<cf_tl id="Quantity" var = "1">	
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ReceiptWarehouse",	
						align       = "right",				
						alias       = "",					
						formatted   = "numberformat(ReceiptWarehouse,'__,__')",														
						search      = ""}>		
						
						
	<cfset itm = itm+1>
		
	<cf_tl id="UoM" var = "1">	
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "UoMDescription",					
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>	
																		
						
	<cfset itm = itm+1>
	
	<cf_tl id="Cost" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ReceiptAmountBaseCost",					
						align       = "right",
						alias       = "",					
						formatted   = "numberFormat(ReceiptAmountBaseCost,',.__')",														
						search      = ""}>		
						
	<cfset itm = itm+1>
	
	<cf_tl id="Tax" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ReceiptAmountBaseTax",					
						align       = "right",
						alias       = "",					
						formatted   = "numberFormat(ReceiptAmountBaseTax,',.__')",														
						search      = ""}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Total" var = "1">	
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ReceiptAmountBase",					
						align       = "right",
						alias       = "",					
						formatted   = "numberFormat(ReceiptAmountBase,',.__')",														
						search      = ""}>													
						
	<cfset itm = itm+1>				
	
	<!--- hidden fields --->
	
	<cfset fields[itm] = {label     = "Id",                    
	     				field       = "ReceiptId",					
						display     = "No",
						alias       = "",																			
						search      = "text"}>																																
		
<cfset menu=ArrayNew(1)>	
	
<!--- embed|window|dialogajax|dialog|standard --->
							
<cf_listing
	    header              = "transactionlist"
	    box                 = "listing"
		link                = "#SESSION.root#/Warehouse/Maintenance/ItemMaster/Receipt/ReceiptListingContent.cfm?mission=#url.mission#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"		
		datasource          = "AppsQuery"
		listquery           = "#myquery#"		
		listgroup           = "WarehouseName"
		listorderfield      = "DeliveryDate"
		listorder           = "DeliveryDate"
		listorderdir        = "ASC"
		headercolor         = "ffffff"
		show                = "35"		
		menu                = "#menu#"
		filtershow          = "Show"
		excelshow           = "Yes" 		
		listlayout          = "#fields#"
		drillmode           = "window" 
		drillargument       = "900;1200;false;false"	
		drilltemplate       = "Procurement/Application/Receipt/ReceiptEntry/ReceiptLineEdit.cfm?rctid="
		drillkey            = "ReceiptId"
		drillbox            = "addaddress">	


