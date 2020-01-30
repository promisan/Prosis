<cfparam name="url.idmenu" default="">

<cfif url.id1 neq "">

	<cf_screentop height="100%" 
	   scroll="Yes" 
	   html="Yes" 
	   label="Asset Action"
	   option="Maintain Asset Action - #url.id1#" 	    
	   layout="webapp" 
	   banner="yellow" 
	   bannerheight="50"
	   JQuery="yes"
	   menuAccess="Yes" 
	   systemfunctionid="#url.idmenu#">

<cfelse>

	<cf_screentop height="100%" 
	   scroll="Yes" 
	   html="Yes" 
	   label="Asset Action" 
	   option="Add Asset Action" 	   
	   layout="webapp" 
	   bannerheight="50"
	   JQuery="yes"
	   menuAccess="Yes" 
	   systemfunctionid="#url.idmenu#">
	
</cfif>

<cf_menuscript>
<cf_textareascript>
<cfajaximport tags="cfdiv,cfform">

<script>
function selectCategory(controltochange, controltochange2, control){
	if (control.checked){
		document.getElementById(controltochange2).style.backgroundColor = 'E1EDFF';
		document.getElementById(controltochange).style.display = 'table-row';
	}
	else{
		document.getElementById(controltochange2).style.backgroundColor =  '';
		document.getElementById(controltochange).style.display = 'none';
	}
}

function selectMetric(controltochange, control){
	if (control.checked){		
		document.getElementById(controltochange).style.backgroundColor = 'D9FBDF';
	}
	else{
		document.getElementById(controltochange).style.backgroundColor =  '';
	}
}
</script>

<table width="100%" height="100%" align="center">
	<tr><td height="4" id="process2"></td></tr>	 
	
	<tr><td height="25">
	
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
		
				<cfset wd = "30">
				<cfset ht = "30">		
				
				<cf_menutab item       = "1" 
				            iconsrc    = "Info.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "1"
							padding    = "2"
							class      = "highlight1"
							name       = "Details"
							source     = "RecordEdit.cfm?id1=#url.id1#&idmenu=#url.idmenu#">			
				
				<cfif url.id1 neq "">
				
				<cf_menutab item       = "2" 
				            iconsrc    = "Logos/Warehouse/list.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#"
							targetitem = "2"
							padding    = "2"
							name       = "Values"
							source     = "ListValuesListing.cfm?idmenu=#url.idmenu#&Code=#URL.ID1#&ID2=">							
				
				<cf_menutab item       = "3" 
				            iconsrc    = "Logos/Warehouse/UoM.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#"
							targetitem = "2"
							padding    = "2"
							name       = "Category Metric"
							source     = "MetricListing.cfm?ID1=#URL.ID1#&idmenu=#url.idmenu#">
							
				</cfif>
				
			<td width="20%"></td>	
				
		</tr>						
		</table>	
	</td>
	</tr>
	
	<tr><td height="2"></td></tr>
	<tr><td height="1" colspan="2" class="line"></td></tr>						
	<tr>
	
		<td colspan="2" height="100%" valign="top">
			
		<cf_divscroll>	
		<table width="100%" height="100%">
						
				<cf_menucontainer item="1" class="regular">
				    <cfinclude template="RecordEdit.cfm">					
				</cf_menucontainer>
				<cf_menucontainer item="2" class="hide">				
							
		</table>
		</cf_divscroll>
		
		</td>
	</tr>	

</table>