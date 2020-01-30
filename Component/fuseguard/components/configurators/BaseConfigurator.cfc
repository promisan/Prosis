<cfcomponent output="false" hint="The Base Component that All Configurator Components Should Extend.">
	
	<cffunction name="init" returntype="BaseConfigurator" output="false" hint="Returns an instance of the Configuration Object">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="configure" returntype="void" output="false" access="public" hint="Called when the firewall is initialized to configure itself">
		<cfargument name="firewallInstance" required="true" hint="The firewall instance to be configured">
	</cffunction>
	
</cfcomponent>