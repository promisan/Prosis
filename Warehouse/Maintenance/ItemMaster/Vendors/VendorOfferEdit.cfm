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

<cfparam name="url.offerid" default="">

<cfquery name="get" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT    	O.*,
		 			(
						SELECT 	OrgUnitName 
						FROM 	Organization.dbo.Organization
						WHERE	Mission = (SELECT TreeVendor FROM Purchase.dbo.Ref_ParameterMission WHERE Mission = '#url.mission#')
						AND 	OrgUnit = O.OrgUnitVendor
					) as VendorName,
					(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = '#url.itemno#' AND UoM = O.UoM) as UoMDescription,
					(SELECT ItemDescription FROM Item WHERE ItemNo = '#url.itemno#') as ItemDescription
		 FROM      	ItemVendorOffer O
		 WHERE     	O.ItemNo = '#url.itemno#'
		 AND		O.UoM    = '#url.uom#'
		 AND		O.OrgUnitVendor = #url.orgunitvendor#
		 <cfif url.offerid neq "">	
		 AND		O.OfferId = '#url.offerid#'
		 <cfelse>
		 AND		1 = 0
		 </cfif>
		
</cfquery>

<cfquery name="getHeader" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT    	V.*,		 			
		 			(
						SELECT 	OrgUnitName 
						FROM 	Organization.dbo.Organization
						WHERE	Mission = (SELECT TreeVendor FROM Purchase.dbo.Ref_ParameterMission WHERE Mission = '#url.mission#')
						AND 	OrgUnit = V.OrgUnitVendor
					) as VendorName,
					(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = '#url.itemno#' AND UoM = V.UoM) as UoMDescription,
					(SELECT ItemDescription FROM Item WHERE ItemNo = '#url.itemno#') as ItemDescription
		 FROM      	ItemVendor V
		 WHERE     	V.ItemNo = '#url.itemno#'		 
		 AND		V.OrgUnitVendor = #url.orgunitvendor#
</cfquery>

<cfif url.offerid neq "">	
	<cf_screentop height="100%" scroll="Yes" html="Yes" label="Vendor Offer" option="Maintain Vendor Offer" layout="webapp" banner="yellow" user="no">
<cfelse> 
	<cf_screentop height="100%" scroll="Yes" html="Yes" label="Vendor Offer" option="Add Vendor Offer" layout="webapp" user="no">
</cfif>

<cfoutput>

<table class="hide">
	<tr><td><iframe name="processeditvendoroffer" id="processeditvendoroffer" frameborder="0"></iframe></td></tr>
</table>

<cfform name="frmeditvendoroffer" method="POST" target="processeditvendoroffer" action="vendors/vendorOfferSubmit.cfm?itemno=#url.itemno#&mission=#url.mission#&uom=#url.uom#&orgunitvendor=#url.orgunitvendor#&offerid=#url.offerid#">

<table width="90%" align="center" class="formpadding formspacing>
	<tr><td height="5"></td></tr>
	<tr class="fixlengthlist">
		<td style="height:25px" width="25%" class="labelmedium"><cf_tl id="Item">:</td>
		<td class="labelmedium">#getHeader.ItemDescription#</td>
	</tr>
	<tr class="fixlengthlist">
		<td style="height:25px" class="labelmedium"><cf_tl id="UoM">:</td>
		<td class="labelmedium">#getHeader.UoMDescription#</td>
	</tr>
	<tr class="fixlengthlist">
		<td style="height:25px" class="labelmedium"><cf_tl id="Vendor">:</td>
		<td class="labelmedium">#getHeader.VendorName#</td>
	</tr>
	<tr class="fixlengthlist">
		<td class="labelmedium" ><cf_tl id="Location">:</td>
		<td class="labelmedium">
		
			<cfquery name="getLocations" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT 	L.*,
						(LocationCode + ' - ' + LocationName) as LocationDisplay,
						C.Description as ClassDescription
				FROM   	Location L,
						Ref_LocationClass C
				WHERE  	L.LocationClass = C.Code
				AND		L.Mission = '#url.mission#'
			</cfquery>
			
			<cfselect 	name="locationId" 
						value="location" 
						class="regularxl"
						display="LocationDisplay" 
						group="ClassDescription" 
						query="getLocations" 
						selected="#get.LocationId#"/>
		</td>
	</tr>
	<tr class="fixlengthlist">
		<td ><cf_tl id="Effective">:</td>
		<td class="labelmedium">
		
			<cfset defaultEffective = now()>
			<cfif url.dateEffective neq "">
				<cfset defaultEffective = get.dateEffective>
			</cfif>
			
			<cf_intelliCalendarDate9
					FieldName="DateEffective"
					Message="Select a valid Effective Date"
					class="regularxl"
					Default="#dateformat(defaultEffective, CLIENT.DateFormatShow)#"
					AllowBlank="True"> 
		</td>
	</tr>
	
	<tr class="fixlengthlist">
		<td class="labelmedium" ><cf_tl id="Minimum Qty">:</td>
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
				required="Yes" validate="numeric" message="Please, enter a valid volume." class="regularxl" size="4">
		</td>
		</tr>
		</table>
		</td>
	</tr>
	<!--- <tr>
		<td>UoM Multiplier:</td>
		<td>
			<cfinput type="Text" name="OfferUoMMultiplier" value="#get.OfferUoMMultiplier#" 
				required="Yes" validate="integer" message="Please, enter a valid uom multiplier." size="10">
		</td>
	</tr> --->
	
	<tr class="fixlengthlist">
		<td class="labelmedium" ><cf_tl id="Price">:</td>
		<td>
			<cfquery name="getLookup" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   Currency
				where  Operational = 1				
			</cfquery>
			
			<cfif get.currency eq "">
			   <cfset curr = APPLICATION.BaseCurrency>
			<cfelse>
			   <cfset curr = get.currency>   
			</cfif>
								
			<select name="currency" id="currency" class="regularxl">
				<cfloop query="getLookup">
				  <option value="#getLookup.currency#" <cfif curr eq getLookup.currency>selected</cfif>>#getLookup.currency# - #getLookup.description#</option>
			  	</cfloop>
			</select>
			&nbsp;
			<cfinput type="Text" class="regularxl" name="ItemPrice" value="#get.ItemPrice#" 
				required="Yes" validate="numeric" message="Please, enter a valid price." size="10">
			&nbsp;
			<cf_tl id="Tax">
			<cfinput type="Text" class="regularxl" name="ItemTax" value="#get.ItemTax#" 
				required="Yes" validate="numeric" message="Please, enter a valid tax." size="10">
		</td>
	</tr>
	
	<tr class="fixlengthlist">
		<td  class="labelmedium"><cf_tl id="Tax Included">:</td>
		<td class="labelmedium">
			<input type="radio" name="taxIncluded" id="taxIncluded" value="0" <cfif get.taxIncluded eq "0" or url.offerid eq "">checked</cfif>>No
			<input type="radio" name="taxIncluded" id="taxIncluded" value="1" <cfif get.taxIncluded eq "1">checked</cfif>>Yes
		</td>
	</tr>	
	
	<tr><td height="10"></td></tr>
	<tr><td colspan="2" height="1" class="line"></td></tr>
	<tr><td height="10"></td></tr>
	
	<tr>
		<td colspan="2" align="center">
			<input class    = "button10g"
				value       = "Save" 
				type        = "Submit"
				id          = "save"					
				width       = "140px" 					
				color       = "636334"
				fontsize    = "11px"> 
		</td>
	</tr>
	
</table>

</cfform>

</cfoutput>

<cfset ajaxonload("doCalendar")> 