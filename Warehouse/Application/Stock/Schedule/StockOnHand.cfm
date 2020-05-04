
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