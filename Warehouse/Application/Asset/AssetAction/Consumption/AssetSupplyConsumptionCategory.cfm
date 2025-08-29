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
<cfparam name = "url.year" default="">
<cfparam name = "url.month" default="">

<cfif NOT ISDEFINED("qConsumptionData")>
	<cfinclude template="GraphConsumptionPrepare.cfm">
</cfif>

<cfquery name="qConsumptionData" dbtype="query">
	SELECT * 
	FROM  Consumption
	WHERE Category = '#URL.category#'
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0">

<cfoutput>

<cfloop query="qConsumptionData">  

	<!--- get the issuances for this item --->	
		
	<cfquery name="Issues" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		 SELECT   CONVERT(VARCHAR(10),I.TransactionDate,126) as TransactionDate,
		          SUM(I.TransactionQuantityBase) as TransactionQuantityBase,	
				  count(*) as Issues
								  
		 FROM     ItemTransaction AS I INNER JOIN                  
                  AssetItem ON I.AssetId = AssetItem.AssetId 
		  
	     WHERE    ( 
		 
		 		  I.AssetId    = '#url.assetid#'	
		 
		 		  OR 
		 
		          I.AssetId IN (SELECT AssetId 
		                        FROM   AssetItem 
						        WHERE  ParentAssetid = '#URL.Assetid#') 
								
				  )					
								
		 AND      I.TransactionType = '2'
		 
		 <!--- only stock issues that are part of the supplies needed for this asset --->
		 
		 AND      I.ItemNo          = '#SupplyItemNo#'
		 AND      I.TransactionUoM  = '#SupplyItemUoM#'
		 
		 <cfif URL.Month neq "">
			 AND  Datepart(month,I.TransactionDate) = '#URL.Month#'
		 </cfif>
		 
		 <cfif URL.Year neq "">
			 AND  Datepart(year,I.TransactionDate) = '#URL.Year#'
		 </cfif>
		 
		 GROUP BY CONVERT(VARCHAR(10),I.TransactionDate,126)
		 ORDER BY CONVERT(VARCHAR(10),I.TransactionDate,126) 
		 
		 
	</cfquery>	

	<cfset sItemNo = SupplyItemNo>
	<cfset sUoM    = SupplyItemUoM>

	<cfquery name="Years" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		 SELECT    DISTINCT Datepart(year,I.TransactionDate) as Year
	     FROM      ItemTransaction I 
		 WHERE     ( 
		 
		 		   I.AssetId    = '#url.assetid#'	
		 
		 		   OR 
		 
		           I.AssetId IN (SELECT AssetId 
		                         FROM   AssetItem 
						         WHERE  ParentAssetid = '#URL.Assetid#') 
								
				   )		
				   
		 AND       I.TransactionType = '2'
		 AND       I.ItemNo          = '#SupplyItemNo#'
		 AND       I.TransactionUoM  = '#SupplyItemUoM#'
		 ORDER BY  Datepart(year,I.TransactionDate)
		 
	</cfquery>
		
	<!--- get the the relevant metrics for this asset category --->
	
	<cfquery name="getMetrics" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		  SELECT   A.Metric, R.Measurement, R.MeasurementUoM
		  FROM     Ref_AssetActionMetric A INNER JOIN
		           Ref_Metric R ON A.Metric = R.Code  
		  WHERE    A.ActionCategory = '#url.action#' 
		  AND      A.Category       = '#get.Category#'	
		  <!--- added to limit the selection --->
		  AND      A.Metric         = '#url.metric#'
		  AND      R.Operational = 1
		
	</cfquery>	
		
	<tr class="line">
		<td colspan="2" class="top4n" style="height:30px;padding-left:10px">	
		<font face="Calibri" size="4"><b>#ItemDescription# (#UOMDescription#)</font>
		</td>
   </tr>
	
    <!---		
	<cfloop query="getMetrics">
	--->
	
		   <cfset opening = "">
		   <cfset closing = "">
				
			<cfquery name="getTarget" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    AssetItemSupplyMetric
				WHERE   AssetId           = '#url.assetid#'
				AND     SupplyItemNo      = '#sItemNo#'
				AND     SupplyItemUoM     = '#sUoM#'
				AND     Metric            = '#Metric#' 	
		    </cfquery>	
			
						
			<cfif getTarget.recordCount eq 0 and isDefined("qConsumptionData.ItemNo")>
			
				<!--- we take it from the master item instead --->
			
				<cfquery name="getTarget" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  *
						FROM    ItemSupplyMetric
						WHERE   ItemNo            = '#qConsumptionData.ItemNo#'
						AND     SupplyItemNo      = '#sItemNo#'
						AND     SupplyItemUoM     = '#sUoM#'
						AND     Metric            = '#Metric#' 		
				    </cfquery>
					
			</cfif>	
			
			<cfset myar = ArrayNew(2)>
			
			<tr>
			
			<td valign="top" colspan="2" style="padding:10px">	
									
			<table width= "100%" align="center" style="formpadding">
			
			   <cfif years.recordcount gte "1">
			   
					<tr>		
							
						<td valign="top" width="200" style="border-radius:5px;border:1px solid silver">	
																		
							<cfform id = "fConsumption" onsubmit = "return false;">
							
							<table cellspacing="0" cellpadding="0">					
								<tr><td><cfinclude template="AssetSupplyConsumptionViewData.cfm"></td></tr>						
							</table>	
							
							</cfform>
								
						</td>	
							
						<td>&nbsp;</td>					
										
						<td align = "center" valign="top" style="border-radius:5px;border:1px solid silver">						
							<cfinclude template="AssetSupplyConsumptionViewPresentation.cfm">						 					
						</td>
					
					</tr>	
				
				</cfif>
				
			</table>
									
			</td>
			
	<!---						
	</cfloop>
	--->
			
</cfloop>

</cfoutput>

</table>