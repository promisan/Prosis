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

<!--- cancelling return --->

<cfquery name="get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM       ItemTransaction 
		WHERE      TransactionId  = '#url.returnid#' 		
</cfquery>


<cfquery name="Item" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM       Item
		WHERE      ItemNo  = '#get.ItemNo#' 		
</cfquery>

<cf_stockTransactDelete TransactionId = "#url.returnid#">

<!--- adjust the consignment receipt --->
					
<cfquery name="Line" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">					
		SELECT * 
		FROM   Purchase.dbo.PurchaseLineReceipt							
		WHERE  ReceiptId = '#get.ReceiptId#'												
</cfquery>

<cfset rcpt = Line.ReceiptQuantity - get.TransactionQuantity/Line.ReceiptMultiplier>										
<cfset dis  = Line.ReceiptDiscount*100> 					
<cfset damt = Line.ReceiptPrice*rcpt*((100-dis)/100)>

<cfif Line.TaxIncluded eq "1">
		
	 	<cfset cost = damt*(1/(1+Line.ReceiptTax))>
		<cfset tax  = damt*(Line.ReceiptTax/(1+Line.ReceiptTax))>
		<cfset cost = round(cost*1000)/1000>				  
		<cfset tax  = round(tax*1000)/1000>
		  					
<cfelse>

	  	<cfset cost = round(damt*1000)/1000>
		<cfset tax  = damt*Line.ReceiptTax>

</cfif>
		
<!--- 31/12/2011 
added provision to not take tax if the purchase line does not have tax either --->
							
<cfset costB = round((cost/Line.ExchangeRate)*1000)>
<cfset costB = costB/1000>
<cfset taxb  = round((tax/Line.ExchangeRate)*1000)>
<cfset taxB  = taxB/1000>					
				
<cfquery name="set" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">					
		UPDATE Purchase.dbo.PurchaseLineReceipt
		SET    ReceiptQuantity       = '#rcpt#',				    
		       ReceiptAmountCost     = '#cost#',
			   ReceiptAmountTax      = '#tax#',
			   ReceiptAmountBaseCost = '#costb#',
			   ReceiptAmountBaseTax  = '#taxb#'
		WHERE  ReceiptId = '#get.ReceiptId#'												
</cfquery>

<cfset url.mission       = get.Mission>
<cfset url.transactionid = url.id>
<cfset receiptid         = get.ReceiptId>

<cfinclude template="ReturnHistory.cfm">

<cfquery name="Returned" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  sum(TransactionQuantity*-1) as Returned
		FROM    ItemTransaction
		WHERE   Mission = '#url.mission#'
		AND     ReceiptId = '#ReceiptId#' and transactionType = '3'
</cfquery>

<cfif return.recordcount eq "0">
	<cfset retu = "0">
<cfelse>
	<cfset retu = Returned.Returned/Line.ReceiptMultiplier>
</cfif>	

<cf_precision number="#Item.ItemPrecision#">

<cfoutput>
<script>
	document.getElementById('returned_#url.id#').innerHTML = '#numberformat(retu,'#pformat#')#'
	document.getElementById('billable_#url.id#').innerHTML = '#numberformat(rcpt,'#pformat#')#'
</script>
</cfoutput>