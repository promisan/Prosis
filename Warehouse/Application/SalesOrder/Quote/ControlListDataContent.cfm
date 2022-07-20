
<!--- control list data content --->

<cf_verifyOperational Module="WorkOrder">

<cfoutput>
<cfsavecontent variable="myquery">
		
		SELECT *, C.Created
		FROM (
		
		
		    SELECT        CR.Mission, 
			              CR.RequestNo,
						  CR.CustomerId, 
						  CR.AddressId, 
						  CR.Warehouse, 
						  CR.BatchNo, 
						  CR.Remarks, 
						  CR.ActionStatus, 
						  CR.Source, 
						  C.CustomerName,
						  C.Reference, 
						  C.PhoneNumber, 
						  C.MobileNumber,
						  C.eMailAddress, 
						  CR.RequestClass,
						  
						  (SELECT     Description
                           FROM       Ref_WarehouseBatchClass
                           WHERE      Code = CR.RequestClass) AS RequestClassName,
						  
						  (CASE WHEN BatchNo is NULL THEN 'Open' ELSE 'Sold' END) as QuoteStatus,
						  CR.OfficerLastName as Officer,
						  
                          (SELECT     AddressCity
                           FROM       System.dbo.Ref_Address
                           WHERE      AddressId = CR.AddressId) AS AddressCity,
						  
						  (SELECT     TOP 1 SalesCurrency AS Expr1
                           FROM       CustomerRequestLine AS S
                           WHERE      RequestNo = CR.RequestNo 
						   AND        BatchId IS NULL) AS SalesCurrency,  
						   
                          (SELECT     SUM(SalesTotal) AS Expr1
                           FROM       CustomerRequestLine AS S
                           WHERE      RequestNo = CR.RequestNo 
						   AND        BatchId IS NULL) AS SalesTotal, 
						   
						   CR.OfficerUserId, 
						   CR.OfficerLastName, 
						   CR.OfficerFirstName, 
						   CR.Created
						   
			FROM           CustomerRequest AS CR INNER JOIN Customer AS C ON CR.CustomerId = C.CustomerId
			WHERE          CR.Warehouse = '#url.warehouse#' 
			<!--- has turned into a sales order quote --->		
			<cfif operational eq "1">
			AND            NOT EXISTS (SELECT 'X' FROM WorkOrder.dbo.WorkorderLine WHERE Source = 'Quote' and SourceNo = CR.RequestNo)
			</cfif>
			-- AND            CR.BatchNo IS NULL 
			AND            CR.ActionStatus <> '9' 
			<!--- to exclude temporary loaded records to amend --->
			AND            EXISTS (SELECT    'X'
                                   FROM      CustomerRequestLine AS S
                                   WHERE     RequestNo = CR.RequestNo 
							       AND       BatchId IS NULL)
						
		) as C WHERE 1=1
		
		 --Condition
														
</cfsavecontent>	

</cfoutput>

<!---

<cfsavecontent variable="myquery">
	
	<cfoutput>	 
	SELECT  *
	FROM    #session.acc#_Quote C				
	</cfoutput>	
	
</cfsavecontent>

--->

