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