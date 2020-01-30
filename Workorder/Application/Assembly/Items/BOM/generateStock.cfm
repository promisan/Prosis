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
