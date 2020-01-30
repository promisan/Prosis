<cfcomponent hint="Utility Component Intended to be extended by Application.cfc">
	
	<cffunction name="fuseguard" returntype="boolean" output="false" hint="Invokes FuseGuard Web Application Firewall">
		<cfargument name="configurator" default="DefaultConfigurator">
		<cfargument name="scope" default="application" hint="Use server, application, or request">
		<cfset arguments.scope = Left(arguments.scope, 1)>
		<cfif arguments.scope IS "a">
			<cfif NOT StructKeyExists(application, "fuseguard") OR application.fuseguard.shouldReInitialize()>
				<cfset application.fuseguard = CreateObject("component", "firewall").init(configurator=arguments.configurator)>
			</cfif>
			<cfreturn application.fuseguard.processRequest()>
		<cfelseif arguments.scope IS "s">
			<cfif NOT StructKeyExists(server, "fuseguard") OR server.fuseguard.shouldReInitialize()>
				<cfset server.fuseguard = CreateObject("component", "firewall").init(configurator=arguments.configurator)>
			</cfif>
			<cfreturn server.fuseguard.processRequest()>
		<cfelse>
			<cfif NOT StructKeyExists(request, "fuseguard") OR request.fuseguard.shouldReInitialize()>
				<cfset request.fuseguard = CreateObject("component", "firewall").init(configurator=arguments.configurator)>
			</cfif>
			<cfreturn request.fuseguard.processRequest()>
		</cfif>
	</cffunction>
	
</cfcomponent>