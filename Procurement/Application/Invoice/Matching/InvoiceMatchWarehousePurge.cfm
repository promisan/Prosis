
 <!--- warehouse issuance tracking --->
 
<!--- unlink the line --->

<cftransaction>
	
	<cfquery name="ResetLine" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	     UPDATE  Materials.dbo.ItemTransactionShipping
		 SET     InvoiceId = NULL
		 FROM    Materials.dbo.ItemTransaction T, 
		         Materials.dbo.ItemTransactionShipping S
		 WHERE   S.TransactionId = T.Transactionid
		 AND     T.TransactionBatchNo  = '#URL.BatchNo#'				   
	</cfquery>	
	
	<!--- lower the payables amount --->
	
	<cfquery name="getInvoice" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Invoice
		WHERE   InvoiceId = '#URL.InvoiceId#'					   
	</cfquery>	
	
	<cfquery name="getNewTotal" 
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
	
	<cfset decrease = getInvoice.DocumentAmount - getNewTotal.total>
	
	<!--- lower the matching amount based on a random association 
	in trhe CMP mode there can be several requisitions, otherwise it will be
	just one line here. --->
	
	<cfquery name="getMatched" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    SELECT * 
		FROM   InvoicePurchase	
		WHERE  InvoiceId = '#URL.InvoiceId#'				   
	</cfquery>	

	<cfloop query="getMatched">
	
		<cfif decrease gt "0">
	
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

<script>
	history.go()
</script>
