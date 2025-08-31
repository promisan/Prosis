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
		SELECT * 
		FROM   WorkOrderLineItemResource R, WorkOrderLineItem I
		WHERE  R.WorkOrderItemId = I.WorkOrderItemId
		AND    WorkOrderItemIdResource = '#url.WorkOrderItemIdResource#'			
</cfquery>

<cfquery name="update" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE	WorkOrderLineItemResource
		WHERE   WorkOrderItemIdResource = '#url.WorkOrderItemIdResource#'			
</cfquery>

<!--- also update the parent table --->

<cfquery name="update" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		UPDATE 	WorkOrderLineResource
		
		SET     Quantity = Quantity - '#get.Quantity#'
		
		
		WHERE   WorkOrderId     = '#get.WorkOrderId#'			
		AND     WorkOrderLine   = '#get.WorkOrderLine#'
		AND     ResourceItemNo  = '#get.ResourceItemNo#'
		AND     ResourceUoM     = '#get.ResourceUoM#'
</cfquery>
		
<cfoutput>

	<script>
	    _cf_loadingtexthtml='';		
		ptoken.navigate('#SESSION.Root#/WorkOrder/Application/Assembly/Items/FinalProduct/FinalProductBOM.cfm?WorkOrderItemId=#URL.WorkOrderItemId#','resource_#URL.WorkOrderItemId#');
	</script>
	
</cfoutput>