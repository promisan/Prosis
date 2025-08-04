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

<cfparam name="taxexemption" default="1">

<cfset prcfix = replace(url.priceFixed,",","","ALL")> 
<cfset prcvar = replace(url.priceVariable,",","","ALL")> 

<cfif isNumeric(prcfix) and isNumeric(prcvar)>
	
	<cfset price = prcfix+prcvar>
	
	<!---
	<cfset amt = round(get.TransactionQuantity * 100 * -1 * Prc)/100>
	--->
	
	<cfif TaxExemption eq "1">
	
		<cfquery name="setPrice" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">	  
		  
	      UPDATE  ItemTransactionShipping
		  
		  SET     SalesCurrency       = '#url.currency#',
				  SalesPriceFixed     = '#prcfix#', 		
				  SalesPriceVariable  = '#prcvar#',  
		          SalesPrice          = '#prcfix+prcvar#',
				  SalesAmount         = ROUND(-T.TransactionQuantity*#price#,2),
				  TaxPercentage       = '0',
				  TaxExemption        = '1',
				  TaxIncluded         = '0',
				  SalesTax            = '0'
	      
		  FROM    ItemTransactionShipping S INNER JOIN ItemTransaction ON S.TransactionId = T.TransactionId						  
 		  WHERE   T.TransactionBatchNo = '#BatchNo#'	
		  		  		  
		</cfquery>	  
	
	<cfelse>
	
	    <!--- ---------------------------------------------- --->
		<!--- this we need to derrive from the Purchase Line --->
		<!--- ---------------------------------------------- --->
		
		<cfparam name="taxperc"     default="0">
		<cfparam name="taxincluded" default="0">
				
		<!--- old
				
		<cfset val = get.TransactionQuantity * 100 * -1 * prc>
		
		<cfif taxincluded eq "0">
		
			<cfset tax = round(val*taxperc)/100>				
		
		<cfelse>
		
			<cfset tax = round(val*(taxperc/(1+taxperc)))/100>		
			<cfset amt = round(val*(1/(1+taxperc)))/100>		
		
		</cfif>
		
		--->
		
		<cfquery name="setPrice" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">	  
	      UPDATE  ItemTransactionShipping
		  
		  SET     SalesCurrency       = '#url.currency#',
				  SalesPriceFixed     = '#prcfix#', 		
				  SalesPriceVariable  = '#prcvar#',  
		          SalesPrice          = '#prcfix+prcvar#',				 
				  TaxPercentage       = '#taxperc#',
				  TaxExemption        = '0',
				  TaxIncluded         = '#taxincluded#',
				  
				  <cfif taxincluded eq "0">
				  	  SalesAmount         = ROUND(-T.TransactionQuantity*#price#,2),
					  SalesTax            = ROUND(-(T.TransactionQuantity*#price#)*#taxperc#,2)
				  <cfelse>
				  	  SalesAmount         = ROUND(-(T.TransactionQuantity*#price#)*(1/(1+#taxperc#),2),
				  	  SalesTax            = ROUND(-(T.TransactionQuantity*#price#)*(#taxperc#/(1+#taxperc#),2)
				  </cfif>
	      
		  FROM    ItemTransactionShipping S INNER JOIN ItemTransaction T ON S.TransactionId = T.TransactionId						  
 		  WHERE   T.TransactionBatchNo = '#BatchNo#'			  		  
		</cfquery>	  
		
			
	</cfif>	
	
	<cfquery name="getWhs" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">	  
		  SELECT  *
		  FROM    WarehouseBatch
		  WHERE   BatchNo = '#BatchNo#'		     
	</cfquery>	  	
		
	<cfquery name="getSales" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">	  
		  SELECT  SUM(SalesTotal) as SalesTotal 
		  FROM    ItemTransactionShipping S INNER JOIN ItemTransaction T ON S.TransactionId = T.TransactionId						  
 		  WHERE   T.TransactionBatchNo = '#BatchNo#'		     
	</cfquery>	  
	
	<cfoutput>#numberformat(getSales.SalesTotal,',.__')#</cfoutput>
	
	<!--- overall total --->
	
	<cfquery name="getTotal" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">	  
	      SELECT  SUM(S.SalesTotal) as Total
		  FROM    ItemTransaction T, ItemTransactionShipping S, WarehouseBatch B
		  WHERE   T.TransactionId = S.TransactionId
		  AND     B.BatchNo = T.TransactionBatchNo
		  
		  AND     T.Mission   = '#getWhs.mission#'
		  AND     T.Warehouse = '#getWhs.warehouse#'
		  
		  AND     (( T.TransactionType = '8' AND T.TransactionQuantity < 0) OR T.TransactionType = '2')
		  
		  AND     T.BillingMode = 'External'
		  
		  AND     B.BillingStatus = '1'
		  
		  <!--- not invoiced yet --->
		  
		  AND     T.TransactionId IN  (
				  SELECT   TransactionId
                  FROM     ItemTransactionShipping S
                  WHERE    TransactionId = T.TransactionId 
				  AND      (
				            InvoiceId IS NULL OR 
							InvoiceId NOT IN (SELECT InvoiceId FROM Purchase.dbo.Invoice WHERE InvoiceId = S.InvoiceId)
						   )
				 )				  
		 
	</cfquery>	
	
	<cfoutput>
		<script>	
		 	document.getElementById('totalinvoice').innerHTML = "#numberformat(getTotal.Total,',__.__')#"	
		</script> 
	</cfoutput> 	

</cfif>

	  