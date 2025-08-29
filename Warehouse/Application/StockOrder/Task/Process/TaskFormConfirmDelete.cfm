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
<cfquery name="get" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT  * 
	FROM    RequestTask
	WHERE   TaskId = '#url.taskid#'	
</cfquery>	 

<cftransaction>
	  	  
<cfquery name="clear" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    DELETE FROM ItemTransactionShipping 	
	WHERE  TransactionId = '#url.transactionid#'	
</cfquery>	 
		
<!--- update the lines --->
	  	  
<cfquery name="line" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT   * 
	FROM     ItemTransaction
	WHERE    TransactionId = '#url.transactionid#'	
</cfquery>	 
	
<cfquery name="UpdateBatch"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE WarehouseBatch		
		SET    ActionStatus = '0',
		       ActionOfficerDate      = getdate(),
		       ActionOfficerUserId    = '#SESSION.acc#',
			   ActionOfficerLastName  = '#SESSION.last#',
			   ActionOfficerFirstName = '#SESSION.first#'
		WHERE  BatchNo = '#line.TransactionBatchNo#'
</cfquery>
	
<cfquery name="UpdateLines"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE ItemTransaction		
		SET    ActionStatus = '0'
		WHERE  TransactionBatchNo = '#line.TransactionBatchNo#'
</cfquery>

<cf_setRequestStatus requestid = "#get.RequestId#">
	
</cftransaction>
 	
<cfoutput>
<script language="JavaScript">
  try {
  ColdFusion.Window.hide('dialogprocesstask')
  } catch(e) {}
  // refresh the content of the receipts
  ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskProcessDetail.cfm?taskid=#url.taskid#&actormode=#url.actormode#','box#url.taskid#')
  // update the status in the view on the line level
  se = document.getElementById('status#url.taskid#')
  if (se) {
  ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskViewStatus.cfm?taskid=#url.taskid#&actormode=#url.actormode#','status#url.taskid#')
  }
</script>
</cfoutput>
	

	  

