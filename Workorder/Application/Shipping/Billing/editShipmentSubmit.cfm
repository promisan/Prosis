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

<cfparam name="form.commoditycode" default="">			 

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
	
	SET   <cfif form.commoditycode neq ""> CommodityCode   = '#form.CommodityCode#',</cfif>
			  SalesPrice      = '#prc#',
			  SalesAmount     = '#amt#',
			  SalesTax        = '#tax#',
			  SalesBaseAmount = '#amtB#',
			  SalesBaseTax    = '#amtT#'
			  
	WHERE     TransactionId = '#url.TransactionId#'	
	
</cfquery>  

<cfoutput>

	<script>
		try { ProsisUI.closeWindow('executetask',true)} catch(e){}	
		ptoken.navigate('BillingEntryDetail.cfm?workorderid=#get.WorkOrderId#&systemfunctionid=#url.systemfunctionid#','mycontent')		
	</script>

</cfoutput>