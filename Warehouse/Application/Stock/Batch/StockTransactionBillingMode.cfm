
<cfif url.selected eq "True">
	<cfset val = "External">
<cfelse>
	<cfset val = "Internal">
</cfif>

<cfquery name="Set"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE   ItemTransaction
	SET      BillingMode = '#val#'
	WHERE    TransactionId = '#URL.TransactionId#' 	
</cfquery>

<cf_compression>