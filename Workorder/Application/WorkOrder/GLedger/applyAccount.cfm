<cfquery name="account" 
datasource="appsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_Account
	WHERE	 GLAccount = '#url.account#'
</cfquery>

<cfoutput>
	<script>
		$('###url.area#glaccount').val('#account.glaccount#');
		$('###url.area#gldescription').val('#account.description#');
		$('###url.area#debitcredit').val('#account.accountType#');
	</script>
</cfoutput>