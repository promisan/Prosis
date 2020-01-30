
<cfparam name="url.systemfunctionid" default="">

<cfset itm = 0>		

<cf_tl id="Recapitulation" var="vRecap">

<cfset itm = itm+1>	
<cf_menutab item       = "#itm#" 
            iconsrc    = "Logos/Workorder/SaleOrder.png" 
			iconwidth  = "#wd#" 
			padding    = "2"
			targetitem = "1"
			class      = "highlight1"
			iconheight = "#ht#" 
			name       = "#vRecap#"
			source     = "../../Assembly/Items/HalfProduct/Summary/SummaryView.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">

<cf_tl id="Produced Items" var="vProducts">

<cfset itm = itm+1>		
<cf_menutab item       = "#itm#" 
            iconsrc    = "Logos/Workorder/FinalProduct.png" 
			iconwidth  = "#wd#" 
			padding    = "2"
			targetitem = "1"			
			iconheight = "#ht#" 
			name       = "#vProducts#"
			source     = "../../Assembly/Items/HalfProduct/ItemView.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">

<cf_tl id="Cost of Production" var="vCosts">

<cfset itm = itm+1>						
<cf_menutab item       = "#itm#" 
            iconsrc    = "Logos/Warehouse/BOM.png" 
			iconwidth  = "#wd#" 
			iconheight = "#ht#"
			targetitem = "1"
			padding    = "2"
			name       = "#vCosts# "
			source     = "../../Assembly/Items/BOM/ItemView.cfm?mode=halfproduct&systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">				
			

		
<cfset itm = itm+1>		
<cf_tl id="Ledger Posting" var="vPosting">
<cf_menutab item       = "#itm#" 
            iconsrc    = "Financials.png" 
			iconwidth  = "#wd#" 
			padding    = "3"
			targetitem = "1"
			iconheight = "#ht#"
			name       = "#vPosting#"
			source     = "../../Assembly/Items/HalfProduct/Summary/PostingListing.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#&systemfunctionid=#url.systemfunctionid#">

<!---
			
<cfif workorder.actionstatus lte "1">
				
	<cf_tl id="Earmark Stock to Order" var="vEarmark">
	<cfset itm = itm+1>		
	<cf_menutab item       = "#itm#" 
	            iconsrc    = "Logos/Workorder/Earmarkstock.png" 
				iconwidth  = "#wd#" 
				padding    = "3"
				targetitem = "1"			
				iconheight = "#ht#" 
				name       = "#vEarmark#"
				source     = "../../Assembly/Earmarkstock/EarmarkView.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">
				
</cfif>

--->
				
<cfif children.recordcount eq "0" and transferstatus neq "disable">			
				
		<cfset itm = itm+1>		
		<cf_tl id="Edit Line and Notes" var="vEditLines">
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/Workorder/General.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					targetitem = "1"
					padding    = "2"
					name       = "#vEditLines#"
					source     = "ServiceLineForm.cfm?openmode=#url.openmode#&tabno=1&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">		
				
</cfif>			
				
<cfif accessProcess neq "NONE">	

	<cfset itm = itm+1>		
	<cf_tl id="Actions" var="vActions">
	<cf_menutab item       = "#itm#" 
	            iconsrc    = "Logos/Workorder/Task.png" 
				iconwidth  = "#wd#" 
				targetitem = "1"
				padding    = "2"
				iconheight = "#ht#" 
				name       = "#vActions#"
				source     = "Action/WorkAction.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#&tabno=1">	
			
</cfif>					