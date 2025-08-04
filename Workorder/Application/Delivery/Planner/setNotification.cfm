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

<cfquery name="workorder" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT   *
    FROM     Workorder W, WorkOrderLine WL
	WHERE    W.WorkorderId = WL.WorkOrderId
    AND      WorkOrderLineId = '#url.workorderlineid#'		
</cfquery>

<cfquery name="Get" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT   T.WorkOrderId, T.WorkOrderLine, T.Topic, T.TopicValue
    FROM     WorkOrderLine AS WL INNER JOIN
             WorkOrderLineTopic AS T ON WL.WorkOrderId = T.WorkOrderId AND WL.WorkOrderLine = T.WorkOrderLine
    WHERE    T.Topic = 'f010'
    AND      WorkOrderLineId = '#url.workorderlineid#'	
	AND      T.Operational = 1
</cfquery>

<cfif get.topicvalue eq "1">
  <cfset new = "0">
  <cfset display = "<font color='FF0000'><b>No</b></font>">
<cfelse>
  <cfset new = "1">
  <cfset display = "<font color='green'><b>Yes</b></font>">
</cfif>

<cfoutput>#display#</cfoutput>

<cfset id                = workorder.workorderid>
<cfset url.workorderline = workorder.workorderline>
	
<cfset url.topicselect   = "f010">
<cfset form.topic_f010 = new>

<cfinclude template="../../WorkOrder/Create/CustomFieldsSubmit.cfm">	

<!--- we also refresh the number on the left panel --->

<cfoutput>
	<script>		
	_cf_loadingtexthtml='';	
	ptoken.navigate('Planner/setScheduled.cfm?mission=#workorder.mission#&date=#url.dts#','scheduled')
	</script>
</cfoutput>