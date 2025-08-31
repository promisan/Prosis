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
<div id="divVendorOfferListing">

<cfquery name="getOffers" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT 	O.*,
				(SELECT LocationCode FROM Location WHERE Location = O.LocationId) as LocationCode,
				(SELECT LocationName FROM Location WHERE Location = O.LocationId) as LocationName,
				(SELECT TreeOrder FROM Location WHERE Location = O.LocationId) as LocationOrder,
				(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = '#url.itemno#' AND UoM = '#url.uom#') as UoMDescription
		FROM 	ItemVendorOffer O
		WHERE	O.ItemNo = '#url.itemno#'
		AND		O.UoM = '#url.uom#'
		AND		O.OrgUnitVendor = #url.orgunitvendor#
		AND		O.Mission = '#url.mission#'
		ORDER BY DateEffective DESC, LocationOrder
</cfquery>

<cfset dColumns = 9>

<table width="100%" align="center">
	<tr><td height="4"></td></tr>
	<tr><td height="1" colspan="<cfoutput>#dColumns#</cfoutput>" class="line"></td></tr>
	<tr><td height="2"></td></tr>
	<tr>
		<td colspan="<cfoutput>#dColumns - 1#</cfoutput>" class="labelmedium"><cf_tl id="Offers"></td>
		<td colspan="1" align="right">
		<cf_tl id="Record Offer" var="1">
		<cfoutput>
			<input value  = "#lt_text#" 
				class     = "button10g"
				type      = "Button"
				style     = "width:130px"
				id        = "addOffer"									
				onclick   = "javascript: editvendorofferperdate('','#url.mission#','#itemno#','#url.uom#','#url.orgunitvendor#','');"> 
		 </cfoutput>		
		</td>
	</tr>
	<tr><td height="2"></td></tr>
	<tr><td height="1" colspan="<cfoutput>#dColumns#</cfoutput>" class="line"></td></tr>
	<tr><td height="2"></td></tr>
	
	<tr class="labelmedium2 fixlengthlist">
		<td width="40"></td>
		<td><cf_tl id="Location"></td>		
		<td align="right"><cf_tl id="Currency"></td>
		<td align="right"><font size="1" color="808080"><cf_tl id="Fixed"></td>
		<td align="right"><font size="1" color="808080"><cf_tl id="Variable"></td>
		<td align="right"><cf_tl id="Price"></td>
		<td align="right"><cf_tl id="Tax"></td>
		<td align="center"><cf_tl id="Tax Incl."></td>
		<td width="40"></td>
	</tr>
	
	<tr><td height="2"></td></tr>
	<tr><td height="1" colspan="<cfoutput>#dColumns#</cfoutput>" class="line" ></td></tr>
	<tr><td height="3"></td></tr>
	
	<cfif getOffers.recordCount neq 0>
	
		<cfoutput query="getOffers" group="dateEffective">
			<cfset passDate = Dateformat(dateEffective, 'yyyy-mm-dd')>
			<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor='FFFFFF'" bgcolor="FFFFFF" class="fixlengthlist">
				<td class="labelmedium2" style="font-size:17px" colspan="#dColumns - 1#" align="left" onClick="javascript: editvendorofferperdate('#offerid#','#mission#','#itemno#','#uom#','#orgunitvendor#','#passDate#');" style="cursor: pointer;" class="label">
					<b>#mission#</b> #Dateformat(dateEffective, "#CLIENT.DateFormatShow#")# - #lsNumberFormat(OfferMinimumQuantity, ",.__")# #UoMDescription#s minimum
				</td>
				<td colspan="1" align="right" style="padding-top:3px">
					
					<!--- <cfif currentrow eq 1> --->
					<table cellpadding="0" cellspacing="0" class="formspacing">
					 	<tr>
							<td>
								<cf_img icon="edit" onclick="editvendorofferperdate('#offerId#','#mission#','#itemno#','#uom#','#orgunitvendor#','#passDate#');">
							</td>
							<td>
							 	<cf_img icon="delete" onclick="if (confirm('Do you want to remove this portion ?')) {_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Warehouse/Maintenance/ItemMaster/vendors/vendorOfferPurgePerDate.cfm?offerid=#offerid#&mission=#url.mission#&itemno=#url.itemno#&uom=#uom#&orgunitvendor=#orgunitvendor#&effectiveDate=#passDate#','divVendorOfferListing');}">
							</td>
						</tr>
					</table>
					<!--- </cfif> --->
					
				</td>
			</tr>
			<tr><td height="3"></td></tr>
			<cfoutput>
			<tr class="labelmedium2 fixlengthlist">	
				<td></td>		
				<td>#LocationName# <font size="1">[#LocationCode#]</font></td>
				<td align="right">#currency#</td>
				<td align="right"><font color="808080">#lsNumberFormat(ItemPriceFixed, ",.__")#</td>
				<td align="right"><font color="808080">#lsNumberFormat(ItemPriceVariable, ",.__")#</td>
				<td align="right">#lsNumberFormat(ItemPrice, ",.__")#</td>
				<td align="right">#lsNumberFormat(ItemTax, ",._")#%</td>
				<td align="center"><cfif taxIncluded eq 0>No<cfelse>Yes</cfif></td>
				<td></td>
			</tr>
			</cfoutput>
			
		</cfoutput>
	
	<cfelse>	
		
		<tr class="labelmedium2"><td style="padding:4px" align="center" colspan="<cfoutput>#dColumns#</cfoutput>">No offers recorded</td></tr>		
		
	</cfif>
	<tr><td height="2"></td></tr>
	<tr><td height="1" colspan="<cfoutput>#dColumns#</cfoutput>" class="line"></td></tr>		
</table>

</div>

