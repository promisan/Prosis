<cfquery name="removeItem" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		DELETE
		FROM	WorkOrderServiceItem
		WHERE	ServiceDomain = '#url.ServiceDomain#'
		AND		Reference = '#url.Reference#'
		AND		ItemNo = '#url.itemno#'
		AND		UoM = '#url.uom#'
	
</cfquery>

<cfoutput>
	<script>
		_cf_loadingtexthtml='';	
		ptoken.navigate('WorkOrderService/WorkOrderServiceItem.cfm?id1=#url.serviceDomain#&id2=#url.reference#','itemContainer');
	</script>
</cfoutput>