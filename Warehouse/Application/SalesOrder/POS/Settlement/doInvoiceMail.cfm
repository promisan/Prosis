
<!--- sent mail --->

<cfquery name="GetWarehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT * 
	FROM   WarehouseJournal 
	WHERE  Area = 'SETTLE'
	AND    Warehouse = ( SELECT Warehouse
						 FROM   WarehouseBatch
				         WHERE  BatchId = '#URL.batchid#')		
						 		 
						 				 
</cfquery>	

<cfif GetWarehouse.eMailTemplate neq "">
	<cfinclude template="../../../../../#GetWarehouse.emailTemplate#">
<cfelse>
	<cf_receiptStandard batchId="#url.batchid#">	
</cfif>

<table><tr class="labelmedium2"><td><cf_tl id="Mail sent"></td></tr></table>

	