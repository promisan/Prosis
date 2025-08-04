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

<cfif url.costId neq "">

	<cfif url.orgUnit neq "">
		<cftry>
		
			<cfquery name="InsertOwner" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO ServiceItemUnitMissionOrgUnit
						(
							CostId,
							OrgUnitOwner,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					VALUES
						(
							'#url.costId#',
							'#url.orgUnit#',
							'#session.acc#',
							'#session.last#',
							'#session.first#'
						)
			</cfquery>
			
			<cfcatch></cfcatch>
		</cftry>
	</cfif>

	<cfquery name="getOwners" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	O.*
			FROM	ServiceItemUnitMissionOrgUnit S
					INNER JOIN Organization.dbo.Organization O
						ON S.OrgUnitOwner = O.OrgUnit
			<cfif url.CostId neq "">
			WHERE	S.CostId = '#url.CostId#'
			<cfelse>
			WHERE	1=0
			</cfif>
			ORDER BY S.Created ASC
	</cfquery>

	<cfif getOwners.recordCount gt 0>
		<table width="100%" class="navigation_table">
			<tr>
				<td width="5%"></td>
				<td width="15%" class="labelit">Unit</td>
				<td style="padding-left:5px" class="labelit">Name</td>
			</tr>
			<tr><td height="5"></td></tr>
			<tr><td colspan="3" class="line"></td></tr>
			<tr><td height="5"></td></tr>
			<cfoutput query="getOwners">
				<tr class="navigation_row">
					<td width="5%"><cf_img icon="delete" onclick="purgeCostOwner('#url.costId#','#orgUnit#')"></td>
					<td width="15%" class="labelit">#OrgUnitCode#</td>
					<td style="padding-left:5px" class="labelit">#OrgUnitName#</td>
				</tr>
			</cfoutput>
			<tr><td height="10"></td></tr>
		</table>
	</cfif>

	<cfset AjaxOnLoad("doHighlight")>

<cfelse>

	<cfquery name="getUnit" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Organization
			WHERE 	OrgUnit = '#url.OrgUnit#'
	</cfquery>

	<cfif getUnit.recordCount eq 1>
		<cfoutput>
			<script>
				$('##orgunitcode').val('#getUnit.OrgUnitCode#');
				$('##orgunitname').val('#getUnit.orgunitname#');
				$('##orgunit').val('#getUnit.orgunit#');
				$('##mission2').val('#getUnit.mission#');
				$('##orgunitclass').val('#getUnit.orgunitclass#');
			</script>
		</cfoutput>
	</cfif>

</cfif>