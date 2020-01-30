<cfquery name="qUpdate" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	 
    DELETE WorkOrderLineResource 
	WHERE  ResourceId = '#URL.ResourceId#'    									  
</cfquery>

<cfoutput>
<script>

  
    try {
	   document.getElementById('close').click()	} 
	 catch(e) {}
	
	try {
		window.applyfilter('1','','#URL.ResourceId#')		
	}	
	catch(e) {}	
</script>
</cfoutput>