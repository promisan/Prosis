
<cftransaction>
		
	<!--- update workflow --->
	<cfquery name="Delete" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     DELETE FROM WorkOrderEvent			  
			 WHERE  WorkOrderId = '#URL.WorkOrderId#'
			  AND   WorkOrderEventId = '#URL.ID2#'
	</cfquery>

</cftransaction>

<cfoutput>
	<script>
	    
		 document.getElementById("eventline#url.row#").className = "hide";
		 document.getElementById("box_#URL.ID2#").className = "hide"	
		 document.getElementById("attach_#URL.ID2#").className = "hide"			
	</script>
</cfoutput>

