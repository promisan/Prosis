
<!--- control list data content --->

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_Quote"> 

<cfquery name="Get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	 	
		SELECT   S.RequestNo,
				 C.CustomerId,
		         C.CustomerName,
		         S.AddressId,
				 C.PersonNo,
		         AD.Address,
		         AD.Address2,
		         AD.AddressCity,
		         C.Reference, 
				 C.PhoneNumber, 
				 C.MobileNumber,
				 C.eMailAddress, 
				 MAX(P.LastName)        as Officer, 
				 MAX(S.SalesCurrency)   as SalesCurrency,
				 MAX(S.Source)          as Source,
				 MAX(S.TransactionDate) AS TransactionDate, 
				 SUM(S.SalesAmount)     AS SalesAmount, 
				 SUM(S.SalesTax)        AS SalesTax, 
				 SUM(S.SalesTotal)      AS SalesTotal 
		INTO     userQuery.dbo.#session.acc#_Quote				  
		FROM     vwCustomerRequest S INNER JOIN
	             Materials.dbo.Customer C ON S.CustomerId = C.CustomerId LEFT OUTER JOIN
	             Employee.dbo.Person P ON S.SalesPersonNo = P.PersonNo LEFT OUTER JOIN
	             System.dbo.Ref_Address AD ON AD.AddressId = S.AddressId
		WHERE    Warehouse = '#url.warehouse#'
		AND      BatchId is NULL AND ActionStatus != '9' <!--- not transformed into a real sale which is posted yet --->		 
	    GROUP BY S.RequestNo,
		         C.CustomerName,
	    		 S.AddressId,	
				 C.PersonNo,			
		         AD.Address,
		         AD.Address2,
		         AD.AddressCity,
		         C.Reference, 				 
				 C.MobileNumber,
				 C.PhoneNumber, 
				 C.eMailAddress, 
				 C.CustomerId
										
</cfquery>		

<cfsavecontent variable="myquery">
	
	<cfoutput>	 
	SELECT  *
	FROM    #session.acc#_Quote C				
	</cfoutput>	
	
</cfsavecontent>

<cfset itm = 0>
<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>
	<cf_tl id="QuoteNo" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Requestno",											
						alias       = "C",																								
						search      = "text"}>		

	<cfset itm = itm+1>
	<cf_tl id="Customer" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "CustomerName",		
						formatted   = "CustomerName",										
						alias       = "C",																			
						search      = "text",
						filtermode  = "2"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Date" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionDate",	
						formatted   = "dateformat(TransactionDate,client.dateformatshow)",					
						alias       = "",																			
						search      = "date"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Time" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionDate",	
						formatted   = "timeformat(TransactionDate,'HH:MM')",					
						alias       = ""}>											
						
						
	<cfset itm = itm+1>
	<cf_tl id="Source" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Source",		
						formatted   = "Source",										
						alias       = "S",																			
						search      = "text",
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
	<cf_tl id="Reference" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Reference",											
						alias       = "C",																								
						search      = "text",
						searchalias = "C",
						filtermode  = "2"}>		

	<cfset itm = itm+1>
		
	<cf_tl id="Phone" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "MobileNumber",																	
						alias       = "C",																			
						search      = "text"}>		
						
	<cfset itm = itm+1>
		
	<cf_tl id="Fixed" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "PhoneNumber",																	
						alias       = "C",																			
						search      = "text"}>									
	
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
						filtermode  = "2"}>									
						
		
						
	<cfset itm = itm+1>
	<cf_tl id="Curr" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "SalesCurrency",					
						alias       = ""}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Amount" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "SalesTotal",	
						formatted   = "numberformat(SalesTotal,',.__')",	
						align       = "right",										
						alias       = "",
						search      = "amount"}>																										
							
		
	<cfset itm = itm+1>	
	<!--- hidden fields --->
	<cf_tl id="Id" var = "1">												
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "CustomerId",					
						display     = "No",
						alias       = ""}>		
						
	<cfset itm = itm+1>
	<cf_tl id="PersonNo" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "PersonNo",		
						formatted   = "PersonNo",		
						display     = "No",								
						alias       = "C"}>																																					
		
<cfset menu=ArrayNew(1)>	
	
<!--- embed|window|dialogajax|dialog|standard --->

<!--- prevent the method to see this as an embedded listing --->
	
<cf_listing
	    header              = "PriceListing"
	    box                 = "mybox"
		link                = "#SESSION.root#/Warehouse/Application/SalesOrder/Quote/ControlListDataContent.cfm?warehouse=#url.warehouse#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"	   			
		datasource          = "AppsQuery"
		listquery           = "#myquery#"					
		listorderfield      = "CustomerName"
		listorder           = "CustomerName"
		listorderdir        = "ASC"
		headercolor         = "ffffff"		
		menu                = "#menu#"
		filtershow          = "Yes"
		excelshow           = "Yes" 			
		listlayout          = "#fields#"
		drillmode           = "tab" 
		drillargument       = "#client.height-90#;#client.width-100#;false;false"	
		drilltemplate       = "Warehouse/Application/SalesOrder/Quote/QuoteView.cfm?systemfunctionid=#url.systemfunctionid#&scope=quote&mission=#url.mission#&warehouse=#url.warehouse#&mode=dialog&RequestNo="
		drillkey            = "RequestNo"
		drillbox            = "addlisting">	
		