
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

<table width="100%" cellspacing="0" cellpadding="0" align="center">
	<tr><td height="4"></td></tr>
	<tr><td height="1" colspan="<cfoutput>#dColumns#</cfoutput>" class="line"></td></tr>
	<tr><td height="2"></td></tr>
	<tr>
		<td colspan="<cfoutput>#dColumns - 1#</cfoutput>" class="labelmedium"><cf_tl id="Offers"></td>
		<td colspan="1" align="right">
		<cf_tl id="Record Offer" var="1">
		<cfoutput>
			<input value    = "#lt_text#" 
				class       = "button10g"
				type        = "Button"
				style       = "width:130px"
				id          = "addOffer"									
				onclick 	= "javascript: editvendorofferperdate('','#url.mission#','#itemno#','#url.uom#','#url.orgunitvendor#','');"> 
		 </cfoutput>		
		</td>
	</tr>
	<tr><td height="2"></td></tr>
	<tr><td height="1" colspan="<cfoutput>#dColumns#</cfoutput>" class="line"></td></tr>
	<tr><td height="2"></td></tr>
	
	<tr class="labelmedium">
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
		<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor='FFFFFF'" bgcolor="FFFFFF">
			<td class="labelmedium" colspan="#dColumns - 1#" align="left" onClick="javascript: editvendorofferperdate('#offerid#','#mission#','#itemno#','#uom#','#orgunitvendor#','#passDate#');" style="cursor: pointer;" class="label">
				<b>#Dateformat(dateEffective, "#CLIENT.DateFormatShow#")# - #lsNumberFormat(OfferMinimumQuantity, ",.__")# #UoMDescription#s minimum</b></font>
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
		<tr>	
			<td></td>		
			<td class="labelit">#LocationName# <font size="1">[#LocationCode#]</font></td>
			<td class="labelit" align="right">#currency#</td>
			<td class="labelit" align="right"><font color="808080">#lsNumberFormat(ItemPriceFixed, ",.__")#</td>
			<td class="labelit" align="right"><font color="808080">#lsNumberFormat(ItemPriceVariable, ",.__")#</td>
			<td class="labelit" align="right">#lsNumberFormat(ItemPrice, ",.__")#</td>
			<td class="labelit" align="right">#lsNumberFormat(ItemTax, ",._")#%</td>
			<td class="labelit" align="center"><cfif taxIncluded eq 0>No<cfelse>Yes</cfif></td>
			<td></td>
		</tr>
		</cfoutput>
		
	</cfoutput>
	<cfelse>
		<tr><td height="2"></td></tr>
		<tr><td align="center" class="labelmedium" colspan="<cfoutput>#dColumns#</cfoutput>"><font color="808080">No offers recorded</font></td></tr>
		<tr><td height="3"></td></tr>
	</cfif>
	<tr><td height="2"></td></tr>
	<tr><td height="1" colspan="<cfoutput>#dColumns#</cfoutput>" class="line"></td></tr>		
</table>
</div>

