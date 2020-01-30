
<!--- remove any transfer transactions --->


<cfquery name="getLocation" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    WarehouseLocation
    WHERE   Warehouse = '#url.warehouse#'		
	AND     Location  = '#url.location#'
</cfquery>	

<cfif getLocation.recordcount eq "1">
	
	<cfquery name="getTaskOrder" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  * 
		FROM    TaskOrder	
	    WHERE   StockOrderId = '#url.stockorderid#'		
	</cfquery>	

	<cfif getTaskOrder.location eq url.location>
	
	    <!--- nada --->
	
	<cfelse>
		
		<cftransaction>
		
		<cfquery name="setTaskOrder" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE  TaskOrder
			SET     Location     = '#url.location#'
		    WHERE   StockOrderId = '#url.stockorderid#'		
		</cfquery>	
		
		<cfquery name="getBatch" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  * 
			FROM    WarehouseBatch	
		    WHERE   StockOrderId = '#url.stockorderid#'		
		</cfquery>	
		
		<cfloop query="getBatch">
		
				<cfquery name="List"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT TransactionId 
					FROM   ItemTransaction
					WHERE  TransactionBatchNo = '#BatchNo#'
				</cfquery>
				
				<cfloop query="list">
		
					<cfquery name="Delete"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
						DELETE FROM ItemTransaction
						WHERE  TransactionId = '#TransactionId#'
					</cfquery>
				
				</cfloop>
				
				<cfquery name="Update"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE WarehouseBatch
					SET    ActionStatus = '9', 
					       ActionOfficerUserId    = '#SESSION.acc#',
					       ActionOfficerLastName  = '#SESSION.last#',
						   ActionOfficerFirstName = '#SESSION.first#',
						   ActionOfficerDate      = getDate()
					WHERE  BatchNo = '#BatchNo#'
				</cfquery>
		
		</cfloop>
		
		</cftransaction>
		
	</cfif>	

</cfif>
	
<!--- refresh the task view --->

<script>
  history.go()
</script>

		  