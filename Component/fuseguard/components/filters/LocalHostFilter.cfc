<cfcomponent extends="BaseFilter" name="LocalHostFilter" displayname="LocalHost Filter" hint="Checks if request is from localhost">
	
	<cffunction name="inspectRequest" returntype="numeric" output="false">
		<cfif getFirewall().getRequestIPAddress() IS "127.0.0.1">
			<cfreturn 0>
		<cfelse>
			<cfreturn 10>
		</cfif>
	</cffunction>
	
	<cffunction name="getName" returntype="string" output="false"><cfreturn "Localhost Filter"></cffunction>
	
	<cffunction name="getDescription" returntype="string" output="false"><cfreturn "This filter returns a threat level of 10 on any request that does not come from localhost."></cffunction>
	
	<cffunction name="getThreatCategory" returntype="string" output="false" hint="Returns network">
		<cfreturn "network">
	</cffunction>
	
</cfcomponent>