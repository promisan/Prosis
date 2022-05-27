<cfquery name="getLine"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *,
				(SELECT WarehouseName FROM Materials.dbo.Warehouse WHERE Warehouse = '#url.destinationWarehouse#') as DestinationWarehouseName
		FROM 	Receipt#URL.Warehouse#_#SESSION.acc#
		WHERE	TransactionId = '#url.id#'
</cfquery>

<cfquery name="PriceList"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ItemUoMPrice
		WHERE 	Mission       = '#url.mission#'
		AND		(Warehouse    = '#url.destinationWarehouse#' OR Warehouse IS NULL)
		AND		ItemNo        = '#getLine.ItemNo#'
		AND		UoM           = '#getLine.UoM#'
		AND		DateEffective <= getDate() 
</cfquery>

<cfquery name="ScheduleList"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	S.*
		FROM	Ref_PriceSchedule S
		WHERE EXISTS (	SELECT 	*
						FROM 	WarehouseCategoryPriceSchedule
						WHERE	Category   = (SELECT Category 
						                      FROM   Item 
											  WHERE  ItemNo = '#getLine.ItemNo#')
						AND		(Warehouse = '#url.destinationWarehouse#' OR Warehouse IS NULL)
						AND		PriceSchedule = S.Code )
		OR 		FieldDefault = 1
		ORDER BY S.FieldDefault DESC, S.ListingOrder ASC
</cfquery>

<cfquery name="TaxList"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_Tax
</cfquery>

<cfquery name="Tax"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       WarehouseCategory
		WHERE      Warehouse = '#url.destinationWarehouse#'								
</cfquery>	

<cfquery name="Parameter"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       Ref_ParameterMission
		WHERE      Mission = '#url.mission#'								
</cfquery>	

