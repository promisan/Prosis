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

<cfset form.ElementOrder = replace(form.ElementOrder, ",", "", "ALL")>
<cfset form.Discount = replace(form.Discount, ",", "", "ALL")>
<cfset form.Quantity = replace(form.Quantity, ",", "", "ALL")>

<cfset vDiscount = form.Discount>
<cfif form.DiscountType eq "percentage">
	<cfset vDiscount = form.Discount / 100>
</cfif>

<cfset vElementSerialNo = 1>

<cfif url.serial eq "">

	<cf_AssignSerial promotionId = "#url.promotionId#">

	<cfset vElementSerialNo = pElementSerialNo>

	<cfquery name="Insert" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO PromotionElement
				(
					PromotionId,
					ElementSerialNo,
					ElementOrder,
					ElementName,
					DiscountType,
					Discount,
					Quantity,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName
				)
			VALUES
				(
					'#url.promotionId#',
					'#vElementSerialNo#',
					#form.ElementOrder#,
					'#form.ElementName#',
					'#form.DiscountType#',
					#vDiscount#,
					#form.Quantity#,
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#'
				)
	</cfquery>

<cfelse>

	<cfset vElementSerialNo = url.serial>

	<cfquery name="Update" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	PromotionElement
			SET
				ElementOrder = #form.ElementOrder#,
				ElementName = '#form.ElementName#',
				DiscountType = '#form.DiscountType#',
				Discount = #vDiscount#,
				Quantity = #Form.Quantity#
			WHERE	PromotionId = '#url.promotionId#'
			AND		ElementSerialNo = #vElementSerialNo#
	</cfquery>


</cfif>

<cfdiv id="dummy">

<cfoutput>
	<script>
		ColdFusion.navigate('ElementEditForm.cfm?idmenu=#url.idmenu#&promotionid=#url.promotionid#&serial=#vElementSerialNo#','divElementEditHead');
		ColdFusion.navigate('ElementCategoryItem/ElementCategoryItem.cfm?idmenu=#url.idmenu#&promotionid=#url.promotionid#&serial=#vElementSerialNo#','divElementEditDetail');
		parent.elementrefresh('#url.promotionid#')
	</script>
</cfoutput>