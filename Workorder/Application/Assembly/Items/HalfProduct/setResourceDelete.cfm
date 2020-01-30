
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
		ColdFusion.navigate('#SESSION.Root#/WorkOrder/Application/Assembly/Items/HalfProduct/HalfProductBOM.cfm?WorkOrderItemId=#URL.WorkOrderItemId#','resource_#URL.WorkOrderItemId#');
	</script>
	
</cfoutput>