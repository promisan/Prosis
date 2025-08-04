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

<cfoutput>
<cfsavecontent variable="onhand">
      (
	   SELECT   SUM(TransactionQuantity)
       FROM     ItemTransaction
	   WHERE    Mission        = '#url.mission#'
	    AND     Warehouse      = S.Warehouse 
	    AND     Location       = S.Location 
	    AND     ItemNo         = S.ItemNo 
	    AND     TransactionUoM = S.UoM
  	)
</cfsavecontent>

<cfsavecontent variable="myquery">

	 SELECT    F.WarehouseName,
	           F.City,
	           S.*,	           
	           W.LocationClass,
			   LR.Description as LocationClassName,
			   W.StorageCode,
			   W.Description,
			   R.Description as FacilityClass,
			   
               #onhand# AS OnHand,  
				
			   (SELECT   SUM(TransactionValue)
                    FROM     ItemTransaction
					WHERE    Mission        = '#url.mission#'
                    AND      Warehouse      = S.Warehouse 
			        AND      Location       = S.Location 
			        AND      ItemNo         = S.ItemNo 
			        AND      TransactionUoM = S.UoM) AS OnHandValue,					 
					 
				(CASE WHEN MinimumStock > #onhand#  THEN 'Replenish'
                       WHEN MinimumStock = #onhand# THEN 'Alert'
				  ELSE 'Good' END) as Status		  
	          		   
	 FROM      ItemWarehouseLocation S 	           
			   INNER JOIN WarehouseLocation W ON S.Warehouse = W.Warehouse AND S.Location = W.Location 
			   INNER JOIN Warehouse F ON S.Warehouse = F.Warehouse 
			   INNER JOIN Ref_WarehouseClass R ON R.Code = F.WarehouseClass
			   INNER JOIN Ref_WarehouseLocationClass LR ON LR.Code = W.LocationClass
			   
	 WHERE     F.Mission = '#url.mission#'	
	 AND       F.Operational = 1
	 AND       S.ItemNo  = '#url.itemno#'			
	 AND       S.UoM     = '#url.uom#'
	 
			
</cfsavecontent>


</cfoutput>

<cfset itm = 0>

<cf_tl id = "Facility"    var ="vFacility">
<cf_tl id = "Location"    var ="vLocation">
<cf_tl id = "PlateNo"     var ="vCode">
<cf_tl id = "Class"       var ="vClass">
<cf_tl id = "Location"    var ="vLocation">
<cf_tl id = "Item Name"   var ="vItemName">
<cf_tl id = "Lowest"      var ="vLowest">
<cf_tl id = "Avg. Issue"  var ="vAvgIssue">
<cf_tl id = "Min. Stock"  var ="vMinStock">
<cf_tl id = "Act. Stock"  var ="vActStock">
<cf_tl id = "Stock Value" var ="vStockValue">
<cf_tl id = "Max Stock"   var ="vMaxStock">

