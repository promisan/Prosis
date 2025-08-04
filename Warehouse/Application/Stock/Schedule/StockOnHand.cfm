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

<cf_droptable dbname="AppsMaterials" full="1" tblname="skStockOnHand">

<!--- populate ItemWarehouse and ItemWarehouseLocation based on the content of ItemTransaction --->

<cfinclude template="StockLevel.cfm">

<!--- stock on hand reference table --->

<cfquery name="StockOnHand" 
datasource="AppsMaterials">
	SELECT   Mission, 
			 Warehouse, 
			 ItemNo, 
	         TransactionUoM, 			
			 SUM(TransactionQuantity) AS OnHand,			
			 #now()# as Created			   
			 
	INTO     skStockOnHand
	
	FROM     ItemTransaction	
	GROUP BY ItemNo, TransactionUoM, Mission, Warehouse	
	HAVING   SUM(TransactionQuantity) != 0
</cfquery>

<!--- ----------------------------------------------------------------- --->
<!--- resets the requestline status based on the confirmed transactions --->
<!--- ----------------------------------------------------------------- --->

<cfquery name="Mission" 
datasource="AppsMaterials">
	SELECT     DISTINCT Mission 
	FROM       Request
</cfquery>

<cfloop query="Mission">

	<cf_setRequestStatus mission="#mission#" datasource="AppsMaterials">
	
</cfloop>	