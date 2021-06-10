
<!--- sent mail --->

<cfquery name="GetWarehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT * 
	FROM   WarehouseJournal 
	WHERE  Area = 'SETTLE'
	AND    Warehouse = ( SELECT Warehouse
						 FROM WarehouseBatch
				         WHERE BatchId='#URL.batchid#')		
						 
						 				 
</cfquery>	

<cfif GetWarehouse.eMailTemplate neq "">
	<cfinclude template="../../../../../#GetWarehouse.emailTemplate#">
<cfelse>
	<cf_receiptStandard batchId="#url.batchid#">	
</cfif>

<script>
	alert('eMail sent')
</script>
	