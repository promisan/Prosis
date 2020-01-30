<cfoutput>
		<tr id="detail_#category#_#cnt#_#j#" class="hide ldetails#cnt#">
			
			<td style="border-left:1px dotted silver;border-left:1px dotted silver">
			</td>
				<td <cfif mode eq "add">id="hidden_#qAssets.AssetId#_#i#"</cfif> >
				  <input type="hidden" id="id_#qAssets.AssetId#_#i#" name="id_#qAssets.AssetId#_#i#" class="aid" value="'#qAssets.AssetId#'">
				  <input type="hidden" id="t_#qAssets.AssetId#_#i#" name="t_#qAssets.AssetId#_#i#"   class="tid" value="#i#">									  												
				</td>
			<cfif mode eq "add">
				<td id="add_#qAssets.AssetId#_#i#" align="left">
					<cf_img icon="add" id="add1" onclick="new_transaction('ldetails#cnt#')" safemode="yes">
				</td>
			<cfelse>
				<td></td>
			</cfif>	
			<td id="dates_#qAssets.AssetId#_#i#" style="padding-top:4px;padding-right:4px;" style="border-top:1px dotted silver" align="right">
			   <table width="100%">	
			   <tr>
			   	<td width="50%">
				   <cfif Edit>
					   <select style="font:10px" id="tdeth_#qAssets.AssetId#_#i#" name="tdeth_#qAssets.AssetId#_#i#" onchange="javascript:set_time($(this),'h')">
								<cfloop index="it" from="0" to="23" step="1">
									<cfif it lte "9">
									   <cfset itd = "0#it#">
									<cfelse>
										<cfset itd = "#it#">	  
									</cfif>				 						
								    <option value="#it#" <cfif it eq vHour>selected</cfif>>#itd#</option>
								</cfloop>	
						</select>
						<select style="font:10px" id="tdetm_#qAssets.AssetId#_#i#" name="tdetm_#qAssets.AssetId#_#i#" onchange="javascript:set_time($(this),'m')">
								<cfloop index="it" from="0" to="59" step="1">
									<cfif it lte "9">
										  <cfset it = "0#it#">
									</cfif>				 							
									<option value="#it#" <cfif it eq vMinute>selected</cfif>>#it#</option>
								</cfloop>	
						</select>		
					<cfelse>
						#vHour# : #vMinute#
						<input type="hidden" id="transaction_#qAssets.AssetId#_#i#" name="transaction_#qAssets.AssetId#_#i#"   class="transaction" value="#qAssets.AssetId#_#i#_#TransactionId#">					  
					</cfif>
				</td>	
					<td width="50%" align="left" id="attachment_#qAssets.AssetId#_#i#">
					<cf_img icon="edit" id="edit_#cnt#_#j#" onclick="edit_details('#Category#','#qAssets.AssetId#',this)" safemode="yes">
					</td>
				</tr>
				</table>							
			</td>
			
			<td style="padding-top:4px;" style="border-top:1px dotted silver">
			
				<cfif mode eq "add">
					<cfset vSelected = "">
				<cfelse>
					<cfset vSelected = #list_selected#>	
				</cfif>
				<cfselect name="#qAssets.AssetId#_Action_#i#"
		          query    = "Lookup"
		          value    = "ListCode"
		          display  = "ListValue"
		          selected = "#vSelected#"
		          visible  = "Yes"	
		          enabled  = "Yes"
		          type     = "Text"
		          class    = "action"/>		
			</td>
			<td style="border-top:1px dotted silver;padding-top:4px;padding-left:2px;padding-right:2px;">
				<cfif mode eq "add">
					<cfset vMemo = "">
				<cfelse>
					<cfset vMemo = qAssetAction.ActionMemo>
				</cfif>
				<input type   = "text" 
					name      = "#qAssets.AssetId#_ActionMemo_#i#" 
					id        = "#qAssets.AssetId#_ActionMemo_#i#"
					size      = "40" 
					maxlength = "40" 								
					class     = "memo"
					value     = "#vMemo#"
					style     = "width:100%;text-align:left;padding-left:3px;padding-top:1px;"
					#disabled#>
			</td>
			
			<cfloop query= "qMetrics">
			<td align="right" style="border-top:1px dotted silver;padding-top:4px;padding-left:2px;padding-right:2px;">
				<cfif qAssetAction.recordcount neq 0 and mode neq "add">
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
</cfoutput>