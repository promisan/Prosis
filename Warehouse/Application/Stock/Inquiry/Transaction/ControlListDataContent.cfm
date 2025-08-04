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

<!--- control list data content --->

<cfquery name="Param" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#url.Mission#'	
</cfquery>

<cfsavecontent variable="myquery">

	<cfoutput>	   
		SELECT    TOP 300000 IT.*, IT.TransactionDate <!--- allow for column to be created as _mth --->
	    FROM      userQuery.dbo.#SESSION.acc#_ItemTransaction IT				
	</cfoutput>	
	
</cfsavecontent>

<cfsavecontent variable="warehousescript">

	<cfoutput>	   
		SELECT    @code, @fld, City 
	    FROM      Materials.dbo.Warehouse
		WHERE     Mission = '#url.mission#'
		AND       Operational = 1 	
		ORDER BY City			
	</cfoutput>	
	
</cfsavecontent>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
	
	<cfset itm = itm+1>	
	
	<cf_tl id="Warehouse" var = "1">		
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "WarehouseName",																	
						alias           = "",																			
						search          = "text",
						filtermode      = "2",
						lookupscript    = "#warehousescript#",
						lookupgroup     = "City"}>					
						
	<cfset itm = itm+1>	
	<cf_tl id="Location" var = "1">		
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "StorageCode",																	
						alias           = "",
						display         = "no",																			
						search          = ""}>		


	<!--- 					
	<cfset itm = itm+1>
	<cf_tl id="ItemNo" var = "1">		
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "ItemNo",																	
						alias           = "IT",																			
						searchalias		= "IT",
						search          = "text",
						filtermode      = "4"}>				
	--->					
						
	<cfset itm = itm+1>
	<cf_tl id="Product" var = "1">		
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "ItemDescription",																	
						alias           = "",																			
						search          = "text",
						filtermode      = "4",
						lookupgroup     = "ItemCategory"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Category" var = "1">		
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "ItemCategoryDescription",																	
						alias           = "",																			
						search          = "text",
						display         = "No",
						displayFilter   = "Yes",
						filtermode      = "3"}>											
							
	<cfset itm = itm+1>
	<cf_tl id="UoM" var = "1">			
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "UoMDescription",					
						alias           = "",																									
						filtermode      = "0"}>		
						
						
	
	<cfif Param.LotManagement eq "1">		
				
		<cfset itm = itm+1>
		<cf_tl id="Lot" var = "1">			
		<cfset fields[itm] = {label     = "#lt_text#",                    
		     				field       = "TransactionLot",					
							alias       = "",																			
							search      = "text",
							filtermode  = "2"}>								
	</cfif>					
						
	<cfset itm = itm+1>
	<cf_tl id="Transaction" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "BatchDescription",					
						alias       = "",																			
						search      = "text",
						filtermode  = "3"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="ReceiptNo" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "BatchReference",					
						alias       = "",																			
						search      = "text",
						filtermode  = "4"}>																							
	
	<!---						
	<cfset itm = itm+1>
	<cf_tl id="Request" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "RequestReference",																
						alias       = "",																			
						search      = "text",
						filtermode  = "0"}>		
						
	--->													
						
	<cfset itm = itm+1>
	<cf_tl id="Date" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionDate",					
						alias       = "IT",		
						column      = "month",
						align       = "center",		
						formatted   = "dateformat(TransactionDate,CLIENT.DateFormatShow)",																	
						search      = "date"}>		
	
	
	<cfset itm = itm+1>						
	<cfset fields[itm] = {label   = "St", 	
                    LabelFilter   = "Status",				
					field         = "ActionStatus",					
					filtermode    = "3",    
					search        = "",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=Yellow,1=Green"}>					
						
	<cfset itm = itm+1>
	<cf_tl id="Batch" var = "1">						
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionBatchNo",					
						alias       = "",		
						align       = "center",																	
						search      = "text"}>		
						
    <cfif url.selection eq "unit">
	
		<cfset itm = itm+1>
		<cf_tl id="Receiving Unit" var = "1">						
		<cfset fields[itm] = {label     = "#lt_text#",                    
		     				field       = "Destination",					
							alias       = "",	
							width       = "60",																							
							search      = "text",
							filtermode  = "2"}>			
	
	</cfif>		
	
	<!---
	
	<cfset itm = itm+1>	
	<cf_tl id="Barcode" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "AssetBarCode",																	
						alias       = "",	
						filtermode  = "4", 																		
						search      = "text"}>												
						
	--->					

	<cfset itm = itm+1>
	<cf_tl id="Quantity" var = "1">							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionQuantity",	
						align       = "right",				
						alias       = "",			
						aggregate   = "sum",		
						formatted   = "numberformat(TransactionQuantity,'[precision]')",							
						precision   = "ItemPrecision",													
						search      = "number"}>								
	
	<!--- define access --->
	
	<cfif url.selection eq "price">
	
		<cfinvoke component = "Service.Access"  
			   method           = "RoleAccess" 
			   Role             = "'WhsPick'"
			   Parameter        = "#url.systemfunctionid#"
			   Mission          = "#url.mission#"  	  
			   AccessLevel      = "2"
			   returnvariable   = "accesslevel">						
							
	    <cfif AccessLevel eq "GRANTED">					
		
			<!---
							
			<cfset itm = itm+1>
			<cf_tl id="Price" var = "1">									
			<cfset fields[itm] = {label     = "#lt_text#",                    
			     				field       = "TransactionCostPrice",					
								align       = "right",
								alias       = "",					
								formatted   = "numberFormat(TransactionCostPrice,'__,_.__')",														
								search      = ""}>		
								
			--->					
								
			<cfset itm = itm+1>
	 		<cf_tl id="Amount" var = "1">											
			<cfset fields[itm] = {label     = "#lt_text#",                    
			     				field       = "TransactionValue",					
								align       = "right",
								alias       = "",	
								aggregate   = "sum",				
								formatted   = "numberformat(TransactionValue*-1,',.__')",														
								search      = ""}>	
							
		</cfif>		
	
	</cfif>																																
	
	<cfset itm = itm+1>				
	
	<!--- hidden fields --->
	<cf_tl id="Id" var = "1">												
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionId",					
						display     = "No",
						alias       = "",																			
						search      = "text"}>																																
		
