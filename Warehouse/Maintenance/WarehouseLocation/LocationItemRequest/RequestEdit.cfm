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

<cfquery name="getUoM" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ItemUoM
		WHERE 	ItemNo = '#url.itemno#'
		AND		UoM = '#url.uom#'
</cfquery>

<cfquery name="getWH" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Warehouse
		WHERE 	Warehouse = '#url.warehouse#'
</cfquery>

<cfquery name="get" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT  	R.*,
		 			IU.UoMDescription,
					S.Description as ShipToModeDescription
		 FROM      	ItemWarehouseLocationRequest R
		 			INNER JOIN ItemUoM IU
						ON R.ItemNo = IU.ItemNo
						AND R.UoM = IU.UoM
					INNER JOIN Ref_ShipToMode S
						ON R.ShipToMode = S.Code
		 WHERE		R.Warehouse = '#url.warehouse#'
		 AND       	R.Location = '#url.location#'		
		 AND		R.ItemNo = '#url.itemNo#'
		 AND		R.UoM = '#url.UoM#'
		 <cfif url.ScheduleEffective neq "">
		 AND		R.ScheduleEffective = '#url.ScheduleEffective#'
		 <cfelse>
		 AND		1 = 0
		 </cfif>
		 ORDER BY R.ScheduleEffective DESC
</cfquery>

<cfoutput>

<cf_tl id="Scheduled Request" var = "vLabel">

<cfif url.ScheduleEffective neq "">
    <cf_tl id="Maintain Scheduled Request" var = "vOption">
	<cf_screentop height="100%" label="#vLabel#" option="#vOption#" close="ColdFusion.Window.destroy('mydialog',true)" layout="webapp" banner="yellow" scroll="yes">
<cfelse>
    <cf_tl id="Add Scheduled Request" var = "vOption">
	<cf_screentop height="100%" label="#vLabel#" option="#vOption#" close="ColdFusion.Window.destroy('mydialog',true)" layout="webapp" banner="blue" scroll="yes">
</cfif>

<table class="hide" colspan="2">
<tr><td><iframe name="processfrmRequestUoM" id="processfrmRequestUoM" frameborder="0"></iframe></td></tr>
</table>

