
<cfquery name="Header" 
	datasource="appsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT * 
	FROM TransactionHeader 
	WHERE TransactionId = '#url.transactionid#'		
</cfquery>	

<cfoutput>
 

	<script>
	
	<cfif Header.actionStatus eq "1">	 
	   history.go()	   
	</cfif>
				
	try {
	    parent.opener.reloadForm();		
		} catch(e) {}	
	
	</script>

</cfoutput>
