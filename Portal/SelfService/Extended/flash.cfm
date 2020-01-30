<cfparam name="URL.ID" default="">
<cfparam name="URL.DIR" default="Main">

<cfif URL.ID neq "">
       
		<cfinclude template="#url.DIR#/flash#URL.ID#.cfm">
	
<cfelse>			 
             
       <cftry>
            <cfinclude template="#client.flashcurrent#.cfm">
       <cfcatch>
            <cfinclude template="#url.DIR#/flash1.cfm">
       </cfcatch>
       </cftry>                       			
			
</cfif>