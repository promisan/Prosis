
<!--- control list data content --->

<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     Category
	FROM       AssetItem A, Item I
	WHERE      AssetId = '#url.assetid#'	
	AND        A.ItemNo = I.ItemNo	
</cfquery>

<cfquery name="Metrics" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     RM.Metric
	FROM       Ref_AssetActionCategory RA INNER JOIN
               Ref_AssetActionMetric RM ON RA.ActionCategory = RM.ActionCategory AND RA.Category = RM.Category
	WHERE      RA.Category = '#get.Category#' 
	AND        RA.ActionCategory = 'Operations'
</cfquery>

<cfsavecontent variable="myquery">

	<cfoutput>	  		
	SELECT  B.*,	        
	        
			<cfloop query="Metrics">
			
			<cfset fld = replace(Metric," ","","ALL")>
			<cfset fld = replace(fld,".","","ALL")>
			<cfset fld = replace(fld,",","","ALL")>
			
			(
				SELECT TOP 1 MetricValue
				FROM   AssetItemActionMetric OM, AssetItemAction O
				WHERE  OM.AssetActionId  = O.AssetActionId
				AND    O.TransactionId = B.TransactionId
				AND    OM.Metric = '#Metric#'
			) as #fld#,
			
			</cfloop>
			
			UoMDescription,			
			W.WarehouseName	
	FROM    ItemTransaction B,	        
			ItemUoM	U,
			Warehouse W
	WHERE   B.ItemNo  = U.ItemNo
	AND     B.Warehouse = W.Warehouse
	AND     B.TransactionType = '2'  <!--- issuances --->
	AND     B.TransactionUoM  = U.UOM 	
	
	AND     (
					         B.AssetId        = '#url.assetid#'	
							 OR 
							 B.AssetId IN (SELECT AssetId
							               FROM   AssetItem 
										   WHERE  ParentAssetId = '#url.assetid#')
							 )					          
		
		
	 <cfif URL.Month neq "0">
		 AND      Datepart(month,B.TransactionDate) = '#URL.Month#'
	 </cfif>
		 
	 <cfif URL.Year neq "">
		 AND      Datepart(year,B.TransactionDate) = '#URL.Year#'
	 </cfif>
			
	</cfoutput>	
	
</cfsavecontent>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>
	<cf_tl id="Facility" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "WarehouseName",					
						search      = "text",
						filtermode  = "2",
						alias       = ""}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Date" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionDate",					
						alias       = "",		
						align       = "center",		
						formatted   = "dateformat(TransactionDate,CLIENT.DateFormatShow)",																	
						search      = "date"}>	
						
	<cfset itm = itm+1>
	<cf_tl id="Hour" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionDate",					
						alias       = "",		
						align       = "center",		
						formatted   = "timeformat(TransactionDate,'HH:MM')"}>		
						
	<cfloop query="metrics" startrow="1" endrow="2">
	
		<cfset itm = itm + 1>
		
		<cfset fld = replace(metric," ","","ALL")>
		<cfset fld = replace(fld,".","","ALL")>
		<cfset fld = replace(fld,",","","ALL")>
		
		<cfset fields[itm] = {label  = "#Metric#",                    
				field       = "#fld#", 		
				align       = "right",		
				formatted   = "numberformat(#fld#,',__')"}>		
	
	</cfloop>									
						
	<cfset itm = itm+1>
	<cf_tl id="BatchNo" var = "1">						
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionBatchNo",					
						alias       = "",		
						align       = "center",																	
						search      = "text"}>															
	
	
	<cfset itm = itm+1>		
	<cf_tl id="Item" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ItemDescription",																	
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>				
							
	<cfset itm = itm+1>
	<cf_tl id="UoM" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "UoMDescription",					
						alias       = ""}>			
											

	<cfset itm = itm+1>
	<cf_tl id="Quantity" var = "1">							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionQuantity",	
						align       = "right",				
						alias       = "",					
						formatted   = "numberformat(TransactionQuantity*-1,'__,__')",														
						search      = ""}>								
																					
	
	<cfset itm = itm+1>				
	
	<!--- hidden fields --->
	<cf_tl id="Id" var = "1">												
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionId",					
						display     = "No",
						alias       = "",																			
						search      = "text"}>																																
		
<cfset menu=ArrayNew(1)>	
	
<!--- prevent the method to see this as an embedded listing --->

<cfset url.systemfunctionid = "">

							
<cf_listing
    header              = "transactionlist"
    box                 = "myissuelisting"
	link                = "#SESSION.root#/Warehouse/Application/Asset/AssetAction/Consumption/AssetSupplyConsumptionViewPresentationIssues.cfm?year=#url.year#&month=#url.month#&assetid=#url.assetid#&functionid=#url.systemfunctionid#"
    html                = "No"		
	screentop           = "No"
	tableheight         = "100%"
	tablewidth          = "100%"
	font                = "Verdana"
	datasource          = "appsMaterials"
	listquery           = "#myquery#"		
	listorderfield      = "TransactionDate"
	listorder           = "TransactionDate"
	listorderdir        = "DESC"
	headercolor         = "ffffff"
	show                = "35"		
	menu                = "#menu#"
	filtershow          = "Hide"
	excelshow           = "Yes" 		
	listlayout          = "#fields#"
	drillmode           = "window" 
	drillargument       = "#client.height-90#;#client.width-90#;false;false"	
	drilltemplate       = "Warehouse/Application/Stock/Inquiry/TransactionView.cfm?drillid="
	drillkey            = "TransactionId"
	drillbox            = "addaddress">
	

	