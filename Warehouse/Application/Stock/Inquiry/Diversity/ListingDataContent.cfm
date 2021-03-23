
<!--- control list data content --->

<cfquery name="Param" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	  *
	FROM   	  Ref_ParameterMission
	WHERE  	  Mission = '#url.Mission#'							
</cfquery>	

<cfquery name="CheckCategory" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	  DISTINCT Category
	FROM   	  userQuery.dbo.#SESSION.acc#_Diversity I								
</cfquery>	

<cfsavecontent variable="myquery">

	<cfoutput>	   	
		SELECT    *, LastTransaction  
	    FROM      userQuery.dbo.#SESSION.acc#_Diversity I				
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
<cf_tl id = "Min"            var ="vMinStock">
<cf_tl id = "Confirm"        var ="vPending">
<cf_tl id = "Reorder"        var ="vReorder">
<cf_tl id = "On Hand"        var ="vOnHand">
<cf_tl id = "Value"          var ="vStockValue">
<cf_tl id = "Max"            var ="vMaxStock">
<cf_tl id = "Movement"       var ="vLast">
<cf_tl id = "ItemNoExternal" var ="vItemNoExternal">

<cfquery name="Param" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	  *
	FROM   	  Ref_ParameterMission
	WHERE  	  Mission = '#url.Mission#'							
</cfquery>	

<cfset fields=ArrayNew(1)>

	<!---
    	
	<cfsavecontent variable="itemscript">

		<cfoutput>	   
			SELECT    @code, @fld, Category 
		    FROM      Materials.dbo.Item
			WHERE     Mission = '#url.mission#'
			AND       Operational = 1 
			AND       ItemNo IN (SELECT ItemNo FROM userQuery.dbo.#SESSION.acc#_Diversity I)	
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
	
	--->
	
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label       = "#vSubCategory#",                    
	     				field         = "CategoryItemName",																							
						search        = "text",	
						filtermode    = "3"}>							

		
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
	<cfset fields[itm] = {label           = "#vItem#",                    
	     				field             = "ItemNo",
						functionscript    = "stockOnHandItem",	
						functioncondition = "#url.mission#",																																																			
						search            = "text"}>	
	
	<!--- the below is more for limited number of items with many location 
	<cfset itm = itm+1>		
	<cfset fields[itm] = {label           = "#vItemName#",                    
	     				field             = "ItemDescription",	<!--- display --->	
						searchfield       = "ItemNo",		    <!--- code    --->						
						search            = "text",									
						lookupscript      = "#itemscript#",
						lookupgroup       = "Category",
						filtermode        = "2"}>							
	--->	
	
	<cfset itm = itm+1>		
	<cfset fields[itm] = {label           = "#vItemName#",                    
	     				field             = "ItemDescription",													
						search			  = "text"}>																			
		
	<cfset itm = itm+1>		
	<cfset fields[itm] = {label           = "P",                    
	                    labelfilter       = "Pictures",
	     				field             = "Pictures",					
						alias             = "",	
						width             = "10",
						align       	  = "center",
						filtermode  	  = "2"}>		
						
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
	
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label          = "#vLast#",                    
	     				field            = "LastTransaction",													
						align            = "center",		
						column           = "month",																	
						formatted        = "dateformat(LastTransaction,client.dateformatshow)",						
						search           = "date"}>		
						
	<cfset itm = itm+1>		
	<cfset fields[itm] = {label           = "#vReorder#",                    
	     				field             = "ReorderQuantity",							
						align       	  = "right",
						search			  = "number"}>																	
					
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label     = "#vOnHand#",                    
	     				field       = "OnHand",		
						aggregate   = "SUM",						
						align       = "right",																			
						formatted   = "numberformat(OnHand,'[precision]')",
						precision   = "ItemPrecision",
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
		FROM      Ref_ModuleControl
		WHERE     SystemFunctionId = '#url.systemfunctionid#'
	</cfquery>

</cfif>
	
<cfoutput>
	<input type="hidden" id="mission" name="mission" value="#url.mission#">
</cfoutput>

<!--- embed|window|dialogajax|dialog|standard --->		

<cf_listing
    header              = "diversity#url.warehouse#"
    box                 = "stockonhand_b"
	link                = "#SESSION.root#/Warehouse/Application/Stock/Inquiry/Diversity/ListingDataContent.cfm?mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&warehouse=#url.warehouse#&location=#url.location#"
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
