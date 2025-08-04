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

<cfif url.dateEffective neq "">
	<cfset vyear   = mid(url.dateEffective, 1, 4)>
	<cfset vmonth  = mid(url.dateEffective, 6, 2)>
	<cfset vday    = mid(url.dateEffective, 9, 2)>
	<cfset vEffectiveDate = createDate(vyear, vmonth, vday)>
</cfif>

<cfquery name="get" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  		 
		 SELECT L.Location,
		 		L.LocationCode,
				L.LocationName,
				L.LocationClass,
				(SELECT Description FROM Ref_LocationClass WHERE Code = L.LocationClass) AS LocationClassDescription,
				O.*,
				(	SELECT 	OrgUnitName 
					FROM 	Organization.dbo.Organization
					WHERE	Mission = (SELECT TreeVendor FROM Purchase.dbo.Ref_ParameterMission WHERE Mission = '#url.mission#')
					AND 	OrgUnit = O.OrgUnitVendor
				) as VendorName,
				
				(SELECT UoMDescription  FROM ItemUoM WHERE ItemNo = '#url.itemno#' AND UoM = O.UoM) as UoMDescription,
				(SELECT ItemDescription FROM Item    WHERE ItemNo = '#url.itemno#') as ItemDescription,
				
				(	SELECT 	  TOP 1 ItemPriceFixed 
					FROM 	  ItemVendorOffer 
					WHERE 	  ItemNo        = '#url.itemno#'
					AND		  UoM           = '#url.uom#'
					AND		  OrgUnitVendor = #url.orgunitvendor#		
					AND		  Mission       = L.Mission
					AND		  LocationId    = L.Location
					AND		  DateEffective < #vEffectiveDate#
					ORDER BY  DateEffective DESC
				) as LastPriceFixed
				
		FROM	Location L
				LEFT OUTER JOIN ItemVendorOffer O 
					ON		L.Location = O.LocationId 
					AND		O.ItemNo = '#url.itemno#'
					AND		O.UoM = '#url.uom#'
					AND		O.OrgUnitVendor = #url.orgunitvendor#				
					<cfif url.dateEffective neq "">	
					AND		DAY(O.DateEffective) = #vday# and MONTH(O.DateEffective) = #vmonth# and YEAR(O.DateEffective) = #vyear#
					<cfelse>
					AND		1 = 0
					</cfif>
		WHERE	L.StockLocation = 1
		AND		L.Mission = '#url.mission#'
		ORDER BY L.TreeOrder
		
</cfquery>

<cfquery name="getCurrency" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Currency
	where  Operational = 1
</cfquery>


<!--- DO NOT REMOVE THE CFFORM THAT IS COMMENTED, THIS IS A WORKAROUND TO BE ABLE TO PLACE CFINPUTS INSIDE A CFDIV --->
<!-- <cfform name="frmeditvendoroffer" method="POST" target="processeditvendoroffer" action="vendors/vendorOfferPerDateSubmit.cfm?itemno=#url.itemno#&mission=#url.mission#&uom=#url.uom#&orgunitvendor=#url.orgunitvendor#&dateEffective=#url.dateEffective#"> -->
<table width="100%" align="center">
<tr>
	<td width="25%" class="labelmedium" style="height:25px"><cf_tl id="Currency">:</td>
	<td>										
		<cfif get.currency eq "">
		   <cfset curr = APPLICATION.BaseCurrency>
		<cfelse>
		   <cfset curr = get.currency>   
		</cfif>
							
		<select name="currency" id="currency" class="regularxl">
			<cfoutput query="getCurrency">
			  <option value="#getCurrency.currency#" <cfif curr eq getCurrency.currency>selected</cfif>>#getCurrency.currency# - #getCurrency.description#</option>
		  	</cfoutput>
		</select>
	</td>					
</tr>
<tr><td height="3"></td></tr>
<tr>
	<td height="20" class="labelmedium"><cf_tl id="Minimum Quantity">:</td>
	<td>
	<table>
		<tr>		
		<td class="labelmedium">
			<cfinput type="Text" name="OfferMinimumQuantity" value="#get.offerMinimumQuantity#" style="text-align:right"
				required="Yes" validate="numeric" message="Please, enter a valid minimum quantity." class="regularxl" size="4">
		</td>
		<td style="padding-left:5px" class="labelmedium" ><cf_tl id="Volume">:</td>
		<td class="labelmedium" style="padding-left:5px">
			<cfinput type="Text" name="OfferMinimumVolume" value="#get.offerMinimumVolume#" style="text-align:right" 
				required="Yes" validate="numeric" message="Please, enter a valid minimum quantity." class="regularxl" size="4">
		</td>
		</tr>
		</table>
	</td>
	
</tr>	
<tr><td height="2"></td></tr>
<tr>
	<td height="20" class="labelmedium"><cf_tl id="Batch">:</td>
	<td>
		<cfinput type="Text" name="offerreference" value="#get.offerreference#" 
			required="No" class="regularxl" message="Please, enter a valid reference." size="25" maxlength="20">
	</td>
