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
<cfif url.SelectionDate neq "">
     <cfset dateValue = "">
	 <cf_DateConvert Value="#url.SelectionDate#">
	 <cfset dte = dateValue>	
</cfif>	

<cfquery name="SearchResult"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  P.ReceiptNo, 
				P.Currency,
				P.DeliveryDateEnd,
				P.WarehouseItemNo as ItemNo,
				ISNULL(I.ItemDescription,'[Not defined]') as ItemDescription,
				P.WarehouseUoM as UoM,
				U.UoMDescription,
				AVG(P.ReceiptPrice) as ReceiptPrice
		FROM    Purchase.dbo.PurchaseLineReceipt P
				LEFT OUTER JOIN Item I
					ON P.WarehouseItemNo = I.ItemNo
				LEFT OUTER JOIN ItemUoM U
					ON P.WarehouseItemNo = U.ItemNo
					AND	P.WarehouseUoM = U.UoM
		WHERE	P.Warehouse = '#url.warehouse#'
		AND		P.ActionStatus = '1'
		AND		P.DeliveryDateEnd >= #dte#
		AND		I.Category = '#url.category#'
		GROUP BY P.ReceiptNo, 
				P.Currency,
				P.DeliveryDateEnd,
				P.WarehouseItemNo,
				I.ItemDescription,
				P.WarehouseUoM,
				U.UoMDescription
		ORDER BY P.ReceiptNo DESC
</cfquery>

<cfquery name="SearchResultDetail"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	P.*,
				S.Description as PriceScheduleDescription
		FROM 	ItemUoMPrice P
				INNER JOIN Ref_PriceSchedule S
					ON P.PriceSchedule = S.Code
		WHERE 	P.Mission = '#url.mission#'
		AND		P.Warehouse = '#url.warehouse#'
		AND		P.Currency = '#url.currency#' 
</cfquery>

<cfquery name="Taxes"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Tax
</cfquery>

