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

	<cfparam name="form.taxexemption" default="0">
	
	<cfquery name="get"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_Tax
		WHERE TaxCode = '#Form.taxcode#'
	</cfquery>	
		
	<cf_getQuotation 
    element      = "netsale"
	quantity     = "#Replace(Form.Quantity,',','','all')#"
	price        = "#Replace(Form.Price,',','','all')#"
	taxcode      = "#Form.TaxCode#"
	taxexemption = "#Form.TaxExemption#">
	
	<cfset sale = round(amount*1000)/1000>
	
	<cf_getQuotation 
    element      = "nettax"
	quantity     = "#Replace(Form.Quantity,',','','all')#"
	price        = "#Replace(Form.Price,',','','all')#"
	taxcode      = "#Form.TaxCode#"
	taxexemption = "#Form.TaxExemption#">
	
		
	<cfset tax = round(amount*1000)/1000>
	
	<cfquery name="update" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE	WorkOrderLineItem
			SET		Quantity      = #Replace(Form.Quantity,",","","all")#,					
					SalePrice     = #Replace(Form.Price,",","","all")#,
					TaxCode       = '#Form.TaxCode#',
					BillingMode   = '#Form.BillingMode#',
					SaleType      = '#Form.SaleType#',
					CommodityCode = '#Form.CommodityCode#',
					<cfif get.TaxCalculation eq "Inclusive">
					TaxIncluded   = 1,
					<cfelse>
					TaxIncluded   = 0,
					</cfif>
					TaxExemption  = '#Form.TaxExemption#',
					SaleTax       = '#get.Percentage#',
					SaleAmountIncome = #sale#,
					<cfif form.TaxExemption eq "0">
						SaleAmountTax    = #tax#,
					<cfelse>
						SaleAmountTax    = 0,
					</cfif>					
					ItemMemo = <cfif trim(Form.ItemMemo) neq "">'#Form.ItemMemo#'<cfelse>null</cfif>
					
			WHERE   WorkOrderItemId  = '#url.WorkOrderItemId#'			
	</cfquery>
	
	
	<script>	  
	   parent.parent.Prosis.busy('yes')
	   parent.parent._cf_loadingtexthtml='';		   		 
	   parent.parent.document.getElementById('menu2').click()	 	   
	</script>	