<cfset menu=ArrayNew(1)>	
	
<!--- embed|window|dialogajax|dialog|standard --->

<!--- prevent the method to see this as an embedded listing --->
	
<cf_listing
	    header              = "transactionlist"
	    box                 = "transaction_#url.warehouse#"
		link                = "#SESSION.root#/Warehouse/Application/Stock/Inquiry/Transaction/ControlListDataContent.cfm?selection=#url.selection#&mission=#url.mission#&warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"		
		datasource          = "AppsQuery"
		listquery           = "#myquery#"		
		listorderfield      = "TransactionDate"
		listorder           = "TransactionDate"
		listorderdir        = "ASC"
		headercolor         = "ffffff"
		show                = "100"		<!--- better to let is be set in the preferences --->
		menu                = "#menu#"
		filtershow          = "Yes"
		excelshow           = "Yes" 	
		refresh             = "0"
		
		analysisModule      = "Warehouse"
		analysisReportName  = "Facttable: Consumption Transactions"	
		analysisPath        = "Warehouse\Application\Stock\Inquiry\Transaction\"
		analysisTemplate    = "FactTableStock.cfm"
		QueryString         = "mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
		
		listlayout          = "#fields#"
		drillmode           = "window" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "Warehouse/Application/Stock/Inquiry/TransactionView.cfm?systemfunctionid=#url.systemfunctionid#&drillid="
		drillkey            = "TransactionId"
		drillbox            = "addaddress">	
		