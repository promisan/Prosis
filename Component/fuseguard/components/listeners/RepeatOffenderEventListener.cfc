<cfcomponent extends="EventListener" output="false" hint="Event Listener Used by the RepeatOffenderFilter">
	<cfset variables.filter = "">
	
	
	<cffunction name="processBlockedRequest" returntype="void" output="false" access="public" hint="Called when a request is blocked">
		<cfargument name="filter" required="true" hint="The filter triggering the event">
		<cfargument name="level" required="true" type="numeric" hint="The threat level indicated by the filter">
		<cfset variables.filter.processBlockedRequest(arguments.filter, arguments.level)>
	</cffunction>
	
	<cffunction name="setCallbackFilter" returntype="void" output="false" access="public" hint="Invokes processBlockedRequest on this method">
		<cfargument name="filter" required="true" hint="A reference to the filter that wants to receive the event notification">
		<cfset variables.filter = arguments.filter>
	</cffunction>
	
	
	
</cfcomponent>