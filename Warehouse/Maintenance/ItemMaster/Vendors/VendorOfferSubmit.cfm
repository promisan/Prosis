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


<cfif url.offerid eq "">

	<cfquery name="Insert" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">		
		
		INSERT INTO ItemVendorOffer (
				ItemNo,
				UoM,
				OrgUnitVendor,
				OfferId,
				Mission,
				<cfif trim(form.locationid) neq "">LocationId,</cfif>
				DateEffective,
				OfferMinimumQuantity,
				OfferMinimumVolume,
				Currency,
				ItemPrice,
				ItemTax,
				TaxIncluded,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName
			) 		 	  
		VALUES	(
				'#url.itemNo#',
				'#url.uom#',
				#url.orgunitvendor#,
				newId(),
				'#url.mission#',
				<cfif trim(form.locationid) neq "">'#form.locationid#',</cfif>
				#vDateEffective#,
				'#form.OfferMinimumQuantity#',
				'#form.OfferMinimumVolume#',
				'#form.currency#',
				#form.itemPrice#,
				#form.itemTax#,
				#form.taxIncluded#,
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#'
			)
	</cfquery>
	
<cfelse>

	<cfquery name="Update" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">		 		 	  
			 UPDATE 	ItemVendorOffer
			 SET		LocationId    = <cfif trim(form.locationid) neq "">'#form.locationid#'<cfelse>null</cfif>,
			 			DateEffective = #vDateEffective#,
						OfferMinimumQuantity = #form.offerminimumquantity#,
						Currency      = '#form.currency#',
						ItemPrice     = #form.itemPrice#,
						ItemTax       = #form.itemTax#,
						TaxIncluded   = #form.taxIncluded#
			 WHERE     	ItemNo        = '#url.itemno#'
			 AND		UoM           = '#url.uom#'
			 AND		OrgUnitVendor = #url.orgunitvendor#
			 AND		OfferId       = '#url.offerid#'
	</cfquery>

</cfif>

<cfoutput>
	<script>
		ColdFusion.navigate('#SESSION.root#/Warehouse/Maintenance/ItemMaster/Vendors/VendorListing.cfm?id=#url.itemno#&mission=#url.mission#&uom=#url.uom#&orgunitvendor=#url.orgunitvendor#','divVendorListing');
		try { ProsisUI.closeWindow('mydialog') } catch(e) {}
	</script>
</cfoutput>