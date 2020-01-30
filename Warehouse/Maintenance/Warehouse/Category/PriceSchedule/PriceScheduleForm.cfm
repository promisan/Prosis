<cfparam name="url.isReadOnly" default="0">

<cfquery name="Schedule" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_PriceSchedule
</cfquery>

<cfquery name="Currency" 
	datasource="appsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Currency
		WHERE	EnableProcurement = 1
		AND		Operational = 1 
</cfquery>

<cfquery name="qWHPriceSchedule" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	WarehouseCategoryPriceSchedule 
		WHERE 	Warehouse = '#url.warehouse#'
		AND		Category = '#url.category#'
</cfquery>

<cfform name="frmItemPriceSchedule" method="POST" action="Category/PriceSchedule/PriceScheduleSubmit.cfm?warehouse=#url.warehouse#&category=#url.category#">

<table width="98%" align="center" cellpadding="0" class="formpadding">
	
	<tr class="labelmedium">
		<td width="20%"></td>
		<cfoutput query="Currency">
			<td align="center" 
				title="#Description#" 
				id="td_#currency#" 
				bgcolor="D9FFDC" 
				style="border:1px solid C0C0C0;">#Currency#</td>
		</cfoutput>
		<cfset totalCols = Currency.recordCount + 1>
	</tr>
	
	<cfloop query="Schedule">
		<tr class="labelmedium"> 
		
			<cfoutput>
				<td bgcolor="D9FFDC" style="border:1px solid C0C0C0;padding-left:4px">#Description#</td>
			</cfoutput>
			
			<cfloop query="Currency">
				
				<cfquery name="lqWHPriceSchedule" dbtype="query">
					SELECT 	*
					FROM 	qWHPriceSchedule
					WHERE	PriceSchedule = '#Schedule.code#'
					AND		Currency = '#Currency.Currency#'
				</cfquery>
				
				<cfset vSelected = 0>
				<cfif lqWHPriceSchedule.recordCount eq 1>
					<cfset vSelected = 1>
				</cfif>
				
				<cfoutput>
				<td align="center" 
					id="td_#Schedule.code#_#Currency.Currency#" 
					style="border:1px solid C0C0C0; <cfif vSelected eq 1>background-color:'FFFFCF'; </cfif>" 
					onMouseOver="this.bgColor='FFFFCF'" 
					onMouseOut="this.bgColor=''" 
					bgcolor="" 
					width="#100/(Currency.recordCount+1)#%">
						<table>
							<tr>
								<td valign="middle">
									<input 	type="Checkbox" 
										name="cb_#Schedule.code#_#Currency.Currency#" 
										id="cb_#Schedule.code#_#Currency.Currency#" 
										onclick="javascript: hlChecked('#Schedule.code#','#Currency.Currency#');"
										<cfif vSelected eq 1>checked</cfif>
										<cfif url.isReadOnly eq 1>disabled</cfif>>
								</td>
								<cfset vClass = "regular">
								<cfif vSelected eq 0>
									<cfset vClass = "hide">
								</cfif>
								<td id="td_details_#Schedule.code#_#Currency.Currency#" style="padding-left:5px;" class="#vClass#">
									<table>
										<tr>
											<td style="font-size:10px;"><cf_tl id="Multiplier">:</td>
											<td>
												<cfset vCostPriceMultiplier = lqWHPriceSchedule.CostPriceMultiplier>
												<cfif vCostPriceMultiplier eq "">
													<cfset vCostPriceMultiplier = 0>
												</cfif>
												
												<cfif url.isReadOnly eq 1>
													#vCostPriceMultiplier#
												<cfelse>
													<cfinput class="regular" 
													     type="Text" 
														 style="text-align:right; padding-right:2px;"
														 name="CostPriceMultiplier_#Schedule.code#_#Currency.Currency#"  
														 value="#vCostPriceMultiplier#" 
														 validate="numeric"
														 message="Please enter a valid numeric multiplier for #Schedule.description#, #Currency.Currency#" 
														 required="Yes" 
														 size="1" 
														 maxlength="5">
												</cfif>
											</td>
										</tr>
										<tr>
											<td style="font-size:10px;">Ceiling:</td>
											<td>
												<cfset vCostPriceCeiling = lqWHPriceSchedule.CostPriceCeiling>
												<cfif vCostPriceCeiling eq "">
													<cfset vCostPriceCeiling = 0>
												</cfif>
												
												<cfif url.isReadOnly eq 1>
													#vCostPriceCeiling#
												<cfelse>
													<cfinput class="regular" 
													     type="Text" 
														 style="text-align:right; padding-right:2px;"
														 name="CostPriceCeiling_#Schedule.code#_#Currency.Currency#"  
														 value="#vCostPriceCeiling#" 
														 validate="integer"
														 message="Please enter a valid integer ceiling for #Schedule.description#, #Currency.Currency#" 
														 required="Yes" 
														 size="1"
														 maxlength="4">
												</cfif>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
							
				</td>
				</cfoutput>
			</cfloop>
		</tr>
	</cfloop>
	
	<cfif url.isReadOnly eq 0>
	
		<tr><td height="10"></td></tr>
		<tr><td class="line" colspan="<cfoutput>#totalCols#</cfoutput>"></td></tr>
		<tr><td height="5"></td></tr>	
		<tr>
			<td colspan="<cfoutput>#totalCols#</cfoutput>" align="center">				
				<input type="Submit" style="width:110" name="save" id="save" value="Save" class="button10g">				
			</td>
		</tr>
	</cfif>

</table>

</cfform>