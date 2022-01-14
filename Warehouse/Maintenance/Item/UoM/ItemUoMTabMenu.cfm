<table width="100%" cellspacing="0" cellpadding="0">
<tr>

	<cfset wd = "64">
	<cfset ht = "64bill">		
	
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