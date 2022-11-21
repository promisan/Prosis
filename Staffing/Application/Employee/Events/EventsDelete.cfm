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

<!--- close the workflow with an indicator --->
	
<cfset show = "No">   		    
<cfset enf  = "Yes">
    
<cf_ActionListing 
    EntityCode       = "PersonEvent"				
	EntityGroup      = ""
	EntityStatus     = ""				
	ObjectKey4       = "#URL.EventId#"				
	Show             = "#show#"				
	CompleteCurrent  = "#enf#">	 
	
<cfoutput>

<cfif url.scope eq "inquiry" or url.scope eq "personal">
	<script>
	    <!--- we hide the interface --->
		ptoken.navigate('#SESSION.root#/Staffing/Portal/Events/deleteEvent.cfm?id=#url.eventid#','process');
	</script>
<cfelse>
	<script>
		ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/EventsListing.cfm?id=#qEvent.PersonNo#','eventdetail');
	</script>
</cfif>
</cfoutput>
