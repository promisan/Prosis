<!--
    Copyright © 2025 Promisan

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

<!--- listing of internal receipt through transfers or conversion --->

<cfoutput>
	<cfsavecontent variable="qQuery">
		SELECT     W.WarehouseName, 
				   WL.Description, 
				   T.ItemNo, 
				   T.ItemDescription, 
				   T.ItemCategory, 
				   T.TransactionQuantity, 
				   T.TransactionUoM, 
				   UoM.UoMDescription, 
		           T.TransactionDate, 
				   T.TransactionValue, 
				   T.TransactionBatchNo, 
				   T.TransactionId, 
				   T.OfficerUserId, 
				   T.OfficerLastName, 
				   T.OfficerFirstName, 
				   T.Created
		FROM       ItemTransaction T 
		           INNER JOIN Warehouse W ON T.Warehouse = W.Warehouse 
				   INNER JOIN WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location 
				   INNER JOIN ItemUoM UoM ON T.ItemNo = UoM.ItemNo AND T.TransactionUoM = UoM.UoM
		WHERE      T.TransactionType IN ('6','8') 
		AND        T.TransactionQuantity > 0 
		AND        T.TransactionBatchNo IN (
					  		   SELECT  TransactionBatchNo
				               FROM    ItemTransaction
							   WHERE   TransactionBatchNo = T.TransactionBatchNo
				               AND     TransactionType IN ('6','8') 
							   AND     Warehouse = '#url.warehouse#'
				  )
			  	  
	</cfsavecontent>
</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

<cfset itm = itm+1>					
<cfset fields[itm] = {label       = "Facility",                    
					 field        = "WarehouseName", 														
					 search       = "text",
					 filtermode   = "2"}>							 

<cfset itm = itm + 1>															
<cfset fields[itm] = {label       = "Storage Location", 					
					 field        = "Description",		
					 align        = "left",		
					 alias        = "WL",
					 searchalias  = "WL",													
					 search       = "text",
					 filtermode   = "2"}>	
					 

<cfset itm = itm+1>					
<cfset fields[itm] = {label       = "Date",  
                     labelfilter  = "Receipt date",                  
					 field        = "TransactionDate", 	
					 alias        = "T",	
					 searchalias  = "T",
					 formatted    = "dateformat(TransactionDate,CLIENT.DateFormatShow)",			
					 search       = "date"}>						  					 

<cfset itm = itm+1>
<cfset fields[itm] = {label       = "Product",                   		
					 field        = "ItemDescription",	
					 lookupgroup  = "ItemCategory",					
					 alias        = "T",	
					 searchalias  = "T",																		 	
					 search       = "text",
					 filtermode   = "2"}>						 						 

<cfset itm = itm+1>
<cfset fields[itm] = {label       = "Category",                   		
					 field        = "ItemCategory",						
					 alias        = "T",	
					 searchalias  = "T",																		 	
					 search       = "text",
					 filtermode   = "2"}>						 						 

<!---
<cfset itm = itm+1>
<cfset fields[itm] = {label       = "Batch No",                   		
					 field        = "TransactionBatchNo",						
					 alias        = "T",	
					 searchalias  = "T",																		 	
					 search       = "number",
					 filtermode   = "0"}>									
--->				 


<cfset itm = itm+1>
<cfset fields[itm] = {label       = "Officer",                   		
					 field        = "OfficerLastName",						
					 alias        = "T",	
					 searchalias  = "T",																		 	
					 search       = "text",
					 filtermode   = "2"}>											 
				 
			 
						
<cfset itm = itm+1>					
<cfset fields[itm] = {  label      = "Quantity",  					
						field      = "TransactionQuantity",
						align      = "right",
						formatted  = "numberformat(TransactionQuantity,'__,__')",			
						filtermode = "0",						
						search     = "number"}>		
						
									 
<cfset itm = itm+1>
<cfset fields[itm] = {label       = "UoM",                   		
					 field        = "UoMDescription",						
					 alias        = "UoM",	
					 searchalias  = "UoM",																		 	
					 search       = "text",
					 filtermode   = "2"}>									
						
						
<cfset itm = itm+1>					
<cfset fields[itm] = {  label      = "Value",  					
						field      = "TransactionValue",
						align      = "right",
						formatted  = "numberformat(TransactionValue,'__,__.__')",			
						filtermode = "0",						
						search     = "number"}>		

<cfset menu = "">


					 
<cf_listing
    header         = "caselist"
    box            = "casebox"
	link           = "#SESSION.root#/Warehouse/application/StockOrder/Task/Receipt/ReceiptListing.cfm?Warehouse=#url.warehouse#"
    html           = "No"		
	tableheight    = "100%"
	tablewidth     = "100%"
	datasource     = "AppsMaterials"
	listquery      = "#qQuery#"
	listorderfield = "TransactionDate"
	listorderalias = "T"
	listorder      = "TransactionDate"
	listorderdir   = "ASC"
	headercolor    = "ffffff"
	show           = "40"			
	menu           = "#menu#"			
	filtershow     = "Show"
	excelshow      = "Yes" 		
	listlayout     = "#fields#"
	drillmode      = "window" 
	drillargument  = "#client.height-80#;#client.widthfull-30#;true;true"			
	drilltemplate  = "Warehouse/Application/Stock/Inquiry/TransactionView.cfm?drillid="
	drillkey       = "TransactionId"
	drillbox       = "addcasefile"
	allowgrouping  = "No">	  
	