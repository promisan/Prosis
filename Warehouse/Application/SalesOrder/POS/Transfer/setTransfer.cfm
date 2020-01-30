<cfquery name="qExistingTransfer"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT SUM(TransactionQuantity) as TransactionTransfer,
				   SUM(TransactionTransfer) as QuantityTransfer 
			FROM   usertransaction.dbo.Sale#url.Warehouse#Transfer
			WHERE  TransactionId  = '#url.TransactionId#'
</cfquery>	

<cfoutput>

<cfif qExistingTransfer.recordcount neq 0>|&nbsp;#qExistingTransfer.TransactionTransfer#&nbsp;[#qExistingTransfer.QuantityTransfer#]<cfelse>
| --
</cfif>
</cfoutput>
								