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

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
	<tr class="labelmedium line">
		<td height="20" style="min-width:80px;width:80px" class="labelmedium">
			<cfoutput>
			<a href="javascript: editcategoryitem('#category#','');" title="Add Item">
				<font color="0080FF">[<cf_tl id="Add">]</font>
			</a>
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
		<tr style="height:20px" class="line labelmedium navigation_row">
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
							<cf_img icon="edit" class="navigation_action" onclick="editcategoryitem('#category#','#categoryItem#');">
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