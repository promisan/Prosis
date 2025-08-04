<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfset vValid = 1>

<cftransaction>

	<cfif form.origaccount eq "">
	
		<cfquery name="validate" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM	JournalAccount
				WHERE	Journal   = '#url.journal#'
				AND		GLAccount = '#form.glaccount#'
		</cfquery>
		
		<cfif validate.recordCount eq 0>
		
			<cfset vListDefault = 0>
			<cfif isDefined("form.ListDefault")>
				<cfset vListDefault = 1>
			</cfif>
			
			<cfif vListDefault eq 1 and form.mode eq "contra">
			
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
					INSERT INTO JournalAccount (
							Journal,
							GLAccount,
							<cfif form.mode eq "contra">
							ListDefault,
							</cfif>
							ListOrder,
							Mode,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						) VALUES (
							'#url.journal#',
							'#form.glaccount#',
							'#vListDefault#',
							'#form.ListOrder#',
							<cfif form.mode eq "contra">
							'#form.mode#',
							</cfif>
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
						ListOrder   = '#form.ListOrder#',
						Mode        = '#form.mode#'
				WHERE	Journal     = '#url.journal#'
				AND		GLAccount   = '#form.glaccount#'
		</cfquery>
					
	</cfif>

</cftransaction>

<cfif vValid eq 1>
	<script>
		glaccount();
	</script>
<cfelse>
	<cf_tl id="This account is already associated to this journal." var="1">
	<cfoutput>
		<script>
			alert('#lt_text#');
		</script>
	</cfoutput>
</cfif>

<cfif form.origaccount neq "">

	<script>
		ProsisUI.closeWindow('journalaccount')
	</script>

</cfif>	


