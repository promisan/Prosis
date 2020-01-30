
<cfquery name="Delete"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">		
	DELETE FROM RequestTaskAction
	WHERE  TaskActionId = '#url.taskactionid#'
</cfquery>
		
<cfoutput>
	
	<script language="JavaScript">
	  ColdFusion.navigate('#SESSION.root#/warehouse/application/StockOrder/Task/Process/TaskProcessDetail.cfm?taskid=#url.taskid#&actormode=#url.actormode#','box#url.taskid#')
	  se = document.getElementById('status#url.taskid#')
	  if (se) {
	  ColdFusion.navigate('#SESSION.root#/warehouse/application/StockOrder/Task/Process/TaskViewStatus.cfm?taskid=#url.taskid#&actormode=#url.actormode#','status#url.taskid#')
	  }
	</script>

</cfoutput>
	

	  

