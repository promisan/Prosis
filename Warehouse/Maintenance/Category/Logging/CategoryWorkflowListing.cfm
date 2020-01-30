<cfquery name="Observations" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	W.*,
				(SELECT EntityClassName FROM Organization.dbo.Ref_EntityClass WHERE	EntityCode = 'AssObservation' AND EntityClass = W.EntityClass) as EntityClassName
		FROM 	Ref_AssetActionCategoryWorkflow W
		WHERE	W.ActionCategory = '#url.Code#'
		AND		W.Category = '#URL.category#'
</cfquery>

<table width="100%" align="center" class="formpadding" cellspacing="0" cellpadding="0">
	<tr class="labelit line">
		<td align="center" width="8%">
			<cfoutput>
			<a href="javascript: editcategoryworkflow('#url.code#','#url.category#','');" title="Add Observation">
				<font color="0080FF">[<cf_tl id="Add">]</font>
			</a>
			</cfoutput>
		</td>
		<td style="width:40px"><cf_tl id="Code"></td>
		<td style="width:50%"><cf_tl id="Description"></td>
		<td style="70"><cf_tl id="Class"></td>
		<td tyle="width:40px" align="center"><cf_tl id="Op"></td>
	</tr>
		
	<cfif Observations.recordcount eq 0>
		<tr><td colspan="5" style="height:20" align="center" class="labelit"><cf_tl id="No workflows recorded"></b></font></td></tr>		
	</cfif>
	
	<cfoutput query="Observations">
		<tr onMouseOver="this.bgColor='DEFBD9'" onMouseOut="this.bgColor=''" class="labelit">
			<td align="center">
				<table cellspacing="0" cellpadding="0">
					<tr>
						
						<td style="padding-top:2px">
							<cf_img icon="edit" onclick="editcategoryworkflow('#actionCategory#','#category#', '#code#');">
						</td>
						<td style="padding-top:2px;">
							<cf_img icon="delete" onclick="purgecategoryworkflow('#actionCategory#','#category#', '#code#');">
						</td>
					</tr>
				</table>
			</td>
			<td>#code#</td>
			<td>#description#</td>
			<td>#EntityClassName#</td>
			<td align="center"><cfif operational eq 0><b>No</b><cfelse>Yes</cfif></td>
		</tr>
	</cfoutput>
</table>