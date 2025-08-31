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
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *, W.Reference as HeaderReference, WL.Reference as ServiceReference
		FROM      WorkOrder W INNER JOIN WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId
		WHERE     WL.WorkOrderLineId = '#url.workorderlineid#'				
</cfquery>		

<cfif get.serviceItem neq form.serviceItem>

	<cfquery name="setservice" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE  Workorder
			SET     ServiceItem = '#Form.ServiceItem#', 
			        Reference   = '#Form.Reference#'
			WHERE   WorkOrderId = '#get.workorderid#'				
	</cfquery>		
	
	<!--- reset billing --->
	<cfquery name="setservice" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM  WorkOrderLineBilling
		WHERE WorkOrderId = '#get.workorderid#'
	</cfquery>	

</cfif>

<cfif get.ServiceDomainClass neq form.ServiceDomainClass or get.ServiceReference neq form.ServiceReference>

	<cfquery name="setservice" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE  WorkorderLine
			SET     ServiceDomainClass = '#Form.ServiceDomainClass#',
			        Reference          = '#Form.ServiceReference#',
					OfficerUserId      = '#session.acc#',
					OfficerLastName    = '#session.last#',
					OfficerFirstName   = '#session.first#',
					Created            = getDate()
			WHERE   WorkOrderLineId    = '#get.workorderLineid#'				
	</cfquery>	
	
</cfif>

<script>
 history.go()
</script>


