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
<cfquery name="owner" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	O.*,
				(SELECT Owner FROM Ref_ReviewClassOwner WHERE Code = '#url.code#' AND Owner = O.Owner) as Selected,
				(SELECT EntityClass FROM Ref_ReviewClassOwner WHERE Code = '#url.code#' AND Owner = O.Owner) as SelectedWF
		FROM 	Ref_ParameterOwner O
		WHERE	O.Operational = 1
</cfquery>

<!-- <cfform name="dialog"> -->

<table width="100%" align="center" class="navigation_table formpadding">
	<cfquery name="ownerWF" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_EntityClass
			WHERE	1=1
			AND		Operational = 1
			<cfif url.code neq "">
			AND		EntityCode = 'Rev#url.code#'
			<cfelse>
			AND		1=0
			</cfif>
			ORDER BY ListingOrder ASC
	</cfquery>
			
	<cfif ownerWF.recordCount gt 0>
		<tr>
			<td width="5%"></td>
			<td style="padding-left:3px;" class="labelit">Owner</td>
			<td class="labelit">Workflow</td>
		</tr>
		<tr><td height="3"></td></tr>
		<tr><td colspan="3" class="linedotted"></td></tr>
		<tr><td height="3"></td></tr>
		<cfoutput query="owner">
			<cfset ownerId = replace(owner, " ","","ALL")>
			<tr class="navigation_row">
				<td>
					<input type="Checkbox" name="owner_#ownerId#" id="owner_#ownerId#" <cfif owner eq selected>checked</cfif>>
				</td>
				<td style="padding-left:3px;" class="labelit"><label for="owner_#ownerId#">#owner#</label></td>
				<td>
					
					<cfselect 
						query="ownerWF" 
						name="owner_entityClass_#ownerId#" 
						id="owner_entityClass_#ownerId#" 
						display="EntityClassname" 
						value="EntityClass" 
						selected="#SelectedWF#" 
						required="Yes" 
						message="Select a valid workflow for #owner#" 
						class="regularxl">
					</cfselect>
					
				</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="3" style="color:#9B9B9B" class="labelit">[No owners / workflows associated to this code]</td>
		</tr>
	</cfif>
</table>

<!-- </cfform> -->

<cfset AjaxOnLoad("doHighlight")>