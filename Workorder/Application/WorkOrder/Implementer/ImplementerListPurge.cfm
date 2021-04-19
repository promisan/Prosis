<cfquery name="delete" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	WorkOrderImplementer
		WHERE 	WorkOrderId = '#url.workOrderId#'
		AND		OrgUnit = '#url.orgUnit#'
</cfquery>

<cfoutput>
	<script>	 
		ptoken.navigate('#SESSION.root#/Workorder/Application/WorkOrder/Implementer/ImplementerList.cfm?workOrderId=#url.workOrderId#&mission=#url.mission#&mandateno=#url.mandateno#','divImplementerList');
	</script>
</cfoutput>