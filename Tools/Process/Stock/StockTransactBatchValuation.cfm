<!--- 

1. get list of transaction that are negarive
2. loop through the transactions and call the custom method <cf_stockTransactionValuation xxxx=

--->

<cfquery name="getTransactions" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">	
	SELECT *
	FROM ItemTransaction
	WHERE TransactionValue  < 0
	ORDER BY TransactionDate ASC
</cfquery>				

<cfloop query = "getTransactions">
	<cf_StockTransactValuation
		DataSource			= "AppsMaterials" 
		Mission				= "#getTransactions.Mission#"	
		TransactionId		= "#getTransactions.TransactionId#"
		TransactionDate		= "#getTransactions.TransactionDate#"
		TransactionQuantity	= "#getTransactions.TransactionQuantity#"
		ItemNo				= "#getTransactions.ItemNo#"
		Warehouse			= "#getTransactions.Warehouse#"
		TransactionUoM		= "#getTransactions.TransactionUoM#"
		Location			= "#getTransactions.Location#"
		TransactionLot		= "#getTransactions.TransactionLot#"
		WorkOrderId 		= "">
</cfloop>		

