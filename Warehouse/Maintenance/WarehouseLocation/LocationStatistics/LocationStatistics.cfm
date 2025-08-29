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
<cfparam name="url.viewPort" 				default="225">
<cfparam name="url.graphColumns"			default="2">
<cfparam name="url.showTooltip"				default="1">
<cfparam name="url.showPrint"				default="1">
<cfparam name="url.showLocationDescription" default="0">
<cfparam name="url.fontSize" 				default="10">

<cftransaction isolation="read_uncommitted">
	
	<cfquery name="wl" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT	IWL.*,
					WL.Description as LocationDescription,
					WL.LocationId,
					WL.LocationClass,
					WL.StorageShape,
					I.ItemDescription,
					I.ItemPrecision,
					U.UoMDescription,
					I.ItemMaster,
					IM.Description as ItemMasterDescription,
					IM.IsUoMEach,
					ISNULL((
						SELECT 	SUM(TransactionQuantity)
						FROM   	ItemTransaction 
						WHERE  	Warehouse      = IWL.Warehouse
						AND 	Location       = IWL.Location
						AND		ItemNo         = IWL.ItemNo
						AND		TransactionUoM = IWL.UoM
					),0) OnHand
			FROM	ItemWarehouseLocation IWL
					INNER JOIN WarehouseLocation WL 
						ON WL.Warehouse = IWL.Warehouse 
						AND WL.Location = IWL.Location
					INNER JOIN Item I
						ON IWL.ItemNo = I.ItemNo
					INNER JOIN ItemUoM U
						ON IWL.ItemNo = U.ItemNo
						AND IWL.UoM = U.UoM
					INNER JOIN Purchase.dbo.ItemMaster IM 
						ON I.ItemMaster = IM.Code
			WHERE	WL.Warehouse = '#url.warehouse#'
			<cfif url.location neq "">
			AND		WL.Location = '#url.location#'
			</cfif>
			ORDER BY I.ItemMaster, IWL.ItemNo, IWL.UoM
	</cfquery>

</cftransaction>


<cf_divscroll id="divStatisticsLocation">


<cfif url.showPrint eq 1>
	<div id="divPrintButton" align="right" style="padding-right:5px;">
		<cfoutput>
			<img 
				src="#SESSION.root#/images/print.png" 
				height="30" 
				style="cursor:pointer;" 
				title="printable version" 
				onclick="printStatistics('#url.warehouse#','#url.location#','divStatisticsLocation');">
		</cfoutput>
	</div>
</cfif>

