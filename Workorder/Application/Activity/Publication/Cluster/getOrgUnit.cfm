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
<cfquery name="getPub" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Publication
		WHERE	PublicationId = '#url.PublicationId#'
</cfquery>

<cfquery name="getOrgs" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT
				W.WorkOrderId,
				O.*,
				LEN(O.HierarchyCode) as HierarchyCodeLen,
				ISNULL((
					SELECT 	COUNT(*)
					FROM	PublicationWorkOrderAction PWA
							INNER JOIN PublicationClusterElement PCE
								ON PWA.PublicationElementId = PCE.PublicationElementId
							INNER JOIN PublicationCluster PC
								ON PCE.PublicationId = PC.PublicationId
								AND PCE.Cluster = PC.Code
					WHERE	PC.PublicationId = '#url.publicationId#'
					AND		PC.Code = '#url.code#'
					AND		PCE.OrgUnit = O.OrgUnit
				),0) AS CountActions
		FROM	WorkOrder W
				INNER JOIN WorkorderLine L
					ON W.WorkOrderId = L.WorkOrderId
				INNER JOIN Organization.dbo.Organization O
					ON L.OrgUnit = O.OrgUnit
		WHERE	W.WorkOrderId = '#getPub.workOrderId#'
		AND		W.ActionStatus <> '9'
		AND		L.ActionStatus <> '9'
		ORDER BY O.HierarchyCode ASC
</cfquery>

<cfset rootLen = getOrgs.HierarchyCodeLen>

<table width="100%" height="100%">
	<tr>
		<td valign="top" style="padding-left:3px;">
			<table width="100%">
				<cfoutput query="getOrgs">
				<tr>
					<td style="padding-left:#(HierarchyCodeLen-rootLen)*4#px;">
						<table width="95%">
							<tr>
								<cfset vStyle = "font-size:95%;">
								<cfif countActions gt 0>
									<cfset vStyle = "font-weight:bold; font-size:110%;">
								</cfif>
								<td class="clsOrgUnit"
									id="orgUnit_#orgUnit#" 
									style="cursor:pointer; height:20px; padding-right:5px; padding-left:3px;" 
									onclick="selectOrgUnit('#url.publicationId#','#url.code#','#orgUnit#')">
										<table width="100%">
											<tr>
												<td class="labellarge" style="color:##808080; #vStyle#">#OrgUnitName#</td>
												<td class="labellarge" align="right" style="color:##808080; #vStyle#">
													<span id="countActionsOrgUnit_#orgUnit#"><cfif countActions gt 0>[#CountActions#]</cfif></span>
												</td>
											</tr>
										</table> 
								</td>
							</tr>
						</table>
					</td>
				</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
</table>
