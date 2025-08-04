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

<cfset vField = "ItemNo">
<cfset vPrefix = "">
<cfset vColumns = 7>

<cfif url.type eq "AssetItem">
	<cfset vField = "AssetId">
	<cfset vPrefix = "Asset">
	<cfset vColumns = 8>
</cfif>


<cfquery name="Supply" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	S.*,
			(SELECT ItemDescription FROM Item WHERE ItemNo = S.SupplyItemNo) as SupplyDescription,
			(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = S.SupplyItemNo AND UoM = S.SupplyItemUoM) as UoMDescription
	FROM 	#vPrefix#ItemSupply S
	WHERE 	S.#vField# = '#URL.ID#'
	ORDER BY SupplyItemNo
</cfquery>		

<table width="98%" cellspacing="0" cellpadding="0" class="formpadding">

<cfoutput>
<tr class="line labelmedium2">
    <td width="10%" align="center"><a href="javascript:supplyedit('#URL.ID#','','')">[<cf_tl id="New Supply">]</a></td>	
	<td><cf_tl id="Product"></td>	
	<td width="10%"><cf_tl id="UoM"></td>
	<td width="10%" align="center"><cf_tl id="Capacity"></td>
	<td width="10%" align="center"><cf_tl id="Daily Usage"></td>
	<cfif url.type eq "AssetItem"><td><cf_tl id="Supplied through"></td></cfif>
	<td width="15%"><cf_tl id="Officer"></td>
	<td width="15%"><cf_tl id="Created"></td>
</tr>

<cfif Supply.recordCount eq 0>

	<cfif url.type eq "AssetItem">
	
		<!--- <cfinclude template="AssetItemSupplyDefinition.cfm">
		
		<cfquery name="Supply" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	S.*,
					(SELECT ItemDescription FROM Item WHERE ItemNo = S.SupplyItemNo) as SupplyDescription,
					(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = S.SupplyItemNo AND UoM = S.SupplyItemUoM) as UoMDescription
			FROM 	#vPrefix#ItemSupply S
			WHERE 	S.#vField# = '#URL.ID#'
			ORDER BY SupplyItemNo
		</cfquery> --->	
		
	</cfif>
	
	<cfif Supply.recordCount eq 0>
		<tr><td colspan="#vColumns#" align="center" class="labelit"><font color="red"><cf_tl id="No supplies recorded"></font></td></tr>
		<tr><td height="5"></td></tr>
		<tr><td colspan="#vColumns#" class="line"></td></tr>
	</cfif>
	
</cfif>

</cfoutput>

<cfoutput query="Supply">

<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="" class="labelmedium" style="padding-top:3px">
  <td align="center" style="padding-top:3px;">  
    
	<table cellspacing="0" cellpadding="0" class="formpadding">
	   <tr>
	     <td style="padding-right:3px">
		    <cf_img icon="edit" onclick="supplyedit('#URL.ID#','#SupplyItemNo#', '#SupplyItemUoM#');">
		 </td>
	     <td>
		    <cf_img icon="delete" onclick="if (confirm('Do you want to remove this supply item ?')) {supplydelete('#URL.ID#','#SupplyItemNo#', '#SupplyItemUoM#')}">	  
		  </td>
	   </tr>
    </table>
  </td>
  <td>#SupplyDescription#</b></td>
  <td>#UoMDescription#</td>
  <td align="center">#lsNumberFormat(SupplyCapacity,",")#</td>
  <td align="center">#lsNumberFormat(SupplyDailyUsage,",")#</td>
  <cfif url.type eq "AssetItem">
  <td>
  	<cfquery name="warehouse" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	*,
				(SELECT WarehouseName FROM Warehouse WHERE Warehouse = S.Warehouse) as WarehouseName
		FROM 	AssetItemSupplyWarehouse S
		WHERE 	AssetId = '#AssetId#'
		AND 	SupplyItemNo = '#SupplyItemNo#'
		AND		SupplyItemUoM = '#SupplyItemUom#'
	</cfquery>
	
	<cfset whList = "">
	<cfset whList = valueList(warehouse.WarehouseName)>
	<cfset whList = replace(whList,",", ", ", "ALL")>
	
	<cfif trim(whList) eq "">
		<cfset whList = "[Any warehouse]">
	</cfif>
	#whList#
  </td>
  </cfif>
  <td>#OfficerFirstName# #OfficerLastName#</td>
  <td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>	  
