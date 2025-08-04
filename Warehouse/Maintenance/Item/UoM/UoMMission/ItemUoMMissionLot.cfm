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
<cfquery name="GetLots" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ItemUoMMissionLot
		WHERE	ItemNo = '#URL.ID#'
		AND		UoM = '#URL.UoM#'
		AND 	Mission = '#URL.mission#'
</cfquery>

<cfoutput>
	<table width="100%" align="center" class="navigation_table">
		<tr>
			<td class="labelit" width="10%"><cf_tl id="Lot"></td>
			<td class="labelit" width="10%" style="padding-left:3px;"><cf_tl id="Barcode"></td>
			<td class="labelit" width="15%" style="padding-left:3px;"><cf_tl id="Effective"></td>
			<td class="labelit" width="15%" style="padding-left:3px;"><cf_tl id="Expiration"></td>
			<td class="labelit" width="50%" style="padding-left:3px;"><cf_tl id="Remarks"></td>
		</tr>
		<tr><td height="5"></td></tr>
		<tr><td colspan="5" class="line"></td></tr>
		<tr><td height="5"></td></tr>
		<cfif GetLots.recordcount eq 0>
			<tr>
				<td class="labelit" colspan="5" align="center">[<cf_tl id="No lots defined">]</td>
			</tr>
		</cfif>
		<cfloop query="GetLots">
			<tr class="navigation_row">
				<td class="labelit" width="10%">
					#TransactionLot#
					<input 
						type="Hidden" 
						id="lot_transactionLot_#TransactionLot#" 
						name="lot_transactionLot_#TransactionLot#" 
						value="#TransactionLot#">
				</td>
				<td class="labelit" width="10%" style="padding-left:3px;">
					<cf_tl id="Please enter a valid barcode for" var="1">
					<cfinput 
						type="Text" 
						id="lot_itemBarCode_#TransactionLot#" 
						name="lot_itemBarCode_#TransactionLot#" 
						value="#ItemBarCode#" 
						required="Yes" 
						size="5" 
						message="#lt_text# #itemBarCode#" 
						class="regularxl">
				</td>
				<td class="labelit" width="15%" style="padding-left:3px;">
					<cf_intelliCalendarDate9
						FieldName="lot_dateEffective_#TransactionLot#" 
						class="regularxl"
						Default="#dateformat(dateEffective, CLIENT.DateFormatShow)#"
						AllowBlank="true">
				</td>
				<td class="labelit" width="15%" style="padding-left:3px;">
					<cf_intelliCalendarDate9
						FieldName="lot_dateExpiration_#TransactionLot#" 
						class="regularxl"
						Default="#dateformat(dateExpiration, CLIENT.DateFormatShow)#"
						AllowBlank="true">
				</td>
				<td class="labelit" width="50%" style="padding-left:3px;">
					<cfinput 
						type="Text" 
						id="lot_remarks_#itemBarCode#" 
						name="lot_remarks_#itemBarCode#" 
						value="#Remarks#" 
						size="10"
						class="regularxl">
				</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>
