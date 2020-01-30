
<cfquery name="getExchange" 
	 datasource="AppsLedger" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   CurrencyExchange 
	 WHERE  Currency = '#url.currency#' 			
	 ORDER BY EffectiveDate DESC
</cfquery>	

<cfif getExchange.ExchangeRate gt "0">
	
	<cfquery name="setPrices" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 UPDATE    PurchaseLineReceipt
		 SET       ExchangeRate          = '#getExchange.ExchangeRate#', 
		     	   ReceiptAmountBaseCost = round(ReceiptAmountCost / '#getExchange.ExchangeRate#',3), 
			       ReceiptAmountBaseTax  = round(ReceiptAmountTax / '#getExchange.ExchangeRate#',3)
		 WHERE     ReceiptNo = '#url.receiptNo#'
		 AND       Currency  = '#url.currency#'
		 
	</cfquery>

</cfif>

<script>
 history.go()
</script>		 