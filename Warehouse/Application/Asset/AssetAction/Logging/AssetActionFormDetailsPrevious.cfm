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

<cfoutput query="qAssetActionPrevious">
								
	<tr bgcolor="F5FBFE">
		<td bgcolor="FFFFFF"></td>
		<td class="description" height="16" style="border-top:1px dotted d4d4d4">
		   <font face="Verdana" size="1" color="808080">#DateFormat(qAssetActionPrevious.ActionDate,CLIENT.DateFormatShow)#&nbsp;#TimeFormat(qAssetActionPrevious.ActionDate,"HH")#
		</td>
		
		<td class="description" style="border-top:1px dotted d4d4d4">
		
			<cfquery name="Lookup_Previous" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   *
				FROM     Ref_AssetActionList
				WHERE    Code = '#URL.Code#'
				AND      ListCode = '#qAssetActionPrevious.ActionCategoryList#'
				ORDER BY ListOrder
			</cfquery>
			<font face="Verdana" size="1" color="808080">
			#Lookup_Previous.ListValue#							
	          
		</td>
		

			<cfloop query= "qMetrics">
			
				<td align="right" 
				  class="description" style="padding-right:7px;border-top:1px dotted d4d4d4">
				  <font face="Verdana" size="1" color="808080">
				
					<cfif CheckMetric(qAssetActionPrevious.AssetId, qMetrics.Metric)>
					
						<cfquery name="qActionMetricsPrevious" 
						datasource = "AppsMaterials"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   AssetItemActionMetric
							WHERE  AssetActionId = '#qAssetActionPrevious.AssetActionId#' 
							AND    Metric = '#qMetrics.Metric#'
							AND    MetricValue IS NOT NULL
							AND    MetricValue != ''
						</cfquery>
						
						<cfif qActionMetricsPrevious.MetricValue neq "">
							#qActionMetricsPrevious.MetricValue#
						<cfelse>
							<cfif qAssets.Category eq qMetrics.Category>
								N/A
							</cfif>
						</cfif>
					
					</cfif>
														
					</font>	
				</td>	
										
			</cfloop>	
			<td class="description" style="border-top:1px dotted d4d4d4"><font face="Verdana" size="1" color="808080">#qAssetActionPrevious.ActionMemo#</td>

																					
	</tr>		
																		
</cfoutput>




