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
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries for consumption analysis">
		
	<cffunction name="getConsumptionTarget"
             access="public"
             returntype="struct"
             displayname="Return true if the valid UoM exists if not, it returns false">

		<cfargument name = "AssetId"	   type="string"  required="true"   default="">			 	
		<cfargument name = "SupplyItemNo"  type="string"  required="true"   default="">							
		<cfargument name = "SupplyItemUoM" type="string"  required="true"   default="">	
		<cfargument name = "Metric"        type="string"  required="true"   default="">		
		<cfargument name = "Effective"     type="string"  required="true"   default="">	
		<cfargument name = "Expiration"    type="string"  required="true"   default="">					
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#effective#">
		<cfset EFF = dateValue>
		<cfset eff = dateadd("h",-12,eff)>
			
		<cfset dateValue = "">
		<CF_DateConvert Value="#expiration#">
		<cfset EXP = dateValue>
		<cfset exp = dateadd("h",+12,exp)>
		
		<!--- we are getting the correct target based on the operations mode 
		   and the date of the transactions as the target might change over time 
		   if the asset is a parent we define this for the uncerlying assets --->
		   
		<cfquery name="get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT  *
				 FROM    AssetItem
			     WHERE   AssetId        = '#AssetId#'								
		</cfquery>		
		
		 <cfquery name="Base" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT  *
				 FROM    ItemSupplyMetric
			     WHERE   ItemNo         = '#get.ItemNo#'
				 AND     SupplyItemNo   = '#SupplyItemNo#'
				 AND     SupplyItemUoM  = '#SupplyItemUoM#'
				 AND     Metric         = '#Metric#'					
		</cfquery>		   		   
		
		<cfset target.metricQuantity  = base.MetricQuantity>	
		<cfset target.targetDirection = base.targetDirection>
		<cfset target.targetRange     = base.targetRange>
				
		<!---
		 
	    <cfquery name="Default" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT  *
				 FROM    AssetItemSupplyMetric
			     WHERE   AssetId        = '#AssetId#'
				 AND     SupplyItemNo   = '#SupplyItemNo#'
				 AND     SupplyItemUoM  = '#SupplyItemUoM#'
				 AND     Metric         = '#Metric#'					
		</cfquery>		
				
		--->
		
		<!--- define the calculate target consumption for this date --->
				
		<cfquery name="getMetric" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT  *
				 FROM    Ref_Metric
			     WHERE   Code           = '#Metric#'								
	    </cfquery>		
		
		<cfquery name="getAssets" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   AssetId as SelectedAssetId					        
					FROM     AssetItem H
					WHERE    (
					         H.AssetId        = '#assetid#'	
							 OR 
							 H.AssetId IN (SELECT AssetId
							               FROM   AssetItem 
										   WHERE  ParentAssetId = '#assetid#')
							 )		
					AND      H.AssetId IN (SELECT AssetId FROM AssetItemAction WHERE AssetId = H.AssetId) 			          							
	    </cfquery>		
						
		<!--- loop through the assets that contribute to the metrics --->
		
		<cfset operations        = 0>
		<cfset plantarget        = 0>	
		<cfset operationsopening = 0>
		<cfset operationsclosing = 0>			
		<cfset operationopeningT = 0>
		<cfset operationclosingT = 0>	
									
		<cfloop query="getAssets">	
		
			<!--- last measurement beofre this period begins --->
			
			<!---
			<cfoutput>#SelectedAssetId#<br></cfoutput>
			--->
		
			<cfquery name="getInitialOperation" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">		
				  SELECT    TOP 1 MetricValue
				  FROM      AssetItemAction PA, AssetItemActionMetric PM
				  WHERE     PA.AssetId        = '#SelectedAssetId#'  
				  AND       PA.AssetActionId  = PM.AssetActionId
				  AND       PA.ActionType     = 'Standard'   
				  AND       PA.ActionCategory = 'Operations' 						  
				  AND       PM.Metric         = '#metric#'  	
				  AND       PA.ActionDate    < #EFF#
				  ORDER BY  ActionDate DESC			
			</cfquery>	
									
			<!---
				<cfoutput>--#SelectedAssetid#:#getInitialOperation.MetricValue#--<br></cfoutput>			
			--->
						
			<!--- define operations in this period --->
							
			<cfquery name="getOperationLevel" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">					 
		
		      SELECT     AssetId as OperationsAssetId, 
			             AssetActionId, 
						 OperationMode, 
						 ActionDate,
						 
						  ISNULL((SELECT    MetricValue
						   FROM      AssetItemActionMetric
						   WHERE     AssetActionId = A.AssetActionId
						   AND       Metric = '#metric#'),0) as Measurement,	
						   						 
			  
                          (SELECT    TOP 1 TargetRatio
                            FROM     AssetItemSupplyMetricTarget
                            WHERE    AssetId = A.AssetId 
							         AND SupplyItemNo   = '#SupplyItemNo#' 
							         AND SupplyItemUoM  = '#SupplyItemUoM#' 
									 AND Metric         = '#Metric#' 
									 AND DateEffective <= A.ActionDate 
									 AND OperationMode <= A.OperationMode <!--- reversed as dev will change this ActionCategoryList --->
                            ORDER BY OperationMode DESC, 
							         DateEffective DESC) AS Target,
									 
									 
						  (SELECT    TOP 1 TargetRatio
                            FROM     AssetItemSupplyMetric
                            WHERE    AssetId = A.AssetId 
							         AND SupplyItemNo   = '#SupplyItemNo#' 
							         AND SupplyItemUoM  = '#SupplyItemUoM#' 
									 AND Metric         = '#Metric#' 
									 ) AS TargetStandard,	
									 
									 
					   	(SELECT    TOP 1 TargetRatio
                            FROM     ItemSupplyMetric
                            WHERE    ItemNo = '#get.ItemNo#' 
							         AND SupplyItemNo   = '#SupplyItemNo#' 
							         AND SupplyItemUoM  = '#SupplyItemUoM#' 
									 AND Metric         = '#Metric#' 
									 ) AS TargetItem						 
						 	 												 
									 	 
			   FROM        AssetItemAction A
			   WHERE       AssetId        = '#SelectedAssetId#' 
			   AND         ActionDate    >= #EFF#
			   AND         ActionDate    <= #EXP#
			   AND         ActionType     = 'Standard'   <!--- we exclude detail sub measurements --->
			   AND         ActionCategory = 'Operations' <!--- hardcoded --->				
		   </cfquery>	
		   			 		    				
			<!--- define for the asset the target for each recorded date of measurement --->
			
			<cfset vInitialCumulative = 0>
			
			<cfif getInitialOperation.MetricValue eq "">
				<cfset prior = getOperationLevel.Measurement>	
				<cfif prior eq "">
				     <cfset prior = 0>
				</cfif>	
				
			<cfelse>
				<cfset prior = getInitialOperation.MetricValue>
			</cfif>
			<cfset vInitialCumulative = prior>		
			
			<!--- we look through the measurements of this period --->
												
			<cfloop query="getOperationLevel">
			
				<!--- set the target --->
													
				<cfif Target neq "">				
					<cfset tgt = Target>				
				<cfelseif TargetStandard neq "">				
					<cfset tgt = TargetStandard>					
				<cfelseif TargetItem neq "">							
					<cfset tgt = TargetItem>						
				<cfelse>				
					<cfset tgt = "0">									
				</cfif>		
				
				<cfif measurement neq "">				
										
					<cfif getMetric.Measurement eq "Increment">
					
					    <cfset operations = operations + measurement>
						<cfset operationsopening = 0>
						<cfset operationsclosing = 0>
						<cfset plantarget = plantarget + (tgt * measurement)>		
					
					<cfelse>
					
						<!--- cumulative --->																				
												
						<cfset operations = operations + (measurement-prior)>
						
						<!---		
						<cfoutput>#assetid#-#measurement#-#prior#:#operations#<br></cfoutput>
						--->
												
						<cfset operationsopening = prior>
						<cfset operationsclosing = measurement>
						<!--- we define the budget based on each generator --->
						
						<cfset plantarget = plantarget + (tgt * (measurement-prior))>		
						
						<!---
											
						<cfoutput>--#actiondate#==#prior#==#tgt#==#measurement#==#operations#<br></cfoutput>
						
						--->
						
											
					</cfif>
					
					<cfset operationOpeningT  = operationopeningT+operationsOpening>
					<cfset operationClosingT  = operationclosingT+operationsClosing>
					<cfset prior = measurement>
					
				</cfif>
								
			</cfloop>	
			
			<!--- cumulative correction --->
			<cfif getMetric.Measurement eq "Cumulative">
				<cfset operationsopening= vInitialCumulative>
			</cfif>
							
		</cfloop>	
		
		<cfset vEFF = dateAdd('d', -1, EFF)>
		
		<cfquery name="getOperationAVG" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 	SELECT 		AVG(CONVERT(FLOAT,OperationMode)) as OperationMode
				FROM        AssetItemAction A INNER JOIN AssetItem AI ON A.AssetId = AI.AssetId
				WHERE       (A.AssetId = '#assetid#' OR AI.ParentAssetId = '#assetid#')
			   	AND         A.ActionDate    >= #vEFF#
			   	AND         A.ActionDate    <= #EXP#
			   	AND         A.ActionType     = 'Standard'   <!--- we exclude detail sub measurements --->
			   	AND         A.ActionCategory = 'Operations' <!--- hardcoded --->	
				
		</cfquery>
						
		<!--- final calculation of the target consumption for this period --->	
		
		<cfset target.operations        = operations>
		<cfset target.operationsopening = operationopeningT>
		<cfset target.operationsclosing = operationclosingT>
		
		<cfset target.avgOperationMode = getOperationAVG.OperationMode>
		
		<cfif operations neq "0">
			
			<!--- define the AVERAGE weighted target consumption for period --->						
			<cfset target.targetRatio    = round((plantarget/operations)*100)/100>
									
		    <!---
			<cfoutput>
			#plantarget#==#operations#==#target.targetRatio#
			</cfoutput>
			--->			
		
		<cfelse>
		
			<cfset target.targetRatio     = "">
		
		</cfif>
						
			<!--- pending to tune to pass this
				<cfset target.targetDirection = getRatio.targetDirection>
				<cfset target.targetRange     = getRatio.targetRange>
			--->
										
		<cfreturn target>
			 
	</cffunction>	
		
</cfcomponent>
