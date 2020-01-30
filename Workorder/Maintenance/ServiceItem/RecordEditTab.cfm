			
<cf_colorScript>
<cf_menuscript>
<cf_calendarscript>

<script>
	function colorInit() {
		$('#serviceColor').spectrum();
	}
</script>

<cfajaximport tags="cfmenu,cfdiv,cfwindow,cfinput-datefield">

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<cfoutput>
<tr><td height="40">

		<!--- top menu --->
		<table width="100%" border="0" align="center" class="formpadding" cellspacing="0" cellpadding="0">		  		
									
			<cfset ht = "48">
			<cfset wd = "48">			
			
			<tr>		
			
					<cfset itm = 0>
					
					<cfset itm = itm+1>			
										
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Workorder/General.png" 
								targetitem = "1"
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "General Settings"
								class      = "highlight1"
								source 	   = "ServiceItemEdit.cfm?ID1=#URL.ID1#&loadcolor=1">
								
					<cfset itm = itm+1>													
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Workorder/Custom-Fields.png" 
								iconwidth  = "#wd#" 
								targetitem = "2"
								iconheight = "#ht#" 
								name       = "Custom Fields & Actions"
								source 	   = "ServiceItemTopic.cfm?ID1=#URL.ID1#">	
								
					<cfif get.ServiceMode eq "Service">					
								
					<cfset itm = itm+1>													
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Workorder/Provisioning.png" 
								iconwidth  = "#wd#" 
								targetitem = "2"
								iconheight = "#ht#" 
								name       = "Provisioning"
								source 	   = "#SESSION.root#/workorder/maintenance/unitRate/ItemUnitListing.cfm?ID1=#URL.ID1#">		
								
					<cfelse>
					
					<cfset itm = itm+1>													
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Workorder/Provisioning.png" 
								iconwidth  = "#wd#" 
								targetitem = "2"
								iconheight = "#ht#" 
								name       = "Service Provisioning"
								source 	   = "#SESSION.root#/workorder/maintenance/unitRate/ItemUnitListing.cfm?ID1=#URL.ID1#">		
					
					<!--- show settings per entity for procurement, item --->
					
					<cfset itm = itm+1>													
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Workorder/Manufacturing.png" 
								iconwidth  = "#wd#" 
								targetitem = "2"
								iconheight = "#ht#" 
								name       = "Manufacturing Settings"
								source 	   = "#SESSION.root#/workorder/maintenance/WorkOrderItem/EntityListing.cfm?ID1=#URL.ID1#">		
										
					</cfif>								
								
					<cfset itm = itm+1>													
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Workorder/Self-Service.png" 
								iconwidth  = "#wd#" 
								targetitem = "2"
								iconheight = "#ht#" 
								name       = "Selfservice"
								source 	   = "SelfService.cfm?ID1=#URL.ID1#">
					
					<cfset itm = itm+1>													
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/WorkOrder/Accounts-Receivable.png" 
								iconwidth  = "#wd#" 
								targetitem = "2"
								iconheight = "#ht#" 
								name       = "Accounts Receivable"
								source 	   = "FinancialsListing.cfm?ID1=#URL.ID1#">								
																
								
					<cfset itm = itm+1>						
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Workorder/Tabs.png" 
								targetitem = "2"
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "Interface Tabs"
								source 	   = "#SESSION.root#/workorder/maintenance/ServiceItemTab/ServiceItemTabListing.cfm?ID1=#URL.ID1#">
														 		
				</tr>
		</table>

	</td>
 </tr>
 </cfoutput>
 
<tr><td height="1" colspan="1" class="line"></td></tr>

<tr><td height="100%">
	
	<table width="100%" 
	      border="0"
		  height="100%"
		  cellspacing="0" 
		  cellpadding="0" 
		  align="center" 
	      bordercolor="d4d4d4">
	 		
			<!--- <tr class="hide"><td valign="top" height="100" id="result" name="result"></td></tr> --->
			
			<cf_menucontainer item="1" class="regular">
				<cfinclude template="ServiceItemEdit.cfm">
			</cf_menucontainer>							
			
			<cf_menucontainer item="2" class="hide">			
			
												
	</table>

</td></tr>

</table>

