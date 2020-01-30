
<!--- control list data content --->

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_Quote"> 

<cfquery name="Get" 
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	 	
		SELECT   DISTINCT 
		         C.CustomerName, 
		         C.Reference, 
				 C.PhoneNumber, 
				 C.eMailAddress, 
				 P.LastName AS Officer, 
				 S.SalesCurrency,
				 MAX(S.TransactionDate) AS TransactionDate, 
				 SUM(S.SalesAmount)     AS SalesAmount, 
				 SUM(S.SalesTax)        AS SalesTax, 
				 SUM(S.SalesTotal)      AS SalesTotal, 
				 C.CustomerId
		INTO     userQuery.dbo.#session.acc#_Quote				  
		FROM     Sale#url.warehouse# S INNER JOIN
	             Materials.dbo.Customer C ON S.CustomerId = C.CustomerId LEFT OUTER JOIN
	             Employee.dbo.Person P ON S.SalesPersonNo = P.PersonNo
	    GROUP BY C.CustomerName, 
		         C.Reference, 
				 P.LastName, 
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
	     				field       = "PhoneNumber",																	
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
	<cf_tl id="Date" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionDate",	
						formatted   = "dateformat(TransactionDate,client.dateformatshow)",					
						alias       = "",																			
						search      = "date"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Curr" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "SalesCurrency",					
						alias       = ""}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Total" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "SalesTotal",	
						formatted   = "numberformat(SalesTotal,',.__')",											
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
	    box                 = "saleprice"
		link                = "#SESSION.root#/Warehouse/Application/SalesOrder/Quote/ControlListDataContent.cfm?warehouse=#url.warehouse#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		font                = "Calibri"
		datasource          = "AppsQuery"
		listquery           = "#myquery#"	
		
		<!---
		
		listgroupfield      = "CategoryItemName"
		listgroup           = "CategoryItemOrder"
		listgroupdir        = "ASC"	
		
		--->
		
		listorderfield      = "CustomerName"
		listorder           = "CustomerName"
		listorderdir        = "ASC"
		headercolor         = "ffffff"
		show                = "20"		<!--- better to let is be set in the preferences --->
		menu                = "#menu#"
		filtershow          = "Hide"
		excelshow           = "Yes" 			
		listlayout          = "#fields#"
		drillmode           = "window" 
		drillargument       = "#client.height-90#;#client.width-100#;false;false"	
		drilltemplate       = "Warehouse/Application/SalesOrder/POS/Sale/SaleInit.cfm?mission=#url.mission#&warehouse=#url.warehouse#&mode=dialog&customerid="
		drillkey            = "CustomerId"
		drillbox            = "addlisting">	
		