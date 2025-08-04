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

<!--- delete workplan, delete actions, delete workorderline --->


<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 
		FROM     WorkOrderLine WL INNER JOIN
	             WorkOrder W ON WL.WorkOrderId = W.WorkOrderId 
		WHERE    WorkOrderLineId = '#url.drillid#'		
	</cfquery>	 
	
<cfset vDate = "">	
	
<cfif get.actionStatus eq "3">	

	<cfoutput>
	<script>
	 alert("This action is no longer supported")	 
	</script>
	</cfoutput>

<cfelse>

	<cftransaction>

		<cfquery name="getPlan" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT * FROM WorkPlanDetail
			  WHERE WorkActionId IN (
				SELECT   WorkActionId 
				FROM     WorkOrderLineAction
				WHERE    WorkOrderId   = '#get.WorkOrderId#'		
				AND      WorkOrderLine = '#get.WorkOrderLine#'
				)
		</cfquery>	 	

		<cfset vDate = GetPlan.DateTimePlanning>

		
		<cfquery name="deleteplan" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  DELETE FROM WorkPlanDetail
			  WHERE WorkActionId IN (
				SELECT   WorkActionId 
				FROM     WorkOrderLineAction
				WHERE    WorkOrderId   = '#get.WorkOrderId#'		
				AND      WorkOrderLine = '#get.WorkOrderLine#'
				)
		</cfquery>	 	
			
		<cfquery name="deleteaction" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  DELETE   FROM WorkOrderLineAction
			  WHERE    WorkOrderId   = '#get.WorkOrderId#'		
			  AND      WorkOrderLine = '#get.WorkOrderLine#'
		</cfquery>	 	
		
		<cfquery name="deleteline" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  UPDATE   WorkOrderLine
			  SET      Operational = 0, 
			           ActionStatus = '9'
			  WHERE    WorkOrderId   = '#get.WorkOrderId#'		
			  AND      WorkOrderLine = '#get.WorkOrderLine#'
		</cfquery>	 

		<cfquery name="checkWO" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT *
			  FROM    	WorkOrderLine 
			  WHERE    	WorkOrderId   = '#get.WorkOrderId#'	
			  AND 		actionStatus  !='9'
		</cfquery>	 
		<cfif checkWo.recordcount lte 0>
			<cfquery name="deletewo" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  UPDATE   WorkOrder
			  SET      ActionStatus 	= '9'
			  WHERE    WorkOrderId   	= '#get.WorkOrderId#'
			</cfquery>
		</cfif>
	
	</cftransaction>
	
	<cfoutput>
	<script>
	 <cfif vDate neq "">
	 	try { opener.calendardetail('#URLEncodedFormat(vDate)#')} catch(e) {}
	 </cfif>	
	 try { opener.applyfilter('','','content') } catch(e) {}
	 
	 ptoken.location('#session.root#/WorkOrder/Application/Medical/ServiceDetails/WorkOrderLine/WorkOrderLineView.cfm?drillid=#url.drillid#')
	</script>
	</cfoutput>
	
</cfif>	



	


	