</tr>

<tr><td height="5"></td></tr>
<tr>
	<td colspan="2">
		<cf_filelibraryN 
			DocumentPath="Warehouse" 
			SubDirectory="VendorOffer_#url.itemno#_#url.uom#_#url.orgunitvendor#_#url.dateEffective#" 
			Filter="" 
			Insert="yes" 
			Remove="yes" 
			LoadScript="false" 
			rowHeader="no" 
			ShowSize="yes"> 
	</td>
</tr>

<tr><td height="10"></td></tr>
<tr>
	<td colspan="2">
		<table width="100%" align="center">
			<cfset vColumns = 7>
			<tr><td height="1" class="line" colspan="<cfoutput>#vColumns#</cfoutput>"></td></tr>
			<tr class="labelmedium line">
				<td height="20" width="20"></td>
				<td><cf_tl id="Price Location"></td>	
				<td><cf_tl id="Fixed"></td>
				<td><cf_tl id="Variable"></td>	
				<!---
				<td><cf_tl id="Price"></td>
				--->
				<td><cf_tl id="Tax"></td>
				<td align="center"><cf_tl id="Tax Included"></td>
				<td width="20"></td>
			</tr>
						
			<cfoutput query="get" group="LocationClass">					
				<tr class="labelmedium"><td colspan="#vColumns#">#LocationClassDescription#</td></tr>
				<cfoutput>
				
					<tr style="height:30px" onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor='FFFFFF'" bgcolor="FFFFFF">
						<td></td>
						<cfset vLocationFormatted = replace("#get.location#","-","","ALL")>
						<input type="Hidden" name="location_#vLocationFormatted#" id="location_#vLocationFormatted#" value="#get.location#">
						<input type="Hidden" name="offerId_#vLocationFormatted#" id="offerId_#vLocationFormatted#" value="#get.offerId#">
						<td class="labelmedium">#locationName#</td>	
						
						<cfset fixed = 0>
						<cfif get.ItemPriceFixed neq "">
							<cfset fixed = get.ItemPriceFixed>
						<cfelse>
							<cfif get.LastPriceFixed neq "">
								<cfset fixed = get.LastPriceFixed>
							</cfif>
						</cfif>
						
						<td>
							<cfinput type="Text" name="ItemPriceFixed_#vLocationFormatted#" id="ItemPriceFixed_#vLocationFormatted#" value="#numberformat(fixed,',__.__')#" 
								required="Yes" class="regularxl" validate="numeric" message="Please, enter a valid numeric price for [#locationName#]." 
								size="10" style="text-align:right;">
						</td>
						<td>					
							<cfinput type="Text" name="ItemPriceVariable_#vLocationFormatted#" id="ItemPriceVariable_#vLocationFormatted#" value="#numberformat(get.ItemPriceVariable,',__.__')#" 
								required="Yes" class="regularxl" validate="numeric" message="Please, enter a valid numeric price for [#locationName#]." 
								size="10" style="text-align:right;">
						</td>		
						<!---	
						<td>					
							<input type="Text" name="ItemPrice_#vLocationFormatted#" id="ItemPrice_#vLocationFormatted#" value="#get.ItemPrice#" 
								required="Yes" validate="numeric" message="Please, enter a valid numeric price for [#locationName#]." readonly
								size="10" style="text-align:right;">
						</td>
						--->
						<td>
							<cfinput type="Text" name="ItemTax_#vLocationFormatted#" id="ItemTax_#vLocationFormatted#" value="#numberformat(get.ItemTax,'._')#" 
								required="Yes" class="regularxl" validate="numeric" message="Please, enter a valid numeric tax for [#locationName#]." 
								size="2" maxlength="4" style="text-align:right;">%
						</td>			
						<td align="center">
							<input type="Checkbox" class="radiol" name="taxIncluded_#vLocationFormatted#" id="taxIncluded_#vLocationFormatted#" <cfif get.taxIncluded eq "1">checked</cfif>>				
						</td>
						<td align="center">
							<cfif currentrow eq 1>
								<img src="#SESSION.root#/Images/copy.png" title="Copy these values to the rest of locations" style="cursor: pointer;" width="14" height="14" border="0" align="middle" 
									onClick="javascript: cloneOffers('#vLocationFormatted#');">
							</cfif>
						</td>
					</tr>
				</cfoutput>
			</cfoutput>			
		</table>
	</td>
</tr>
<tr><td height="10"></td></tr>
<tr><td colspan="2" height="1" class="line"></td></tr>
<tr><td height="10"></td></tr>

<cfif url.offerId eq "" or get.offerid eq url.offerid>
	
	<tr>
		<td colspan="2" align="center">
			<input	mode        = "silver"
					value       = "Save" 
					type        = "Submit"
					class       = "button10g"
					id          = "save"> 
		</td>
	</tr>
	
</cfif>

</table>
<!-- </cfform> -->		