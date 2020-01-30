
<cfquery name="deleteNotification" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM   Ref_ActionServiceItemNotification
		WHERE  ServiceItem = '#url.scode#'		
		AND    Action = '#url.acode#'
		AND	   Notification = '#url.ncode#'
</cfquery>

<cfoutput>
	<script>
		window.location.reload();
	</script>
</cfoutput>