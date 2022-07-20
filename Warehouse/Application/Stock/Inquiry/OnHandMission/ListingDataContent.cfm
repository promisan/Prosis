
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
	    FROM      userQuery.dbo.#SESSION.acc#_OnHand_#url.mission# I				
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


<cfset globalmission = "granted">


<cfquery name="Warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	  *
		FROM   	  Warehouse W
		WHERE  	  Mission  = '#url.mission#'							
		AND       Operational = 1		
		<cfif globalmission neq "granted">				
		AND       W.MissionOrgUnitId IN (					   
	                     SELECT DISTINCT MissionOrgUnitId 
				         FROM   Organization.dbo.Organization 
						 WHERE  OrgUnit IN (#quotedvalueList(accesslist.orgunit)#) 						 
				 )						
		</cfif>		
		
</cfquery>		

<cfset fields=ArrayNew(1)>
	
	<cfsavecontent variable="itemscript">

		<cfoutput>	   
			SELECT    @code, @fld, Category 
		    FROM      Materials.dbo.Item
			WHERE     Mission = '#url.mission#'
			AND       Operational = 1 
			AND       ItemNo IN (SELECT ItemNo FROM userQuery.dbo.#SESSION.acc#_OnHand_#url.mission# I)	
			ORDER BY  Category			
		</cfoutput>	
	
	</cfsavecontent>			
		
	<cfset itm = itm+1>		
	<cfset fields[itm] = {label           = "#vItemNoExternal#",                    
	     				field             = "ItemNoExternal",							
						align       	  = "left",
						search			  = "text"}>	
						
	<cfset itm = itm+1>		
	<cfset fields[itm] = {label     	  = "#vBarcode#",                    
	     				field       	  = "ItemBarCode",							
						align       	  = "left",
						search			  = "text"}>												

	<cfset itm = itm+1>		
	<cfset fields[itm] = {label     	  = "#vCategory#",                    
	     				field       	  = "Description",							
						align       	  = "left",
						search			  = "text",
						filtermode        = "2"}>
	
	<!---	
	<cfset itm = itm+1>		
	<cfset fields[itm] = {label           = "#vItemName#",                    
	     				field             = "ItemDescription",	<!--- display --->	
						searchfield       = "ItemNo",		    <!--- code    --->						
						search            = "text",									
						lookupscript      = "#itemscript#",
						lookupgroup       = "Category",
						filtermode        = "4"}>	
						--->	
						
	<cfset itm = itm+1>		
	<cfset fields[itm] = {label           = "#vItemName#",                    
	     				field             = "ItemDescription",	<!--- display --->	
						searchfield       = "ItemDescription",		    <!--- code    --->						
						search            = "text",															
						filtermode        = "4"}>																				
		
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
						
	 <cfloop query="warehouse">
	 
		<cfset itm = itm+1>	
		<cfset fields[itm] = {label           = "#Warehouse#",                    
		     				field             = "#Warehouse#",		
							aggregate         = "SUM",						
							align             = "right",	
							width             = "30", 																		
							formatted         = "numberformat(#Warehouse#,'[precision]')",
							precision         = "ItemPrecision",
							search            = "number"}>		
	 	 
	 </cfloop>						
	 
	 <cfset itm = itm+1>	
		<cfset fields[itm] = {label           = "Total",                    
		     				field             = "OnHand#url.mission#",		
							aggregate         = "SUM",						
							align             = "right",	
							width             = "30", 																		
							formatted         = "numberformat(OnHand#url.mission#,'[precision]')",
							precision         = "ItemPrecision",
							search            = "number"}>		
	
	<!---					
	<cfif mode eq "stock" and Param.LotManagement eq "1">
	
		<cfset itm = itm+1>		
		<cfset fields[itm] = {label       = "#vLot#",                    
		     				field         = "TransactionLot",																							
							search        = "text",	
							filtermode    = "4"}>					
	
	</cfif>		
	--->					
						
	<!--- define access 
	
	<cfsavecontent variable="myaddscript">
	
		<cfoutput>
		    
			h = #client.height-150#;
			w = #client.width-150#;
			ptoken.open('#SESSION.root#/warehouse/maintenance/warehouselocation/LocationItemUoM/ItemUoMEdit.cfm?warehouse=#url.warehouse#&location=#url.location#','_blank', 'left=20, top=20, width=' + w + ',height=' + h + ',status=yes, toolbar=no, scrollbars=yes, resizable=yes');
			
		</cfoutput>
	
	</cfsavecontent>
	
	--->

<cfset menu=ArrayNew(1)>	

<cfinvoke component         = "Service.Access"  
		   method           = "WarehouseProcessor" 
		   mission          = "#url..mission#"	  		  
		   systemfunctionid = "#url.systemfunctionid#"
		   returnvariable   = "access">			   	     

<!--- determine is the scope is maintenance as opposed to a application function --->
				
<cfif url.systemfunctionid neq "">
				
	<cfquery name="getFunction" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_ModuleControl
		WHERE     SystemFunctionId = '#url.systemfunctionid#'
	</cfquery>

</cfif>
	
<!--- define access 				  
<cfif url.warehouse neq "" and url.location neq "" and url.systemfunctionid neq "">
		
		<cfif access eq "EDIT" or access eq "ALL" or getFunction.FunctionClass eq "Maintain">		
		
			<cf_tl id="Add Location/Product" var="addNew">
														
			<cfset menu[1] = {label = "#addNew#", icon = "insert.gif", script = "#myaddscript#"}>	
										
		</cfif>
				
</cfif>
--->

<cfoutput>
	<input type="hidden" id="mission" name="mission" value="#url.mission#">
</cfoutput>
			
<cf_listing
    header              = "itemlocationlist"
    box                 = "stockonhand_a"
	link                = "#SESSION.root#/Warehouse/Application/Stock/Inquiry/OnHandMission/ListingDataContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
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
	filtershow          = "Yes"
	excelshow           = "Yes" 		
	listlayout          = "#fields#"
	drillmode           = "tab" 
	drillargument       = "#client.height-90#;#client.width-90#;false;false"	
	drilltemplate       = "Warehouse/Maintenance/ItemMaster/ItemView.cfm?mission=#url.mission#&id="
	drillkey            = "ItemUoMId"
	drillbox            = "adduom">	
	