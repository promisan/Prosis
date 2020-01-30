
<cf_menuscript>
<cfajaximport tags="cfmenu,cfdiv,cfwindow">

<cfinclude template="../CaseFileTabs/TabScript.cfm">

 <script>
 	function saveMission(code) {
	   document.addmission.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
	       ColdFusion.navigate('RecordMissionSubmit.cfm?action='+code,'listing','','','POST','addmission')
		 }   
	 }
	 
	 function deleteMission(claimtype,mission){
	 	if (confirm("Do you want to remove this record?"))
	 	   ColdFusion.navigate('RecordMissionDelete.cfm?id1='+claimtype+'&mission='+mission,'listing')
	 }
	 
	 
	function do_submit_general()
	{
	
		document.editGeneral.onsubmit() 
			if( _CF_error_messages.length == 0 ) {
					ColdFusion.navigate('RecordGeneralSubmit.cfm', 'mainEdit', '', '', 'POST', 'editGeneral')
			 }   
	}	 
	 
</script>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<cfoutput>
<tr><td height="40">

		<!--- top menu --->
				
		<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">		  		
									
			<cfset ht = "30">
			<cfset wd = "30">			
			
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
								source 	   = "RecordGeneralEdit.cfm?ID1=#URL.ID1#">
													
					
					<cfset itm = itm+1>											
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Workorder/Request.png" 
								targetitem = "2"
								iconwidth  = "#wd#" 								
								iconheight = "#ht#" 
								name       = "Enabled for Entities"
								source 	   = "RecordMissionListing.cfm?ID1=#URL.ID1#">
								
					<cfset itm = itm+1>						
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Workorder/orderTabs.png" 
								targetitem = "2"
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "Case File Tabs"
								source 	   = "#SESSION.root#/CaseFile/maintenance/CaseFileTabs/RecordListing.cfm?ClaimType=#URL.ID1#">
														 		
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
				<cfinclude template="RecordGeneralEdit.cfm">
			</cf_menucontainer>							
			
			<cf_menucontainer item="2" class="hide">			
			
												
	</table>

</td></tr>

</table>

