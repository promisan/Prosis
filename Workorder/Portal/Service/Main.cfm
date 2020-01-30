
<cfparam name="URL.Mission" default="OICT">

<cfoutput>
<table width="98%" align="center" height="100%" cellspacing="0" cellpadding="0">

<tr><td valign="top">

	<table width="97%" align="center" height="100%">
		
	<tr><td height="10"></td></tr>
	
	<tr><td height="40">
	
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
		
				<cfset wd = "31">
				<cfset ht = "31">	
								
				<cfset itm = 1>		
				
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Service/Pending.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#"
							targetitem = "1" 
							padding    = "2"
							class      = "highlight1"
							name       = "Pending Requests"
							source     = "../../../../WorkOrder/Portal/Service/Portal/CatalogView.cfm?mission=#url.mission#">						
				
				<cfset itm = itm+1>		
						
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Service/Submit.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "1"
							padding    = "2"							
							name       = "Submit a Service Request"
							source     = "alert:Shows services and a description">	
							
				<cfset itm = itm+1>			
							
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Service/Submitted.png" 
							iconwidth  = "#wd#" 
							targetitem = "1"
							padding    = "2"
							iconheight = "#ht#" 
							name       = "Archived"
							source     = "alert:Listings all completed requests and workflow">										
										
				<cfset itm = itm+1>	
							
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Workorder/Device.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							padding    = "2"
							targetitem = "1"
							name       = "Inventory of services"
							source     = "alert:Listing of assigned services to this user">		
							
				<td width="10%"></td>
						
				
		</tr>						
		</table>	
	</td>
	</tr>
	<tr><td height="2"></td></tr>
	<tr><td height="1" colspan="2" class="line"></td></tr>						
	<tr><td colspan="2" height="100%" valign="top">
			
		<table width="100%" height="100%">
						
				<cf_menucontainer item="1" class="regular">
				<cf_menucontainer item="2" class="hide">
			
		</table>
		
	</td></tr>	
		
	</table>

</td></tr>

</table>

</cfoutput>

