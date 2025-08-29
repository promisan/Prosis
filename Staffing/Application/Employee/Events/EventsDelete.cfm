<!--
    Copyright © 2025 Promisan B.V.

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
