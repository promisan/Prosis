
<cftransaction>
		
	<!--- update workflow --->
	<cfquery name="Delete" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     DELETE FROM WorkOrderBaseLine			  
			 WHERE  WorkOrderId = '#URL.WorkOrderId#'
			  AND   TransactionId = '#URL.ID2#'
	</cfquery>

</cftransaction>

<cfoutput>
	<script>	    
		 document.getElementById("agreementline#url.row#").className = "hide"		
		 document.getElementById("agreementline0#url.row#").className = "hide"
		 document.getElementById("agreementline1#url.row#").className = "hide"
	</script>
</cfoutput>

