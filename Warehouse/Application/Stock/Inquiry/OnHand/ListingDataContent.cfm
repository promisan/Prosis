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
	SELECT 	  *
	FROM   	  Ref_ParameterMission
	WHERE  	  Mission = '#url.Mission#'							
</cfquery>	

<cfquery name="CheckLocation" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	  DISTINCT WarehouseName,Description
	FROM   	  userQuery.dbo.#SESSION.acc#_OnHand I								
</cfquery>	

<cfquery name="CheckCategory" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	  DISTINCT Category
	FROM   	  userQuery.dbo.#SESSION.acc#_OnHand I								
</cfquery>	

<cfsavecontent variable="myquery">

	<cfoutput>	   	
		SELECT    * 
	    FROM      userQuery.dbo.#SESSION.acc#_OnHand I				
	</cfoutput>	
	
</cfsavecontent>						

<cfset itm = 0>

<cf_tl id = "Facility"       var ="vFacility">
<cf_tl id = "Location"       var ="vLocation">
<cf_tl id = "Code"           var ="vCode">
<cf_tl id = "Item"           var ="vItem">
<cf_tl id = "ParentItemNo"   var ="vParentItemNo">
<cf_tl id = "ParentItemName" var ="vParentItemName">
<cf_tl id = "Category"       var ="vCategory">
<cf_tl id = "Subcategory"    var ="vSubCategory">
<cf_tl id = "Lot"            var ="vLot">
<cf_tl id = "Location"       var ="vLocation">
<cf_tl id = "Product"        var ="vItemName">
<cf_tl id = "BarCode"        var ="vBarCode">
<cf_tl id = "UoM"            var ="vUoM">
<cf_tl id = "Lowest"         var ="vLowest">
<cf_tl id = "Issue"          var ="vAvgIssue">
<cf_tl id = "Min"            var ="vMin">
<cf_tl id = "Confirm"        var ="vPending">
<cf_tl id = "Reserved"       var ="vReserve">
<cf_tl id = "On Hand"        var ="vOnHand">
<cf_tl id = "Value"          var ="vStockValue">
<cf_tl id = "Max"            var ="vMax">
<cf_tl id = "Item Code"      var ="vItemNoExternal">

<cfquery name="Param" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	  *
	FROM   	  Ref_ParameterMission
	WHERE  	  Mission = '#url.Mission#'							
</cfquery>	

