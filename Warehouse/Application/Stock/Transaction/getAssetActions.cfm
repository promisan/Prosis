<cfoutput>

<cfif url.adate neq "">
		
	<cfquery name="GetActions" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  DISTINCT RC.ActionCategory
		FROM    AssetItem A 
		        INNER JOIN Item I ON A.ItemNo = I.ItemNo 
		     	INNER JOIN Ref_Category C ON C.Category = I.Category  		
			    INNER JOIN Ref_AssetActionCategory RC ON C.Category = RC.Category AND RC.EnableTransaction = '1'
			<cfif url.assetid eq "">
				WHERE   1=0
			<cfelse>
				WHERE   AssetId = '#url.AssetId#'	 	
			</cfif>
	</cfquery>
	
		
	<cfloop query = "GetActions">
	
		<cfquery name="qMetrics" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT Metric
			FROM   Ref_AssetActionMetric
			WHERE  Category       = '#Get.Category#'
			AND    ActionCategory = '#GetActions.ActionCategory#'
		</cfquery>		
				
		<cfquery name="qAssetActionPrevious" 
		datasource = "AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 * 
			FROM   AssetItemAction
			WHERE  AssetId = '#URL.AssetId#' 
			AND    ActionDate = 
					(
						SELECT   TOP 1 ActionDate 
						FROM     AssetItemAction AIA
						WHERE    AssetId        = '#URL.AssetId#'
						AND      ActionDate     <= #dte#
						AND      ActionCategory = '#GetActions.ActionCategory#'
						AND    EXISTS
						(
								SELECT 'X' 
								FROM   AssetItemActionMetric
								WHERE  AssetActionId = AIA.AssetActionId 
								AND    MetricValue IS NOT NULL
								AND    MetricValue != ''
						)						
						ORDER BY ActionDate DESC
					)	
			AND   ActionCategory = '#GetActions.ActionCategory#'
			AND   ActionType     = 'Standard'			
			ORDER BY Created DESC			
		</cfquery>		
		
		<cfif qAssetActionPrevious.recordcount eq "0">
		
			<cfquery name="qAssetActionPrevious" 
			datasource = "AppsMaterials"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TOP 1 * 
				FROM   AssetItemAction
				WHERE  AssetId = '#URL.AssetId#' 
				AND    ActionDate = 
						(
							SELECT   TOP 1 ActionDate 
							FROM     AssetItemAction AIA
							WHERE    AssetId        = '#URL.AssetId#'
							AND      ActionDate     <= #dte#
							AND      ActionCategory = '#GetActions.ActionCategory#'
							AND    EXISTS
							(
									SELECT 'X' 
									FROM   AssetItemActionMetric
									WHERE  AssetActionId = AIA.AssetActionId 
									AND    MetricValue IS NOT NULL
									AND    MetricValue != ''
							)						
							ORDER BY ActionDate DESC
						)	
				AND   ActionCategory = '#GetActions.ActionCategory#'
				<!---  AND   ActionType     = 'Standard' --->
				ORDER BY Created DESC			
			</cfquery>		
				
		</cfif>
				
		<cfloop query= "qMetrics">	
				
		<tr>
			<td class="label" valign="top" style="padding-top:2px;padding-left:4px"><font color="808080"><cf_tl id="Enter"> #qMetrics.Metric#:</font><font color="red">*</font></td>
			<td colspan="1" class="labelit" onkeydown="if (event.keyCode==13) {event.keyCode=9; return event.keyCode}">

				<cfset tempValue = "">
				
				<cfif url.transactionid neq "">
				
				    <!--- if this is a NOT posted transaction --->
										
					<cfif url.table neq "">

					<cfloop list="1,2,3,4" index = i>
					
						<cfquery name="getLine"
							datasource="AppsTransaction" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    SELECT   AssetMetricValue#i# as value
							FROM     #url.table# T
							WHERE    TransactionId      = '#url.transactionid#'	
							AND      AssetMetric#i#     = '#GetActions.ActionCategory#.#qMetrics.Metric#'
						</cfquery>	
						
						<cfset tempValue = getLine.Value>
						
						<cfif tempValue neq "">
							<cfbreak>
						</cfif>
							
					</cfloop>
					
					</cfif>			
					
					<!--- if this is a posted transaction --->
					
					<!--- To be added --->
					
					<cfif tempValue eq "">
										
						<cfquery name="getLine"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">							
								SELECT   TOP 1 *
								FROM     AssetItemActionMetric AM INNER JOIN
						                 AssetItemAction AI ON AM.AssetActionId = AI.AssetActionId						  
								WHERE    TransactionId      = '#url.transactionid#'								
							</cfquery>	
														
						<cfset tempValue = getLine.MetricValue>			
						
					</cfif>								
			
				</cfif>		
				
				<cf_assignid>	
				
				<!-- <cfform> -->
						
		  		<cfinput type = "Text"
				   style      = "background-color:lime;width:70;height:25;font-size:15;text-align:center;padding-right:2px"
			       name       = "#GetActions.ActionCategory#.#qMetrics.Metric#"
				   id         = "#GetActions.ActionCategory#.#qMetrics.Metric#"				   
				   class      = "value regularxl enterastab"		
				   maxlength  = "7"		   
				   onchange   = "validatemetric('#qAssetActionPrevious.AssetActionId#','#qMetrics.Metric#',this.value,'box#rowguid#','#GetActions.ActionCategory#.#qMetrics.Metric#')"
				   value      = "#tempValue#">	
				   
				 <!-- </cfform> --> 
				   
				</td>  			 								
														
				<td colspan="2" class="labelit" align="center" id="box#rowguid#">
				
					<cfif qAssetActionPrevious.recordcount neq 0>																			
					
						<cfquery name="getAction" 
						datasource = "AppsMaterials"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT TOP 1 * 
							FROM   AssetItemActionMetric
							WHERE  AssetActionId = '#qAssetActionPrevious.AssetActionId#' 
							AND    Metric        = '#qMetrics.Metric#'
							AND    MetricValue IS NOT NULL
						</cfquery>
						
						#qMetrics.Metric# <cf_tl id="On">#DateFormat(qAssetActionPrevious.ActionDate,CLIENT.DateFormatShow)# :<b>#NumberFormat(getAction.MetricValue,'999,999,999.9')#</b>			 
						
					 <cfelse>
					 
					 	<font color="6688aa">No prior measurement</font> 	
						
					 </cfif>		
						
					 </td>					 
			
			 </tr>
			 			 
		</cfloop>
				
	</cfloop>	
	
</cfif>
</cfoutput>