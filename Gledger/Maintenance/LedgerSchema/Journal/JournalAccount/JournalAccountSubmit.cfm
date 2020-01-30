
<cfset vValid = 1>

<cftransaction>

	<cfif url.account eq "">
	
		<cfquery name="validate" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM	JournalAccount
				WHERE	Journal = '#url.journal#'
				AND		GLAccount = '#form.glaccount#'
		</cfquery>
		
		<cfif validate.recordCount eq 0>
		
			<cfset vListDefault = 0>
			<cfif isDefined("form.ListDefault")>
				<cfset vListDefault = 1>
			</cfif>
			
			<cfif vListDefault eq 1>
			
				<cfquery name="updateDefault" 
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE	JournalAccount
						SET		ListDefault = 0
						WHERE	Journal = '#url.journal#'
				</cfquery>
				
			</cfif>

			<cfquery name="insert" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO JournalAccount
						(
							Journal,
							GLAccount,
							ListDefault,
							ListOrder,
							Mode,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					VALUES
						(
							'#url.journal#',
							'#form.glaccount#',
							'#vListDefault#',
							'#form.ListOrder#',
							'#form.mode#',
							'#session.acc#',
							'#session.last#',
							'#session.first#'
						)
			</cfquery>
			
		<cfelse>
		
			<cfset vValid = 0>
			
		</cfif>

	<cfelse>
	
		<cfset vListDefault = 0>
		<cfif isDefined("form.ListDefault")>
			<cfset vListDefault = 1>
		</cfif>
		
		<cfif vListDefault eq 1>
			<cfquery name="updateDefault" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE	JournalAccount
					SET		ListDefault = 0
					WHERE	Journal = '#url.journal#'
			</cfquery>
		</cfif>
	
		<cfquery name="update" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE	JournalAccount
				SET		ListDefault = '#vListDefault#',
						ListOrder = '#form.ListOrder#',
						Mode = '#form.mode#'
				WHERE	Journal = '#url.journal#'
				AND		GLAccount = '#form.glaccount#'
		</cfquery>
	
	</cfif>

</cftransaction>

<cfif vValid eq 1>
	<script>
		opener.glaccount();
	</script>
<cfelse>
	<cf_tl id="This account is already associated to this journal." var="1">
	<cfoutput>
		<script>
			alert('#lt_text#');
		</script>
	</cfoutput>
</cfif>

<script>
	window.close();
</script>


