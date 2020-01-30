
<table width="100%">
	
	<tr class="line">
		<td>
				
		<table width="50%"
		       border="0"
		       cellspacing="0"
		       cellpadding="0">
		
					<cf_menutab item       = "1" 
		            iconsrc    = "Logos/WorkOrder/pending_charges.png" 
					iconwidth  = "48" 
					iconheight = "48" 
					targetitem = "1"
					name       = "Pending Charges"
					class      = "highlight1"
					border	   = "yes"
					source     = "SubmissionPending.cfm?scope=portal&serviceitem=#url.serviceitem#">
				
					<cf_menutab item       = "2" 
		            iconsrc    = "Logos/WorkOrder/authorised_charges.png" 
					iconwidth  = "48" 
					iconheight = "48" 
					targetitem = "1"			
					name       = "Authorised Charges"
					border	   = "yes"			
					source     = "SubmissionLog.cfm?serviceitem=#url.serviceitem#&scope=portal">
		
		</table>		

		</td>
		
	</tr>
	
	<tr>
	<td style="padding-top:4px">
		
	<table width="100%" height="100%">
		
		<cfparam name="url.scope"   default="portal">
		<cf_menucontainer item="1" class="regular">
			<cfinclude template="SubmissionPending.cfm">
		</cf_menucontainer>						
		
	</table>
	
	</td>
	
</tr>	