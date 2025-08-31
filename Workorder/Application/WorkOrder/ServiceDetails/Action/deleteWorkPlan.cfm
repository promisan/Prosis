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
<!--- we keep the history --->

<cfquery name="undoWorkAction" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE WorkPlanDetail
	SET Operational = 0
	WHERE WorkActionId = '#url.workactionid#' 
</cfquery>

<!---

<cfquery name="undoWorkAction" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM WorkPlanDetail
	WHERE WorkActionId = '#url.workactionid#'
</cfquery>

--->

<cfquery name="WorkAction" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   WorkOrderLineAction
	WHERE  WorkActionid = '#url.workactionid#'
</cfquery>

<cfquery name="WorkOrder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   WorkOrder
	WHERE  WorkOrderId = '#workaction.workorderid#'
</cfquery>

<cfoutput>
<u>
  <a href="javascript:workplan('#url.workactionid#')">
  <font color="FF0000">#dateformat(WorkAction.DateTimePlanning,client.dateformatshow)# <font size="2">#timeformat(WorkAction.DateTimePlanning,"HH:MM")#</font>
  </a>
</u>

<script>
  <!--- reload the calendar if opened from a calendar --->
  try {
   opener.document.getElementById('calendarreload').click()
    } catch(e) {}
  <!--- releoad the listing if opened from a listing --->  
  try { opener.applyfilter('1','','#workactionid#');
    } catch(e) {} 
</script>

</cfoutput>