<cfcomponent name="BaseLogger" hint="Base Component All Loggers Must Extend">
	<cfset variables.verbose = true>
	<cfset variables.escapeMessage = true>
	<cfset variables.logOnlyBlocks = false>
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="firewallInstance">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="logRequest" returntype="void" access="public" output="false">
		<cfargument name="level" type="numeric" required="true">
		<cfargument name="filter" type="any" hint="a Filter object">
		<cfargument name="type" default="inspectRequest" type="variablename">
		<cfargument name="message" type="string" default="">
		<cfargument name="detail" type="string" default="">
	</cffunction>
	
	<cffunction name="setVerbose" returntype="void" access="public" output="false" hint="Tells the logger to be brief if set to false">
		<cfargument name="verbose" type="boolean" required="true">
		<cfset variables.verbose = arguments.verbose>
	</cffunction>
	
	<cffunction name="isVerbose" returntype="boolean" access="public" output="false" hint="Returns true if verbose logging is enabled.">
		<cfreturn variables.verbose>
	</cffunction>
	
	<cffunction name="isViewable" returntype="boolean" hint="If the log is viewable such as a file or DB return true, if not (email, or IM) return false.">
		<cfreturn false>
	</cffunction>
	
	<cffunction name="hasLogReader" returntype="boolean" output="false" hint="If this logger has an associated log reader, return true">
		<cfreturn false>
	</cffunction>
	
	<cffunction name="escapesMessage" returntype="boolean" output="false" hint="Returns true if the log messages are escaped">
		<cfreturn variables.escapeMessage>
	</cffunction>
	
	<cffunction name="setEscapeMessage" returntype="void" output="false" hint="Turns on or off log message escaping, beware that turning this off may not be a good idea.">
		<cfargument name="escapeMessage" type="boolean">
		<cfset variables.escapeMessage = arguments.escapeMessage>
	</cffunction>
	
	<cffunction name="setLogOnlyBlocked" returntype="void" output="false" hint="When true logs only blocked events">
		<cfargument name="logOnlyBlocks" type="boolean" default="false">
		<cfset variables.logOnlyBlocks = arguments.logOnlyBlocks>
	</cffunction>
	
	<cffunction name="logOnlyBlocked" returntype="boolean" output="false" hint="Returns true if only blocked events are logged">
		<cfreturn variables.logOnlyBlocks>
	</cffunction>
	
	<cffunction name="getStorageDescription" returntype="string" output="false" hint="Returns a description of where the data is stored, eg datasource name.">
		<cfreturn "Unspecified">
	</cffunction>
	
</cfcomponent>