<cfset fields=ArrayNew(1)>

    <cfif checkLocation.recordcount gt "1">

	    <!--- 
		<cfset itm = itm+1>	
		<cfset fields[itm] = {label     = "#vFacility#",                    
		     				field       = "WarehouseName",																							
							search      = "text",
							filtermode  = "2"}>		
							
	     --->
		 
		<cfset itm = itm+1>		
		<cfset fields[itm] = {label     = "#vLocation#",                    
		     				field       = "Description",																							
							search      = "text",
							filtermode  = "2"}>
							
		<cfset group = "WarehouseName">
		
	<cfelse>
	
		<cfset group = 	"Category">					
						
	</cfif>		
	
	<cfsavecontent variable="itemscript">

		<cfoutput>	   
			SELECT    @code, @fld, Category 
		    FROM      Materials.dbo.Item
			WHERE     Mission = '#url.mission#'
			AND       Operational = 1 
			AND       ItemNo IN (SELECT ItemNo FROM userQuery.dbo.#SESSION.acc#_OnHand I)	
			ORDER BY  Category			
		</cfoutput>	
	
	</cfsavecontent>	
			
	<cfif checkCategory.recordcount gte "2">
	
		<cfset itm = itm+1>		
		<cfset fields[itm] = {label       = "#vCategory#",                    
		     				field         = "CategoryDescription",	
							search        = "text",	
							filtermode    = "3"}>	
		
		<cfset itm = itm+1>					
		<cfset fields[itm] = {label       = "#vSubCategory#",                    
		     				field         = "CategoryItemName"}>								
						
	<cfelse>
	
		<cfset itm = itm+1>	
		<cfset fields[itm] = {label       = "#vCategory#",                    
		     				field         = "CategoryDescription"}>	
		
		<cfset itm = itm+1>	
		<cfset fields[itm] = {label       = "#vSubCategory#",                    
		     				field         = "CategoryItemName",																							
							search        = "text",	
							filtermode    = "3"}>	
	
	</cfif>								

	<cfset itm = itm+1>		
	<cfset fields[itm] = {label           = "P",                    
	                    labelfilter       = "Pictures",
	     				field             = "Pictures",					
						alias             = "",	
						width             = "10",
						align       	  = "center",
						filtermode  	  = "2"}>							
	
	<cfset itm = itm+1>		
	<cfset fields[itm] = {label     	  = "Barcode",                    
	     				field       	  = "ItemBarCode",							
						align       	  = "left",
						search			  = "text"}>

	<cfset itm = itm+1>		
	<cfset fields[itm] = {label           = "#vItemNoExternal#",                    
	     				field             = "ItemNoExternal",							
						align       	  = "left",
						search			  = "text"}>		
	
	<cfset itm = itm+1>		
	<cfset fields[itm] = {label           = "#vItemName#",                    
	     				field             = "ItemDescription",	<!--- display --->	
						searchfield       = "ItemNo",		    <!--- code    --->						
						search            = "text",									
						lookupscript      = "#itemscript#",
						lookupgroup       = "Category",
						filtermode        = "2"}>																
		
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label           = "#vItem#",                    
	     				field             = "ItemNo",
						functionscript    = "stockOnHandItem",	
						functioncondition = "#url.mission#",																																																			
						search            = "text"}>									
						
	<cfset itm = itm+1>			
	<cfset fields[itm] = {label           = "#vUoM#",                    
	     				field             = "UoMDescription",																						
						search            = "text",
						filtermode        = "2"}>		
						
	<cfif mode eq "stock" and Param.LotManagement eq "1">
	
		<cfset itm = itm+1>		
		<cfset fields[itm] = {label       = "#vLot#",                    
		     				field         = "TransactionLot",																							
							search        = "text",	
							filtermode    = "4"}>					
	
	</cfif>							
										
	<!--- remove this

	<cfif mode eq "Item">
	
		<cfset itm = itm+1>
		
		<cfset fields[itm] = {label       = "#vPending#",                    
		     				field         = "OnHandPending",							
							align         = "right",																			
							formatted     = "numberformat(OnHandPending,'[precision]')",							
							precision     = "ItemPrecision",
							search        = "number"}>	
						
	</cfif>			
	
	<cfset itm = itm+1>		
	<cfset fields[itm] = {label           = "#vMin#",                    
	     				field             = "MinimumStock",							
						align       	  = "right",
						width             = "14",
						search			  = "number"}>													
							
	<cfset itm = itm+1>		
	<cfset fields[itm] = {label           = "#vMax#",                    
	     				field             = "MaximumStock",							
						align       	  = "right",
						width             = "14",
						search			  = "number"}>		
												
	--->			
		
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label           = "#vReserve#",                    
	     				field             = "Reserved",		
						aggregate         = "SUM",						
						align             = "right",	
						width             = "25",            																		
						formatted         = "numberformat(Reserved,'[precision]')",
						precision         = "ItemPrecision",
						search            = "number"}>			
					
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label           = "#vOnHand#",                    
	     				field             = "OnHand",		
						aggregate         = "SUM",						
						align             = "right",	
						width             = "25", 																		
						formatted         = "numberformat(OnHand,'[precision]')",
						precision         = "ItemPrecision",
						search            = "number"}>		
	
	<!--- Hardcoded temporarily as per Dev's advise, until we discuss about the Lot barcode. --->
					
	<cfif mode eq "Item">				
	
		<cfset itm = itm+1>					
		
		<cfset fields[itm] = {label     = "S",                    
		                    labelfilter = "Status",
		     				field       = "Status",					
							alias       = "",	
							width       = "10",
							align       = "center",										
							formatted   = "Rating",																								
							ratinglist  = "Replenish=Red,Alert=Yellow,Good=Green",
							search      = "",
							filtermode  = "2"}>
		
		<!--- EFMS					
		<cfset itm = itm+1>
		
		<cfset fields[itm] = {label     = "#vLowest#",                    
		     				field       = "LowestStock",					
							alias       = "",	
							align       = "right",																		
							formatted   = "numberformat(loweststock,',__')",
							search      = "number"}>	
							
		--->
								
		<cfset itm = itm+1>				
		<cfset fields[itm] = {label     = "#vAvgIssue#",                    
		     				field       = "DistributionAverage",					
							alias       = "",	
							align       = "right",																		
							formatted   = "numberformat(DistributionAverage,',__')"}>						
						
														
		<cfset itm = itm+1>
			
		<!--- hidden fields --->
		
		<cfset fields[itm] = {label     = "Id",                    
		     				field       = "ItemLocationId",					
							display     = "No",
							alias       = "",																			
							search      = "text"}>		
						
	</cfif>							
				
			
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


<cfif (url.location neq "" and 
       url.systemfunctionid neq "" and 
	   Param.LotManagement eq "0" and url.mode eq "item" and
	   (access eq "EDIT" or access eq "ALL" or getFunction.FunctionClass eq "Maintain")) 
	   
	   or (getAdministrator(url.mission) eq "1" and Param.LotManagement eq "0" and  url.mode eq "item")>
	   
	<!--- embed|window|dialogajax|dialog|standard --->			
	<cf_listing
	    header              = "itemlocationlist"
	    box                 = "stockonhand_a"
		link                = "#SESSION.root#/Warehouse/Application/Stock/Inquiry/OnHand/ListingDataContent.cfm?mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&warehouse=#url.warehouse#&location=#url.location#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		font                = "Verdana"
		datasource          = "AppsMaterials"
		listquery           = "#myquery#"	
		listgroup           = "Category"			
		listorder           = "Description"
		listorderalias      = "I"
		listorderdir        = "ASC"
		headercolor         = "ffffff"
		show                = "35"		
		menu                = "#menu#"
		filtershow          = "Hide"
		excelshow           = "Yes" 		
		listlayout          = "#fields#"
		drillmode           = "window" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "Warehouse/Maintenance/WarehouseLocation/LocationItemUoM/ItemUoMEdit.cfm?drillid="
		drillkey            = "ItemLocationId"
		drillbox            = "adduom">	
		
<cfelse>

	<!--- embed|window|dialogajax|dialog|standard --->	
	

	<cf_listing
	    header              = "itemlocationlist"
	    box                 = "onhand_#url.warehouse#"
		link                = "#SESSION.root#/Warehouse/Application/Stock/Inquiry/OnHand/ListingDataContent.cfm?mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&warehouse=#url.warehouse#&location=#url.location#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		font                = "Verdana"
		datasource          = "AppsMaterials"
		listquery           = "#myquery#"		
		listgroup           = "WarehouseName"
		listorder           = "Description"
		listorderalias      = "I"
		listorderdir        = "ASC"
		headercolor         = "ffffff"
		show                = "35"		
		menu                = "#menu#"
		filtershow          = "Yes"
		excelshow           = "Yes" 	
		drillkey            = "ListingKey"	
		listlayout          = "#fields#">	

</cfif>