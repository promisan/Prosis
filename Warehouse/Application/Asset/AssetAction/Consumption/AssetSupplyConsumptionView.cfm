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
<cfparam name="url.action"  default="Operations">
<cfparam name="url.mode"    default="chart">
<cfparam name="url.year"    default="#DateFormat(now(),'yyyy')#">
<cfparam name="url.height"   default="0">
<cfparam name="url.width"    default="0">

<!--- get the fuel issues --->
<cfinclude template="../Logging/AssetActionFunctions.cfm">

<cfoutput>

<table width="99%" align="center" height="100%"><tr><td style="padding-bottom:6px">

<cf_divscroll>

<table width="99%" align="center" cellspacing="0" cellpadding="0">

<!--- filter only valid supplies item for this asset item master like diesel, 
   LATER we need to split this even more by Oil (and maybe Lubricante) if these are kept --->

<cfinclude template="GraphConsumptionPrepare.cfm">

<cfif Consumption.recordCount eq 0>

	<tr><td height="10"></td></tr>
	<tr>
		<td colspan="2" align="center" class="labelit">
			<font color="808080">
			<b><cf_tl id="No supplies defined for this asset"></b>
			</font>
			<br>
			<br>
			<a href="javascript: gotoConsumption();" title="Click to define supplies for this asset">
				<font color="0080FF">
					[<cf_tl id="Click here to define supplies">]
				</font>
			</a>
		</td>
	</tr>
	
</cfif>
	
<cfquery name="Years" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT   DISTINCT Datepart(year,I.TransactionDate) as Year
     FROM     ItemTransaction I 
	 
	 WHERE    ( 
		 
	 		  I.AssetId    = '#url.assetid#'	
		 
	 		  OR 
		 
	          I.AssetId IN (SELECT AssetId 
	                        FROM   AssetItem 
					        WHERE  ParentAssetid = '#URL.Assetid#') 
								
			  )			
	
	 AND      I.TransactionType = '2'
	 AND      
	 ( EXISTS
		(
		 	SELECT 'X'
			FROM AssetItemSupply S
			WHERE 
			(
				S.SupplyItemNo         = I.ItemNo
				AND   S.SupplyItemUoM  = I.TransactionUoM
				AND   S.AssetId        = I.AssetId
			)
		 )
		 OR    
		 EXISTS
		 (
		 	SELECT 'X'
			FROM ItemSupply S
			WHERE 
			(
				S.SupplyItemNo = I.ItemNo
				AND   S.SupplyItemUoM = I.TransactionUoM
				AND   S.ItemNo  = '#get.itemNo#' 
			)
		 )
	 )
	 ORDER BY Datepart(year,I.TransactionDate)
</cfquery>
		
<cfif url.year eq "">
	 <cfset url.year = years.Year>
</cfif>

<tr><td colspan="2">

<table width="100%">
<tr>

<cfif Years.recordcount eq "0">

<td style="padding-left:5px" colspan="2"><font face="Calibri" size="3" color="808080"><i>[No issuances]</i></td>

<cfelse>

<td style="padding-left:5px" style="padding-left:5px">

	<table>
			<tr>
			
			<td style="padding-left:5px;padding-right:3px" class="labelit">Calendar&nbsp;Year:</td>

			<td>
		     <cfoutput>
						
				<select name="year" id="year" class="regularxl"      
					<cfif URL.mode eq "consumption">
					    onChange="window.location='AssetView.cfm?assetId=#url.assetId#&mode=#URL.mode#&scale='+$('##scale').val()+'&year='+this.value+'&month='">
					<cfelse>
					    onChange="ColdFusion.navigate('Consumption/AssetSupplyConsumptionView.cfm?assetId=#url.assetId#&height=#url.height#&width=#url.width#&mode='+document.getElementById('viewmodeselect').value+'&scale='+$('##scale').val()+'&year='+this.value+'&month=','contentbox1');">
					</cfif>	
					<cfloop query  = "years">
						<option value="#Year#" <cfif Years.year eq URL.Year>selected</cfif>>#Year#</option>
					</cfloop>
				</select>	
				
			</cfoutput>	
			
		   </td>
		   
		   </tr>
		   
	</table>	   	
	
