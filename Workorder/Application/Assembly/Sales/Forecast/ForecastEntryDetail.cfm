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
<cfif trim(url.category) neq "" and trim(url.categoryitem) neq "">
	
	<cfset vInitPeriod = 1>
	<cfset vEndPeriod = 52>
	<cf_tl id="By Week" var="1">
	<cfset vPeriodTitle = lt_text>
	
	<cfif trim(lcase(url.period)) eq "w">
		<cfset vEndPeriod = 52>
		<cf_tl id="By Week" var="1">
		<cfset vPeriodTitle = lt_text>
	</cfif>
	<cfif trim(lcase(url.period)) eq "m">
		<cfset vEndPeriod = 12>
		<cf_tl id="By Month" var="1">
		<cfset vPeriodTitle = lt_text>
	</cfif>
	<cfif trim(lcase(url.period)) eq "q">
		<cfset vEndPeriod = 4>
		<cf_tl id="By Quarter" var="1">
		<cfset vPeriodTitle = lt_text>
	</cfif>
	<cfif trim(lcase(url.period)) eq "s">
		<cfset vEndPeriod = 2>
		<cf_tl id="By Semester" var="1">
		<cfset vPeriodTitle = lt_text>
	</cfif>
	<cfif trim(lcase(url.period)) eq "y">
		<cf_tl id="By Year" var="1">
		<cfset vPeriodTitle = lt_text>
		<cfset vEndPeriod = 1>
	</cfif>
	
	<cfset vUoMColumnStyle = "width:5%; max-width:5%; padding-right:10px; font-size:10px;">
	<cfset vCellWidthINT = INT(95/vEndPeriod)>
	<cfset vCellWidth = "#vCellWidthINT#%">
	
	<cfset vCellStyle = "border:1px solid ##E6E6E6; background-color:##EAFFEB;">
	
	<cfquery name="getItemUoMs" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT	I.ItemNo,
					I.ItemDescription,
					I.Category,
					U.UoM,
					U.UoMDescription,
					U.ItemBarCode
			FROM	#CLIENT.LanPrefix#Item I
					INNER JOIN ItemUoM U
						ON I.ItemNo = U.ItemNo
			WHERE	I.Operational = '1'
			AND		U.Operational = '1'
			AND		I.Category = '#url.category#'
			AND		I.CategoryItem = '#url.categoryItem#'
			ORDER BY 
					I.ItemDescription ASC,
					U.UoMDescription ASC
	</cfquery>
	
	<cfquery name="getRequestedItems" 
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT	*
			FROM	ServiceItemCustomerRequest
			WHERE	ServiceItem = '#url.serviceItem#'
			AND		CustomerId = '#url.customerId#'
	</cfquery>
	
	
	<table width="100%" align="center">
	
		<tr><td height="5"></td></tr>
		<tr>
			<td align="right">
				<cfinvoke 
					component = "Service.Presentation.TableFilter"  
				   	method           = "tablefilterfield" 
				   	filtermode       = "direct"
				   	name             = "filtersearch"
				   	style            = "font:14px;height:35px;width:250px;"
				   	rowclass         = "clsSearchRow"
				   	rowfields        = "ccontent">
			</td>
		</tr>
		<tr><td height="5"></td></tr>
	
		<tr style="display:none;"><td id="processSave"></td></tr>
		
		<tr>
			<td>
				<cfoutput>
					<table width="100%" align="center">
						<tr>
							<td style="#vUoMColumnStyle#"></td>
							<td colspan="#vEndPeriod#" class="labellarge" align="center" style="#vCellStyle#">
								#lsNumberFormat(url.year,',')# #vPeriodTitle#
							</td>
						</tr>
						<tr>
							<td style="#vUoMColumnStyle#"></td>
							<cfloop from="#vInitPeriod#" to="#vEndPeriod#" index="ip">
								<td class="labelit dateHeader_#ip#" width="#vCellWidth#" align="center" style="#vCellStyle#">
									<cf_DatePeriodLeap 
										year="#url.year#" 
										period="#url.period#"
										leap="#ip#">
									#left(dateFormat(leapDate,client.dateformatshow), 5)#
								</td>
							</cfloop>
						</tr>
					</table>
				</cfoutput>
			</td>
		</tr>
		<tr><td height="10"></td></tr>
	
		<cfif getItemUoMs.recordCount eq 0>
			<tr>
				<cfif trim(url.category) neq "" and trim(url.categoryitem) neq "">
					<td class="labelmedium">[ <cf_tl id="No items defined"> ]</td>
				</cfif>
			</tr>
		</cfif>
		
		<cfoutput query="getItemUoMs" group="ItemNo">
			<tr class="clsSearchRow">
				<td class="ccontent" style="display:none;">#ItemBarCode# #ItemDescription#</td>
				<td>
					<table width="100%" align="center">
						<tr>
							<td class="labelmedium">
								[<b>#ItemBarCode#</b>] #ItemDescription#
							</td>
						</tr>
						<cfoutput>
							<tr>
								<td>
									<table width="100%" align="center">
										<tr>
										
											<td class="labelit itemUoMHeader_#ItemNo#_#UoM#" align="right" style="#vUoMColumnStyle# background-color:##EAFFEB;">#left(UoMDescription,15)#</td>
											
											<cfloop from="#vInitPeriod#" to="#vEndPeriod#" index="ip">
											
												<cf_DatePeriodLeap 
													year="#url.year#" 
													period="#url.period#"
													leap="#ip#">
												
												<cfquery name="getRequested" 
														dbtype="query">	
															SELECT	*
															FROM 	getRequestedItems
															WHERE	ItemNo = '#ItemNo#'
															AND		UoM = '#UoM#'
															AND		RequestDue = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#LeapDate#" />
												</cfquery>
											
												<td 
													id="td_#ItemNo#_#UoM#_#ip#" 
													class="labelit" 
													width="#vCellWidth#" 
													align="center" 
													style="#vCellStyle#" 
													onmouseover="$('.dateHeader_#ip#, .itemUoMHeader_#ItemNo#_#UoM#').css('background-color','##8DEFB5');" 
													onmouseout="$('.dateHeader_#ip#, .itemUoMHeader_#ItemNo#_#UoM#').css('background-color','##EAFFEB');">
													
														<table width="100%" align="center">	
															<tr>
																<td style="padding:2px;">
																	<input 
																		type="Text" 
																		name="fc_#ItemNo#_#UoM#_#ip#" 
																		id="fc_#ItemNo#_#UoM#_#ip#"
																		class="regularxl enterastab" 
																		style="width:100%; font-size:11px; text-align:center; min-width:25px;" 
																		value="#getRequested.RequestQuantity#"
																		onchange="ColdFusion.navigate('ForecastSubmit.cfm?serviceItem=#url.serviceitem#&customerid=#customerid#&year=#url.year#&itemno=#itemno#&uom=#uom#&period=#url.period#&itemperiod=#ip#&variation='+$('##fc_var_#ItemNo#_#UoM#_#ip#').val()+'&value='+this.value,'processSave');">
																</td>
																<td class="labelit" align="center">&##177;</td>
																<td style="padding:2px;">
																	<input 
																		type="Text" 
																		name="fc_var_#ItemNo#_#UoM#_#ip#" 
																		id="fc_var_#ItemNo#_#UoM#_#ip#" 
																		class="regularxl enterastab" 
																		style="width:100%; font-size:11px; text-align:center; min-width:25px;" 
																		value="#getRequested.RequestVariation#"
																		onchange="ColdFusion.navigate('ForecastSubmit.cfm?serviceItem=#url.serviceitem#&customerid=#url.customerid#&year=#url.year#&itemno=#itemno#&uom=#uom#&period=#url.period#&itemperiod=#ip#&value='+$('##fc_#ItemNo#_#UoM#_#ip#').val()+'&variation='+this.value,'processSave');">
																</td>
															</tr>
															<tr>
																<td align="center" colspan="3" class="labelit" style="#vCellStyle#">
																	0.0
																</td>
															</tr>
														</table>
													
												</td>
											</cfloop>
											
										</tr>
									</table>
								</td>
							</tr>
							<tr><td height="5"></td></tr>
						</cfoutput>
						<tr><td height="5"></td></tr>
					</table>
				</td>
			</tr>
		</cfoutput>
		
	</table>
	
<cfelse>

	<table width="100%" align="center">
	
		<tr><td height="25"></td></tr>
		<tr>
			<td align="center" class="labellarge">
				<cf_tl id="Please select a valid category and category item">
			</td>
		</tr>
		<tr><td height="5"></td></tr>
		
	</table>

</cfif>