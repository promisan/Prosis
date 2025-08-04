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

<!--- generate stock and consume BOM by first earmarking it --->

<cfinvoke component="Service.Process.WorkOrder.WorkOrderLineItem" 
		  method		    = "ProcessProduction" 
		  workorderid       = "#url.workorderid#"
		  workorderline     = "#url.workorderline#"
		  ActionStatus      = "0">		  

<cfif url.mode eq "FinalProduct">
	
	<cfoutput>
		<script>
			Prosis.busy('no')
			ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/FinalProduct/FinalProductListing.cfm?workorderid=#url.workOrderId#&workorderline=#url.workOrderLine#','topSection');
		</script>
	</cfoutput>

<cfelse>
		
	<cfoutput>
		<script>
		    Prosis.busy('no')
			ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/HalfProduct/HalfProductListing.cfm?workorderid=#url.workOrderId#&workorderline=#url.workOrderLine#','topSection');
		</script>
	</cfoutput>

</cfif>
