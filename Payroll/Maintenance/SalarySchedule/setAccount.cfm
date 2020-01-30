
<!--- set the selected account --->


<cfquery name="get" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_Account
		WHERE  GLAccount = '#URL.account#'
	</cfquery>

<cfoutput>
	<script>
		$('##glaccount').val('#get.GLAccount#');	
		$('##gldescription').val('#get.Description#');
		$('##debitcredit').val('#get.AccountType#');
	</script>	
</cfoutput>