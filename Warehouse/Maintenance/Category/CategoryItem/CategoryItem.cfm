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
<cfquery name="Lookup" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_CategoryItem
		WHERE 	Category = '#url.category#'
		ORDER BY CategoryItemOrder ASC
</cfquery>

<table width="96%" align="center" class="formpadding">
<tr><td>

<table width="100%" class="navigation_table">
	<tr class="labelmedium2 line">
		<td height="20" style="min-width:80px;width:80px" class="labelmedium">
			<cfoutput>
			<a href="javascript: editcategoryitem('#category#','');" title="Add Item">[<cf_tl id="Add">]</a>
			</cfoutput>
		</td>
		<td width="10%" align="center"><cf_tl id="Sort"></td>
		<td width="10%"><cf_tl id="Code"></td>
		<td><cf_tl id="Description"></td>
	</tr>
		
	<cfif lookup.recordcount eq 0>
		<tr>
			<td colspan="4" align="center" height="25" class="labelmedium"><cf_tl id="No generic items recorded."></b></font></td>
		</tr>
	</cfif>
	
	<cfoutput query="lookup">
		<tr class="line labelmedium2 navigation_row">
			<td>
				  
				<cfquery name="Validate" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT 	TOP 1 *
						FROM 	Item
						WHERE 	Category     = '#url.category#'
						AND		CategoryItem = '#CategoryItem#'
				</cfquery>
				
				<table>
					<tr>
						<td style="padding-left:4px;">
							<cf_img icon="open" class="navigation_action" onclick="editcategoryitem('#category#','#categoryItem#');">
						</td>
						<td style="padding-left:4px">
							<cfif Validate.recordCount eq 0>
								<cf_img icon="delete" onclick="purgecategoryitem('#category#','#categoryItem#');">
							</cfif>
						</td>
						
					</tr>
				</table>

			</td>
			<td align="center">#CategoryItemOrder#</td>
			<td>#CategoryItem#</td>
			<td>#CategoryItemName#</td>
		</tr>
	</cfoutput>
	<tr><td class="line" colspan="4"></td></tr>
</table>

</td></tr>
</table>

<cfset ajaxonload("function() { Prosis.busy('no'); doHighlight(); }")>