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

		  