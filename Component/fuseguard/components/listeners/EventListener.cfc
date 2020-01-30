<cfcomponent output="false" displayname="Event Listener Base Implementation" hint="Base Component All Event Listeners Must Extend">
	
	<cffunction name="init" access="public" output="false" returntype="EventListener" hint="Called on initiliaztion, returns an instance of self">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="processBlockedRequest" returntype="void" output="false" access="public" hint="Called when a request is blocked">
		<cfargument name="filter" required="true" hint="The filter triggering the event">
		<cfargument name="level" required="true" type="numeric" hint="The threat level indicated by the filter">
	</cffunction>
	
</cfcomponent>