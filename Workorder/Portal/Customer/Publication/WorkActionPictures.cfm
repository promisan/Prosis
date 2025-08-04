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
<cfquery name="sections" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT  
				PC.*
		FROM	Publication P
				INNER JOIN PublicationCluster PC
					ON P.PublicationId = PC.PublicationId
				INNER JOIN PublicationClusterElement PCE
					ON PC.PublicationId = PCE.PublicationId
					AND PC.Code = PCE.Cluster
				INNER JOIN PublicationWorkOrderAction PWA
					ON PCE.PublicationElementId = PWA.PublicationElementId
				INNER JOIN WorkOrderLineAction WOLA
					ON PWA.WorkActionId = WOLA.WorkActionId
				INNER JOIN Ref_Action AC
					ON WOLA.ActionClass = AC.Code
				INNER JOIN Organization.dbo.Organization O
					ON PCE.OrgUnit = O.OrgUnit
		WHERE 	1=1
		<cfif url.publicationId neq "">
		AND		P.PublicationId = '#url.PublicationId#'
		<cfelse>
		AND		1=0
		</cfif>
		<cfif url.orgunit neq "">
			<cfif url.orgunit neq "VIEWALLORGUNITS">
				AND		PCE.OrgUnit = '#url.orgUnit#'
			</cfif>
		<cfelse>
		AND		1=0
		</cfif>
		ORDER BY
				PC.ListingOrder ASC
</cfquery>


<table width="98%" height="100%" align="center" class="formpadding">
	<cfif sections.recordCount eq 0>
		<tr>
			<td align="center" class="labellarge" style="padding-top:50px; color:red;">[<cf_tl id="No elements publicated in this location">]</td>
		</tr>
	<cfelse>
		<tr>
			<td>
				<table width="100%" align="center">
					<tr>
						<td width="8%" class="labellarge">
							<cf_tl id="Section">:
						</td>
						<td>
							<table>
								<tr>
									<cfoutput query="sections">
										<td style="padding-left:20px;" class="labellarge">
											<input 
												type="Radio" 
												name="cluster" 
												id="cluster_#code#" 
												value="#Code#" 
												class="regularxl" 
												style="cursor:pointer;" 
												<cfif currentrow eq 1>checked</cfif> 
												onclick="ColdFusion.navigate('WorkActionPicturesDetail.cfm?publicationId=#url.publicationid#&orgUnit=#url.orgUnit#&cluster='+this.value,'picturesDetail');">
										</td>
										<td class="labellarge" style="padding-left:3px;">
											<label for="cluster_#code#" style="cursor:pointer;">#Description#</label>
										</td>
									</cfoutput>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td height="100%" width="100%">
				<cfdiv id="picturesDetail" style="height:100%; width:100%;" bind="url:WorkActionPicturesDetail.cfm?publicationId=#url.publicationid#&orgUnit=#url.orgUnit#&cluster=#sections.code#">
			</td>
		</tr>
	</cfif>
	
</table>


  

