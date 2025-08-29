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
<cfif url.txt neq "">
	<cfset Message = "">
	<cfloop from="1" to=#ListLen(SESSION.csmtp)# index="i"> 
			<cfset workorder = ListGetAt(SESSION.csmtp, i)> 
			<cfset WorOrder = Replace(WorkOrder,"{","","all")>
			<cfset WorOrder = Replace(WorkOrder,"}","","all")>		
			<cfset WorkOrderId   = ListGetAt(workOrder, 1,"|")> 
			<cfset WorkOrderLine = ListGetAt(workOrder, 2,"|")> 
			<cfset veMailAddress = ListGetAt(workOrder, 3,"|")> 
			<cfquery name="qAction" datasource="AppsWorkOrder">
				SELECT *
			  	FROM WorkOrderLineAction
			  	WHERE 
			       	WorkOrderId   = '#WorkOrderId#' AND
			       	WorkOrderLine = '#WorkOrderLine#' AND
			       	ActionClass   = 'Notification'
			  	ORDER BY Created DESC
			</cfquery>  	
			<cfset Message = "#Message# #qAction.ActionMemo#<BR><HR><BR>">
	</cfloop>
</cfif>	

<cfoutput>
  <table align="center" valign="top" width="100%" height="100%">
  	<tr valign="top">
		<td style="padding:4px" class="labelmedium">
			<cfif url.txt neq "">
				#Message#
			<cfelse>
				Displaying results...	
			</cfif>	
		</td>
	</tr>
	</table> 
</cfoutput>