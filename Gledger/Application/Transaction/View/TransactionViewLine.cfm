
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
	
	try {
	    parent.opener.reloadForm();		
		} catch(e) {}	
	
	</script>

</cfoutput>
