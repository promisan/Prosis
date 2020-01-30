
<!--- get workorder line --->


<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    WL.WorkOrderId, WL.WorkOrderLine, WS.Reference, WS.Description
	FROM      WorkOrderLine WL INNER JOIN
              WorkOrderService WS ON WL.ServiceDomain = WS.ServiceDomain AND WL.Reference = WS.Reference
	WHERE     WorkOrderLineId = '#url.workorderlineid#'
</cfquery>	

<cfif get.recordcount eq "1">
	
	<cfoutput query="get">
	
		<script>
			 document.getElementById('workorderline').value = '#get.workorderline#'
			
		</script>
		#get.reference# #get.Description#
	
	</cfoutput>

</cfif>