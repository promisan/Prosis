<cfcomponent extends="BaseConfigurator" hint="Example Configuration that very strict">
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
		<!--- Set Default Block Level = 1 meaning block anything with threat level 1-10--->
		<cfset firewall.setDefaultBlockLevel(1)>
		
		<!--- Use the Reinitialization Key 
			to reinitialize by passing ?fuseguard_reinit=yourKey --->
		<!---<cfset firewall.setReInitializeKey("yourKey")>--->
		<cfset firewall.setReInitializeKey(CreateUUID() & RandRange(1,999999) & CreateUUID())>
		
		<!--- =============== WEB MANAGER =============== --->
		<cfset firewall.setWebManagerEnabled(true)>
		
		<cfset authenticator = firewall.newAuthenticatorInstance("DBAuthenticator")>
		<cfset authenticator.setDatasource(datasource=variables.datasource, username=variables.datasource_username, password=variables.datasource_password, dbtype=variables.db_type)>
		<!--- default hash algorithm is SHA-1 you can change to a stronger one, you will need to reset your password using the forgot password feature in the web manager --->
		<!---
		<cfset authenticator.setHashAlgorithm("SHA-512")>
		--->
		<cfset firewall.setAuthenticator(authenticator)>
		
		
		<!--- =============== LOGGERS =============== --->
		
		<!--- database logger --->
		<cfset logger = firewall.newLoggerInstance("DBLogger")>
		<cfset logger.setVerbose(true)>
		<cfset logger.setDatasource(datasource=variables.datasource, username=variables.datasource_username, password=variables.datasource_password, dbtype=variables.db_type)>
		<cfset firewall.addLogger( logger )>
		
		<!--- cflog Logger - Logs to filesystem in cf log folder --->
		<!---
		<cfset logger = firewall.newLoggerInstance("CFLogLogger")>
		<cfset logger.setVerbose(false)>
		<cfset firewall.addLogger( logger )>
		--->
		<!--- cfmail SMTP Logger - Sends logs via email --->
		<cfif variables.email IS NOT "you@example.com">
			<cfset logger = firewall.newLoggerInstance("CFMailLogger")>
			<cfset logger.addRecipient(variables.email)>
			<cfset firewall.addLogger( logger )>
		</cfif>
		
		<!--- =============== FILTERS =============== --->
		<!--- Filters Execute in the order they were added --->
		
		<!--- Repeat Offender Filter - Stop Logging blocks after 50 attempts per IP to prevent
			 overload resources with logging --->
		<cfset filter = firewall.newFilterInstance("RepeatOffenderFilter")>
		<cfset filter.setMaximumBlockedRequests(50)>
		<cfset filter.setLogLevel(0)>
		<cfset firewall.addFilter( filter )>
		
		<!--- Repeat Offender Filter - Block IP's that are blocked 5 times --->
		<cfset filter = firewall.newFilterInstance("RepeatOffenderFilter")>
		<cfset filter.setMaximumBlockedRequests(5)>
		<cfset firewall.addFilter( filter )>
		
		<!--- Simple IP Blocking Filter - blocks by IP address --->
		<cfset filter = firewall.newFilterInstance("SimpleIPBlockingFilter")>
		<cfset filter.blockIP("10.11.12.13")><!--- Block Requests from IP 10.11.12.13--->
		<cfset firewall.addFilter( filter )>
		
		<!--- JVM DOS Floating Point Filter - Fixed in JVM 1.6.0_24 if running that version or greater you can disable this --->
		<cfset filter = firewall.newFilterInstance("JVMFloatingPointFilter")>
		<cfset firewall.addFilter( filter )>
		
		<!--- ID Validation Filter - makes sure variables ending in id are only intergers --->
		<cfset filter = firewall.newFilterInstance("IDValidationFilter")>
		<cfset filter.setMaximumStringLength(64)>
		<cfset filter.setStringsAllowed(false)>
		<cfset filter.setUUIDAllowed(false)>
		<cfset filter.setNegativeIntegersAllowed(false)>
		<cfset firewall.addFilter( filter )>
		
		<cfif FindNoCase("BlueDragon", server.coldfusion.productname)>
			<!--- open blue dragon doesnt use an integer for cfid 
					so lets ignore cookie.cfid in the IDValidationFitler
			--->
			<cfset filter.ignoreVariable("cookie", "cfid")>
			
			<!--- BUT lets still validate cookie.cfid on openbd --->
			<cfset filter = firewall.newFilterInstance("VariablePatternFilter")>
			<cfset filter.setPattern("^[0-9a-zA-Z_-]+$")>
			<cfset filter.setVariableName("cookie", "cfid")>
			<cfset firewall.addFilter( filter )>
		</cfif>
		
		<!--- Query String Length Filter - Rejects requests with query string length greater than specified value --->
		<cfset filter = firewall.newFilterInstance("QueryStringLengthFilter")>
		<cfset filter.setMaximumLength(150)>
		<cfset firewall.addFilter( filter )>
		
		<!--- Looks for null byte URL encoded in the url scope  --->
		<cfset filter = firewall.newFilterInstance("NullByteFilter")>
		<cfset firewall.addFilter( filter )>
		
		<!--- URL Session ID Filter - Rejects request that have a session id in the url --->
		<cfset filter = firewall.newFilterInstance("URLSessionIDFilter")>
		<cfset firewall.addFilter( filter )>
		
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
		<cfset filter.setMaximumAttempts(5)>
		<cfset filter.setExpiresAfter(86400)><!--- expires after 86400 seconds (1 day) of inactivity --->
		<cfset firewall.addFilter( filter )>

		<!--- file upload filter, only allows files of specified types to be uploaded --->
		<cfset filter = firewall.newFilterInstance("FileUploadFilter")>
		<cfset filter.setDeniedFileExtensions("*")>
		<cfset filter.setAllowedFileExtensions("jpg,gif,png,jpeg,doc,pdf,docx,xls,xlsx,jpeg")>
		<cfset firewall.addFilter(filter)>

		<!--- Content Length Filter - Rejects large requests --->
		<cfset filter = firewall.newFilterInstance("ContentLengthFilter")>
		<cfset filter.setMaximumLength(1048576)><!--- 1MB max size --->
		<cfset firewall.addFilter( filter )>
		
		<!--- CRLF Injection Filter - Looks for CRLF in the Request --->
		<cfset filter = firewall.newFilterInstance("CRLFInjectionFilter")>
		<cfset filter.setScopes("url")>
		<cfset firewall.addFilter(filter)>
		
		<!--- XSS Filter - Looks for Cross Site Scripting Vectors --->
		<cfset filter = firewall.newFilterInstance("CrossSiteScriptingFilter")>
		<cfset firewall.addFilter( filter )>
		
		<!--- SQL Injection Filter - Looks for SQL Injection in the Request --->
		<cfset filter = firewall.newFilterInstance("SQLInjectionFilter")>
		<cfset firewall.addFilter( filter )>
		
		<!--- Scope Injection Filter - Looks Variables like url.application.x --->
		<cfset filter = firewall.newFilterInstance("ScopeInjectionFilter")>
		<cfset filter.setStrictMode(true)><!--- strictMode flags any variable with a dot in it, eg x.cfm?y.z=1 --->
		<cfset firewall.addFilter( filter )>
		
		<!--- for more information about the options of each filter 
			please read the documentation --->
		
	</cffunction>
	
</cfcomponent>