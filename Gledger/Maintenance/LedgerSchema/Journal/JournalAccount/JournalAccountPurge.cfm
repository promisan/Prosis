
<cfquery name="validate" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	JournalAccount
		WHERE	Journal = '#url.journal#'
		AND		GLAccount = '#url.account#'
</cfquery>

<cfif validate.ListDefault eq 1>
	<cfquery name="resetDefault" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE	JournalAccount
			SET		ListDefault = 1
			WHERE	Journal = '#url.journal#'
			AND		GLAccount = (
									SELECT TOP 1 GLAccount
									FROM	JournalAccount
									WHERE	Journal = '#url.journal#'
									AND		GLAccount != '#url.account#'
									ORDER BY ListOrder ASC
								)
	</cfquery>
</cfif>

<cfquery name="delete" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM	JournalAccount
		WHERE	Journal = '#url.journal#'
		AND		GLAccount = '#url.account#'
</cfquery>

<cfoutput>
	<script>
		glaccount();
	</script>
</cfoutput>