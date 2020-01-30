	<cfquery name="qUpdate" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Request
		SET 
			ActionStatus=9
	    WHERE 
	    	RequestId          = '#URL.RequestId#'
	</cfquery>			
		
	<cfoutput>
		<script>
			closeComplaint('#URL.owner#','#URL.requestId#')
		</script>
	</cfoutput>