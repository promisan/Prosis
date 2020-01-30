<cfset itm = 0>
			
<cfif children.recordcount eq "0" and transferstatus neq "disable">			
	
	<cfif children.recordcount gte "1" or transferstatus eq "disable">			
	
		<cfset accessmode = "view">
				
	<cfelse>
	
		<cfset accessmode = "edit">	
					  
	</cfif>    
			
	<cfset itm = itm+1>		
	<cf_tl id="About this activity" var="vEditLines">
	<cf_menutab item       = "#itm#" 
	            iconsrc    = "Logos/Workorder/General.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				targetitem = "1"
				padding    = "3"
				class      = "highlight1"
				name       = "#vEditLines#"
				source     = "ServiceLineForm.cfm?accessmode=#accessmode#&tabno=1&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">		
			
</cfif>		
	
	
<cfif accessProcess neq "NONE">	

	<cfset itm = itm+1>		
	<cf_tl id="Action Schedule" var="vSchedule">
	<cf_menutab item       = "#itm#" 
	            iconsrc    = "Logos/System/Schedule.png" 
				iconwidth  = "#wd#" 
				targetitem = "1"
				padding    = "3"
				iconheight = "#ht#" 
				name       = "#vSchedule#"
				source     = "Schedule/ScheduleListing.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#&tabno=1">	

	<cfset itm = itm+1>		
	<cf_tl id="Actions" var="vActions">
	<cf_menutab item       = "#itm#" 
	            iconsrc    = "Logos/Workorder/Task.png" 
				iconwidth  = "#wd#" 
				targetitem = "1"
				padding    = "3"
				iconheight = "#ht#" 
				name       = "#vActions#"
				source     = "Action/WorkAction.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#&tabno=1">	
						
	<cfquery name="CheckAsset" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    ServiceItemMaterials
		 WHERE   ServiceItem   = '#Item.code#'	
		 AND     MaterialsClass = 'Asset'
	</cfquery>			
	
	<cfif CheckAsset.recordcount gte "1">					
							
		<cfset itm = itm+1>	
		<cf_tl id="Devices" var="vDevices">
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/Workorder/Device.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					padding    = "3"
					targetitem = "1"
					name       = "#vDevices#"
					source     = "../Assets/AssetDialog.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#">		
					
	</cfif>			
	
	<cfset itm = itm+1>					
	<cf_tl id="Provisioning" var="vProvisioning">

	<cf_menutab item       = "#itm#" 
            iconsrc    = "Logos/Workorder/Features.png" 
			iconwidth  = "#wd#" 
			iconheight = "#ht#"
			targetitem = "1" 
			padding    = "3"			
			name       = "#vProvisioning#"
			source     = "Billing/DetailBilling.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#">									
			
</cfif>		
						