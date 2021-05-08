<cfparam name="url.systemfunctionid" default="">

<cfset itm = 1>		

<cf_tl id="Recapitulation" var="vRecap">

<cf_menutab item       = "#itm#" 
            iconsrc    = "Sales-Orders.png" 
			iconwidth  = "#wd#" 
			padding    = "3"
			targetitem = "1"
			class      = "highlight1"
			iconheight = "#ht#" 
			name       = "#vRecap#"
			source     = "../../Assembly/Items/FinalProduct/Summary/SummaryView.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">
	
<cf_tl id="Ordered Items" var="vProducts">

<cfset itm = itm+1>		
<cf_menutab item       = "#itm#" 
            iconsrc    = "Logos/Workorder/FinalProduct.png" 
			iconwidth  = "#wd#" 
			padding    = "3"
			targetitem = "1"			
			iconheight = "#ht#" 
			name       = "#vProducts#"
			source     = "../../Assembly/Items/FinalProduct/ItemView.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">

			
<!---			
<cf_tl id="BOM Service Costs" var="vCosts">

<cfset itm = itm+1>						
<cf_menutab item       = "#itm#" 
            iconsrc    = "Logos/Warehouse/BOM.png" 
			iconwidth  = "#wd#" 
			iconheight = "#ht#"
			targetitem = "1"
			padding    = "2"
			name       = "#vCosts# "
			source     = "../../Assembly/Items/BOM/ItemView.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">				
			
--->			
			

<cfset itm = itm+1>		
<cf_tl id="Under Procurement" var="vProcurement">
<cf_menutab item       = "#itm#" 
            iconsrc    = "Logos/Workorder/Acquired-Product.png" 
			iconwidth  = "#wd#" 
			padding    = "3"
			targetitem = "1"
			iconheight = "#ht#" 
			name       = "#vProcurement#"
			source     = "Requisition/RequisitionListing.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#&systemfunctionid=#url.systemfunctionid#">

			
<cfif workorder.actionstatus lte "1">

	<cf_tl id="Preinvoicing" var="vPre">

	<cfset itm = itm+1>						
	<cf_menutab item       = "#itm#" 
            iconsrc    = "BoM.png" 
			iconwidth  = "#wd#" 
			iconheight = "#ht#"
			targetitem = "1"
			padding    = "2"
			name       = "#vPre# "
			source     = "../../Assembly/Items/FinalProduct/Prebilling/PreBillingView.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">				
				
	<cf_tl id="Earmark Stock" var="vEarmark">
	<cfset itm = itm+1>		
	<cf_menutab item       = "#itm#" 
	            iconsrc    = "Inventory.png" 
				iconwidth  = "#wd#" 
				padding    = "3"
				targetitem = "1"			
				iconheight = "#ht#" 
				name       = "#vEarmark#"
				source     = "../../Assembly/Items/FinalProduct/Reserve/ReserveView.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">
				
</cfif>

				
<cfif children.recordcount eq "0" and transferstatus neq "disable">			
				
		<cfset itm = itm+1>		
		<cf_tl id="Edit Line and Notes" var="vEditLines">
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Edit-Notes.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					targetitem = "1"
					padding    = "3"
					name       = "#vEditLines#"
					source     = "ServiceLineForm.cfm?openmode=#url.openmode#&tabno=1&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">		
				
</cfif>			
				
<cfif accessProcess neq "NONE">	

	<cfset itm = itm+1>		
	<cf_tl id="Actions" var="vActions">
	<cf_menutab item       = "#itm#" 
	            iconsrc    = "Action.png" 
				iconwidth  = "#wd#" 
				targetitem = "1"
				padding    = "3"
				iconheight = "#ht#" 
				name       = "#vActions#"
				source     = "Action/WorkAction.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#&tabno=1">	
			
</cfif>					