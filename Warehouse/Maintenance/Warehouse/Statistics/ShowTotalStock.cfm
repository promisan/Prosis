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
<cfparam name="url.viewPort" 				default="300">
<cfparam name="url.graphColumns"			default="2">
<cfparam name="url.showTooltip"				default="1">
<cfparam name="url.showTotalGraphs"			default="1">
<cfparam name="url.fontSize" 				default="10">

<cftransaction isolation="read_uncommitted">

<cfquery name="wl" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	IWL.Warehouse,
				IWL.ItemNo,
				IWL.UoM,
				I.ItemDescription,
				I.ItemPrecision,
				U.UoMDescription,
				I.ItemMaster,
				
				ISNULL((
					SELECT 	SUM(TransactionQuantity)
					FROM   	ItemTransaction 
					WHERE  	Warehouse      = IWL.Warehouse
					AND		ItemNo         = IWL.ItemNo
					AND		TransactionUoM = IWL.UoM
				),0) OnHand,
				
				SUM(IWL.HighestStock) as HighestStock,
				SUM(IWL.MaximumStock) as MaximumStock,
				SUM(IWL.MinimumStock) as MinimumStock
		FROM	ItemWarehouseLocation IWL 
				INNER JOIN WarehouseLocation WL ON WL.Warehouse = IWL.Warehouse AND WL.Location = IWL.Location
				INNER JOIN Item I     	         ON IWL.ItemNo = I.ItemNo
				INNER JOIN ItemUoM U             ON IWL.ItemNo = U.ItemNo AND IWL.UoM = U.UoM				
		WHERE	WL.Warehouse = '#url.warehouse#'
		GROUP BY 
				IWL.Warehouse,
				IWL.ItemNo,
				IWL.UoM,
				I.ItemDescription,
				I.ItemPrecision,
				U.UoMDescription,
				I.ItemMaster
		ORDER BY I.ItemDescription, IWL.UoM
			
</cfquery>

</cftransaction>

<cfset locNumberOfColumns = url.graphColumns>

<table width="100%" align="center">

	<!--- Total Stock on hand in text --->
	<tr>
		<td align="center" width="100%" class="navigation_table" colspan="<cfoutput>#locNumberOfColumns#</cfoutput>">
			
					<table width="100%" align="center" class="clsPrintable">
						<tr>
							<td class="labelsmall"  width="25%" height="20"><cf_tl id="Item"></td>
							<td class="labelsmall"  width="12%"><cf_tl id="Unit of Measure"></td>
							<td class="labelsmall"  width="12%" align="right"><cf_tl id="Official Capacity"></td>
							<td class="labelsmall"  width="12%" align="right"><cf_tl id="Actual Capacity"></td>
							<td class="labelsmall"  width="12%" align="right"><cf_tl id="Minimum Stock"></td>
							<td class="labelsmall"  width="12%" align="right"><cf_tl id="On Hand"></td>
							<td class="labelsmall"  width="10%" align="center"><cf_tl id="Status"></td>
						</tr>
						
						<tr><td colspan="7" class="line"></td></tr>
						
						<cfoutput query="wl">
							
							<cf_precision number = ItemPrecision> <!--- returns pformat --->
							
							<cfset vColor1 = "47D51E"> <!--- green = ok --->
							<cfset vStatus = "OK">
							<cfset vStatus2 = "OK">
							<cfset vStatusClass = "clsGreen">
							<cfif OnHand lte MinimumStock>
								<cfset vColor1 = "E1686B"> <!--- red = under minimum --->
								<cfset vStatus = "Under Minimum">
								<cfset vStatus2 = "Check">
								<cfset vStatusClass = "clsRed">
							</cfif>
							<!--- Pending:  Define a condition to show a listing with lights for totals --->
							<tr class="labelit navigation_row" bgcolor="">
								<td width="35%" height="15">#ItemDescription#</td>
								<td width="20%">#UoMDescription#</td>
								<td width="10%" align="right">#lsNumberFormat(HighestStock,pformat)#</td>
								<td width="10%" align="right">#lsNumberFormat(MaximumStock,pformat)#</td>
								<td width="10%" align="right">#lsNumberFormat(MinimumStock,pformat)#</td>
								<td width="10%" align="right">#lsNumberFormat(OnHand,pformat)#</td>
								<td width="5%" align="center" style="padding-left:4px" valign="middle" title="#vStatus#">
									<table align="center" >
										<tr>
											<td class="vStatusClass" valign="middle" align="center" height="10" width="10" 
											   style="font-size:9px; font-weight:bold; background-color:###vColor1#; color:###vColor1#;">
												#vStatus2#
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</cfoutput>
					</table>
			
		</td>
	</tr>

</table>