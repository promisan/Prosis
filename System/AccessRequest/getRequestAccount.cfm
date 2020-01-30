<cf_compression>

<cfquery name="UserAccount" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT *
	FROM   UserNames
	WHERE  Account = '#URL.Acc#'
	
</cfquery>

<cfoutput>

	<script>
		addAccount('#UserAccount.FirstName#','#UserAccount.LastName#','#UserAccount.Account#');
	</script>

</cfoutput>