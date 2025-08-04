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
<cfquery name="getPublicationClusters" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	C.*,
				ISNULL((
					SELECT 	COUNT(*)
					FROM	PublicationWorkOrderAction PWA
							INNER JOIN PublicationClusterElement PCE
								ON PWA.PublicationElementId = PCE.PublicationElementId
							INNER JOIN PublicationCluster PC
								ON PCE.PublicationId = PC.PublicationId
								AND PCE.Cluster = PC.Code
					WHERE	PC.PublicationId = C.PublicationId
					AND		PC.Code = C.Code
				),0) AS CountActions
		FROM	PublicationCluster C
		WHERE	C.PublicationId = '#url.publicationId#'
		ORDER BY C.ListingOrder ASC
</cfquery>

<table>
	<tr>
		<cfoutput query="getPublicationClusters">
			<cfset vSelectedStyle = "font-size:12px;">
			<cfif url.autoselect eq code or (url.autoselect eq "" and currentrow eq 1)>
				<cfset vSelectedStyle = "font-size:17px;">
			</cfif>
			<td style="padding-right:15px;" class="labelmedium">
				<table>
					<tr>
						<td>
							<input class="radiol"
								type="Radio" 
								name="cluster"
								id="cluster_#code#"
								value="#Code#" 
								onclick="selectCluster('#url.publicationId#','#code#','font-size','12px','17px');" 
								<cfif url.autoselect eq code or (url.autoselect eq "" and currentrow eq 1)>checked</cfif>>
						</td>
						<td style="padding-left:3px;" valign="middle" class="labelit">
							<label for="cluster_#code#"><span class="clsClusterLabel" style="#vSelectedStyle#" id="clusterLabel_#code#">#Code# - #Description# <span id="countActionsCluster_#code#">[#CountActions#]</span></span></label>
						</td>
					</tr>
				</table>
			</td>
		</cfoutput>
	</tr>
</table>