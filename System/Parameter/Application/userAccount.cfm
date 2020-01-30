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

	#UserAccount.FirstName# #UserAccount.LastName# (#UserAccount.Account#)
	<input type="hidden" name="acc" id="acc" value="#UserAccount.Account#">
	
</cfoutput>