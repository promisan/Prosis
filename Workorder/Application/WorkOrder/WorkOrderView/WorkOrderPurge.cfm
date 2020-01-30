
<cftransaction>

	<cfquery name="checkRequest" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT * FROM RequestWorkorder
			 WHERE  WorkOrderId = '#URL.WorkOrderId#'			
	</cfquery>
	
	<cfquery name="checkItem" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT * FROM WorkorderLineItem
			 WHERE  WorkOrderId = '#URL.WorkOrderId#'			
	</cfquery>
	
	<cfif checkrequest.recordcount eq "0" and checkItem.recordcount eq "0">
		
		<cfquery name="DeleteLines" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     DELETE WorkOrderLine
				 WHERE  WorkOrderId = '#URL.WorkOrderId#'			
		</cfquery>
		
		<cfquery name="DeleteHeader" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     DELETE WorkOrder
				 WHERE  WorkOrderId = '#URL.WorkOrderId#'			
		</cfquery>
		
		
		<cfoutput>
			<script>	    
				history.go()
			</script>
		</cfoutput>
		
	<cfelse>
	
		<cfoutput>
			<script>	    
				alert('Operation not allowed')
			</script>
		</cfoutput>	
	
	</cfif>

</cftransaction>

