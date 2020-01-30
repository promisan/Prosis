
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