<cfform name="frmRequestUoM" target="processfrmRequestUoM"
  action="../LocationItemRequest/RequestSubmit.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#&ScheduleEffective=#url.ScheduleEffective#">	

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
	
		<tr><td height="15"></td></tr>
	
		<tr>
			<td class="labelmedium" width="30%"><cf_tl id="Effective">:</td>
			<td>
				<cfif url.ScheduleEffective eq "">
					<cf_intelliCalendarDate9
						FieldName="ScheduleEffective"
						class="regularxl" 
						Default="#dateformat(now(), '#CLIENT.DateFormatShow#')#"
						AllowBlank="False">
				<cfelse>
					<b>#dateFormat(get.ScheduleEffective,'#CLIENT.DateFormatShow#')#</b>
					<input type="Hidden" name="ScheduleEffective" id="ScheduleEffective" value="#dateFormat(get.ScheduleEffective,'#CLIENT.DateFormatShow#')#">
				</cfif>
			</td>
		</tr>
		
		<tr>
			<td class="labelmedium"><cf_tl id="Mode">:</td>
			<td>
				<table cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<select name="ScheduleMode" id="ScheduleMode" onchange="toggleModeDetail(this);" class="regularxl" >
								<option value="Month" <cfif get.ScheduleMode eq "Month" or url.ScheduleEffective eq "">selected</cfif>>Month
								<option value="Interval" <cfif get.ScheduleMode eq "Interval">selected</cfif>>Interval
							</select>
						</td>
						<td width="8"></td>
						<td>
							<table cellspacing="0" cellpadding="0">
							
								<cfset vDisplayModeDetail = "none">
								<cfif get.ScheduleMode eq "Interval">
									<cfset vDisplayModeDetail = "block">
								</cfif>
								
								<tr id="trIntervalDetail" style="display:<cfoutput>#vDisplayModeDetail#</cfoutput>;">
									<td class="labelmedium" style="padding-right:4px"><cf_tl id="Every"></td>
									<td>
										<cfset vDays = 7>
										<cfif get.ScheduleInterval neq "">
											<cfset vDays = get.ScheduleInterval>
										</cfif>
										
										<cfinput type="Text" 
											name="ScheduleInterval" 
											required="Yes" 
											class="regularxl" 
											message="Please, enter a valid integer interval between 1 and 7." 
											validate="integer" 
											range="1,7" 
											size="1"
											maxlength="1"
											value="#vDays#" 
											style="text-align:center;">
											
									</td>
									<td style="padding-left:3px" class="labelmedium"><cf_tl id="days"></td>
								</tr>
								
								<cfset vDisplayModeDetail="none">
								
								<cfif get.ScheduleMode eq "Month" or url.ScheduleEffective eq "">
									<cfset vDisplayModeDetail = "block">
								</cfif>
								
								<tr id="trMonthDetail" style="display:<cfoutput>#vDisplayModeDetail#</cfoutput>;">
									<td class="labelmedium" tyle="padding-right:3px"><cf_tl id="On the day"></td>
									<td>
										<cfset vMDays = 1>
										<cfif get.ScheduleDayMonth neq "">
											<cfset vMDays = get.ScheduleDayMonth>
										</cfif>
										
										<cfinput type="Text" 
											name="ScheduleDayMonth" 
											required="Yes" 
											message="Please, enter a valid integer month day between 1 and 31." 
											validate="integer" 
											range="1,31" 
											size="1"
											class="regularxl" 
											maxlength="2"
											value="#vMDays#" 
											style="text-align:center;">
											
									</td>
									<td class="labelmedium" tyle="padding-left:3px"><cf_tl id="of each month"></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td class="labelmedium"><cf_tl id="Source Facility">:</td>
			<td>
				<cfquery name="WarehouseSelect" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   * 
						FROM     Warehouse W
						WHERE    W.Mission = '#getWH.mission#'		
						AND      W.Distribution = 1 
						AND		 W.Operational = 1
						AND		 W.Warehouse IN 
								 (
									 SELECT 	Warehouse 
									 FROM 		ItemWarehouseLocation 
									 WHERE		ItemNo = '#url.itemNo#'
									 AND		UoM = '#url.UoM#'
									 AND		Operational = 1
								 )
						ORDER BY W.WarehouseDefault DESC
				</cfquery>
				
				<cfselect 
					name="sourceWarehouse" 
					id="sourceWarehouse" 
					class="regularxl" 
					query="WarehouseSelect" 
					display="warehouseName" 
					value="warehouse" 
					required="Yes" 
					message="Please, select a valid source facility" 
					selected="#get.sourceWarehouse#" 
					queryPosition="below"  
					onchange="ColdFusion.navigate('../LocationItemRequest/RequestType.cfm?warehouse='+this.value+'&requestType=&requestAction=','divRequestType');">
						<option value=""> -- <cf_tl id="Select a source facility"> --
				</cfselect>
			</td>
		</tr>
		
		<tr>
			<td class="labelmedium"><cf_tl id="Request Type">:</td>
			<td>
				<cfdiv id="divRequestType" bind="url:../LocationItemRequest/RequestType.cfm?warehouse=#get.sourceWarehouse#&requestType=#get.requestType#&requestAction=#get.RequestAction#">
			</td>
		</tr>
		
		<tr>
			<td class="labelmedium"><cf_tl id="Priority">:</TD>						
			<td>		
				<cfdiv id="divRequestAction" bind="url:#SESSION.root#/Warehouse/Portal/Checkout/getRequestAction.cfm?warehouse=#get.sourceWarehouse#&requesttype=#get.requestType#&width=&RequestAction=#get.RequestAction#">
			</td>
		</tr>
		
		<tr>
			<td class="labelmedium"><cf_tl id="Quantity">:</td>
			<td class="labelmedium">
				<cfinput type="Text" 
					name="ScheduleQuantity" 
					required="Yes" 
					message="Please, enter a valid numeric quantity." 
					validate="numeric" 
					size="5"
					class="regularxl" 
					maxlength="8"
					value="#get.ScheduleQuantity#" 
					style="text-align:right; padding-right:2px;"> #getUoM.UoMDescription#
			</td>
		</tr>
		
		<tr>
			<td class="labelmedium"><cf_tl id="Ship Mode">:</td>
			<td>
				<cfquery name="getMode" 
				    datasource="AppsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
						SELECT	*
						FROM 	Ref_ShipToMode
						ORDER BY ListingOrder
				</cfquery>
				
				
				<cfselect 
					name="ShipToMode" 
					id="ShipToMode" 
					required="Yes" 
					message="Please, select a valid ship mode." 
					query="getMode" 
					class="regularxl"
					display="description" 
					value="code" 
					selected="#get.shipToMode#"/>

			</td> 
		</tr>
		
		<tr>
			<td class="labelmedium"><cf_tl id="Memo">:</td>
			<td>
				<cfinput type="Text" 
					name="ScheduleMemo" 
					required="No" 
					message="Please, enter a valid memo." 
					size="30"
					class="regularxl" 					
					maxlength="80"
					value="#get.ScheduleMemo#">
			</td>
		</tr>
		
		<tr>
			<td style="height:28" class="labelmedium"><cf_tl id="Enabled">:</td>
			<td class="labelmedium">
				<input type="Radio" name="operational" id="operational" value="1" <cfif get.operational eq 1 or url.ScheduleEffective eq "">checked</cfif>> Yes
				<input type="Radio" name="operational" id="operational" value="0" <cfif get.operational eq 0>checked</cfif>> No
			</td>
		</tr>
		
		<tr><td height="10"></td></tr>
		<tr><td colspan="2" class="line"></td></tr>
		<tr><td height="10"></td></tr>
		<tr>
			<td colspan="2" align="center">
				<cf_tl id="Save" var="1">
				<input 
					type		= "submit"
					mode        = "silver"
					value       = "#lt_text#" 				
					id          = "save"					
					width       = "100px" 					
					color       = "636334"
					fontsize    = "11px"
					class		= "button10g">
			</td>
		</tr>
		
</table>

</cfform>

</cfoutput>

<cfset ajaxonload("doCalendar")>