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
<cfoutput>

<table><tr><td style="padding:3px">

<table cellspacing="0" cellpadding="0" class="navigation_table" style="border:1px solid d4d4d4">	
					
	<tr class="line">	   
	   <td height="20" align="center" colspan="1" class="labelit" bgcolor="B0D3EE"><cf_space spaces="18">Date</td>			      
	   <td bgcolor="ffffcf" class="labelit" style="padding-right:30px" align="right" colspan="3">Measured</td>	  	   
	   <td bgcolor="f1f1f1" class="labelit" align="center" style="padding-left:1px">Target</td>
	   <td align="center"   class="labelit" bgcolor="F3F3DA" style="padding-left:1px">Actual</td>			
	</tr>
					
	<tr>	   
	   <td height="20" class="labelit" align="center" bgcolor="B0D3EE" style="padding-left:1px"></td>			   
	   <td bgcolor="ffffcf" class="labelit" align="right"   style="padding-right:1px"><cf_space spaces="20">&Sigma; #Consumption.UOMDescription#</td>
	   <td bgcolor="ffffcf" class="labelit" align="center"  style="padding-left:1px"><cf_space spaces="4"></td>
	   <td bgcolor="ffffcf" class="labelit" align="right"   style="padding-right:1px"><cf_space spaces="20">&Delta; #getMetrics.Metric#</td>
	   <td bgcolor="f1f1f1" class="labelit" align="center"  style="padding-right:0px"><cf_space spaces="20">Consum.<br>/#getTarget.metricQuantity# #getMetrics.MeasurementUoM#</td>
	   <td bgcolor="F3F3DA" class="labelit" align="center"  style="padding-right:0px"><cf_space spaces="20">Consum.<br>/#getTarget.metricQuantity# #getMetrics.MeasurementUoM#</td>			
	</tr>		
	
	<cfset row = 0>
	<cfset scale = 0>

	<cfset yMax = "0">
	<cfset yMin = "0">
	<cfset mMax = "0">
							
	<cfloop query="Issues">
	
		<tr><td colspan="6" class="line"></td></tr>	

		<!--- configuring all the values based on the datase --->
			<cfif yMin eq "">
				<cfset yMin = Year(TransactionDate)>	
			<cfelseif yMin gt Year(TransactionDate)>
				<cfset yMin = Year(TransactionDate)>		
			</cfif>

			<cfif yMax eq "">
				<cfset yMax = Year(TransactionDate)>
			<cfelseif yMax lt Year(TransactionDate)>
				<cfset yMax = Year(TransactionDate)>										
			</cfif>
		
			<cfif mMax eq "">
				<cfset mMax = Month(TransactionDate)>
			<cfelseif mMax lt Month(TransactionDate)>
				<cfset mMax = Month(TransactionDate)>										
			</cfif>
		<!--- end configuring values--->
											
		<cfif currentrow eq "1">
		
		 <tr bgcolor="f4f4f4">
		    <td align="center" class="labelit" height="20" style="padding-right:2px">#dateformat(transactiondate,"DD/MM")#</td>
		    <td align="right" class="labelit" style="padding-right:1px"><cfif issues neq "1"><font size="1">(#issues#)</font></cfif> #numberformat(-TransactionQuantityBase,"__,__._")#</td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
		 </tr>	
		
		 <cfset prior = TransactionDate>
		
		<cfelseif currentrow gte "2">
		
			<cfset row = row+1>
			
			<cfif url.mode eq "chart">	
		
			<tr class="m_#qConsumptionData.supplyitemNo#_#dateformat(prior,'M')#">						
			    <td style="padding-left:2px"><!---#dateformat(prior,CLIENT.DateFormatShow)#---></td>
				
			</cfif>											
								
		    <cfif getMetrics.Measurement eq "Cumulative">	
			
			    <!--- we get the highest closing metric value for each asset in this observation period, which is routinely the last value 
				and then we sum for each of the found assets and deduct the prior value from the new sum to be shown for operations
				--->	
																							
					
				<cfquery name="ClosingMetricValues" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   H.AssetId, 					         						
					         MAX(M.MetricValue) as MetricValue
					FROM     AssetItemAction H, 
					         AssetItemActionMetric M,
							 
							 
							 <!--- retrieve the most recent measurement for this asset which qualifies --->
							 
							 (							 
							 
							 SELECT  AH.AssetId, 
					                 MAX(AH.ActionDate) as ActionDate
							 FROM    AssetItemAction AH, 
							         AssetItemActionMetric AM
							 WHERE   (
							         AH.AssetId = '#url.assetid#'	
									 OR 
									 AH.AssetId IN (SELECT AssetId
									               FROM   AssetItem 
												   WHERE  ParentAssetId = '#url.assetid#')
									 )					          
							 AND      AH.AssetActionId  = AM.AssetActionId		 
							 AND      AH.ActionCategory = '#url.action#' <!--- operations --->
							 AND      AM.Metric         = '#getMetrics.metric#'	
							 AND      AH.ActionType     = 'Standard'					
							 AND      AH.ActionDate <= '#dateformat(TransactionDate,client.dateSQL)#' 	<!--- date of this issuance --->	
							 GROUP BY AH.Assetid	
							 
							) as L 
							 
					WHERE    H.AssetId    = L.AssetId
					AND      H.ActionDate = L.ActionDate	
					
							 
							 
					AND     (
					         H.AssetId = '#url.assetid#'	
							 OR 
							 H.AssetId IN (SELECT AssetId
							               FROM   AssetItem 
										   WHERE  ParentAssetId = '#url.assetid#')
							 )			 
												 			          
					AND      H.AssetActionId  = M.AssetActionId		 
					AND      H.ActionCategory = '#url.action#' <!--- operations --->
					AND      M.Metric         = '#getMetrics.metric#'	
					AND      H.ActionType     = 'Standard'
					
					GROUP BY H.Assetid			
					
									
			    </cfquery>						
				
				<!--- we sum but if one asset has no observation we have an issue --->
								
				<cfquery name="MetricValues" dbtype="query">
					SELECT   SUM(MetricValue) as MetricValue
					FROM     ClosingMetricValues 						
				</cfquery>																	
								
				<cfparam name="opening" default="">
				
					<cfloop query="MetricValues">
																									
					    <cfif currentrow eq "1" and opening eq "">
							 <cfset opening = metricvalue>		
						<cfelseif currentrow eq "1">
						     <!--- correctly take the last measurement as the opening for this sub period --->
						     <cfset opening = closing>	 				 
						</cfif> 
																
						<cfif recordcount eq currentrow>
							 <cfset closing = metricvalue> 				 
						</cfif>
						
						<cfif ClosingMetricValues.recordcount eq "1">
						
							<cfif url.mode eq "chart">					
							
								<cfif currentrow eq "1">														   
									<td></td>																
								<cfelse>							
								<tr class = "m_#qConsumptionData.supplyitemNo#_#dateformat(actiondate,'M')#">
								    <td></td>
									<td></td>							   							
								</cfif>							
									<td align="center" style="padding-right:2px"></td>
								    <td align="right" style="padding-right:15px" class="labelsmall"><font color="808080">[#MetricValue#]</td>
								</tr>
							
							</cfif>		
						
						</cfif>								
						
					</cfloop>								
					
			<cfelse>
			
				<!--- in case of incremental we summarize by date any values which also works for the composing assets --->
																									
				<cfquery name="MetricValues" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   CONVERT(VARCHAR(10),H.ActionDate,126) as ActionDate, 
					         SUM(M.MetricValue) as MetricValue	
					FROM     AssetItemAction H, 
					         AssetItemActionMetric M
					WHERE    (
					         H.AssetId        = '#url.assetid#'	
							 OR 
							 H.AssetId IN (SELECT AssetId
							               FROM   AssetItem 
										   WHERE  ParentAssetId = '#url.assetid#')
							 )		
					          
					AND      H.AssetActionId  = M.AssetActionId		 
					AND      H.ActionCategory = '#url.action#'
					AND      M.Metric         = '#getMetrics.metric#'	
					AND      H.ActionType     = 'Standard'
					AND      ActionDate      >= '#dateformat(prior,client.dateSQL)#' 
					AND      ActionDate      <= '#dateformat(TransactionDate,client.dateSQL)#' 	
					GROUP BY CONVERT(VARCHAR(10),H.ActionDate,126)			
					ORDER BY ActionDate	 					
			    </cfquery>																							
								
				<cfloop query="MetricValues">
					
					    <cfif currentrow eq "1">
							 <cfset opening = 0>
							 <cfset closing = metricvalue>
						<cfelse>
							<cfset closing = closing+metricvalue>								
						</cfif> 	
						
						<cfif url.mode eq "chart">						
				
							<cfif currentrow eq "1">														   
								<td></td>																	
							<cfelse>								
							<tr class = "m_#qConsumptionData.supplyitemNo#_#dateformat(actiondate,'M')#">
							    <td></td>
								<td></td>								   							
							</cfif>								
								<td align="center" style="padding-right:10px"><font size="1" color="808080">#dateformat(actiondate,"DD/MM")#</font></td>
							    <td align="right" style="padding-right:10px"><font size="1" color="808080">#MetricValue#</td>
							</tr>
						
						</cfif>
					
				</cfloop>				
			
			</cfif>			
												
			<tr class="navigation_row" class = "m_#qConsumptionData.supplyitemNo#_#dateformat(transactiondate,'M')#" >
			
			<!--- date if resupply --->			
		    <td class="labelit" height="16"	align="center" style="padding-right:2px">#dateformat(transactiondate,"DD/MM")#</td>
			
			<!--- quantity of resupply --->			
		    <td class="labelit" style="padding-right:2px" align="right"><cfif issues neq "1"><font size="1">(#issues#)</font></cfif> #numberformat(-TransactionQuantityBase,"__,__._")#</td>
						
			<cfset val = -transactionQuantityBase>					
								
			<cfif MetricValues.recordcount gte "1">			
						
				<cfinvoke component = "Service.Process.Materials.Consumption"  
				   method           = "getConsumptionTarget" 
				   assetid          = "#qConsumptionData.AssetId#" 
				   supplyItemNo     = "#qConsumptionData.SupplyItemNo#"
				   supplyItemUoM    = "#qConsumptionData.SupplyItemUoM#"
				   Metric           = "#getMetrics.metric#"
				   Effective        = "#dateformat(prior,CLIENT.DateFormatShow)#"	   
				   Expiration       = "#dateformat(transactiondate,CLIENT.DateFormatShow)#"	   
				   returnvariable   = "getTarget">					 																	  
				   
				<!--- 
				
				    Hanno. we will check for an adjusted target based on the operation level
				    in the period since the last transaction

					hereto we consider the operational level for each day since the last and define the target based on
					
					effective date
					operations level

					the resulting target is the average of the target found for each date
					
					cfc : pass the assetid, supplyitemno, uom, metric, startdate, enddate
					- return value => target value
					if not found we take the default as per above
					      					
				--->
							
			  	
				
				<td></td>
								
				<!--- calculated operations recorded expressed in the metric --->
				
			    <cfset total = closing-opening>	
								
				<td class="labelit" align="right" style="padding-right:2px">#total#</td>				
				
				<cfset myar[row][1] = "#dateformat(transactiondate,'DD/MM')#">	
																	
				<cftry>
				
				    <!--- this will express the target in the denomination of the metric,  like 100 kms, how many liters --->
					<cfset tgt = getTarget.targetRatio*getTarget.metricQuantity>
					
				<cfcatch>
				
					<cfset tgt = 0>
					
				</cfcatch>	
				
				</cftry>	
				
				<cfset myar[row][2] = numberformat(tgt,'____.__')>
										
				<cfif scale lt getTarget.targetratio>
					  <cfset scale = getTarget.targetratio>
				</cfif>
				
				<!--- the calculated target consumption for the period based on the operations AND level of operatoins 
				                                                        for the asset or the assets (generator group) involved --->
						
				<td align="right" bgcolor="80FF80" class="labelit" style="border:1px solid black;padding-right:2px"><cfif tgt lte "0">n/a<cfelse>#numberformat(tgt,'__,__.___')#</cfif></td>
				
				<cfif total eq "0">
				
				    <cfset act = "0">
					
				<cfelse>				
				    
					<!--- actual ratio found--->				
									
					<cftry>
						<cfset act = val/(total/getTarget.metricQuantity)>
												
					<cfcatch>
						<cfset act = 0>	
					</cfcatch>	
					</cftry>	
				</cfif>	

				<!--- show only limited digits --->
				<cfset act = round(act * 1000)/1000>				
				
				<cfset myar[row][3] = act>
				
				<cfif scale lt act>
				  <cfset scale = act>
				</cfif>
				
				<cfif getTarget.TargetDirection eq "up">
												
				<!--- means if actual lower is better --->
				
				<cfif tgt eq "0">
				
				<td align="right" class="labelit" bgcolor="6688aa"    style="border:1px solid black; padding-right:2px">						
					<font color="FFFFFF">#numberformat(act,'__,__.___')#</font>						
				</td>							
				
				<cfelseif act lt 0 or act/tgt lt 0.2>		
				
				<!--- something is very likely wrong --->				
				<td align="right" class="labelit" bgcolor="black"  style="border:1px solid black;padding-right:2px">						
					<font color="FFFFFF">#numberformat(act,'__,__.___')#</b></font>						
				</td>		
				
				<cfelseif act gt tgt and act/tgt lte (100+getTarget.TargetRange)/100>		
				
				<!--- within the range --->				
				<td align="right" class="labelit" bgcolor="yellow"  style="border:1px solid black; padding-right:2px">						
					<font color="black">#numberformat(act,'__,__.___')#</b></font>						
				</td>
				
				<cfelseif act/tgt gt (100+getTarget.TargetRange)/100>		
				
				<!--- not good --->				
				<td align="right" class="labelit" bgcolor="red" style="border:1px solid black; padding-right:2px">						
					<font color="FFFFFF">#numberformat(act,'__,__.___')#</b></font>						
				</td>							
				
				<cfelse>
				<!--- good --->
				<td align="right" class="labelit" bgcolor="00FF00" style="border:1px solid black; padding-right:2px">						
					<font color="black">#numberformat(act,'__,__.___')#</b></font>						
				</td>
				</cfif>
				
				<cfelse>
				
				<!--- means if actual is higher is better --->
				
				
				</cfif>
							
	</cfif>
			
			</tr>
								
			<cfset prior = dateAdd("d",1,TransactionDate)>
																	
		</cfif>	
		
	</cfloop>
</table>

</td></tr></table>

<cfset jsondata = serializeJSON(myar)>

<cfparam name="CLIENT.graph_#qConsumptionData.supplyitemNo#" default = "#jsondata#">

<cfif jsondata neq evaluate("CLIENT.graph_#qConsumptionData.supplyitemNo#")>
	<cfset IsDeleteSuccessful=StructDelete(Client, "graph_#qConsumptionData.supplyitemNo#")>
	<cfparam name="CLIENT.graph_#qConsumptionData.supplyitemNo#" default = "#jsondata#">
</cfif>

</cfoutput>

<cfset ajaxonLoad("doHighlight")>
