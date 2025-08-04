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

<cfquery name="Total" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT  SUM(Quantity * UoMRate) AS Total
		 FROM    PurchaseLineTravel
		 WHERE   RequisitionNo      = '#URL.ID#'		 
</cfquery>

<cfquery name="Exc"
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT TOP 1 * 
		FROM       CurrencyExchange
	    WHERE      Currency = '#Form.Ratecurrency#'
		AND        EffectiveDate <= getDate()
		ORDER BY   EffectiveDate DESC
</cfquery>	 
		
<cfset pr = numberformat(Total.Total/Exc.ExchangeRate,".__")>
		
<cfquery name="Update" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  UPDATE PurchaseLine
	  SET	 OrderItemNo           = '#Form.OrderItemNo#',
		     OrderItem             = '#Form.OrderItem#',
		     OrderQuantity         = '1', 
		     OrderUoM              = 'Package', 
		     OrderMultiplier       = '1',
		     Currency              = '#Form.RateCurrency#',
		     OrderZero             = 0,			
		     OrderPrice            = '#Total.Total#',
		     OrderDiscount         = '0',
		     OrderTax              = '0', 
		     TaxIncluded           = '1',
			 OrderAmountCost       = '#Total.Total#',
			 OrderAmountTax        = '0', 
			 ExchangeRate          = '#Exc.ExchangeRate#',
			 OrderAmountBaseCost   = '#pr#', 
			 OrderAmountBaseTax    = '0'
	  WHERE RequisitionNo = '#URL.ID#'
</cfquery>