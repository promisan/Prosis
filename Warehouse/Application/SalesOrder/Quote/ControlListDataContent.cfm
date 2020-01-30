
<!--- control list data content --->

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_Quote"> 

<cfquery name="Get" 
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	 	
		SELECT   DISTINCT
				 CAST(C.CustomerId AS VARCHAR(50))+'|'+CAST(S.AddressId AS VARCHAR(50)) as QuoteId, 
				 C.CustomerId,
		         C.CustomerName,
		         S.AddressId,
		         AD.Address,
		         AD.Address2,
		         AD.AddressCity,
		         C.Reference, 
				 C.PhoneNumber, 
				 C.MobileNumber,
				 C.eMailAddress, 
				 P.LastName AS Officer, 
				 S.SalesCurrency,
				 MAX(S.TransactionDate) AS TransactionDate, 
				 SUM(S.SalesAmount)     AS SalesAmount, 
				 SUM(S.SalesTax)        AS SalesTax, 
				 SUM(S.SalesTotal)      AS SalesTotal 
		INTO     userQuery.dbo.#session.acc#_Quote				  
		FROM     Sale#url.warehouse# S INNER JOIN
	             Materials.dbo.Customer C ON S.CustomerId = C.CustomerId LEFT OUTER JOIN
	             Employee.dbo.Person P ON S.SalesPersonNo = P.PersonNo LEFT OUTER JOIN
	             System.dbo.Ref_Address AD ON AD.AddressId = S.AddressId
		WHERE    BatchId is NULL <!--- not transformed into a real sale which is posted yet --->		 
	    GROUP BY C.CustomerName,
	    		 S.AddressId,
		         AD.Address,
		         AD.Address2,
		         AD.AddressCity,
		         C.Reference, 
				 P.LastName, 
				 C.MobileNumber,
				 C.PhoneNumber, 
				 C.eMailAddress, 
				 C.CustomerId,
				 S.SalesCurrency	
						
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
	<cf_tl id="Customer" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "CustomerName",		
						formatted   = "CustomerName",										
						alias       = "C",																			
						search      = "text",
						filtermode  = "2"}>		

<!---
	<cfset itm = itm+1>
	<cf_tl id="Address" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Address",		
						formatted   = "Address",										
						alias       = "AD",																			
						search      = "text",
						filtermode  = "2"}>		
						
						--->

	
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
	<cf_tl id="eMail" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "eMailAddress",					
						alias       = "C",																			
						search      = "text",
						filtermode  = "2"}>	
						
	<cfset itm = itm+1>
		
	<cf_tl id="Officer" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Officer",																	
						alias       = "C",																			
						search      = "text"}>									
						
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
						alias       = "",																			
						search      = "text"}>																																
		
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
		filtershow          = "Hide"
		excelshow           = "Yes" 			
		listlayout          = "#fields#"
		drillmode           = "tab" 
		drillargument       = "#client.height-90#;#client.width-100#;false;false"	
		drilltemplate       = "Warehouse/Application/SalesOrder/POS/Sale/SaleInit.cfm?mission=#url.mission#&warehouse=#url.warehouse#&mode=dialog&QuoteId="
		drillkey            = "QuoteId"
		drillbox            = "addlisting">	
		