<!--- 
<div >
--->

	<table width="100%" align="center">
	
		<cfset locNumberOfColumns = url.graphColumns>
		
		<cfif url.location neq "">
		<tr>	
			<td align="center" colspan="<cfoutput>#locNumberOfColumns#</cfoutput>">
				<table width="100%" align="center" >
					<tr>
						<td style="padding-top:5px">
							
							<cfinclude template="LocationStatisticsDetail.cfm">
							
						</td>
					</tr>
				</table>
			</td>
		</tr>
		</cfif>	
		
		<tr><td height="10"></td></tr>
		
		<!--- Stock on hand in text disabled 9/30/2015 
		<tr>
			<td align="center" colspan="<cfoutput>#locNumberOfColumns#</cfoutput>">
				<table width="100%" align="center">
					<tr>
						<td style="border:0px dotted silver">
							
									<table width="100%" align="center" class="clsPrintable">
										<tr>
											<td height="15"></td>
											<td class="labelsmall"><cf_tl id="Location"></td>
											<td class="labelsmall"><cf_tl id="Item"></td>
											<td class="labelsmall"><cf_tl id="Description"></td>
											<td class="labelsmall"><cf_tl id="UoM"></td>
											<td class="labelsmall" align="right"><cf_tl id="On Hand"></td>
										</tr>
										<tr><td colspan="6" style="height:2px; border-bottom:1px dotted #C0C0C0;"></td></tr>
										<tr><td height="3"></td></tr>
										
										<!--- group by itemMaster --->
										<cfoutput query="wl" group="ItemMaster">
										
											<cfset ItemMasterTotal = 0>
											<cf_precision number = ItemPrecision> <!--- returns pformat --->
											<tr><td colspan="6" height="15" class="labellarge"><b>#ItemMasterDescription#</td></tr>
											<tr><td colspan="6" style="height:2px; border-bottom:1px dotted ##C0C0C0;"></td></tr>
											
											<!--- group by ItemNo --->
											<cfoutput group="ItemNo">
											
												<!--- group by UoM --->
												<cfoutput group="UoM">
												
													<cfset ItemUoMTotal = 0>
													
													<!--- detail --->
													<cfoutput>
													
														<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="">
															<td width="5%"></td>
															<td>#Location# #LocationDescription#</td>
															<td>#ItemNo#</td>
															<td>#ItemDescription#</td>
															<td>#UoMDescription#</td>
															<td align="right" style="padding-right:7px">#lsNumberFormat(OnHand,pformat)#</td>
														</tr>		
														<cfif OnHand neq "">
															<cfset ItemMasterTotal = ItemMasterTotal + OnHand>
															<cfset ItemUoMTotal = ItemUoMTotal + OnHand>
														</cfif>
														
													<!--- end detail --->
													</cfoutput>
													
													<!--- sum by item/UoM --->
													<cfif IsUoMEach eq 0>
													
														<tr>
															<td colspan="5"></td>
															<td align="right" 
																onMouseOver="this.bgColor='FFFFCF'" 
																onMouseOut="this.bgColor=''" 
																style="border-top:1px dotted ##C0C0C0; padding-right:7px">
																<b>#lsNumberFormat(ItemUoMTotal,pformat)#
															</td>
														</tr>
														
														<tr><td height="3"></td></tr>
														
													</cfif>
													
												<!--- end group by uom --->
												</cfoutput>
												
											<!--- end group by itemNo --->
											</cfoutput>
											
											<!--- sum by itemMaster --->
											<cfif IsUoMEach eq 1>
												<tr>
													<td colspan="5"></td>
													<td class="statG"
														align="right" 
														onMouseOver="this.bgColor='FFFFCF'" 
														onMouseOut="this.bgColor=''" 
														bgcolor="" 
														style="border-top:1px dotted ##C0C0C0; font-size:14px; font-weight:bold;">
														#lsNumberFormat(ItemMasterTotal,pformat)#
													</td>
												</tr>
											</cfif>
											
										<!--- end group by itemMaster --->
										</cfoutput>
										
									</table>
							
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		--->
		
		<tr><td height="10"></td></tr>
	
		<!--- Stock on hand in graphics --->
		<tr>
			<td align="center" colspan="<cfoutput>#locNumberOfColumns#</cfoutput>">
				<table width="98%" align="center" height="100%" align="center">
					<tr>
					<cfset locCntColumns = 0>
					
					
					<cfoutput query="wl">
					
					
						<cfif lcase(wl.storageShape) neq "n/a">
							<td align="center" valign="top" width="#100/locNumberOfColumns#%">
								
								<cfset url.locationClass 			= locationClass>
								<cfset url.LocationId 				= LocationId>
								<cfset url.ItemNo 					= ItemNo>
								<cfset url.uom 						= UoM>
								<cfset url.itemLocationId 			= itemLocationId>
								<cfset url.highlightTank			= 0>
								<cfset url.fontSize					= url.fontSize>
								
								<cfinclude template="../../../Portal/Stock/InquiryWarehouseTanks.cfm">
								
							</td>
							<cfset locCntColumns = locCntColumns + 1>
							<cfif locCntColumns gte locNumberOfColumns>
								</tr>
								<tr>
								<cfset locCntColumns = 0>
							</cfif>
						</cfif>
					</cfoutput>
					
					</tr>
				</table>
			</td>
		</tr>
		
		<cfif wl.recordCount eq 0>
			<tr>
				<td align="center" colspan="<cfoutput>#locNumberOfColumns#</cfoutput>">
					<table width="100%" align="center" class="clsPrintable">
						<tr>
							<td class="labelmedium">								
									<font color="FF0000">[<cf_tl id="No tanks are configured">]</font>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</cfif>
		
	</table>

</cf_divscroll>	