<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "Region",                    
	     				field       = "City",											
						alias       = "F",		
						display     = "No",		
						displayfilter = "Yes",	
						filtermode  = "2",																	
						search      = "text"}>	

	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vFacility#",                    
	     				field       = "WarehouseName",											
						alias       = "F",		
						filtermode  = "0",	
						search      = "text",
						labelfilter = "Facility Name",
						displayfilter = "Yes"}>	
						
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "Facility",                    
	     				field       = "FacilityClass",											
						searchfield = "Description",
						fieldsort   = "Description",
						searchalias = "R",
						alias       = "R",	
						label       = "Facility Class",	
						filtermode  = "2",																	
						search      = "text"}>						
						
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vLocation#",                    
	     				field       = "Description",	
						searchfield = "Description",
						searchalias = "W",										
						alias       = "W",																			
						search      = "text"}>	
						
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label     = "#vClass#",                    
	     				field       = "LocationClassName",																	
						searchfield  = "Description",	
						searchalias = "LR",		
						labelfilter = "Storage Class",	
						display     = "No",		
						displayfilter = "Yes",														
						search      = "text",
						filtermode  = "2"}>														

	<cfset itm = itm+1>	
	<cfset fields[itm] = {label     = "#vCode#",                    
	     				field       = "StorageCode",											
						alias       = "W",																							
						search      = "text"}>					
					
	<!---
	
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vItem#",                    
	     				field       = "ItemNo",
						functionscript    = "item",
						alias       = "I",																			
						search      = "text"}>		

	<cfset itm = itm+1>
		
	<cfset fields[itm] = {label     = "#vItemName#",                    
	     				field       = "ItemDescription",																	
						alias       = "I",																			
						search      = "text",
						filtermode  = "2"}>				
							
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vUoM#",                    
	     				field       = "UoMDescription",					
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>	
						
	<cfset itm = itm+1>		
	
	--->	
	
	<cfset itm = itm+1>	
	
	<cfset fields[itm] = {label     = "",                    
	     				field       = "Status",					
						alias       = "",	
						align       = "center",										
						formatted   = "Rating",																								
						ratinglist  = "Replenish=Red,Alert=Yellow,Good=Green",
						search      = "",
						filtermode  = "2"}>							
	
	<!---					
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vLowest#",                    
	     				field       = "LowestStock",					
						alias       = "",	
						align       = "right",																		
						formatted   = "numberformat(loweststock,'__,__')",
						search      = "number"}>	
						
						--->
						
	<cfset itm = itm+1>		
	
	<cfset fields[itm] = {label     = "#vAvgIssue#",                    
	     				field       = "DistributionAverage",					
						alias       = "",	
						align       = "right",																		
						formatted   = "numberformat(DistributionAverage,',__')"}>						
						
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vMinStock#",                    
	     				field       = "MinimumStock",					
						alias       = "",		
						align       = "right",																	
						formatted   = "numberformat(minimumstock,',__')"}>		
						
							
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vMaxStock#",                    
	     				field       = "MaximumStock",					
						alias       = "",	
						align       = "right",																			
						formatted   = "numberformat(Maximumstock,',__')"}>							
						
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vActStock#",                    
	     				field       = "OnHand",					
						alias       = "",	
						aggregate   = "sum",
						align       = "right",																			
						formatted   = "numberformat(OnHand,',__')"}>						
	
	<!---					
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "#vStockValue#",                    
	     				field       = "OnHandValue",					
						alias       = "",	
						align       = "right",																			
						formatted   = "numberformat(OnHandValue,',.__')"}>		
						
	--->	
												
	<cfset itm = itm+1>
		
	<!--- hidden fields --->
	
	<cfset fields[itm] = {label     = "Id",                    
	     				field       = "ItemLocationId",					
						display     = "No",
						alias       = "",																			
						search      = "text"}>		
						
		


<cfset menu=ArrayNew(1)>	

<cfset pass = "">

<cfset url.systemfunctionid = "">

	<!--- embed|window|dialogajax|dialog|standard --->			
	<cf_listing
	    header              = "itemlocationlist"
	    box                 = "listing"
		link                = "#SESSION.root#/Warehouse/Inquiry/Warehouse/WarehouseViewDetailListing.cfm?systemfunctionid=#pass#&mission=#url.mission#&itemno=#url.itemno#&uom=#url.uom#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		font                = "Verdana"
		datasource          = "AppsMaterials"
		listquery           = "#myquery#"		
		listgroup           = "WarehouseName"
		listgroupalias      = "F"		
		listorder           = "Description"
		listorderalias      = "W"
		listorderdir        = "ASC"
		headercolor         = "ffffff"
		show                = "35"		
		menu                = "#menu#"
		filtershow          = "Yes"
		excelshow           = "Yes" 		
		listlayout          = "#fields#"
		drillmode           = "window" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "Warehouse/Maintenance/WarehouseLocation/LocationItemUoM/ItemUoMEdit.cfm?drillid="
		drillkey            = "ItemLocationId"
		drillbox            = "adduom">	
	