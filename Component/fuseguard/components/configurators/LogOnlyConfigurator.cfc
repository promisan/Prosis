<cfcomponent extends="BaseConfigurator" hint="Example Configuration that only logs attacks, it does not block them.">
	<cfset variables.email = "you@example.com">
	<cfset variables.datasource = "fuseguard">
	<cfset variables.db_type = "derby"><!--- derby,mysql,sqlserver --->
	<cfset variables.datasource_username = "">
	<cfset variables.datasource_password = "">
	
	<cffunction name="configure" returntype="void" output="false" access="public" hint="Called when the firewall is initialized to configure itself">
		<cfargument name="firewallInstance" required="true" hint="The firewall component instance to be configured">
		<cfset var firewall = arguments.firewallInstance>
		<cfset var filter = "">
		<cfset var logger = "">
		<cfset var authenticator = "">
		<!--- =============== DEFAULTS =============== --->
		
		<!--- Set Default Log Level = 1 meaning log anything that has a threat of 1-10 --->
		<cfset firewall.setDefaultLogLevel(1)>
		<!--- Set Default Block Level = 0 meaning don't block anything--->
		<cfset firewall.setDefaultBlockLevel(0)>
		
		<!--- Use the Reinitialization Key 
			to reinitialize by passing ?fuseguard_reinit=yourKey --->
		<!---<cfset firewall.setReInitializeKey("yourKey")>--->
		<cfset firewall.setReInitializeKey(CreateUUID() & RandRange(1,999999) & CreateUUID())>
		
		<!--- =============== WEB MANAGER =============== --->
		<cfset firewall.setWebManagerEnabled(true)>
		
		<cfset authenticator = firewall.newAuthenticatorInstance("DBAuthenticator")>
		<cfset authenticator.setDatasource(datasource=variables.datasource, username=variables.datasource_username, password=variables.datasource_password, dbtype=variables.db_type)>
		<cfset firewall.setAuthenticator(authenticator)>
		
		
		<!--- =============== LOGGERS =============== --->
		
		<!--- database logger --->
		<cfset logger = firewall.newLoggerInstance("DBLogger")>
		<cfset logger.setVerbose(true)>
		<cfset logger.setEscapeMessage(false)>
		<cfset logger.setDatasource(datasource=variables.datasource, username=variables.datasource_username, password=variables.datasource_password, dbtype=variables.db_type)>
		<cfset firewall.addLogger( logger )>
		
		<!--- cflog Logger - Logs to filesystem in cf log folder --->
		<!--->
		<cfset logger = firewall.newLoggerInstance("CFLogLogger")>
		<cfset logger.setVerbose(false)>
		<cfset firewall.addLogger( logger )>
		--->
		<!--- cfmail SMTP Logger - Sends logs via email --->
		<cfif variables.email IS NOT "you@example.com">
			<cfset logger = firewall.newLoggerInstance("CFMailLogger")>
			<cfset logger.setVerbose(true)>
			<cfset logger.addRecipient(variables.email)>
			<cfset firewall.addLogger( logger )>
		</cfif>
		
		<!--- =============== FILTERS =============== --->
		<!--- Filters Execute in the order they were added --->
		
		<!--- Repeat Offender Filter - Bans IP's that are blocked multiple times --->
		<cfset filter = firewall.newFilterInstance("RepeatOffenderFilter")>
		<cfset filter.setMaximumBlockedRequests(30)>
		<cfset firewall.addFilter( filter )>
		
		<!--- Simple IP Blocking Filter - blocks by IP address --->
		<cfset filter = firewall.newFilterInstance("SimpleIPBlockingFilter")>
		<cfset filter.blockIP("10.11.12.13")><!--- Block Requests from IP 10.11.12.13--->
		<cfset firewall.addFilter( filter )>
		
		<!--- Query String Length Filter - Rejects requests with query string length greater than specified value --->
		<cfset filter = firewall.newFilterInstance("QueryStringLengthFilter")>
		<cfset filter.setMaximumLength(512)>
		<cfset firewall.addFilter( filter )>
		
		<!--- Looks for null byte URL encoded in the url scope  --->
		<cfset filter = firewall.newFilterInstance("NullByteFilter")>
		<cfset filter.setScopes("url")>
		<cfset firewall.addFilter( filter )>
		
		<!--- JVM DOS Floating Point Filter - Fixed in JVM 1.6.0_24 if running that version or greater you can disable this --->
		<cfset filter = firewall.newFilterInstance("JVMFloatingPointFilter")>
		<cfset firewall.addFilter( filter )>
		
		<!--- ID Validation Filter - makes sure variables ending in id are simple strings --->
		<cfset filter = firewall.newFilterInstance("IDValidationFilter")>
		<!--- ignore CGI scope because it is not applicable to this filter --->
		<cfset filter.setScopes("form,url,cookie")>
		<cfset filter.setMaximumStringLength(256)>
		<cfset firewall.addFilter( filter )>
		
		<!--- SQL Injection Filter - Looks for SQL Injection in the Request --->
		<cfset filter = firewall.newFilterInstance("SQLInjectionFilter")>
		<cfset firewall.addFilter( filter )>
		
		<!--- XSS Filter - Looks for Cross Site Scripting Vectors --->
		<cfset filter = firewall.newFilterInstance("CrossSiteScriptingFilter")>
		<cfset firewall.addFilter( filter )>
		
		<!--- CRLF Injection Filter - Looks for CRLF in the Request --->
		<cfset filter = firewall.newFilterInstance("CRLFInjectionFilter")>
		<cfset filter.setScopes("url")>
		<cfset firewall.addFilter(filter)>
		
		<!--- Session Hijacking Filter - Looks for change of session --->
		<cfset filter = firewall.newFilterInstance("SessionHijackingFilter")>
		<cfset firewall.addFilter(filter)>
		
		<!--- Foreign Post Filter - Rejects form POST from other domains --->
		<cfset filter = firewall.newFilterInstance("ForeignPostFilter")>
		<cfset firewall.addFilter( filter )>
		
		<!--- Dot Dot Slash Filter - Rejects ../ or ..\ in variables --->
		<cfset filter = firewall.newFilterInstance("DotDotSlashFilter")>
		<cfset firewall.addFilter( filter )>
		
		<!--- Dictionary Attack Filter - Looks for repeated requests with passwords --->
		<cfset filter = firewall.newFilterInstance("DictionaryAttackFilter")>
		<cfset filter.setMaximumAttempts(20)>
		<cfset filter.setExpiresAfter(120)><!--- expires after 120 seconds of inactivity --->
		<cfset firewall.addFilter( filter )>

		<!--- Content Length Filter - Rejects large requests --->
		<cfset filter = firewall.newFilterInstance("ContentLengthFilter")>
		<cfset filter.setMaximumLength(10485760)>
		<cfset firewall.addFilter( filter )>
		
		<!--- URL Session ID Filter - Rejects request that have a session id in the url --->
		<cfset filter = firewall.newFilterInstance("URLSessionIDFilter")>
		<cfset firewall.addFilter( filter )>
		
		<!--- Scope Injection Filter - Looks Variables like url.application.x --->
		<cfset filter = firewall.newFilterInstance("ScopeInjectionFilter")>
		<cfset firewall.addFilter( filter )>
		
		<!--- for more information about the options of each filter 
			please read the documentation --->
		
	</cffunction>
	
</cfcomponent>