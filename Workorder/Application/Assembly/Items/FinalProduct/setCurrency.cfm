
<!--- set currency --->

<cfquery name="order" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  WorkOrder
		SET     Currency = '#url.currency#'
		WHERE   WorkOrderId = '#url.WorkOrderId#'					
</cfquery>

<cfquery name="orderitem" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE WorkOrderLineItem
		SET    Currency = '#url.currency#'
		WHERE  WorkOrderId = '#url.WorkOrderId#'					
</cfquery>

<script>
	   Prosis.busy('yes')
	   _cf_loadingtexthtml='';		   			 
	   document.getElementById('menu2').click()	 	   
</script>	