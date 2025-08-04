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

<cfquery name="SearchResult"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_WarehouseCity
		ORDER BY Mission, ListingOrder
</cfquery>

<cf_screentop html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "1">

<table height="100%" width="95%" align="center">

<tr><td style="height:10px"><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>
	<script>
		function recordadd(grp) {
			ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddWarehouseCity", "left=80, top=80, width=450, height= 300, toolbar=no, status=no, scrollbars=no, resizable=yes");
		}
		
		function recordedit(mission,city) {
			ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&mission="+mission+"&city=" + city, "EditWarehousecity", "left=80, top=80, width= 450, height= 300, toolbar=no, status=no, scrollbars=no, resizable=yes");
		}
	</script>	
</cfoutput>

<tr><td>

	<cf_divscroll>

	<table width="96%" align="center">  
		<tr>
			<td>
				<table width="100%" align="center" class="formpadding navigation_table">
					<tr class="labelmedium2 line">
					    <td></td> 
					    <td></td>
						<td>Region</td>
						<td align="center">Order</td>
						<td>Officer</td>
					    <td>Entered</td>
					</tr>
					
					<cfoutput query="SearchResult" group="mission">
						<tr class="line"><td colspan="6" style="font-size:14px;">#Mission#</td></tr>
						<cfoutput>					    
						    <tr class="navigation_row labelmedium2 line"> 
								<td width="15"></td>
								<td align="center" style="padding-top:3px">
								  <cf_img icon="open" onclick="recordedit('#mission#','#city#');">
								</td>		
								<td>#City#</td>
								<td align="center">#listingOrder#</td>
								<td>#OfficerFirstName# #OfficerLastName#</td>
								<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
						    </tr>
						</cfoutput>
						<tr><td height="5"></td></tr>
					</cfoutput>
					
				</table>
			</td>
		</tr>
	</table>

	</cf_divscroll>
	
</td>
</tr>
</table>	