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

<cfif url.SelectionDate neq "">
     <cfset dateValue = "">
	 <cf_DateConvert Value="#url.SelectionDate#">
	 <cfset dte = dateValue>	
</cfif>	

<cfquery name="SearchResult"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  P.ReceiptNo, 
				P.Currency,
				P.DeliveryDateEnd,
				P.WarehouseItemNo as ItemNo,
				ISNULL(I.ItemDescription,'[Not defined]') as ItemDescription,
				P.WarehouseUoM as UoM,
				U.UoMDescription,
				AVG(P.ReceiptPrice) as ReceiptPrice
		FROM    Purchase.dbo.PurchaseLineReceipt P
				LEFT OUTER JOIN Item I
					ON P.WarehouseItemNo = I.ItemNo
				LEFT OUTER JOIN ItemUoM U
					ON P.WarehouseItemNo = U.ItemNo
					AND	P.WarehouseUoM = U.UoM
		WHERE	P.Warehouse = '#url.warehouse#'
		AND		P.ActionStatus = '1'
		AND		P.DeliveryDateEnd >= #dte#
		AND		I.Category = '#url.category#'
		GROUP BY P.ReceiptNo, 
				P.Currency,
				P.DeliveryDateEnd,
				P.WarehouseItemNo,
				I.ItemDescription,
				P.WarehouseUoM,
				U.UoMDescription
		ORDER BY P.ReceiptNo DESC
</cfquery>

<cfquery name="SearchResultDetail"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	P.*,
				S.Description as PriceScheduleDescription
		FROM 	ItemUoMPrice P
				INNER JOIN Ref_PriceSchedule S
					ON P.PriceSchedule = S.Code
		WHERE 	P.Mission = '#url.mission#'
		AND		P.Warehouse = '#url.warehouse#'
		AND		P.Currency = '#url.currency#' 
</cfquery>

<cfloop query="SearchResult">
	<cfquery name="qSearchResultDetail" dbtype="query">
		SELECT 	*
		FROM 	SearchResultDetail
		WHERE	ItemNo = '#ItemNo#'
		AND		UoM = '#UoM#'
	</cfquery>
	
	<cfloop query="qSearchResultDetail">
		<cfset vPriceId = replace(priceId,"-","","ALL") & "_" & replace(SearchResult.receiptno,"-","","ALL")>
		<cfif isDefined("Form.en_#vPriceId#")>
			<cfquery name="validate"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	*
					FROM 	ItemUoMPrice
					WHERE 	ItemNo        = '#ItemNo#'
					AND		UoM           = '#UoM#'
					AND		PriceSchedule = '#PriceSchedule#'
					AND		Mission       = '#url.mission#'
					AND		Warehouse     = '#url.warehouse#'
					AND		Currency      = '#url.currency#' 
					AND		DateEffective = '#dateFormat(SearchResult.deliveryDateEnd,"yyyymmdd")#'
			</cfquery>
			
			<cfset vSalesPrice = evaluate("Form.SalesPrice_#vPriceId#")>
			<cfset vSalesPrice = replace(vSalesPrice,",","","ALL")>
			
			<cfset vTaxCode = evaluate("Form.TaxCode_#vPriceId#")>
			
			<cfif validate.recordCount eq 0 and vSalesPrice gt 0>
			
				<cfquery name="insert"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO ItemUoMPrice
						(
							ItemNo,
							UoM,
							PriceSchedule,
							Mission,
							Warehouse,
							Currency,
							DateEffective,
							SalesPrice,
							TaxCode,
							CalculationMode,
							CalculationClass,
							CalculationPointer,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					VALUES ('#ItemNo#',
							'#UoM#',
							'#PriceSchedule#',
							'#Mission#',
							'#Warehouse#',
							'#Currency#',
							'#dateFormat(SearchResult.deliveryDateEnd,"yyyymmdd")#',
							#vSalesPrice#,
							'#vTaxCode#',
							'#CalculationMode#',
							'#CalculationClass#',
							'#CalculationPointer#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#' )
				</cfquery>
				
			<cfelse>
			
				<cfquery name="update"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE ItemUoMPrice
					SET    SalesPrice = #vSalesPrice#,
						   TaxCode = '#vTaxCode#'
					WHERE  PriceId = '#PriceId#'
				</cfquery>
			
			</cfif>
			
		</cfif>
	</cfloop>

</cfloop>


<cfoutput>
	<script>
		ptoken.navigate('../../SalesOrder/Pricing/Form/PricingForm.cfm?mission=#url.mission#&warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#&currency=#url.currency#&category=#url.category#&selectionDate=#url.SelectionDate#&mid=#url.mid#','contentbox1');
	</script>
</cfoutput>