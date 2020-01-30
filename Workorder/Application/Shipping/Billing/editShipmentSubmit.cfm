			 
<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      ItemTransaction
	WHERE     TransactionId = '#url.TransactionId#'	
</cfquery>  
			 
<cfquery name="getship" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      ItemTransactionshipping
	WHERE     TransactionId = '#url.TransactionId#'	
</cfquery>  

<cfset prc  = Form.SalesPrice>

<cfset amt  = prc * get.TransactionQuantity * -1>

<cfif getShip.TaxExemption eq "1">

	<cfset tax  = 0>
		
<cfelse>

	<cfif getShip.TaxIncluded eq "0">
		<cfset tax = amt * getShip.TaxPercentage>
	<cfelse>
		<cfset tax = amt/(1+getShip.TaxPercentage) * getShip.TaxPercentage>
		<cfset amt = amt - tax>
	</cfif>

	    
</cfif>

<cfset amtB = amt/getShip.ExchangeRate>
<cfset amtB = round(amtB*100)/100>

<cfset amtT = tax/getShip.ExchangeRate>
<cfset amtT = round(amtT*100)/100>
			 
<cfquery name="update" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	UPDATE    ItemTransactionShipping
	
	SET       CommodityCode   = '#form.CommodityCode#',
			  SalesPrice      = '#prc#',
			  SalesAmount     = '#amt#',
			  SalesTax        = '#tax#',
			  SalesBaseAmount = '#amtB#',
			  SalesBaseTax    = '#amtT#'
			  
	WHERE     TransactionId = '#url.TransactionId#'	
	
</cfquery>  

<cfoutput>

	<script>
	try { ColdFusion.Window.destroy('executetask',true)} catch(e){}	
	ColdFusion.navigate('BillingEntryDetail.cfm?workorderid=#get.WorkOrderId#&systemfunctionid=#url.systemfunctionid#','mycontent')		
	</script>

</cfoutput>