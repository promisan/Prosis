

<cfparam name="URL.id"                default="0000">
<cfparam name="URL.mission"           default="">

<cfparam name="URL.Group"             default="TransactionDate">
<cfparam name="URL.page"              default="1">
<cfparam name="URL.status"            default="0">
<cfparam name="URL.Fnd"               default="">
<cfparam name="URL.TransactionType"   default="">

<cfoutput>
<input type="hidden" id="warehouseselected" value="#url.warehouse#">
</cfoutput>

<cfif url.status eq "9">
     <cfset suff = "Deny">
<cfelse>
     <cfset suff = "">  
</cfif>

<cfinclude template="StockBatchPrepare.cfm">

<cfoutput>
<cfsavecontent variable="myquery">

	SELECT    *, TransactionDate
	FROM      StockBatch_#SESSION.acc# B
	WHERE     1=1 
	
</cfsavecontent>
</cfoutput>

<cfset fields=ArrayNew(1)>

<cfset itm = 0>
					
<cfset itm = itm+1>		
<cf_tl id="BatchNo" var="vBatchNo">
<cfset fields[itm] = {label         = "#vBatchNo#", 
					  field         = "BatchNo",
				      searchfield   = "BatchNo",
					  filtermode    = "0",
					  search        = "text"}>		
					  
<cfset itm = itm+1>		
<cf_tl id="Class" var="vBatchClass">
<cfset fields[itm] = {label         = "#vBatchClass#", 
					  field         = "BatchDescription",
				      searchfield   = "BatchDescription",
					  filtermode    = "2",
					  search        = "text"}>		
					  
<cfset itm = itm+1>		
<cf_tl id="Destination Warehouse" var="vDestination">
<cfset fields[itm] = {label         = "#vDestination#", 
					  field         = "ContraWarehouse",
				      searchfield   = "ContraWarehouse",
					  filtermode    = "2",
					  search        = "text"}>							  					  	

<cfset itm = itm+1>		
<cf_tl id="Customer Name" var="vCustomer">
<cfset fields[itm] = {label         = "#vCustomer#", 
					  field         = "CustomerName",
					  searchfield	= "CustomerName",
  					  filtermode    = "0",
					  search		= "text"}>		
					  
<cfset itm = itm+1>		
<cf_tl id="Invoice" var="vInvoice">
<cfset fields[itm] = {label         = "#vInvoice#", 
					  field         = "BatchReference",
					  searchfield	= "BatchReference",
  					  filtermode    = "0",
					  search		= "text"}>							  

					  
<cfset itm = itm+1>		
<cf_tl id="Location" var="vLocation">
<cfset fields[itm] = {label         = "#vLocation#", 
					  field         = "LocationDescription",
					  searchfield	= "LocationDescription",
  					  filtermode    = "3",
					  search		= "text"}>	
					  
<cfset itm = itm+1>		
<cf_tl id="Del" var="vDelivery">
<cfset fields[itm] = {label         = "#vDelivery#", 
					  field         = "DeliveryMode",
					  searchfield	= "DeliveryMode",
  					  filtermode    = "2",
					  search		= "text"}>		
					  
				  					  						  

<cfset itm = itm+1>		
<cf_tl id="Name" var="vFirst">
<cfset fields[itm] = {label         = "#vFirst#", 
					  field         = "OfficerFirstName",
				      searchfield   = "OfficerFirstName",
					  filtermode    = "2",
					  search        = "text"}>	
					  
<cfset itm = itm+1>		
<cf_tl id="Date" var="vDate">
<cfset fields[itm] = {label         = "#vDate#", 
					  field         = "TransactionDate",
				      searchfield   = "TransactionDate",
					  column        = "month",
					  filtermode    = "0",
					  formatted     = "dateformat(TransactionDate,client.dateformatshow)",
					  search        = "date"}>	
					  
<cfset itm = itm+1>		
<cf_tl id="Time" var="vTime">
<cfset fields[itm] = {label         = "#vTime#", 
					  field         = "Created",
				      searchfield   = "Created",
					  filtermode    = "0",
					  formatted     = "timeformat(Created,'HH:MM')",
					  search        = "text"}>	
					  
<cfset itm = itm+1>		

<cfset fields[itm] = {label         = "##", 
					  field         = "Lines",
				      searchfield   = "Lines",
					  filtermode    = "0",
					  align         = "right",
					  formatted     = "numberformat(Lines,',_')",
					  search        = "number"}>	
					 
<cfset itm = itm+1>		
<cf_tl id="Clear" var="vClear">
<cfset fields[itm] = {label         = "CL", 
					  field         = "Cleared",
				      searchfield   = "Cleared",
					  filtermode    = "0",
					  align         = "right",
					  formatted     = "numberformat(Cleared,',_')",
					  search        = "number"}>						  					  

<cfset itm = itm+1>			
<cf_tl id="Status" var="vStatus">			
<cfset fields[itm] = {label       = "S", 	
                    LabelFilter   = "#vStatus#",				
					field         = "ProcessStatus",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=Yellow,1=Green,9=Red"}>	
	
<cfif url.status eq "0">
	<cfset sl = "Hide">
<cfelse>
	<cfset sl = "Yes">
</cfif>					  
					  
<cf_listing
    header         = "BatchListing"
    box            = "batch_#url.status#_#url.warehouse#"
	link           = "#session.root#/warehouse/application/stock/batch/stockbatchlisting.cfm?status=#url.status#&warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#"
    html           = "Yes"
	show           = "40"
	datasource     = "AppsQuery"
	listquery      = "#myquery#"		
	listorderalias = ""	
	listorder      = "BatchNo"
	listorderdir   = "DESC"
	headercolor    = "ffffff"
	listlayout     = "#fields#"
	filterShow     = "#sl#"
	excelShow      = "Yes"
	drillmode      = "tab"	
	drillstring    = "mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&mode=process"
	drilltemplate  = "warehouse/application/stock/batch/BatchView.cfm?batchno="
	drillkey       = "BatchNo">	

<!--- rework the refresh --->

<cfif url.status eq "0">

	<cf_securediv bind="url:#session.root#/warehouse/application/stock/batch/StockBatchlistingConnection.cfm?warehouse=#url.warehouse#">	
		   
</cfif>		   