</td>		

</cfif>
		
	<td style="padding-left:5px" align="right" style="padding-right:1px">
		<table>
			<tr>
						
			<cfquery name="qCategory" dbtype="query">
				SELECT DISTINCT Category
				FROM Consumption
			</cfquery>			

			<cfloop query="qCategory">
				
				<cfif currentrow eq 1>
					<cfset vClass = "highlight">
					<cfset URL.category = Category>
				<cfelse>
				   <cfset vClass = "blue">					
				</cfif>
				
				<cfquery name="getCategory" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					 SELECT  *	
				     FROM    Ref_Category
					 WHERE   Category = '#Category#'
				</cfquery>
				
				<!--- define the relevant metrics for this category --->
				
				<td align = "center" class="labelmedium" style="padding-right:4px">
					Select #getCategory.Description# consumption in:
				</td>
				
				<cfquery name="getMetrics" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
					  SELECT   A.Metric, R.Measurement
					  FROM     Ref_AssetActionMetric A INNER JOIN
					           Ref_Metric R ON A.Metric = R.Code  
					  WHERE    A.ActionCategory = '#url.action#' 
					  AND      A.Category       = '#get.Category#'	
					  AND      R.Operational    = 1
					  AND      R.Code IN (SELECT DISTINCT AIAM.Metric
										  FROM   AssetItemAction AS AIA INNER JOIN
				                                 AssetItemActionMetric AS AIAM ON AIA.AssetActionId = AIAM.AssetActionId
										  WHERE  AIA.AssetId IN
						                          (SELECT     AssetId
                        						   FROM          AssetItem
						                           WHERE      AssetId = '#URL.Assetid#' OR ParentAssetId = '#URL.Assetid#')
										 )		   
					ORDER BY R.Code DESC
				</cfquery>	
								
				<cfset row = currentrow>
				
				<!--- select for the metrics under this category --->
				
					<cfloop query="getMetrics">
						<cfif CheckMetric(url.assetid, Metric)>
						
							<cfif Years.recordcount eq "0">
					
							<td style   = "border:dotted gray 1px;height:22;width:90" 
							    align   = "center" 								
							    id      = "c_#row#_#currentrow-1#">
								#Metric#
							</td>
					
							<cfelse>
									
							<td class = "<cfif currentrow eq '1'>#vClass#</cfif>" 
							  style   = "cursor:pointer;border:dotted gray 1px;height:22;width:90" 
							  align   = "center" 
							  id      = "c_#row#_#currentrow-1#" 
							  onclick = "getcategory('#row#_#currentrow-1#','#URL.assetid#','#Category#','#metric#','#URL.action#','#qCategory.recordcount-1#','#qCategory.recordcount#')">
								#Metric#
							</td>
						
							</cfif>
						</cfif>	
				
					</cfloop>							
							
					<td width="5%"></td>		
				</cfloop>	
			
			
			</tr>
		</table>
	
	</td>
	
	<td align="right" width="50%">
	
	<table cellspacing="0" cellpadding="0" class="formpadding" style="border:0px solid silver;border-radius:4px">
	    <tr>
		<td height="24" class="labelit" style="padding-top:8px;padding-right:5px">Legend:</td>	
		<td style="border:1px solid gray" class="labelit" width="90" align="center" bgcolor="00FF00"><font color="black">Good</td>
		<td style="border:1px solid gray" class="labelit" width="90" align="center" bgcolor="yellow">Within Range</td>	
		<td style="border:1px solid gray" class="labelit" width="90" align="center" bgcolor="red"><font color="FFFFFF">Exceeds Target</td>
		<td style="border:1px solid gray" class="labelit" width="90" align="center" bgcolor="black"><font color="FFFFFF">Investigate</td>
		</tr>	
	</table>
	
	</td>
</tr>
</table>	

</td></tr>	

<tr><td style="height:5px"></td></tr>
<tr>
<td id="ditems" name="ditems" style="border:1px solid silver;border-radius:5px">
    <cfset url.metric = getMetrics.Metric>
	<cfinclude template="AssetSupplyConsumptionCategory.cfm">
</td>
</tr>

</table>

</cf_divscroll>

</cfoutput>

</td></tr>
</table>



  		


