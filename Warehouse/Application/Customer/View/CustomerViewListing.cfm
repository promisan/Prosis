<cfparam name="url.mission" default="">

<cfoutput>
			
	<cfquery name="Contact" 
			 datasource="AppsMaterials" 
			 username="#Session.login#" 
			 password="#Session.dbpw#">
			 	SELECT Code
				FROM   Ref_Contact
				ORDER  BY ListingOrder
	</cfquery>
					
	<cfsavecontent variable="myquery">		
	
		SELECT *
		FROM (
	
		SELECT CustomerId, 
		       CustomerName AS CustomerFullName, 
			   LastName, 
			   FirstName, 
			   Reference, 
			   CustomerSerialNo,
			   PhoneNumber, 
			   MobileNumber, 
			   PostalCode,
		       TaxExemption,
			   eMailAddress, 
			   Created,
		   	   LastTransaction,				
			   OfficerLastName,
			   OfficerFirstName
				
		FROM   (
					SELECT *, 
						(
							SELECT TOP 1 TransactionDate
							FROM   ItemTransaction TD
							WHERE  TD.CustomerId = C1.CustomerId
							ORDER  BY TD.TransactionDate Desc
						)  LastTransaction 
					FROM Customer C1
				) AS C
			
				
		WHERE  Mission = '#url.mission#' 
		AND    Operational = 1
		
		) as C
		
		WHERE 1=1
		
		-- condition
		
		
	</cfsavecontent>							
	
</cfoutput>

		
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cfset itm = itm+1>						
<cf_tl id="No" var="vNo">
<cfset fields[itm] = {label     = "#vNo#",                  
					  field       = "CustomerSerialNo",
					  filtermode    = "4",		
  					  alias			= "C",			
					  search      = "text"}>	
					
<cfset itm = itm+1>		
<cf_tl id="Name" var="vName">
<cfset fields[itm] = {label         = "#vName#", 
					  field         = "CustomerFullName",
					  alias			= "C",				      
					  filtermode    = "4",
					  displayfilter = "Yes",
					  search        = "text"}>		
		  					
				
<cfset itm = itm+1>						
<cf_tl id="Reference" var="vReference">
<cfset fields[itm] = {label     = "#vReference#",                  
					  field       = "Reference",
					  filtermode    = "4",		
  					  alias			= "C",			
					  search      = "text"}>	
					  
<cfset itm = itm+1>		
<cf_tl id="Exempt" var="vTax">
<cfset fields[itm] = {label       = "#vTax#",	
                      field       = "TaxExemption",
					  alias		  = "C",                      
					  filtermode  = "2",
					  search      = "text"}>						  
					  
<cfset itm = itm+1>		
<cf_tl id="Mobile" var="vMobile">
<cfset fields[itm] = {label     = "#vMobile#",                  
					  field       = "MobileNumber",
  					  alias			= "C",
					  filtermode    = "4",
					  searchfield = "MobileNumber",
					  filtermode  = "0",
					  search      = "text"}>						  					
					
<cfset itm = itm+1>		
<cf_tl id="Phone" var="vPhone">
<cfset fields[itm] = {label     = "#vPhone#",                  
					  field       = "PhoneNumber",
  					  alias			= "C",
					  filtermode    = "4",
					  searchfield = "PhoneNumber",
					  filtermode  = "0",
					  search      = "text"}>								
						
<cfset itm = itm+1>		
<cf_tl id="eMail" var="vEmail">
<cfset fields[itm] = {label       = "#vEmail#",	
                      field       = "eMailAddress",
					  alias			= "C",
					  filtermode    = "4",
                      searchfield = "eMailAddress",
					  filtermode  = "0",
					  search      = "text"}>	
					  
<cfset itm = itm+1>		
<cf_tl id="Address" var="vAddress">
<cfset fields[itm] = {label       = "#vAddress#",	
                      field       = "PostalCode",
                      searchfield = "PostalCode",					  
					  filtermode  = "1",
					  search      = "text"}>					  

<cfset itm = itm+1>			
<cf_tl id="LastTransaction" var="vTransaction">				
<cfset fields[itm] = {label       = "#vTransaction#",  					
					  field       = "LastTransaction",
					  alias		  = "C",
					  search      = "date",
					  formatted   = "dateformat(LastTransaction,'#CLIENT.DateFormatShow#')"}>	
					  
		  
<cfset itm = itm+1>		
<cf_tl id="Created" var="vCreated">
<cfset fields[itm] = {label       = "#vCreated#",  					
					  field       = "Created",
					  alias		  = "C",
					  search      = "date",
					  searchalias = "C",
					  formatted   = "dateformat(Created,'#CLIENT.DateFormatShow#')"}>	
					  
<cfset itm = itm+1>							
	   
<cfset menu=ArrayNew(1)>	
   				
	<cfset newLabel = "New Customer">
		
	<cf_tl id="#newLabel#" var="1">
							
	<cfset menu[1] = {label = "#lt_text#", script = "addCustomer()"}>				 
		
	<cf_listing
	    header         = "Customer"
		menu           = "#menu#"
	    box            = "customerlisting"
		link           = "CustomerViewListing.cfm?systemfunctionid=#url.systemfunctionid#&Mission=#url.mission#"
	    html           = "No"
		show           = "40"
		datasource     = "AppsMaterials"
		listquery      = "#myquery#"			
		listorder      = "LastName"
		listorderfield = "LastName"
		listorderalias = "C"
		listorderdir   = "ASC"		
		headercolor    = "ffffff"
		listlayout     = "#fields#"
		filterShow     = "Yes"
		excelShow      = "Yes"
		drillmode      = "tab"	
		drillargument  = "890;1060;true;true"	
		drilltemplate  = "Warehouse/Application/Customer/View/CustomerEditTab.cfm?drillid="
		drillkey       = "CustomerId">