<cfquery name="qEvent" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT * 
		 FROM   PersonEvent
		 WHERE  EventId='#URL.eventId#'
</cfquery>		

<cfquery name="DeleteEvent" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE PersonEvent
		SET    ActionStatus = 9
		WHERE  EventId = '#URL.EventId#'		 
</cfquery>
	
<cfoutput>
<cfif url.scope neq "portal">
	<script>
		ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventsListing.cfm?id=#qEvent.PersonNo#','eventdetail');
	</script>
<cfelse>
	<script>
		ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/Selfservice.cfm?id=#qEvent.PersonNo#','eventdetail');
	</script>
</cfif>
</cfoutput>
