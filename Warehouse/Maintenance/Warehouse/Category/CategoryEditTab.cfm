<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*,
			(SELECT Description FROM Ref_Category WHERE Category = '#URL.ID2#') AS CategoryDescription
	FROM 	WarehouseCategory
	WHERE 	Warehouse = '#URL.ID1#'
	AND		Category  = '#URL.ID2#'
</cfquery>

<cfif url.id2 eq "">
	<cf_screentop height="100%" scroll="Yes" html="Yes" layout="webapp" label="Add Category" user="no">
<cfelse>
	<cf_screentop height="100%" scroll="Yes" html="Yes" layout="webapp" label="Maintain Warehouse Category - #get.categoryDescription#" banner="gray" user="no">
</cfif>

<cf_tl id = "Do you want to remove this record?" var = "msg1">

<cfajaximport tags="cfform">

<cfoutput>
	<script>
		function ask() {
			if (confirm("#msg1#")) {	
			return true 	
			}	
			return false	
		}
		
		function hlChecked(s,c) {
			var control = document.getElementById('cb_'+s+'_'+c);
			if (control.checked) {
				document.getElementById('td_'+s+'_'+c).style.backgroundColor = 'FFFFCF';
				document.getElementById('td_details_'+s+'_'+c).className = 'regular';
			}
			else {
				document.getElementById('td_'+s+'_'+c).style.backgroundColor = '';
				document.getElementById('td_details_'+s+'_'+c).className = 'hide';
			}
			document.getElementById('CostPriceMultiplier_'+s+'_'+c).value = '0';
			document.getElementById('CostPriceCeiling_'+s+'_'+c).value = '0';
		}
	</script>
</cfoutput>

<table width="100%" height="100%" align="center">
	<tr class="hide"><td height="1" id="process2"></td></tr>	 
	
	<tr><td colspan="2" style="padding:3px">
	
		<table width="98%" align="center" cellspacing="0" cellpadding="0">
		<tr>
		
				<cfset wd = "48">
				<cfset ht = "48">					
				<cfset itm = 0>
				
				<cfset itm = itm + 1>
				<cf_tl id = "General Information" var = "vName1">
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Warehouse/General.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							target	   = "subbox"
							base	   = "submenu"	
							targetitem = "1"
							padding    = "2"
							class      = "highlight1"
							name       = "#vName1#"
							source     = "Category/CategoryEdit.cfm?idmenu=#url.idmenu#&id1=#url.id1#&id2=#url.id2#">
				
				<cfif url.id2 neq "">
				
					<cfset itm = itm + 1>		
					<cf_tl id = "Sale Price Schedule" var = "vName2">
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Warehouse/UoMPricing.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#"
								target	   = "subbox"
								base	   = "submenu"	
								targetitem = "1"
								padding    = "2"
								name       = "#vName2#"
								source     = "Category/PriceSchedule/PriceSchedule.cfm?idmenu=#url.idmenu#&id1=#url.id1#&id2=#url.id2#">
								
				</cfif>
				
			<td width="20%"></td>	
				
		</tr>						
		</table>	
	</td>
	</tr>
		
	<tr><td height="1" colspan="2" class="line"></td></tr>						
	<tr>
	
		<td colspan="2" height="100%" valign="top">
			
		<table width="100%" height="100%">
						
				<cf_menucontainer item="1" class="regular" name="subbox">
					<cfdiv id="divMenu" bind="url:Category/CategoryEdit.cfm?idmenu=#url.idmenu#&id1=#url.id1#&id2=#url.id2#">				
				</cf_menucontainer>
							
		</table>
		</td>
	</tr>	

</table>