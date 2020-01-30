<cfquery name="get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Account
	WHERE GLAccount = '#url.glaccount#'
</cfquery>

<cfoutput>
	<script>
		$('###url.codefld#').val('#get.glAccount#');
		$('###url.descfld#').val('#get.description#');
	</script>
</cfoutput>