</tr>

<cfquery name="Metric" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM	#vPrefix#ItemSupplyMetric 
	WHERE	#vField# = '#URL.ID#'
	AND 	SupplyItemNo = '#SupplyItemNo#' 
	AND 	SupplyItemUoM = '#SupplyItemUoM#'
</cfquery>

<cfif Metric.recordCount gt 0>
<tr>					
	<td align="right"></td>
	<td colspan="#vColumns#">
		<table border="0">
			<tr class="labelmedium">
			<td><cf_tl id="Standard Consumption">:</td>
			<cfloop query="Metric">
				<td valign="bottom"><cfif Metric.currentrow neq 1>-</cfif></td>
				<td valign="bottom" class="labelit">
					<p style="background-color:E1EDFF; margin-left: <cfif Metric.currentrow neq 1>3<cfelse>1</cfif>px;">
						&nbsp; #lsNumberFormat(TargetRatio * Metric.MetricQuantity, ",.__")# #Supply.UoMDescription# <b>/</b> #Metric.MetricQuantity# #Metric#
						<cfif lcase(TargetDirection) eq "up">
							<cfset imgSource = "arrow-up.gif">
						<cfelseif lcase(TargetDirection) eq "down">
							<cfset imgSource = "arrow-down.gif">
						</cfif>
						<img src="#SESSION.root#/Images/#imgSource#" 
						    alt="#TargetDirection#" height="14" border="0" align="absmiddle">(#TargetRange#) &nbsp;
					</p>
				</td>
			</cfloop>
			</tr>
		</table>
	</td>		
</tr>
</cfif>

<cfif url.type eq "Item">

	<cfquery name="MetricTargetLocations" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT M.Mission, M.Location, 
				ISNULL(L.LocationName,'Default') as LocationName
		FROM	ItemSupplyMetricTarget M
				LEFT OUTER JOIN Location L
					ON M.Location = L.Location
		WHERE	M.ItemNo = '#URL.ID#'
		AND 	M.SupplyItemNo = '#SupplyItemNo#' 
		AND 	M.SupplyItemUoM = '#SupplyItemUoM#'
		ORDER BY M.Mission, M.Location
	</cfquery>

</cfif>

<cfif url.type eq "AssetItem">

	<cfquery name="MetricTargetLocations" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT M.DateEffective
		FROM	AssetItemSupplyMetricTarget M
		WHERE	M.AssetId = '#URL.ID#'
		AND 	M.SupplyItemNo = '#SupplyItemNo#' 
		AND 	M.SupplyItemUoM = '#SupplyItemUoM#'
		ORDER BY M.DateEffective DESC
	</cfquery>

</cfif>
	
	<cfquery name="MetricTarget" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	MT.*,
				(
					SELECT 	MetricQuantity 
					FROM 	#vPrefix#ItemSupplyMetric 
					WHERE 	#vField# = MT.#vField# 
					AND 	SupplyItemNo = MT.SupplyItemNo 
					AND 	SupplyItemUoM = MT.SupplyItemUoM 
					AND 	Metric = MT.Metric
				) as MetricQuantity,
				(
					SELECT 	Description
					FROM	Ref_Metric
					WHERE 	Code = MT.Metric
				) as MetricDescription
		FROM	#vPrefix#ItemSupplyMetricTarget MT
		WHERE	MT.#vField# = '#URL.ID#'
		AND 	MT.SupplyItemNo = '#SupplyItemNo#' 
		AND 	MT.SupplyItemUoM = '#SupplyItemUoM#'
	</cfquery>
	
	<cfif MetricTarget.recordCount gt 0>
	<tr>			
		<td align="right"></td>
		<td colspan="#vColumns#">
			<table width="100%" border="0">
				<tr style="color:808080;font-weight: bold;">
					<cfif url.type eq "Item">
						<td class="labelit"><cf_tl id="Mission"></td>
						<td class="labelit"><cf_tl id="Location"></td>
					</cfif>
					<cfif url.type eq "AssetItem">
						<td colspan="2" class="labelit"><cf_tl id="Effective Date"></td>
					</cfif>
					<td class="labelit">#Supply.UoMDescription# per</td>
					<cfset operationModeList = "0,25,50,75,100">
					<cfloop index="opMode" list="#operationModeList#">
					<td align="center" class="labelit">#opMode#%</td>
					</cfloop>
				</tr>
				<tr><td class="line" colspan="#vColumns+2#"></td></tr>
				
				<cfset priorMission = "">
				
				<cfloop query="MetricTargetLocations">
					<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="" class="labelmedium2">
					
						<cfquery name="qMetricTarget" dbtype="query">
							SELECT 	*
							FROM	MetricTarget
							
							<cfif url.type eq "Item">
							WHERE	Mission = '#MetricTargetLocations.Mission#'
							AND		Location <cfif trim(MetricTargetLocations.Location) eq "">IS NULL<cfelse>= '#MetricTargetLocations.Location#'</cfif>
							ORDER BY Metric, OperationMode
							</cfif>
							
							<cfif url.type eq "AssetItem">
							WHERE	DateEffective = <cfqueryPARAM value = "#MetricTargetLocations.DateEffective#" CFSQLType = "CF_SQL_TIMESTAMP"> 
							ORDER BY DateEffective DESC
							</cfif>
						</cfquery>
						
						<cfif url.type eq "Item">
						<td><cfif priorMission neq MetricTargetLocations.Mission>#MetricTargetLocations.Mission#</cfif></td>
						<td valign="bottom">#MetricTargetLocations.LocationName#</td>
						</cfif>
						
						<cfif url.type eq "AssetItem">
							<td colspan="2">#dateFormat(MetricTargetLocations.DateEffective,'#CLIENT.DateFormatShow#')#</td>
						</cfif>
						
						<cfset priorMetric = qMetricTarget.Metric>
						<cfset priorMetricQuantity = qMetricTarget.MetricQuantity>
						<cfset priorMetricDescription = qMetricTarget.MetricDescription>
						<cfset cntMetricTarget = 1>
						
						<td>#qMetricTarget.MetricQuantity#&nbsp;&nbsp;#qMetricTarget.MetricDescription#</td>
						
						<cfloop query="qMetricTarget">
							<cfif priorMetric neq Metric>
								<cfset cntMetricTarget = 1>
								</tr>
								<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="">
								<td></td>
								<td></td>
								<td class="labelit">#qMetricTarget.MetricQuantity#&nbsp;&nbsp;#qMetricTarget.MetricDescription#</td>
							</cfif>
							
							<!--- <td valign="bottom" align="center"><cfif cntMetricTarget neq 1>-</cfif></td> --->
							<td valign="bottom" align="center" title="[#operationMode#%] :  #lsNumberFormat(TargetRatio * MetricQuantity, ',.__')# #Supply.UoMDescription# / #MetricQuantity# #MetricDescription#">
								<p style="background-color:E1EDFF; margin-left: <cfif Metric.currentrow neq 1>3<cfelse>1</cfif>px;">
									&nbsp; #lsNumberFormat(TargetRatio * MetricQuantity, ",.__")#&nbsp;
									<cfif lcase(TargetDirection) eq "up">
										<cfset imgSource = "arrow-up.gif">
									<cfelseif lcase(TargetDirection) eq "down">
										<cfset imgSource = "arrow-down.gif">
									</cfif>
									<img src="#SESSION.root#/Images/#imgSource#" alt="#TargetDirection#" height="14" border="0" align="absmiddle">(#TargetRange#)
								</p>
							</td>
							
							<cfset priorMetric = Metric>
							<cfset priorMetricQuantity = MetricQuantity>
							<cfset priorMetricDescription = MetricDescription>
							<cfset cntMetricTarget = cntMetricTarget + 1>
							
						</cfloop>
						
					</tr>
					<tr><td colspan="#vColumns+2#" style="border-bottom:1px solid ##E4E4E4;"></td></tr>
					<tr><td height="5"></td></tr>
					<cfif url.type eq "Item">
					<cfset priorMission = MetricTargetLocations.Mission>
					</cfif>
				</cfloop>
				
			</table>
		</td>		
	</tr>
	</cfif>

<tr><td colspan="#vColumns#" class="line"></td></tr>

</cfoutput>
</table>