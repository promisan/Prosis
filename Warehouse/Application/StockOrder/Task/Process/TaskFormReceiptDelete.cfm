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

<cfoutput>

<cftransaction>

	<cfquery name="List"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   RequestId, TransactionId 
		FROM     ItemTransaction
		WHERE    TransactionBatchNo = '#URL.BatchNo#'
		ORDER BY Created DESC
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
		
		<cfquery name="Check"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT *  
			FROM   ItemTransactionValuation 
			WHERE  TransactionId = '#TransactionId#' 
			<!--- special case sourcing --->
			AND    DistributionTransactionId != TransactionId
		</cfquery>
		
		<cfif check.recordcount gte "1">
					
		    <script language="JavaScript1.1">
				 alert("#TransactionId#-#currentrow#It appears this transaction has been (partially)sourced by other transactions. Operation not allowed.")
				 ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskProcessDetail.cfm?taskid=#url.taskid#&actormode=#url.actormode#','box#url.taskid#')
				 ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskViewStatus.cfm?taskid=#url.taskid#&actormode=#url.actormode#','status#url.taskid#')		 
			</script>
				
			<cfabort>
		
		<cfelse>
		
			<cf_StockTransactDelete alias="AppsMaterials" transactionId="#TransactionId#">	
			
		</cfif>
		
		<!--- ---------------------------------- --->
		<!--- set the status of the request line --->
		<!--- ---------------------------------- --->
		
		<cfif Requestid neq "">
				
			<cf_setRequestStatus requestid = "#RequestId#">
		
		</cfif>
		
	</cfloop>
		
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
			   ActionMemo             = 'Cancel Receipt'
		WHERE  BatchNo                = '#URL.BatchNo#'
	</cfquery>
		
</cftransaction>	
	
<script language="JavaScript">
	  ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskProcessDetail.cfm?taskid=#url.taskid#&actormode=#url.actormode#','box#url.taskid#')
	  ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskViewStatus.cfm?taskid=#url.taskid#&actormode=#url.actormode#','status#url.taskid#')
</script>

</cfoutput>
