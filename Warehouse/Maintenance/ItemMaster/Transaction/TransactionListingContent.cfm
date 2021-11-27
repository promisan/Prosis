<!--- control list data content --->

<cfsavecontent variable="myquery">

	<cfoutput>
	   
		SELECT    *, TransactionDate
	    FROM      userQuery.dbo.#SESSION.acc#_ItemTransaction_item
				
	</cfoutput>	
	
</cfsavecontent>

<!--- determine if it makes sense to show the location --->

<cfquery name="checkLocation"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   WarehouseName,
	         count(DISTINCT LocationDescription)
	FROM     userQuery.dbo.#SESSION.acc#_ItemTransaction_item
	GROUP BY WarehouseName
	HAVING   Count(DISTINCT LocationDescription) > 1	
</cfquery>	

<cfset fields=ArrayNew(1)>

	<cfset itm = 1>
	<cf_tl id="Facility" var = "1"> 
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "WarehouseName",					
						alias         = "",																			
						search        = "text",
						filtermode    = "3"}>
						
	<cfset itm = itm+1>
	<cf_tl id="Location" var = "1"> 								
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "Location",					
						alias         = "",																			
						search        = "text",
						filtermode    = "3"}>							
						
	<cfset itm = itm+1>
	<cf_tl id="Purchase" var = "1"> 	
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "PurchaseNo",	
						functionscript  = "ProcPOEdit",
						functionfield   = "PurchaseNo",		
						width           = "25",							
						alias           = "",																			
						search          = "text"}>	
											
	<cfset itm = itm+1>
	<cf_tl id="BatchNo" var = "1"> 								
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "TransactionBatchNo",					
						alias           = "",		
						functionscript  = "batch",
						functionfield   = "TransactionBatchNo",																		
						search          = "text",
						filtermode      = "2"}>		
															
	<!---							
	<cfif checkLocation.recordcount gte "1">		
				
		<cfset itm = itm+1>
		<cf_tl id="Location" var = "1"> 	
		<cfset fields[itm] = {label     = "#lt_text#",                    
		     				field       = "LocationDescription",					
							alias       = "",																			
							search      = "text",
							filtermode  = "2"}>	
	</cfif>		
	--->			
						
	<cfset itm = itm+1>
	<cf_tl id="Type" var = "1"> 			
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "Description",					
						alias           = "",	
						display         = "No",																		
						search          = "text",
						filtermode      = "3"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Class" var = "1"> 			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "BatchClassName",					
						alias       = "",																			
						search      = "text",
						filtermode  = "3"}>																			

	<cfset itm = itm+1>
	<cf_tl id="Officer" var = "1"> 								
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Officer",					
						alias       = "",																			
						search      = "text",
						filtermode  = "3"}>		

						
	<cfset itm = itm+1>
	<cf_tl id="Date" var = "1"> 				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionDate",					
						alias       = "",		
						column      = "month",							
						formatted   = "dateformat(TransactionDate,CLIENT.DateFormatShow)",																	
						search      = "date"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Time" var = "1"> 					
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionDate",					
						alias       = "",								
						formatted   = "timeformat(TransactionDate,'HH:MM')",																	
						search      = ""}>		
						
											
	
	<!---					
	<cfset itm = itm+1>
	<cf_tl id="Reference" var = "1"> 	
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionReference",					
						alias       = "",																			
						search      = "text"}>																	
	--->	
		

	<cfset itm = itm+1>
	<cf_tl id="Quantity" var = "1"> 						
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionQuantity",	
						align       = "right",	
						width       = "15",			
						alias       = "",	
						aggregate  = "sum",					
						formatted   = "numberformat(TransactionQuantity,',__')",														
						search      = ""}>	
						
	<cfset itm = itm+1>
	<cf_tl id="UoM" var = "1"> 		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "UoMDescription",					
						alias       = "",																			
						search      = "text",
						filtermode  = "3"}>			
						
	<cfset itm = itm+1>
	<cf_tl id="Class" var = "1"> 		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ClassMode",					
						alias       = "",																			
						search      = "text",
						filtermode  = "3"}>											
	
	<!---					
	<cfset itm = itm+1>
	<cf_tl id="CostPrice" var = "1"> 							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionCostPrice",					
						align       = "right",
						width       = "15",	
						alias       = "",					
						formatted   = "numberFormat(TransactionCostPrice,',.__')",														
						search      = ""}>		
						
	--->
	
	<cfinvoke component = "Service.Access"  
			   method           = "RoleAccess" 
			   Role             = "'WhsPick'"
			   Parameter        = "#url.systemfunctionid#"			   
			   AccessLevel      = "2"
			   returnvariable   = "accesslevel">						
							
	 <cfif AccessLevel eq "GRANTED">	
	 
	 		<cfset itm = itm+1>
			<cf_tl id="Price" var = "1"> 								
			<cfset fields[itm] = {label     = "#lt_text#",                    
			     				field       = "TransactionCostPrice",					
								align       = "right",								
								alias       = "",					
								formatted   = "numberformat(TransactionCostPrice,',.__')",														
								search      = ""}>								
						
			<cfset itm = itm+1>
			<cf_tl id="Amount" var = "1"> 								
			<cfset fields[itm] = {label     = "#lt_text#",                    
			     				field       = "TransactionValue",					
								align       = "right",									
								alias       = "",		
								aggregate  = "sum",					
								formatted   = "numberformat(TransactionValue,',.__')",														
								search      = ""}>																														
	
	</cfif>	
	
	<cfset itm = itm+1>				
	
	<!--- hidden fields --->
	
	<cfset fields[itm] = {label     = "Id",                    
	     				field       = "TransactionId",					
						display     = "No",
						alias       = ""}>																																
		
<cfset menu=ArrayNew(1)>	
	
<!--- embed|window|dialogajax|dialog|standard --->
							
<cf_listing
	    header              = "transactionlist"
	    box                 = "listing"
		link                = "#SESSION.root#/Warehouse/Maintenance/ItemMaster/Transaction/TransactionListingContent.cfm?systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"		
		datasource          = "AppsQuery"
		listquery           = "#myquery#"				
		listorderfield      = "Created"
		listorder           = "Created"
		listorderdir        = "DESC"
		headercolor         = "ffffff"
		show                = "100"		
		menu                = "#menu#"
		filtershow          = "Hide"
		excelshow           = "Yes" 		
		listlayout          = "#fields#"
		drillmode           = "window" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "Warehouse/Application/Stock/Inquiry/TransactionView.cfm?drillid="
		drillkey            = "TransactionId"
		drillbox            = "addaddress">	