<cfquery name="Update"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
		UPDATE userTransaction.dbo.Transfer#URL.whs#_#SESSION.acc#		
		SET    TransferWarehouse = '#url.warehouseto#',
    		   TransferLocation  = '#url.locationto#'							
 	</cfquery>
	
	<cfoutput>
	
	<script>
		stocktransfer('n','#url.systemfunctionid#')
	</script>
	
	</cfoutput>