<cfset itm = 0>
<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>
	<cf_tl id="No" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Requestno",											
						alias       = "C",																								
						search      = "text"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Stage" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "QuoteStatus",											
						alias       = "C",	
						filtermode  = "3",																							
						search      = "text"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Batch" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "BatchNo",											
						alias       = "C",	
						filtermode  = "2",																							
						search      = "text"}>														

	<cfset itm = itm+1>
	<cf_tl id="Customer" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "CustomerName",		
						formatted   = "CustomerName",										
						alias       = "C",																			
						search      = "text",
						filtermode  = "3"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Reference" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Reference",											
						alias       = "C",																								
						search      = "text",
						searchalias = "C",
						filtermode  = "2"}>							
						
	<cfset itm = itm+1>
	<cf_tl id="Address" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "AddressCity",		
						formatted   = "AddressCity",										
						alias       = "C",																			
						search      = "text",
						filtermode  = "2"}>													
						
	<cfset itm = itm+1>
	<cf_tl id="Date" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Created",	
						column      = "month",
						formatted   = "dateformat(Created,client.dateformatshow)",					
						alias       = "C",																			
						search      = "date"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Time" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Created",	
						formatted   = "timeformat(Created,'HH:MM')",					
						alias       = "C"}>											
												
	<cfset itm = itm+1>
	<cf_tl id="Source" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Source",		
						formatted   = "Source",			
						column      = "common",							
						alias       = "C",																			
						search      = "text",
						filtermode  = "3"}>				
					
	
	<!---						
	<cfset itm = itm+1>
	<cf_tl id="eMail" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "eMailAddress",					
						alias       = "C",																			
						search      = "text",
						filtermode  = "2"}>	
						
						--->
						
	<cfset itm = itm+1>		
	<cf_tl id="Officer" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Officer",																							
						alias       = "C",																			
						search      = "text",
						filtermode  = "3"}>									
						
								
	<cfset itm = itm+1>
	<cf_tl id="Curr" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "SalesCurrency",					
						alias       = ""}>		
						
	
	<cfset itm = itm+1>
	<cf_tl id="Amount" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "SalesTotal",	
						formatted   = "numberformat(SalesTotal,',')",	
						align       = "right",			
						aggregate   = "sum",							
						alias       = "",
						search      = "amount"}>		
						
	<cfset itm = itm+1>		
	<cf_tl id="Phone" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "MobileNumber",																	
						alias       = "C",		
						rowlevel    = "2",																	
						search      = "text"}>		
						
	<cfset itm = itm+1>		
	<cf_tl id="Fixed" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "PhoneNumber",																	
						alias       = "C",	
						rowlevel    = "2"}>			
											
	<cfset itm = itm+1>	
	<cf_tl id="Remarks" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				labelfilter   = "#lt_text#",
						field         = "Remarks",	
						display       = "1",								
						rowlevel      = "2",
						Colspan       = "9",																																													
						search        = "text"}>																																
							
		
	<cfset itm = itm+1>	
	<!--- hidden fields --->
	<cf_tl id="Id" var = "1">												
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "CustomerId",					
						display     = "No",						
						alias       = ""}>		
	
	<!---					
	<cfset itm = itm+1>
	<cf_tl id="PersonNo" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "PersonNo",		
						formatted   = "PersonNo",		
						display     = "No",								
						alias       = "C"}>		
						
						--->																																			
		
<cfset menu=ArrayNew(1)>	
	
<!--- embed|window|dialogajax|dialog|standard --->

<!--- prevent the method to see this as an embedded listing --->
	
<cf_listing
	    header             = "CustomerQuote"
	    box                = "customerquote_#url.warehouse#"
		link               = "#SESSION.root#/Warehouse/Application/SalesOrder/Quote/ControlListDataContent.cfm?warehouse=#url.warehouse#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"	   			
		datasource         = "AppsMaterials"
		listquery          = "#myquery#"					
		listorderfield     = "CustomerName"
		listorder          = "CustomerName"
		listorderdir       = "ASC"
		headercolor        = "ffffff"		
		menu               = "#menu#"
		filtershow         = "Yes"
		excelshow          = "Yes" 			
		listlayout         = "#fields#"
		drillmode          = "tab" 
		drillargument      = "#client.height-90#;#client.width-100#;false;false"	
		drilltemplate      = "Warehouse/Application/SalesOrder/Quote/QuoteView.cfm?systemfunctionid=#url.systemfunctionid#&scope=quote&mission=#url.mission#&warehouse=#url.warehouse#&mode=dialog&RequestNo="
		drillkey           = "RequestNo"		
		deletetable        = "Materials.dbo.CustomerRequest"
		annotation         = "WhsQuote">	
		