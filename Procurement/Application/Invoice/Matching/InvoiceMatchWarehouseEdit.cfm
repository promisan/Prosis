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

 <!--- warehouse issuance tracking --->
 
<!--- unlink the line --->


<cfset prc = replace(url.price,",","","ALL")> 

<cfif isNumeric(prc)>

	<cftransaction>
	
	<cfquery name="get" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">	  
	      SELECT  * 
		  FROM     Materials.dbo.ItemTransactionShipping S,  Materials.dbo.ItemTransaction IT		 
		  WHERE   S.TransactionId = IT.TransactionId
		  AND     IT.TransactionId = '#url.transactionid#'
	</cfquery>	  
	
	<cfset amt = round(get.TransactionQuantity * 100 * -1 * prc)/100>
	
	<cfif get.TaxExemption eq "1">
		
			<cfquery name="setPrice" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">	  
		      UPDATE  Materials.dbo.ItemTransactionShipping
			  SET     SalesPrice    = '#prc#',
					  SalesAmount   = '#amt#',
					  TaxPercentage = '0',
					  TaxExemption  = '1',
					  TaxIncluded   = '0',
					  SalesTax      = '0'
			  WHERE   TransactionId = '#url.transactionid#'
			</cfquery>	  
	
	<cfelse>
	
	    <!--- ---------------------------------------------- --->
		<!--- this we need to derrive from the Purchase Line --->
		<!--- ---------------------------------------------- --->
		
		<cfset taxperc     = get.taxpercentage>
		<cfset taxincluded = get.taxIncluded>
						
		<cfset val = get.TransactionQuantity * 100 * -1 * prc>
		
		<cfif taxincluded eq "0">
		
			<cfset tax = round(val*taxperc)/100>				
		
		<cfelse>
		
			<cfset tax = round(val*(taxperc/(1+taxperc)))/100>		
			<cfset amt = amt - tax>		
		
		</cfif>
		
		<cfquery name="setPrice" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">	  
	      UPDATE  Materials.dbo.ItemTransactionShipping
		  SET     SalesPrice    = '#prc#',
				  SalesAmount   = '#amt#',			      
				  SalesTax      = '#tax#
		  WHERE   TransactionId = '#url.transactionid#'
		</cfquery>	  
			
	</cfif>		
		
	<!--- lower the payables amount --->
	
	<cfquery name="getInvoice" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Invoice
		WHERE   InvoiceId = '#URL.InvoiceId#'					   
	</cfquery>	
	
	<cfquery name="getTotal" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    SELECT  SUM(SalesTotal) as Total
		FROM    Materials.dbo.ItemTransactionShipping
		WHERE   InvoiceId = '#URL.InvoiceId#'				   
	</cfquery>	
	
	<cfquery name="ResetInvoice" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    UPDATE  Invoice
		SET     DocumentAmount = '#getTotal.total#'
		WHERE   InvoiceId = '#URL.InvoiceId#'				   
	</cfquery>	
	
	<cfset decrease = getInvoice.DocumentAmount - getTotal.total>
	
	<!--- lower the matching amount based on random associations --->
	
	<cfquery name="getMatched" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    SELECT * 
		FROM   InvoicePurchase	
		WHERE  InvoiceId = '#URL.InvoiceId#'				   
	</cfquery>	
	
	<cfloop query="getMatched">
	
		<cfif decrease neq "0">
	
			<cfif documentAmountMatched gte decrease>
					
				<cfquery name="getMatched" 
				   datasource="AppsPurchase" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				    UPDATE InvoicePurchase	
					SET    DocumentAmountMatched = DocumentAmountMatched - #decrease#,
					       AmountMatched         = AmountMatched - (#decrease * (amountMatched/DocumentAmountMatched)#)  <!--- aplly in the same exchange rate --->
					WHERE  InvoiceId = '#URL.InvoiceId#'				   
					AND    MatchingNo = '#matchingno#'
				</cfquery>	
				
				<cfset decrease = 0>
			
			<cfelse>
			
				<cfquery name="getMatched" 
				   datasource="AppsPurchase" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				    DELETE FROM InvoicePurchase					
					WHERE  InvoiceId = '#URL.InvoiceId#'				   
					AND    MatchingNo = '#matchingno#'
				</cfquery>	
				
				<cfset decrease = decrease - documentAmountMatched>
			
			</cfif>
	
		</cfif>
	
	</cfloop>

	<!--- refresh the screen --->

	</cftransaction>

</cfif>

<script>
	history.go()
</script>


