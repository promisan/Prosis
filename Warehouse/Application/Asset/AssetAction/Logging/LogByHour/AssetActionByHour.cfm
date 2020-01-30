<cfoutput>
<!--- additional details --->
<cfloop from="8" to="18" index="i">

		<cfset vDate = DateAdd("h", i, dte)>

		<cfquery name="qAssetAction" 
		datasource = "AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   AssetItemAction
			WHERE  AssetId        = '#qAssets.AssetId#' 
			AND    ActionDate = #vDate#
			AND    ActionCategory = '#URL.Code#'
			AND    ActionType     = 'Detail'
		</cfquery>									
													
		<tr id="detail_#category#_#cnt#" class="hide ldetails#cnt#" >
			
			<td style="border-left:1px dotted silver;border-left:1px dotted silver"></td>
			<td>
			  <input type="hidden" id="id_#qAssets.AssetId#_#i#" name="id_#qAssets.AssetId#_#i#" class="aid" value="'#qAssets.AssetId#'">
			  <input type="hidden" id="t_#qAssets.AssetId#_#i#" name="t_#qAssets.AssetId#_#i#"   class="tid" value="#i#">									  												
			</td>
			<td>
			</td>
			<td align="right" style="padding-right:10px">#TimeFormat(vDate,"HH:mm")#</td>
			
			<td style="padding-top:4px;" style="border-top:1px dotted silver">
				<cfselect name="#qAssets.AssetId#_Action_#i#"
		          query    = "Lookup"
		          value    = "ListCode"
		          display  = "ListValue"
		          selected = "#list_selected#"
		          visible  = "Yes"	
		          enabled  = "Yes"
		          type     = "Text"
		          class    = "action"/>		
			</td>
			<td style="border-top:1px dotted silver;padding-top:4px;padding-left:2px;padding-right:2px;">
				<input type   = "text" 
					name      = "#qAssets.AssetId#_ActionMemo_#i#" 
					id        = "#qAssets.AssetId#_ActionMemo_#i#"
					size      = "40" 
					maxlength = "40" 								
					class     = "memo"
					value     = "#qAssetAction.ActionMemo#"
					style     = "width:100%;text-align:left;padding-left:3px;padding-top:1px;"
					#disabled#>
			</td>
			
			<cfloop query= "qMetrics">
			<td align="right" style="border-top:1px dotted silver;padding-top:4px;padding-left:2px;padding-right:2px;">
				<cfif qAssetAction.recordcount neq 0>
					<cfquery name="qActionMetrics" 
						datasource = "AppsMaterials"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT * 
						FROM   AssetItemActionMetric
						WHERE  AssetActionId = '#qAssetAction.AssetActionId#' 
						AND    Metric = '#qMetrics.Metric#'
					</cfquery>
				<cfelse>
		
					<cfquery name="qActionMetrics" 
					datasource = "AppsMaterials"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
							SELECT * 
							FROM   AssetItemActionMetric
							WHERE 1=0
					</cfquery>					
			
				</cfif>						
		
				<cfif qAssets.Category eq qMetrics.Category>
					<input type   = "text" 
						name      = "#qAssets.AssetId#_#i#_#qMetrics.Metric#" 
						id        = "#qAssets.AssetId#_#i#_#qMetrics.Metric#"
						size      = "7"
						maxlength = "7" 									
						class     = "value" 
						value     = "#qActionMetrics.MetricValue#"
					    style     = "text-align:right;padding-right:3px;width:100%;padding-top:1px;"
						#disabled#>
				</cfif>			
			</td>	
			</cfloop>												
		</tr>
</cfloop>
</cfoutput>