<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfquery name="Param"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#url.mission#'
</cfquery>

<cfoutput>
<cfsavecontent variable="myquery">

    SELECT * --,OrderDate
	FROM ( 

		SELECT     P.PurchaseNo, W.WarehouseName, S.OrderClass, S.OrderDate, S.OrgUnitVendor, P.Currency,
	                (SELECT      OrgUnitName
	                  FROM       Organization.dbo.Organization
	                  WHERE      OrgUnit = S.OrgUnitVendor) AS VendorName, 
					  
				    R.Warehouse, R.WarehouseUoM AS UoM, I.UoMDescription,
					P.OrderQuantity * P.OrderMultiplier AS Ordered,
					
	                (SELECT        ISNULL(SUM(ReceiptQuantity * ReceiptMultiplier), 0) AS Expr1
	                  FROM            PurchaseLineReceipt AS PLR
	                  WHERE        (RequisitionNo = P.RequisitionNo) AND (ActionStatus <> '9')) AS Received, 
					  
					P.OrderQuantity * P.OrderMultiplier -
					  
	                (SELECT        ISNULL(SUM(ReceiptQuantity * ReceiptMultiplier), 0) AS Expr1
	                  FROM            PurchaseLineReceipt AS PLR
	                  WHERE        (RequisitionNo = P.RequisitionNo) AND (ActionStatus <> '9')) AS Pending, 
					  
					P.OrderAmountBaseCost, 
					P.OrderAmountBaseTax, 
					P.OrderAmountBase
												   
		FROM        RequisitionLine AS R INNER JOIN	
	                PurchaseLine AS P ON R.RequisitionNo = P.RequisitionNo INNER JOIN
	                Purchase AS S ON P.PurchaseNo = S.PurchaseNo INNER JOIN 
				    Materials.dbo.Warehouse W ON R.Warehouse = W.Warehouse INNER JOIN
                    Materials.dbo.ItemUoM I ON R.WarehouseItemNo = I.ItemNo AND R.WarehouseUoM = I.UoM
		WHERE       R.Mission = '#URL.Mission#' 
		AND         R.WarehouseItemNo = '#URL.ItemNo#' 
		AND         R.ActionStatus = '3' 
		AND         P.ActionStatus <> '9'
		
	
	) as D
	
	WHERE 1=1 
	--condition

</cfsavecontent>
</cfoutput>
	

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

    <!---
	<cfset itm = itm+1>

	<cf_tl id="Status" var = "1">
	
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "StatusDescription",					
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>	
						
	--->					

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
	
	<!---
						
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
	
	--->
						
	<cfset itm = itm+1>	
	<cf_tl id="Date" var = "1">	
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "OrderDate",					
						alias       = "",		
						align       = "center",		
						column      = "month",
						formatted   = "dateformat(OrderDate,CLIENT.DateFormatShow)",																	
						search      = "date"}>		
						
	<cfset itm = itm+1>		
	<cf_tl id="UoM" var = "1">	
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "UoMDescription",					
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>						
						
	<cfset itm = itm+1>						
	<cf_tl id="Receipt" var = "1">	
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Pending",	
						align       = "right",				
						aggregate   = "sum",	
						formatted   = "numberformat(Pending,',__')",														
						search      = ""}>				
				
	<cfset itm = itm+1>	
	<cf_tl id="Ordered" var = "1">	
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Ordered",	
						align       = "right",	
						aggregate   = "sum",												
						formatted   = "numberformat(Ordered,',__')",														
						search      = ""}>		
	
	
	<cfset itm = itm+1>	
	<cf_tl id="Cost" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "OrderAmountBaseCost",					
						align       = "right",
						aggregate   = "sum",
						width       = "20",			
						formatted   = "numberFormat(OrderAmountBaseCost,',.__')",														
						search      = ""}>		
						
	<cfset itm = itm+1>	
	<cf_tl id="Tax" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "OrderAmountBaseTax",					
						align       = "right",
						width       = "20",				
						aggregate   = "sum",
						formatted   = "numberFormat(OrderAmountBaseTax,',.__')",														
						search      = ""}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Total" var = "1">	
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "OrderAmountBase",					
						align       = "right",
						width       = "20",
						aggregate   = "sum",				
						formatted   = "numberFormat(OrderAmountBase,',.__')",														
						search      = ""}>													
						
	<cfset itm = itm+1>				
	
	<!--- hidden fields --->
	
	<cfset fields[itm] = {label     = "Id",                    
	     				field       = "RequisitionNo",					
						display     = "No",
						alias       = "",																			
						search      = "text"}>																																
		
<cfset menu=ArrayNew(1)>	
	
<!--- embed|window|dialogajax|dialog|standard --->
							
<cf_listing
	    header              = "requisitionlist#url.itemno#_#url.mission#"
	    box                 = "requisitionlist#url.itemno#_#url.mission#"
		link                = "#SESSION.root#/Warehouse/Maintenance/ItemMaster/Requisition/RequisitionListingContent.cfm?itemno=#url.itemno#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"		
		datasource          = "AppsPurchase"
		listquery           = "#myquery#"		
		listgroup           = "WarehouseName"
		listorderfield      = "OrderDate"
		listorder           = "OrderDate"
		listorderdir        = "ASC"
		headercolor         = "ffffff"
		show                = "60"		
		menu                = "#menu#"
		filtershow          = "Show"
		excelshow           = "Yes" 		
		listlayout          = "#fields#"
		drillmode           = "tab" 
		drillargument       = "900;1200;false;false"	
		drilltemplate       = "Procurement/Application/Receipt/ReceiptEntry/ReceiptLineEdit.cfm?rctid="
		drillkey            = "PurchaseNo"
		drillbox            = "addaddress">	


