
<cf_compression>

<cfquery name="setRecipient" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  UPDATE BroadcastRecipient
	  SET    Selected    = '#URL.val#'
	  WHERE  RecipientId = '#URL.recid#' 
</cfquery>