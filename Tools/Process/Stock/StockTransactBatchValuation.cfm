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

