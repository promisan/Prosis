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

<table width="100%" height="100%" align="center">
	<tr>
		<td valign="top">
			<table width="100%">
				<tr><td height="5"></td></tr>
				<tr>
					<td valign="top" style="padding-left:3px;" height="5%">
						<cfoutput>
							<table width="100%">
								<tr>
									<td class="clsOrgUnit labellarge"
										id="orgUnit_VIEWALLORGUNITS" 
										style="cursor:pointer; height:20px; padding-right:5px; padding-left:3px; color:##808080; font-size:120%;" 
										onclick="selectOrgUnit('#url.publicationId#','VIEWALLORGUNITS')">
											<table width="100%">
												<tr>
													<td class="labellarge" style="font-size:120%; color:##454545;"><cf_tl id="View All"></td>
													<td class="labellarge" align="right" style="font-size:120%; color:##454545;">
														<img src="#session.root#/images/picture_blueSquare.png">
													</td>
												</tr>
											</table> 
									</td>
								</tr>
							</table>
						</cfoutput>
					</td>
				</tr>
				<tr><td height="5"></td></tr>
				<tr><td style="border-bottom:1px solid #EDEDED; height:1px;"></td></tr>
				<tr><td height="5"></td></tr>
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
												<cfset vStyle = "font-size:120%; color:##454545;">
											</cfif>
											<td class="clsOrgUnit"
												id="orgUnit_#orgUnit#" 
												style="cursor:pointer; height:20px; padding-right:5px; padding-left:3px;" 
												onclick="selectOrgUnit('#url.publicationId#','#orgUnit#')">
													<table width="100%">
														<tr>
															<td class="labellarge" style="color:##808080; #vStyle#">#OrgUnitName#</td>
															<td class="labellarge" align="right" style="color:##808080; #vStyle#">
																<cfif countActions gt 0>
																	<cf_tl id="Pictures" var="1">
																	<img src="#session.root#/images/picture_blueSquare.png">
																</cfif>
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
		</td>
	</tr>
</table>
