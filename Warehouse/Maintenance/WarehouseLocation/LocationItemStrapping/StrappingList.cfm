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
<cfparam name="url.showOpenST" default="1">

<cfset vWidth = "">
<cfset vDisplay = "display:none;">
<cfset vToggle = "show">
<cfset vToggleTwistie = "expand">
<cfif url.showOpenST eq 1>
	<cfset vWidth = "width='50%'">
	<cfset vDisplay = "">
	<cfset vToggle = "hide">
	<cfset vToggleTwistie = "collapse">
</cfif>

<cfquery name="getItem" 
     datasource="AppsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *,
			    (SELECT ISNULL(COUNT(*),0) FROM ItemWarehouseLocationStrapping WHERE Warehouse = '#url.warehouse#' AND Location = '#url.location#' AND ItemNo = '#url.itemNo#' AND UoM = '#url.UoM#') AS Strapping,				
	 			(SELECT ItemDescription FROM Item   WHERE ItemNo = '#url.itemNo#') as ItemDescription,
				(SELECT ItemPrecision FROM Item     WHERE ItemNo = '#url.itemNo#') as ItemPrecision,
				(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = '#url.itemNo#' AND UoM = '#url.uom#') as UoMDescription
	 FROM       ItemWarehouseLocation 
	 WHERE		Warehouse = '#url.warehouse#'
	 AND       	Location  = '#url.location#'		
	 AND		ItemNo    = '#url.itemNo#'
	 AND		UoM       = '#url.UoM#'
</cfquery>

<table width="100%" height="100%" align="center" style="border:1px dotted #C0C0C0;">
	<tr>
		<td valign="top">
			<table width="100%" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td valign="middle"
						height="18"															
						id="tdStrappingTwistie" 
						style="cursor:pointer;" 
						onclick="toggleStrappingList();" 
						title="<cfoutput>#vToggle#</cfoutput>">
							<table>
								<tr>
									<td height="30" style="padding-left:4px">
										<cfoutput>
											<img src="#SESSION.root#/images/#vToggleTwistie#.png" style="width:13px;" id="imgStrappingTwistie">
										</cfoutput>
									</td>
									<td valign="middle" style="padding-left:6px;" class="labellarge" style="padding-left:4px">
										<cf_tl id="Compose Strapping List">
									</td>
								</tr>
							</table>
					</td>
				</tr>
				
				<tr>
					<td id="tdStrappingListContainer" valign="top" align="center" <cfoutput>#vWidth#</cfoutput>>
					
						<div id="divStrappingListContainer" style="<cfoutput>#vDisplay#</cfoutput>">

						<cfform 
							name="frmStrappingSettings" 
							method="POST" 
							action="#SESSION.root#/warehouse/maintenance/warehouseLocation/locationItemStrapping/StrappingSettingsSubmit.cfm?warehouse=#url.warehouse#&location=#url.location#&itemno=#url.itemNo#&uom=#url.uom#">
												
						<table width="100%" align="center">
														
							<tr>
								<td>
									<table width="97%" cellspacing="0" align="center" class="formpadding">					
										<tr>
											<td width="20%" class="labelit"><cf_tl id="Mode">:</td>
											<td>
												<cfoutput>
													<select name="StrappingIncrementMode" id="StrappingIncrementMode" class="regularxl" onchange="strappingModeChange(this,#getItem.highestStock#,#getItem.StrappingScale#);">
														<option value="Strapping" <cfif  getItem.StrappingIncrementMode eq "Strapping" or getItem.recordcount eq "0">selected</cfif>>Strapping</option>
														<option value="Capacity" <cfif getItem.StrappingIncrementMode eq "Capacity">selected</cfif>>Capacity</option>
													</select>
													<input type="Hidden" name="StrappingIncrementModeOld" id="StrappingIncrementModeOld" value="#getItem.StrappingIncrementMode#">
												</cfoutput>
										    </td>
										</tr>
										<cfset vDisplayStrappingScale = "">
										<cfif getItem.StrappingIncrementMode eq "Strapping">
											<cfset vDisplayStrappingScale = "">
										</cfif>
										<cfif getItem.StrappingIncrementMode eq "Capacity">
											<cfset vDisplayStrappingScale = "display:none;">
										</cfif>
										<tr id="trStrappingScale" style="<cfoutput>#vDisplayStrappingScale#</cfoutput>">
											<td class="labelit"><cf_tl id="Scale">:</td>
											
											<td class="labelit">
												From  1  To  
												<cfif getItem.recordcount eq "1">
												    <cfset val = getItem.StrappingScale>
												<cfelse>
												 	<cfset val = "10">		 
												</cfif>
												
												<cfinput type="text" 
											        class="regularxl" 
													name="StrappingScale" 
													size="5" 
													required="Yes"
													validate="integer"
													message="Please, enter a valid integer scale greater than 0."
													value="#val#" 
													style="text-align:right;padding-right:2px;" 
													range="1,">
													
												<cfoutput>
												<input type="Hidden" name="StrappingScaleOld" id="StrappingScaleOld" value="#val#">
												</cfoutput>
											</td>
										</tr>
										<tr>
											<td class="labelit"><cf_tl id="Increment">:</td>
											
											<td class="labelit">
												<cfif getItem.recordcount eq "1">
												    <cfset val = getItem.StrappingIncrement>
												<cfelse>
												 	<cfset val = "1">		 
												</cfif>
												
												<cfinput type="text" 
											        class="regularxl" 
													name="StrappingIncrement" 
													size="2" 
													required="Yes"
													validate="integer"
													message="Please, enter a valid integer increment greater than 0."
													value="#val#" 
													style="text-align:right;padding-right:2px" 
													range="1," 
													onchange="updateScale(#getItem.highestStock#);">
													
												<cfoutput>
												
													<input type="Hidden" name="StrappingIncrementOld" id="StrappingIncrementOld" value="#val#">
													
												</cfoutput>
												
											</td>
										</tr>		
										<tr><td height="5"></td></tr>
										<tr><td class="line" colspan="2"></td></tr>
										<tr><td height="5"></td></tr>
										<tr>
											<td colspan="2" align="center">
											
											<cf_button 
												mode        = "silver"
												label       = "Generate List" 
												onClick     = "return validateStrapping();"
												type        = "submit"
												id          = "save"
												width       = "190px" 
												height      = "24"
												color       = "636334"
												fontsize    = "11px">   
				
											</td>
										</tr>
										<tr><td height="5"></td></tr>
									</table>
								</td>
							</tr>
							
						</table>
						
						</cfform>
						</div>
					</td>
				</tr>
				<tr><td class="line" colspan="2"></td></tr>
				<tr>
					<td valign="top">
						<cfset vLink = "#SESSION.root#/warehouse/maintenance/warehouseLocation/locationItemStrapping/StrappingListDetail.cfm">
						<cfset vParameters = "">
						<cfset vParameters = vParameters & "warehouse=#url.warehouse#">
						<cfset vParameters = vParameters & "&location=#url.location#">
						<cfset vParameters = vParameters & "&itemno=#url.itemNo#">
						<cfset vParameters = vParameters & "&uom=#url.uom#">
						<cfdiv id="divStrappingListingDetail" 
							bind="url:#vLink#?#vParameters#">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>