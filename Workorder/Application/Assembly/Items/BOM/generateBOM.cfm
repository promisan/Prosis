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
<cfparam name="URL.refresh" default="No">
<cfparam name="URL.Mode"    default="FinalProduct">

<cfif URL.refresh eq "Yes">

	<cfquery name="get" 
		datasource="AppsWorkOrder"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    WorkOrder
			WHERE	WorkOrderId   = '#url.workorderid#' 		
	</cfquery>

	<!--- get items without BOM --->
	 
	<cfquery name="Item" 
		datasource="AppsWorkOrder"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  WOL.WorkOrderItemId,
					I.ItemNo, 
					I.ItemDescription,
					U.UoM, 
					U.UoMDescription, 
					WOL.Quantity, 
					WOL.Currency, 
					WOL.SalePrice, 
					WOL.Created
			FROM    WorkOrderLineItem WOL 
			        INNER JOIN Materials.dbo.Item I    ON WOL.ItemNo = I.ItemNo 
					INNER JOIN Materials.dbo.ItemUoM U ON WOL.ItemNo = U.ItemNo AND WOL.UoM = U.UoM
			WHERE	WOL.WorkOrderId   = '#url.workorderid#' 
			AND     WOL.WorkOrderLine = '#url.workorderline#'
			AND     WOL.WorkOrderItemId NOT IN (SELECT WorkorderItemId 
			                                    FROM   WorkOrderLineItemResource 
												WHERE  WorkOrderItemId = WOL.WorkOrderItemId)
												
												
	</cfquery>
	
	<cftransaction>	
			
		<cfloop query="Item">
		
			<cfinvoke component="Service.Process.WorkOrder.WorkOrderLineItem" 
			  method		    = "WorkOrderLineItemResource" 
		      workorderitemid   = "#workorderItemId#">			
			
		</cfloop>	
		
		<!--- sync the BOM table on the higher level --->
				
		<cfinvoke component="Service.Process.WorkOrder.WorkOrderLineItem" 
			  method		    = "SyncWorkOrderLineResource" 
		      workorderid 	    = "#url.WorkOrderId#" 
		      workorderline     = "#url.WorkOrderLine#">
				
	</cftransaction>	
	
</cfif>

<cfif url.mode eq "FinalProduct">
	
	<cfoutput>
		<script>
			ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/FinalProduct/FinalProductListing.cfm?workorderid=#url.workOrderId#&workorderline=#url.workOrderLine#','topSection');
		</script>
	</cfoutput>

<cfelse>	
	
	<cfoutput>
		<script>
			ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/HalfProduct/HalfProductListing.cfm?workorderid=#url.workOrderId#&workorderline=#url.workOrderLine#','topSection');
		</script>
	</cfoutput>

</cfif>
