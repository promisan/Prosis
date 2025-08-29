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
<cfquery name="getElement" 
	datasource="AppsMaterials">
		SELECT 	*
		FROM 	Item
		WHERE	ItemNo = '#url.reference#'
</cfquery>

<cfquery name="getUoMs" 
	datasource="AppsMaterials">
		SELECT	U.ItemUoMId,
				U.ItemNo,
				I.ItemPrecision,
				U.UoM,
				U.UoMCode,
				U.UoMDescription,
				U.StandardCost,
				ItemUoMDetails,
				ItemUoMSpecs,
				ISNULL((
					SELECT	SUM(TransactionQuantity)
					FROM	ItemTransaction
					WHERE	Mission = '#url.mission#'
					AND		Warehouse = '#url.warehouse#'
					AND		ItemNo = U.ItemNo
					AND		TransactionUoM = U.Uom
				), 0) as OnHand
		FROM	ItemUoM U
				INNER JOIN Item I
					ON U.ItemNo = I.ItemNo
		WHERE	U.ItemNo = '#getElement.ItemNo#'
		AND		U.Operational = '1'
		AND		U.EnablePortal = '1'
		AND 	I.Operational = '1'
</cfquery>

<cfif getUoMs.recordCount eq 0>
	<cf_mobilerow style="padding:25px;">
		<cf_mobileCell class="col-lg-12" style="text-align:center;">
			<h2>[ <cf_tl id="No active unit of measures for this item"> ]</h2>
		</cf_mobileCell>
	</cf_mobilerow>
<cfelse>

	<cfoutput query="getElement">

		<cf_mobilerow style="padding-bottom:10px;">
		
			<cf_mobileCell class="col-lg-12">
				<div style="font-size:125%;"><b><cf_tl id="Units of Measure">:</div>
				<div style="padding-top:10px;" class="table-responsive">
					<table style="width:100%;" cellpadding="1" cellspacing="1" class="table table-bordered table-striped">
						<thead style="font-size:85%;">
							<th><cf_tl id="Code"></th>
							<th><cf_tl id="Description"></th>
							<th><cf_tl id="Details"></th>
							<th><cf_tl id="Specs"></th>
							<th style="text-align:right;"><cf_tl id="Std. Cost"></th>
							<th style="text-align:right;"><cf_tl id="On Hand"></th>
							<th style="text-align:right;"><cf_tl id="Request"></th>
						</thead>
						<tbody>
							<cfloop query="getUoMs">
								<cfset vNumberMask = ",.">
								<cfloop from="1" to="#ItemPrecision#" index="decNumber">
									<cfset vNumberMask = "#vNumberMask#_">
								</cfloop>
								<cfif vNumberMask eq ",.">
									<cfset vNumberMask = ",">
								</cfif>

								<tr>
									<td>#UoMCode#</td>
									<td>#UoMDescription#</td>
									<td>#ItemUoMDetails#</td>
									<td>#ItemUoMSpecs#</td>
									<td align="right">#lsNumberFormat(StandardCost, vNumberMask)#</td>
									<td align="right">#lsNumberFormat(OnHand, vNumberMask)#</td>
									<td align="right">
										<input type="Text" style="width:75px; text-align:right; font-size:125%;" value="" id="request_#itemNo#_#UoM#" name="request_#itemNo#_#UoM#">
									</td>
								</tr>
							</cfloop>
						</tbody>
					</table>
				</div>
			</cf_mobileCell>

		</cf_mobilerow>

		<cf_mobilerow class="clsNoPrint">
			<cf_mobileCell class="col-lg-12" style="text-align:center;">
				<cf_tl id="Request" var="1">
				<button class="btn btn-info" title="#lt_text#" style="width:40%;" onclick="_mobile_hideModal();">
					<i class="fa fa-shopping-cart" style="font-size:175%;"></i>
					<span class="visible-lg visible-sm visible-xs" style="text-transform:capitalize;">
						#lcase(lt_text)#
					</span>
				</button>
			</cf_mobileCell>
		</cf_mobilerow>

	</cfoutput>

</cfif>