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
<table width="100%" cellspacing="0" cellpadding="0">
<tr>

	<cfset wd = "50">
	<cfset ht = "50">		
	
	<cf_tl id = "Item Details"        var = "vDetails">
	<cf_tl id = "Sales Pricing"       var = "vPricing">
	<cf_tl id = "Barcode"             var = "vBarcode">
	<cf_tl id = "Labels"              var = "vLabels">
	<cf_tl id = "Entity & Cost Price" var = "vCost">
	<cf_tl id = "Temperature"         var = "vTemp">
	
	<cfset itm = "0">
	
	<cfset itm = itm+1>
	
	<cf_menutab item       = "#itm#" 
	            iconsrc    = "Detail.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				targetitem = "1"
				padding    = "2"
				class      = "highlight1"
				name       = "#vDetails#"
				source     = "ItemUoMEdit.cfm?id=#url.id#&uom=#url.uom#">			
	
	<cfif url.uom neq "">
	
		<cfset itm = itm+1>
		
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Barcode.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#"
					targetitem = "2"
					padding    = "2"
					name       = "#vBarcode#"
					source     = "UoMBarcode/ItemUoMBarcode.cfm?ID=#URL.ID#&UoM=#URL.UoM#">
		
		<cfset itm = itm+1>
		
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Barcode.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#"
					targetitem = "2"
					padding    = "2"
					name       = "#vLabels#"
					source     = "UoMLabel/ItemUoMLabel.cfm?ID=#URL.ID#&UoM=#URL.UoM#">
					
		<cfset itm = itm+1>			
		
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "BoM.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#"
					targetitem = "2"
					padding    = "2"
					name       = "Bill of Materials"
					source     = "UoMBOM/ItemUoMBOM.cfm?ID=#URL.ID#&UoM=#URL.UoM#&selectedMission=">	
								
					
		<cfset itm = itm+1>			
		
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Cost.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#"
					targetitem = "2"
					padding    = "2"
					name       = "#vCost#"
					source     = "UoMMission/ItemUoMMissionView.cfm?ID=#URL.ID#&UoM=#URL.UoM#">
					
		<cfset itm = itm+1>			
		
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Price.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#"
					targetitem = "2"
					padding    = "2"
					name       = "#vPricing#"
					source     = "UoMPrice/ItemUoMPriceView.cfm?ID=#URL.ID#&UoM=#URL.UoM#&selectedMission=">	
					
		<cfset itm = itm+1>									
			
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Temperature.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#"
					targetitem = "2"
					padding    = "2"
					name       = "#vTemp#"
					source     = "UoMVolume/ItemUoMVolume.cfm?ID=#URL.ID#&UoM=#URL.UoM#">
				
	</cfif>
	
</tr>						
</table>