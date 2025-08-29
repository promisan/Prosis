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
<cfset dateValue = "">
<cf_DateConvert Value="#Form.dateEffective#">
<cfset vDateEffective = dateValue>

<cfquery name="getLocations" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM   	Location
	WHERE	StockLocation = 1
	AND		Mission = '#url.mission#'
</cfquery>

<cfquery name="Validate" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	
	SELECT 	*
	FROM 	ItemVendorOffer
	WHERE  	ItemNo        = '#url.itemno#'
	AND		UoM           = '#url.uom#'
	AND		OrgUnitVendor = #url.orgunitvendor#
	AND		DateEffective = #vDateEffective#
	
</cfquery>

<cfloop query="getLocations">
	<cfset vLocationFormatted = replace(location,"-","","ALL")>	
	
	<cfif isDefined('form.location_#vLocationFormatted#')>
	
		<cfset vLocationId    = Evaluate("form.location_#vLocationFormatted#")>
		<cfset vItemPriceFix  = Evaluate("form.ItemPriceFixed_#vLocationFormatted#")>
		<cfset vItemPriceFix  = replace(vItemPriceFix,",","")>
		
		<cfset vItemPriceVar  = Evaluate("form.ItemPriceVariable_#vLocationFormatted#")>
		<cfset vItemPriceVar  = replace(vItemPriceVar,",","")>
		
		
		<cfif vItemPriceFix eq "">
		  <cfset vItemPriceFix = "0">
		</cfif>
		
		<cfif vItemPriceVar eq "">
		  <cfset vItemPriceVar = "0">
		</cfif>
		
		<cfset vItemPrice = vItemPriceFix+vItemPriceVar>
		
		<cfset vItemTax = Evaluate("form.ItemTax_#vLocationFormatted#")>
		<cfset vTaxIncluded = 0>
		
		<cfif isDefined('form.TaxIncluded_#vLocationFormatted#')><cfset vTaxIncluded = 1></cfif>					
						
		<cfif validate.recordcount eq 0>
			
				<cfquery name="Insert" 
				    datasource="AppsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">		
					
					INSERT INTO ItemVendorOffer	(
							ItemNo,
							UoM,
							OrgUnitVendor,
							OfferId,
							Mission,
							LocationId,
							DateEffective,
							OfferMinimumQuantity,
							OfferMinimumVolume,
							Currency,
							ItemPriceFixed,
							ItemPriceVariable,
							ItemPrice,
							ItemTax,
							TaxIncluded,
							Offerreference,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						) 		 	  
					VALUES (
							'#url.itemNo#',
							'#url.uom#',
							#url.orgunitvendor#,
							newId(),
							'#url.mission#',
							'#vLocationId#',
							#vDateEffective#,
							'#form.OfferMinimumQuantity#',
							'#Form.OfferMinimumVolume#',
							'#form.currency#',
							#vItemPriceFix#,
							#vItemPriceVar#,
							#vItemPrice#,
							#vItemTax#,
							#vTaxIncluded#,
							'#form.offerreference#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
						)
				</cfquery>					
			
		<cfelse>
		
			<cfset vOfferId = Evaluate("form.OfferId_#vLocationFormatted#")>
			
				<cfquery name="Update" 
				    datasource="AppsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">		 		 	  
						 UPDATE 	ItemVendorOffer
						 SET		LocationId      = '#vLocationId#',
						 			DateEffective   = #vDateEffective#,
									OfferMinimumQuantity = #form.offerminimumquantity#,
									Currency            = '#form.currency#',
									ItemPriceFixed      = #vItemPriceFix#,
									ItemPriceVariable   = #vItemPriceVar#,
									ItemPrice           = #vItemPrice#,
									ItemTax             = #vItemTax#,
									TaxIncluded         = #vTaxIncluded#,
									OfferReference      = '#form.offerreference#'
						 WHERE     	ItemNo  = '#url.itemno#'
						 AND		UoM     = '#url.uom#'
						 AND		OrgUnitVendor = #url.orgunitvendor#
						 AND		OfferId = '#vOfferId#'
				</cfquery>
		
		</cfif>

	</cfif>
		
</cfloop>


<cfoutput>
	<script>
		ColdFusion.navigate('#SESSION.root#/Warehouse/Maintenance/ItemMaster/Vendors/VendorListing.cfm?id=#url.itemno#&mission=#url.mission#&uom=#url.uom#&orgunitvendor=#url.orgunitvendor#','divVendorListing');
		try { ProsisUI.closeWindow('offerdialog') } catch(e) {}
	</script>
</cfoutput>