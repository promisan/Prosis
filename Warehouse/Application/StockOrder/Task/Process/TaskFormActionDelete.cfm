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
	

	  

