<!--
    Copyright © 2025 Promisan B.V.

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

<table width="100%">
	<tr>
		<td align="center" width="8%">
			<cfoutput>
			<a href="javascript: editcategoryworkflow('#url.code#','#url.category#','');" title="Add Observation">
				<font color="0080FF">[<cf_tl id="Add">]</font>
			</a>
			</cfoutput>
		</td>
		<td><cf_tl id="Code"></td>
		<td><cf_tl id="Description"></td>
		<td><cf_tl id="Class"></td>
		<td align="center"><cf_tl id="Operational"></td>
	</tr>
	
	<tr><td class="line" colspan="5"></td></tr>
	
	<cfif Observations.recordcount eq 0>
		<tr><td colspan="5" height="20" align="center"><font color="808080"><b><cf_tl id="No workflows recorded"></b></font></td></tr>
		<tr><td class="line" colspan="5"></td></tr>
	</cfif>
	
	<cfoutput query="Observations">
		<tr onMouseOver="this.bgColor='DEFBD9'" onMouseOut="this.bgColor=''" bgcolor="">
			<td align="center">
				<table cellspacing="0" class="formpadding">
					<tr>
						<td style="padding-top:2px;">
							<cf_img icon="delete" onclick="purgecategoryworkflow('#actionCategory#','#category#', '#code#');">
						</td>
						<td>
							<cf_img icon="edit" onclick="editcategoryworkflow('#actionCategory#','#category#', '#code#');">
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