<table width="96%" align="center">
	<tr><td height="5"></td></tr>
	<cfif SearchResult.recordCount gt 0>
	<tr>
		<td colspan="3">
			<table>
				<tr onclick="javascript: toggleAllPriceDetail();" style="cursor:pointer;">
					<td>
						<cfoutput>
							<img src="#SESSION.root#/images/expand.png" id="twistieAllPriceDetail" align="absmiddle" height="13">
						</cfoutput>
					</td>
					<td id="textAllPriceDetail" style="padding-left:3px;">Show All Details</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height="8"></td></tr>
	</cfif>
	<tr>
		<td width="10%">Receipt</td>
		<td align="right">Delivery Date</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td height="5"></td></tr>
	
	<cfif SearchResult.recordCount eq 0>
		<tr><td height="30" align="center" colspan="3" style="color:808080;">[No receipts found for the selected criteria]</td></tr>
		<cfabort>
	</cfif>
	
	<cfform name="_formPricingbyReceipt" 
			id="_formPricingbyReceipt" 
			method="POST"
			action="../../SalesOrder/Pricing/Form/PricingSubmit.cfm?mission=#url.mission#&warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#&currency=#url.currency#&category=#url.category#&selectionDate=#url.SelectionDate#">
			
		<cfoutput query="SearchResult" group="ReceiptNo">
		
			<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="">
				<td height="25">
					<img src="#SESSION.root#/images/confirm_delivery.png" height="16" align="absmiddle" title="view receipt detail" style="cursor:pointer;" onclick="javascript: receipt('#receiptno#','receipt');">
					<a href="javascript: togglePriceDetail('#ReceiptNo#');" style="cursor:pointer; color:1E70D2;" title="view items">#ReceiptNo#</a>
				</td>
				<td align="right">#dateFormat(DeliveryDateEnd,"#CLIENT.DateFormatShow#")#</td>
			</tr>
			<tr>
				<td colspan="2">
					<div id="#ReceiptNo#" class="divReceiptPriceDetail" style="display:none;">
						<table width="100%" align="center" cellspacing="0" class="formpadding">
							<tr>
								<td align="right" valign="top">
									<img src="#SESSION.root#/images/join.gif" align="absmiddle">
								</td>
								<td>
									<table width="100%" align="center" style="border:1px dotted ##C0C0C0;">
										<tr>
											<td height="20">Item</td>
											<td>Description</td>
											<td align="center">UoM</td>
											<td align="right" style="padding-right:5px;">Avg Cost</td>
											<td align="right">Sale Price</td>
										</tr>
										<tr><td colspan="5" class="linedotted"></td></tr>
										<cfoutput>
											<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="">
												<td onclick="itemopen('#ItemNo#','');" style="cursor:pointer; color:1E70D2; border-bottom:1px dotted ##C0C0C0;" title="view item">
													#ItemNo#
												</td>
												<td style="border-bottom:1px dotted ##C0C0C0;">#ItemDescription#</td>
												<td align="center" style="border-bottom:1px dotted ##C0C0C0;">#UoMDescription#</td>
												<td align="right" style="padding-right:5px; border-bottom:1px dotted ##C0C0C0;">#lsNumberFormat(ReceiptPrice,",.__")#</td>
												
												<td width="45%" align="right" style="border-bottom:1px dotted ##C0C0C0;">
													<table width="100%" align="right" cellspacing="0" style="border-left:1px dotted ##C0C0C0;" class="formpadding">
														<cfset vDeliveryDate = createDate(year(deliveryDateEnd),month(deliveryDateEnd),day(deliveryDateEnd))>
														<cfquery name="validPriceShedules" dbtype="query">
															SELECT DISTINCT PriceSchedule
															FROM 	SearchResultDetail
															WHERE	ItemNo = '#ItemNo#'
															AND		UoM = '#UoM#'
														</cfquery>
														
														<cfif validPriceShedules.recordCount eq 0>
															
															<tr>
																<td style="padding-left:3px;" colspan="4">
																	<table width="100%" style="color:808080;">
																		<tr>
																			<td colspan="3">No price defined for:</td>
																		</tr>
																		<tr>
																			<td width="5"></td>
																			<td>Entity:</td>
																			<td>#url.mission#</td>
																		</tr>
																		<tr>
																			<td width="5"></td>
																			<td>Warehouse:</td>
																			<td>#url.warehouse#</td>
																		</tr>
																		<tr>
																			<td width="5"></td>
																			<td>Item:</td>
																			<td onclick="itemopen('#ItemNo#','');" style="cursor:pointer; color:1E70D2;" title="view item">#ItemNo#</td>
																		</tr>
																		<tr>
																			<td width="5"></td>
																			<td>UoM:</td>
																			<td>#UoM#</td>
																		</tr>
																	</table>
																</td>
															</tr>
															
														</cfif>
														
														<cfloop query="validPriceShedules">
															
															<cfquery name="qSearchResultDetail" dbtype="query">
																SELECT  *
																FROM 	SearchResultDetail
																WHERE	ItemNo        = '#SearchResult.ItemNo#'
																AND		UoM           = '#SearchResult.UoM#'
																AND		PriceSchedule = '#validPriceShedules.PriceSchedule#'
																AND		DateEffective <= <cfqueryparam value="#vDeliveryDate#" cfsqltype="CF_SQL_DATE">
																ORDER BY DateEffective DESC
															</cfquery>
															
															<cfset vBGColor = "">
															<cfset vDisclaimer = "">
															
															<cfif qSearchResultDetail.recordCount eq 0>
															
																<cfquery name="qSearchResultDetail" dbtype="query">
																	SELECT   *
																	FROM 	 SearchResultDetail
																	WHERE	 ItemNo        = '#SearchResult.ItemNo#'
																	AND		 UoM           = '#SearchResult.UoM#'
																	AND		 PriceSchedule = '#validPriceShedules.PriceSchedule#'
																	AND		 DateEffective > <cfqueryparam value="#vDeliveryDate#" cfsqltype="CF_SQL_DATE">
																	ORDER BY DateEffective ASC
																</cfquery>
																
																<cfset vBGColor = "FFCCCD">
																<cfset vDisclaimer = " (*After Receipt Delivery Date)">
															
															</cfif>
															
															<cfloop query="qSearchResultDetail" startrow="1" endrow="1">
																<tr bgcolor="#vBGColor#" title="Effective from #dateFormat(DateEffective, '#CLIENT.DateFormatShow#')##vDisclaimer#">
																	<td style="padding-left:3px;">#priceScheduleDescription#&nbsp;</td>
																	<cfset vPriceId = replace(priceId,"-","","ALL") & "_" & replace(SearchResult.receiptno,"-","","ALL")>
																	<td>
																		<select 
																			style="font:10px" name="TaxCode_#vPriceId#" id="TaxCode_#vPriceId#" size="1" 
																			disabled>
																		    <cfloop query="taxes">
																				<option value="#TaxCode#" <cfif TaxCode eq qSearchResultDetail.TaxCode>selected</cfif>>
																		    		#Description#
																				</option>
																			</cfloop>
																	    </select>
																	</td>
																	<td>#currency#&nbsp;</td>
																	<td align="right">
																		<cfinput 
																			type="text" 
																			name="SalesPrice_#vPriceId#" 
																			value="#SalesPrice#" 
																			message="Please enter a valid numerc sales price for receipt #SearchResult.receiptno#, item #SearchResult.ItemDescription#, uom #SearchResult.uomDescription#, schedule #priceScheduleDescription#" 
																			required="Yes" 
																			validate="numeric" 
																			size="5" 
																			maxlength="10" 
																			class="regular" 
																			style="padding-right:2px; text-align:right; background-color:DCE8FC;" 
																			disabled="disabled">
																	</td>
																	<td width="1%">
																		<input type="Hidden"   id="taxValue_#vPriceId#" name="taxValue_#vPriceId#" value="#TaxCode#">
																		<input type="Hidden"   id="value_#vPriceId#"    name="value_#vPriceId#" value="#SalesPrice#">
																		<input type="Checkbox" id="en_#vPriceId#"       name="en_#vPriceId#" onclick="enablePriceEdit('#vPriceId#');">
																	</td>		
																</tr>
															</cfloop>
														</cfloop>
													</table>
												</td>
											</tr>
										</cfoutput>
									</table>
								</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
		</cfoutput>
		<tr><td height="4"></td></tr>
		<tr><td colspan="2" class="line"></td></tr>
		<tr><td height="4"></td></tr>
		<tr>
			<td align="center" colspan="2">
			
				<input type="Submit" id="save" name="save" value="Save"  style="height:27px;width:400px" class="button10g">
			</td>
		</tr>
		
	</cfform>
</table>