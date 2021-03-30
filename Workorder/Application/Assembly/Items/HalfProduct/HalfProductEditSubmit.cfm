
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
					Warehouse     = '#Form.Warehouse#',
					TransactionLot = '#Form.TransactionLot#',
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
					</cfif>					
					ItemMemo = <cfif trim(Form.ItemMemo) neq "">'#Form.ItemMemo#'<cfelse>null</cfif>
					
			WHERE   WorkOrderItemId  = '#url.WorkOrderItemId#'			
	</cfquery>
	
	<script>
	   parent.parent.Prosis.busy('yes')
	   parent.parent._cf_loadingtexthtml='';	
	   parent.parent.ProsisUI.closeWindow('mydialog')			 
	   parent.parent.document.getElementById('menu2').click()	 
	   
	</script>	