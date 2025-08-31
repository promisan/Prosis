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
<cfparam name="url.itemLocationId" 				default="">
<cfparam name="url.showLocationDescription" 	default="1">
<cfparam name="url.fontSize" 					default="10">
<cfparam name="url.showTooltip" 				default="0">
<cfparam name="url.highlightTank" 				default="1">
<cfparam name="url.viewPort"					default="350">
 
<cfset vLocationId = '00000000-0000-0000-0000-000000000000'>

<cfif url.locationId neq "">
	<cfset vLocationId = url.locationId>
</cfif>

<cfquery name="WarehouseLocationList" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	WL.*, 
				IWL.ItemNo,
				IWL.UoM,
				IWL.ItemLocationId,
				IWL.HighestStock,
				IWL.MaximumStock,
				IWL.MinimumStock,
				
				ISNULL((
					SELECT 	SUM(TransactionQuantity)
					FROM   	ItemTransaction
					WHERE  	Warehouse      = IWL.Warehouse
					AND		Location       = IWL.Location
					AND		ItemNo         = IWL.ItemNo
					AND		TransactionUoM = IWL.UoM
				),0) OnHand,
				
				(SELECT ISNULL(COUNT(*),0) FROM ItemWarehouseLocationStrapping WHERE Warehouse = IWL.Warehouse AND Location = IWL.Location AND ItemNo = IWL.ItemNo AND UoM = IWL.UoM) AS Strapping,
				(SELECT ItemDescription    FROM Item WHERE ItemNo = IWL.ItemNo) as ItemDescription,
				(SELECT ItemPrecision      FROM Item WHERE ItemNo = IWL.ItemNo) as ItemPrecision,
				(SELECT UoMDescription     FROM ItemUoM WHERE ItemNo = IWL.ItemNo AND UoM = IWL.UoM) as UoMDescription
				
		FROM	WarehouseLocation WL LEFT OUTER JOIN ItemWarehouseLocation IWL ON WL.Warehouse = IWL.Warehouse AND WL.Location = IWL.Location
		
		WHERE	WL.Warehouse       = '#url.warehouse#'
		AND		WL.LocationClass   = '#url.locationClass#'
		AND		WL.LocationId <cfif url.locationId neq ""> = '#vLocationId#'<cfelse> IS NULL</cfif>
		AND		IWL.ItemNo         = '#url.itemno#'
		AND		IWL.UoM            = '#url.uom#'
		<cfif url.itemLocationId neq "">
		AND		IWL.itemLocationId = '#url.itemLocationId#'
		</cfif>
		
		ORDER BY WL.Warehouse, WL.LocationClass, WL.Location 
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" align="center" height="100%">
	
	<tr>
		<td valign="top">
			<table width="100%" align="center" height="100%">
				
				<tr>
					<td>
						<table width="100%" cellspacing="0" cellpadding="0" align="center" height="100%" class="formpadding">
							<tr>
							
							<cfif WarehouseLocationList.recordCount eq 0 >
								<td align="center" class="label">
									<cf_tableround>
										<b>[No Tanks are configured]</b>
									</cf_tableround>
								</td>
							</cfif>
							
							<cfset NumberOfColumns = 3>
							<cfset cntTanks        = 1>
							<cfset cntColumns      = 0>
							
							<cfoutput query="WarehouseLocationList">
							
								<td id="tank_id_#warehouse#_#location#_#url.itemno#_#url.uom#"
									style="padding:2px;" 
									width="#100/NumberOfColumns#%"
									valign="top">
									
									<cfset vTankTRId = "">
									<cfset vMouseOut = "">
									<cfset vMouseOver = "">
												
									<cfif url.highlightTank eq 1>
										<cfset vTankTRId  = "tankTR_id_#warehouse#_#location#_#url.itemno#_#url.uom#">
										<cfset vMouseOut  = "selectrow('id_#warehouse#_#location#_#url.itemno#_#url.uom#', 0, 'E9F3FC', '8EC6EE', 'C0C0C0');">
										<cfset vMouseOver = "selectrow('id_#warehouse#_#location#_#url.itemno#_#url.uom#', 1, 'E9F3FC', '8EC6EE', 'C0C0C0');">
									</cfif>																		
										
									<cf_tableround 
											totalHeight="100%" 
											mode="gradientColor" 
											color="silver" 
											id="#vTankTRId#"
											onmouseout="#vMouseOut#" 
											onmouseover="#vMouseOver#">																																						
													
											<cf_StockTank
											  warehouse                = "#warehouse#"
											  location                 = "#location#"
											  itemno                   = "#itemno#"
											  uom                      = "#uom#"
											  showtank                 = "1"
											  showstrap                = "0"			
											  showLocationDescription  = "#url.showLocationDescription#"											  
											  fontsize                 = "#url.fontsize#"
											  tankId                   = "itank_#url.Warehouse#_#url.LocationClass#_#url.itemno#_#url.uom#_#cntTanks#"														 											 
											  viewPort                 = "#url.viewPort#">														
																														
									</cf_tableround>
					
								</td>
								
								<cfset cntTanks = cntTanks + 1>
								<cfset cntColumns = cntColumns + 1>
								
								<cfif cntColumns gte NumberOfColumns>
									</tr>
									<tr>
									<cfset cntColumns = 0>
								</cfif>
								
							</cfoutput>
							
							</tr>
						</table>
					</td>
				</tr>
			</table>
			
		</td>
	</tr>
	
</table>
