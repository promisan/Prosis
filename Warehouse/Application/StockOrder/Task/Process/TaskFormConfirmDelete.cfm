
<!--- undo the confirmation --->
  	  
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
	

	  

