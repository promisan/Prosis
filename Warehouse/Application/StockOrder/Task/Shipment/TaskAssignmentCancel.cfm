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

<!---
1. Delink lines from the header
2. remove header
3. Replace with the screen
--->

<!--- verify if there are any stock transaction related to this stockorder --->

<cfquery name="check" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  	 SELECT    I.TransactionId
	 FROM      ItemTransaction I INNER JOIN
               RequestTask R ON I.RequestId = R.RequestId AND I.TaskSerialNo = R.TaskSerialNo
  	 WHERE     R.StockOrderid = '#url.id#'											  
</cfquery>

<cfif check.recordcount gte "1" and session.acc neq "Administrator">

    <!--- added in 16/4/2013 --->

	<script>
		alert("You may no longer cancel this stock order. Please contact your administrator !")
	</script>

<cfelse>

	<cftransaction>
	
		<cfquery name="get" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		    SELECT  * 
			FROM    TaskOrder
			WHERE   StockOrderId = '#url.id#'	
		</cfquery>
		
		<cfquery name="getLine" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		    SELECT  * 
			FROM    RequestTask
			WHERE   StockOrderId = '#url.id#'	
		</cfquery>
				
		<!--- this no longer will occur as we prevent it --->
		
		<cfquery name="Batch" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">		  
		  SELECT    DISTINCT I.TransactionBatchNo
	 	  FROM      ItemTransaction I INNER JOIN
                    RequestTask R ON I.RequestId = R.RequestId AND I.TaskSerialNo = R.TaskSerialNo
		  WHERE     R.StockOrderid = '#url.id#'			 								  
		</cfquery>		
		
		<cfloop query="Batch">
			
			<cfquery name="Update"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE WarehouseBatch
				SET    ActionStatus           = '9', 
				       ActionOfficerUserId    = '#SESSION.acc#',
				       ActionOfficerLastName  = '#SESSION.last#',
					   ActionOfficerFirstName = '#SESSION.first#',
					   ActionOfficerDate      = getDate(),
					   ActionMemo             = 'Cancel stock order'
				WHERE  BatchNo = '#TransactionBatchNo#'	
			</cfquery>	
			
		</cfloop>	
		
		<cfquery name="List" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">		  
		  SELECT    I.TransactionId
	 	  FROM      ItemTransaction I INNER JOIN
                    RequestTask R ON I.RequestId = R.RequestId AND I.TaskSerialNo = R.TaskSerialNo
		  WHERE     R.StockOrderid = '#url.id#'			 								  
		</cfquery>		
		
		<cfloop query="List">	
	
		    <!--- remove any observations driven by this transaction --->
			
			<cfquery name="Delete"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">					
				DELETE FROM AssetItemAction
				WHERE  TransactionId = '#TransactionId#'				
			</cfquery>
			
			<cf_StockTransactDelete alias="AppsMaterials" transactionId="#TransactionId#">		
		
		</cfloop>	
		
		<cfquery name="resetRequestTasks" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		    UPDATE RequestTask 
			SET    StockOrderid = NULL
			WHERE  StockOrderId = '#url.id#'	
		</cfquery>		
				
		<cfquery name="ResetTaskOrder" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		    UPDATE TaskOrder
			SET    ActionStatus     = '8',
			       Remarks          = 'Cancelled by overwrite'			
			WHERE  StockOrderId     = '#url.id#'		
		</cfquery>
	
	</cftransaction>
	
</cfif>	

<cfoutput>

<cfif scope eq "regular">

	<script>
		window.close() 
		try {
		opener.applyfilter('','','content')
		} catch(e) { opener.history.go()}
		try {
		if (opener.document.getElementById('tasktreerefresh')) {				
        opener.ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/View/StockOrderTreeTaskRefresh.cfm?mission=#get.mission#&warehouse=#get.warehouse#','tasktreerefresh')
        } } catch(e) {}	
	</script>

<cfelse>

	<script>
		showtaskpending('#get.mission#','#getLine.TaskType#')
		if (document.getElementById('tasktreerefresh')) {					
        ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/View/StockOrderTreeTaskRefresh.cfm?mission=#get.mission#&warehouse=#get.warehouse#','tasktreerefresh')
        }	
		ColdFusion.Window.destroy('dialogprocesstask',true) 
	</script>

</cfif>

</cfoutput>


