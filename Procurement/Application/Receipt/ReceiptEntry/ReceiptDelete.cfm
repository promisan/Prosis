
<!--- receipt delete --->

<cfquery name="RemoveLines" 
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM   PurchaseLineReceipt
    WHERE  ReceiptNo = '#URL.receiptno#' 
</cfquery>

<cfloop query="RemoveLines">

	<cfset url.rctid = receiptid>
	<cfset url.mode  = "batch">
	<cfinclude template="ReceiptPurge.cfm">

</cfloop>

<cfquery name="RemoveLines" 
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    DELETE FROM PurchaseLineReceipt
    WHERE  ReceiptNo = '#URL.receiptno#' 
	AND    ActionStatus = '9'
</cfquery>

<cfquery name="Check" 
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
	FROM   PurchaseLineReceipt
    WHERE  ReceiptNo = '#URL.receiptno#' 	
</cfquery>

<cfif check.recordcount eq "0">
	
	<cfquery name="RemoveLines" 
	    datasource="AppsPurchase" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    	DELETE FROM Receipt
		    WHERE  ReceiptNo = '#URL.receiptno#' 	
	</cfquery>

</cfif>

<script>
   parent.window.close()   
</script>
