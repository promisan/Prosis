
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
	   
	SELECT * --,DeliveryDate
    FROM (
	SELECT     R.Warehouse, 
	           W.WarehouseName,
			   R.WarehouseItemNo, 
			   R.WarehouseUoM,
			   R.TransactionLot,
			   I.UOMDescription, 
			   P.PurchaseNo, 
			   R.ReceiptId, 
			   R.DeliveryDate, 
			   R.ReceiptNo, 
			   S.Description as StatusDescription,
			   Org.OrgUnitName AS VendorName, 
			   Org.OrgUnit AS VendorUnit,
			   R.ReceiptWarehouse, 
			   R.ReceiptAmountBaseCost, 
			   R.ReceiptAmountBaseTax, 
			   R.ReceiptAmountBase			   
	FROM       PurchaseLineReceipt R INNER JOIN
	           PurchaseLine PL ON R.RequisitionNo = PL.RequisitionNo INNER JOIN
	           Purchase P ON PL.PurchaseNo = P.PurchaseNo INNER JOIN
	           Organization.dbo.Organization Org ON P.OrgUnitVendor = Org.OrgUnit INNER JOIN 
			   Materials.dbo.Warehouse W ON R.Warehouse = W.Warehouse INNER JOIN
               Materials.dbo.ItemUoM I ON R.WarehouseItemNo = I.ItemNo AND R.WarehouseUoM = I.UoM INNER JOIN
			   Status S ON Status = R.ActionStatus
	WHERE      P.Mission = '#URL.Mission#'
	AND        StatusClass = 'Receipt'
	AND        R.Warehouse IN (SELECT  Warehouse
	                           FROM    Materials.dbo.Warehouse
	                           WHERE   Mission = '#URL.Mission#')
	AND        R.WarehouseItemNo = '#URL.ItemNo#'	
	AND        R.ActionStatus IN ('0','1','2')
	) as D
	WHERE 1=1 
	--condition
				
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
						column      = "month",
						align       = "center",		
						formatted   = "dateformat(DeliveryDate,CLIENT.DateFormatShow)",																	
						search      = "date"}>		
				
	<cfset itm = itm+1>	
	<cf_tl id="Quantity" var = "1">	
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ReceiptWarehouse",	
						align       = "right",				
						alias       = "",					
						formatted   = "numberformat(ReceiptWarehouse,',__')",														
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
						width       = "20",
						alias       = "",	
						aggregate   = "sum",				
						formatted   = "numberFormat(ReceiptAmountBaseCost,',.__')",														
						search      = ""}>		
						
	<cfset itm = itm+1>	
	<cf_tl id="Tax" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ReceiptAmountBaseTax",					
						align       = "right",
						width       = "20",	
						aggregate   = "sum",			
						formatted   = "numberFormat(ReceiptAmountBaseTax,',.__')",														
						search      = ""}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Total" var = "1">	
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ReceiptAmountBase",					
						align       = "right",
						width       = "20",
						aggregate   = "sum",			
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
	    header              = "receiptlist#url.itemno#_#url.mission#"
	    box                 = "receiptlist#url.itemno#_#url.mission#"
		link                = "#SESSION.root#/Warehouse/Maintenance/ItemMaster/Receipt/ReceiptListingContent.cfm?itemno=#url.itemno#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"		
		datasource          = "AppsPurchase"
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
		drillmode           = "tab" 
		drillargument       = "900;1200;false;false"	
		drilltemplate       = "Procurement/Application/Receipt/ReceiptEntry/ReceiptLineEdit.cfm?rctid="
		drillkey            = "ReceiptId"
		drillbox            = "addaddress">	


