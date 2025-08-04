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
	SELECT 	  *
	FROM   	  Ref_ParameterMission
	WHERE  	  Mission = '#url.Mission#'							
</cfquery>	

<cfsavecontent variable="myquery">

	<cfoutput>	   	
		SELECT    * 
	    FROM      userQuery.dbo.#SESSION.acc#_OnHandTransaction I		
		
	</cfoutput>	
	
</cfsavecontent>						

<cfset itm = 0>

<cf_tl id = "Facility"    var ="vFacility">
<cf_tl id = "Location"    var ="vLocation">
<cf_tl id = "Code"        var ="vCode">
<cf_tl id = "Item"        var ="vItem">
<cf_tl id = "Category"    var ="vCategory">
<cf_tl id = "Lot"         var ="vLot">
<cf_tl id = "Reference"   var ="vReference">
<cf_tl id = "Location"    var ="vLocation">
<cf_tl id = "Product"     var ="vItemName">
<cf_tl id = "BarCode"     var ="vBarCode">
<cf_tl id = "UoM"         var ="vUoM">
<cf_tl id = "Lowest"      var ="vLowest">
<cf_tl id = "Avg.Issue"   var ="vAvgIssue">
<cf_tl id = "Min.Stock"   var ="vMinStock">
<cf_tl id = "Confirm"     var ="vPending">
<cf_tl id = "Original"    var ="vOriginal">
<cf_tl id = "Consumed"    var ="vUsed">
<cf_tl id = "Value"       var ="vStockValue">
<cf_tl id = "OnHand"      var ="vOnHand">


<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vFacility#",                    
	     				field       = "WarehouseName",																							
						search      = "text",
						filtermode  = "2"}>		

	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vLocation#",                    
	     				field       = "LocationName",																							
						search      = "text",
						filtermode  = "2"}>		
	
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vCategory#",                    
	     				field       = "Category",																							
						search      = "text",	
						filtermode  = "2"}>		
		
	<cfsavecontent variable="itemscript">

		<cfoutput>	   
			SELECT    @code, @fld, Category 
		    FROM      Materials.dbo.Item
			WHERE     Mission = '#url.mission#'
			AND       Operational = 1 
			AND       ItemNo IN (SELECT ItemNo FROM userQuery.dbo.#SESSION.acc#_OnHandTransaction I)	
			ORDER BY Category			
		</cfoutput>	
	
	</cfsavecontent>							
						
	<cfset itm = itm+1>
		
	<cfset fields[itm] = {label       = "#vItemName#",                    
	     				field         = "ItemDescription",	<!--- display --->	
						searchfield   = "ItemNo",		    <!--- code    --->						
						search        = "text",									
						lookupscript  = "#itemscript#",
						lookupgroup   = "Category",
						filtermode    = "2"}>													
		
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     	  = "#vItem#",                    
	     				field       	  = "ItemNo",
						functionscript    = "item",																																																				
						search      	  = "text"}>		
						
	<cfset itm = itm+1>	
		
	<cfset fields[itm] = {label     = "#vUoM#",                    
	     				field       = "UoMDescription",																						
						search      = "text",
						filtermode  = "2"}>						
	
	<cfif Param.LotManagement eq "1">
	
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vLot#",                    
	     				field       = "TransactionLot",																							
						search      = "text",	
						filtermode  = "2"}>		

	</cfif>		
		
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vReference#",                    
	     				field       = "TransactionReference",																							
						search      = "text",	
						filtermode  = "4"}>										
					
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vOriginal#",                    
	     				field       = "OnHand",							
						align       = "right",																			
						formatted   = "numberformat(TransactionQuantity,',__')",
						search      = "number"}>		
	
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vUsed#",                    
	     				field       = "QuantityUsed",							
						align       = "right",																			
						formatted   = "numberformat(QuantityUsed,',__')"}>		
						
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vOnHand#",                    
	     				field       = "QuantityOnHand",							
						align       = "right",																			
						formatted   = "numberformat(QuantityOnHand,',__')",
						search      = "number"}>													
		
				
			
<!--- define access --->
<cfsavecontent variable="myaddscript">

    <cfoutput>
	    
		h = #client.height-150#;
		w = #client.width-150#;
		ptoken.open('#SESSION.root#/warehouse/maintenance/warehouselocation/LocationItemUoM/ItemUoMEdit.cfm?warehouse=#url.warehouse#&location=#url.location#','_blank', 'left=20, top=20, width=' + w + ',height=' + h + ',status=yes, toolbar=no, scrollbars=yes, resizable=yes');
		
	</cfoutput>
	
</cfsavecontent>

<cfset menu=ArrayNew(1)>	

<cfinvoke component         = "Service.Access"  
		   method           = "WarehouseProcessor" 
		   mission          = "#url..mission#"	  
		   warehouse        = "#url.warehouse#"
		   systemfunctionid = "#url.systemfunctionid#"
		   returnvariable   = "access">			   	     

<!--- determine is the scope is maintenance as opposed to a application function --->
				
<cfif url.systemfunctionid neq "">
				
	<cfquery name="getFunction" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM       Ref_ModuleControl
		WHERE     (SystemFunctionId = '#url.systemfunctionid#')
	</cfquery>

</cfif>
				  
<cfif url.warehouse neq "" and url.location neq "" and url.systemfunctionid neq "">
		
		<cfif access eq "EDIT" or access eq "ALL" or getFunction.FunctionClass eq "Maintain">		
		
			<cf_tl id="Add Location/Product" var="addNew">
														
			<cfset menu[1] = {label = "#addNew#", icon = "insert.gif", script = "#myaddscript#"}>	
										
		</cfif>
				
</cfif>

<cfoutput>
	<input type="hidden" id="mission" name="mission" value="#url.mission#">
</cfoutput>
		
<cf_listing
	    header              = "itemlocationlist"
	    box                 = "itemlocationlist_#url.warehouse#"		
		link                = "#SESSION.root#/Warehouse/Application/Stock/Inquiry/OnHandTransaction/ListingDataContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&warehouse=#url.warehouse#&location=#url.location#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		font                = "Verdana"
		datasource          = "AppsMaterials"
		listquery           = "#myquery#"		
		listgroup           = "WarehouseName"
		listorder           = "ItemDescription"
		listorderalias      = "I"
		listorderdir        = "ASC"
		headercolor         = "ffffff"
		show                = "35"		
		menu                = "#menu#"
		filtershow          = "Yes"
		excelshow           = "Yes" 	
		drillmode           = "window" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "Warehouse/Application/Stock/Inquiry/TransactionView.cfm?accessmode=process&systemfunctionid=#url.systemfunctionid#&drillid="
		drillkey            = "TransactionId"	
		listlayout          = "#fields#">	

