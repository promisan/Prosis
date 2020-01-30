
<cfoutput>

	<cfsavecontent variable="myquery">	
		SELECT     Transactionid,
		           PurchaseNo, 
				   OrgUnitName,
		           Description, 	
				   Journal,
				   JournalSerialNo,			  
				   TransactionDate,
				   Currency, 
				   AmountDebit, 
	               Offset
		FROM       #SESSION.acc#_Advance		
	</cfsavecontent>	
	
</cfoutput>				  
				
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset fields[1] = {label   = "Vendor", 
                    width   = "30%", 
					field   = "OrgUnitName",								
					search  = "text"}>

<cfset fields[2] = {label   = "Purchase", 
                    width   = "12%", 
					field   = "PurchaseNo",
					functionscript   = "ProcPOEdit",					
					search  = "text"}>
					
<cfset fields[3] = {label   = "Journal", 
                    width   = "8%", 
					field   = "Journal",
					filtermode = "1",
					search  = "text"}>					
					
<cfset fields[4] = {label   = "SerialNo", 
                    width   = "8%", 
					field   = "JournalSerialNo",
					filtermode = "1",
					search  = "text"}>
					
<cfset fields[5] = {label      = "Date", 
                    width      = "10%", 
					field      = "TransactionDate",
					formatted  = "dateformat(TransactionDate,CLIENT.DateFormatShow)",
					filtermode = "1",
					search     = "date"}>						

<cfset fields[6] = {label   = "Curr", 
                    width   = "6%", 
					field   = "Currency",						
					search  = "text"}>												
						
<cfset fields[7] = {label      = "Advance",    
					width      = "13%", 
					field      = "AmountDebit",
					align      = "right",
					filtermode = "1",
					formatted  = "numberformat(AmountDebit,'__,__.__')"}>
					
<cfset fields[8] = {label      = "Offset",    
					width      = "13%", 
					field      = "Offset",		
					align      = "right",								
					formatted  = "numberformat(Offset,'__,__.__')"}>		
					
<cfset fields[9] = {label      = "Id",    
					width      = "1%", 
					field      = "TransactionId",		
					display    = "no"}>																	
			
						
<cf_listing
    header        = "Finance"
    box           = "transaction"
	link          = "#SESSION.root#/GLedger/Inquiry/Advance/ListingVendorContent.cfm?mission=#url.mission#&currency=#url.currency#"
    html          = "No"
	show          = "40"
	datasource    = "AppsQuery"
	listquery     = "#myquery#"
	listkey       = "personNo"
	listgroup     = "OrgUnitName"
	listorder     = "TransactionDate"
	listorderdir  = "ASC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"
	drillmode     = "window"
	drillargument = "940;1000;false;false"	
	drilltemplate = "Gledger/Application/Transaction/View/TransactionViewDetail.cfm?id="
	drillkey      = "TransactionId">
	