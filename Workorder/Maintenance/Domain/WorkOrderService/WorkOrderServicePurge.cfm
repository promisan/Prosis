<cfquery name="CountRec" 
      datasource="AppsWorkOrder" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
		SELECT	WorkorderId as id
		FROM	Workorderline
		WHERE	ServiceDomain = '#url.id1#'
		AND 	Reference = '#url.id2#'
</cfquery>

<cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Workorder Service is in use. Operation aborted.")
     
     </script>  
 
<cfelse>
		
	<cfquery name="Delete" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM WorkOrderService
		WHERE	ServiceDomain = '#url.id1#'
		AND 	Reference = '#url.id2#'
	</cfquery>

</cfif>

<cfoutput>
	<script language="JavaScript">
    	ptoken.navigate('#SESSION.root#/Workorder/Maintenance/Domain/WorkOrderService/WorkOrderServiceListing.cfm?ID1=#url.id1#','workOrderServiceListing')   
	</script> 
</cfoutput>