<table style="width:100%;min-width:600px">
	
		<cfif ScheduleList.recordCount eq 0>
			<tr>
				<td class="labelmedium" align="center" style="padding:8px; color:red;">[<cf_tl id="No price schedules defined for this warehouse and item category">]</td>
			</tr>
		</cfif>
		
		<tr>
			<td class="labelmedium" style="font-size:17px" colspan="2">
			
			    <cfif parameter.priceManagement eq "1">
				
				<cfoutput>
					<cf_tl id="Apply to">: <b>#url.destinationWarehouse# #getLine.DestinationWarehouseName#
				</cfoutput>
				
				<cfelse>
				
				<cfoutput>
					<cf_tl id="Apply to">: <b>#url.mission#
				</cfoutput>
				
				</cfif>
				
			</td>
		</tr>
		
		<cfset cntTotal = 0>
		<cfset cntSchedule = 0>
		<cfloop query="ScheduleList">
			<cfset cntSchedule = cntSchedule + 1>
			<tr class="labelmedium line" style="height:20px">
				<td style="padding-left:3px; padding-right:5px; font-size:13px;">
					<cfoutput>
						#Description#
						<cfif FieldDefault eq 1>
						<span style="font-size:9px; font-style:italic;">(Default)</span>
						</cfif>
					</cfoutput>
				</td>
				<td>
					<table width="100%">
						<cfquery name="CurrencyList" 
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT 	C.*
								FROM   	Currency C
								WHERE 	C.EnableProcurement = 1
								AND		C.Operational = 1
								
								AND EXISTS
									(
										SELECT 	*
										FROM 	Materials.dbo.WarehouseCategoryPriceSchedule
										WHERE	Warehouse = '#url.destinationWarehouse#'
										AND		Category = (SELECT Category FROM Materials.dbo.Item WHERE ItemNo = '#getLine.ItemNo#')
										AND		Currency = C.Currency
										AND		PriceSchedule = '#code#'
									)
						</cfquery>

						<cfif CurrencyList.recordCount eq 0>
							<tr class="labelmedium">
								<td align="center" class="labelit"  style="padding:8px; color:red;"><cf_tl id="No currencies defined for this warehouse and item category"></td>
							</tr>
						</cfif>
						
						<cfset cntCurrency = 0>
						
						<cfloop query="CurrencyList">
						
							<cfset cntCurrency = cntCurrency + 1>
							<cfset cntTotal = cntTotal + 1>
							
							<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="" class="labelmedium2">
								<td style="<cfif cntCurrency neq CurrencyList.recordCount>border-bottom:1px dotted #C0C0C0;</cfif>  padding-left:3px;" title="<cfoutput>#Description#</cfoutput>"><cfoutput>#Currency#</cfoutput></td>
								<td style="<cfif cntCurrency neq CurrencyList.recordCount>border-bottom:1px dotted #C0C0C0;</cfif>  padding-left:15px;">
		
									<cfquery dbtype="query" name="qPriceList">
										SELECT 	*
										FROM 	PriceList
										WHERE	PriceSchedule = '#ScheduleList.code#'
										AND		Currency = '#CurrencyList.currency#'
										ORDER BY DateEffective DESC
									</cfquery>
									
									<cfif qPriceList.recordCount eq 0>
										<cfquery dbtype="query" name="qPriceList">
											SELECT 	'' taxCode, '' salesPrice, '' dateEffective
											FROM	getLine
										</cfquery>
									</cfif>
									
									<table width="100%">
									
										<cfloop query="qPriceList" startrow="1" endrow="1">
										
										<tr class="labelmedium2">
																				
											<cfset vZIndex = 10000-(1000*url.row)-cntTotal>
											
											<cfoutput>
											
												<td style="padding-left:4px;padding-right:4px; position:relative; z-index:<cfoutput>#vZIndex#</cfoutput>;" class="calendar_#url.id#">
													<cfset vDateEffective = qPriceList.dateEffective>
													<cfif qPriceList.dateEffective eq ''>
														<cfset vDateEffective = now()>
													</cfif>
													
													<cf_intelliCalendarDate9
													    class="regularxl"
														style="border:0px"
														FieldName="dateEffective_#url.id#_#ScheduleList.code#_#CurrencyList.currency#" 
														Default="#dateformat(vDateEffective, '#CLIENT.DateFormatShow#')#"
														AllowBlank="False">
													
												</td>
											</cfoutput>
											
											<td style="padding-left:4px;padding-right:4px">
																						
																						
												<cfif qPriceList.TaxCode eq "">
													<cfset defaulttax = Tax.TaxCode>
												<cfelse>	
												    <cfset defaulttax = qPriceList.TaxCode>
												</cfif>
											
												<cfoutput>
													<select 
														name="taxCode_#url.id#_#ScheduleList.code#_#CurrencyList.currency#" 
														id="taxCode_#url.id#_#ScheduleList.code#_#CurrencyList.currency#" 
														class="regularxl" style="border:0px"
														onchange="submitReceiptItemPrice('#url.mission#','#url.warehouse#','#url.destinationWarehouse#','#url.id#','#ScheduleList.code#','#CurrencyList.currency#');">
															<cfloop query="TaxList">
																<option value="#TaxCode#" <cfif defaulttax eq taxcode>selected</cfif>>#Description#
															</cfloop>
													</select>
												</cfoutput>
											</td>
											<td style="padding-left:4px;padding-right:4px">
												
												<cfset vSalesPrice = "">
												<cfif qPriceList.SalesPrice neq ''>
													<cfset vSalesPrice = lsNumberFormat(qPriceList.SalesPrice,'.__')>
												</cfif>
												
												<cf_tl id="Enter a valid numeric sales price for" var="1">
												
												<cfinput type="Text" 
													name="salesPrice_#url.id#_#ScheduleList.code#_#CurrencyList.currency#" 
													id="salesPrice_#url.id#_#ScheduleList.code#_#CurrencyList.currency#" 
													value="#vSalesPrice#" 
													required="no" 
													validate="numeric" 
													message="#lt_text# #ScheduleList.description# [#CurrencyList.currency#]" 
													size="8" 
													maxlength="10" 
													class="regularxl" 
													style="text-align:right; padding-right:2px;border:0px;background-color:f1f1f1"
													onblur="submitReceiptItemPrice('#url.mission#','#url.warehouse#','#url.destinationWarehouse#','#url.id#','#ScheduleList.code#','#CurrencyList.currency#');">
													
											</td>
											<td width="45" style="padding-left:4px;padding-right:4px" id="<cfoutput>processReceiptItemPrice_#url.id#_#ScheduleList.code#_#CurrencyList.currency#</cfoutput>">
											
											<cfif parameter.priceManagement eq "1">
											
											<td><cf_tl id="Global for Entity"></td>
											<td>
												<cf_tl id="check to apply to whole entity" var="1">
												<cfoutput>
												
												<input type="Checkbox" 
													id="inherit_#url.id#_#ScheduleList.code#_#CurrencyList.currency#" 
													name="inherit_#url.id#_#ScheduleList.code#_#CurrencyList.currency#" 
													title="#lt_text#" 
													class="radiol"
													checked
													onclick="warningApplyEntity(this);">
													
												</cfoutput>
											</td>
											
											<cfelse>
											
											<td class="hide">
											<input type="Checkbox" 
													id="inherit_#url.id#_#ScheduleList.code#_#CurrencyList.currency#" 
													name="inherit_#url.id#_#ScheduleList.code#_#CurrencyList.currency#" 
													title="#lt_text#" 
													class="radiol">
											</td>
											
											</cfif>
											
											</td>
										</tr>
										</cfloop>
									</table>
								</td>
							</tr>
						</cfloop>
					</table>
				</td>
			</tr>
		</cfloop>
	
</table>

<cfset ajaxOnLoad("doCalendar")>