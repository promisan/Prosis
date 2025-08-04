<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

<!--- no needed 

<cfif url.id2 eq "">
	
	<cf_screentop height="100%" scroll="Yes" html="Yes" layout="webapp" label="Add Category" user="no">
	
<cfelse>
	<cf_screentop height="100%" scroll="Yes" html="no" layout="webapp" label="Maintain Warehouse Category - #get.categoryDescription#" banner="gray" user="no">
</cfif>

--->

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

<table style="width:100%;height:100%" align="center">

	<tr class="hide"><td height="1" id="process2"></td></tr>	 
	
	<tr><td colspan="2">
	
		<table width="98%" align="center">
		<tr>
		
				<cfset wd = "42">
				<cfset ht = "42">					
				<cfset itm = 0>
				
				<cfset itm = itm + 1>
				<cf_tl id = "General Settings" var = "vName1">
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Warehouse/General.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							target	   = "subbox"
							base	   = "submenu"	
							targetitem = "1"							
							class      = "highlight1"
							name       = "#vName1#"
							source     = "Category/CategoryEdit.cfm?idmenu=#url.idmenu#&id1=#url.id1#&id2=#url.id2#">
				
				<cfif url.id2 neq "">
				
					<cfset itm = itm + 1>		
					<cf_tl id = "Price Schedule" var = "vName2">
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Warehouse/UoMPricing.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#"
								target	   = "subbox"
								base	   = "submenu"	
								targetitem = "1"								
								name       = "#vName2#"
								source     = "Category/PriceSchedule/PriceSchedule.cfm?idmenu=#url.idmenu#&id1=#url.id1#&id2=#url.id2#">
								
				</cfif>
				
			<td width="20%"></td>	
				
		</tr>						
		</table>	
	</td>
	</tr>
						
	<tr>
	
		<td colspan="2" height="100%" valign="top" style="padding-top:4px">
			
		<table width="96%" height="96%" align="center">
										
				<cf_menucontainer item="1" class="regular" name="subbox">
									
					<cfinclude template="CategoryEdit.cfm">			
					<!---				 				
					<cfdiv id="contentdivMenu1" bind="url:Category/CategoryEdit.cfm?idmenu=#url.idmenu#&id1=#url.id1#&id2=#url.id2#">									
					--->
				
				</cf_menucontainer>
				
		</table>
		</td>
	</tr>	

</table>