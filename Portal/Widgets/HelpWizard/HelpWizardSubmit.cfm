
<cfoutput>
<cfif url.id neq "">
	<cfif url.process eq "Delete"> 
		<cfquery name="HelpWizardUpdate" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE UserModule
				SET    Status   = '0'
				WHERE  SystemFunctionId = '#url.id#'
				AND    Account = '#SESSION.acc#'
		</cfquery>	
	<cfelseif url.process eq "Complete">
		<cfquery name="HelpWizardUpdate" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE UserModule
				SET    Status   = '3'
				WHERE  SystemFunctionId = '#url.id#'
				AND    Account = '#SESSION.acc#'
		</cfquery>
	</cfif>
</cfif>
</cfoutput>
	