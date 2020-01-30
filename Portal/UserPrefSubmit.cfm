
<cfif url.id eq "Theme">

	<cfoutput>

	<cfquery name="UpdateUser" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE   UserNames 
	SET      Pref_Color   = '#url.theme#'	         
	WHERE    Account = '#SESSION.acc#'
	</cfquery>
	
	<cf_compression>
		
	</cfoutput>

	
</cfif>
