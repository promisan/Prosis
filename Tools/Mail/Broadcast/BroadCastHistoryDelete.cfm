
<cfquery name="Delete" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  DELETE FROM Broadcast
	  WHERE BroadcastId = '#URL.del#' 
</cfquery>

<cfinclude template="BroadCastHistory.cfm">