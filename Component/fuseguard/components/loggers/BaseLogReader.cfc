<cfcomponent hint="I am an abstract class for reading from a log">
	
	<cfset variables.firewall = "">
	<cfset variables.logger = "">
	
	<cffunction name="init" returntype="BaseLogReader" output="false" hint="Initialize the LogReader on firewall startup.">
		<cfargument name="firewall" hint="The firewall instance.">
		<cfargument name="logger" hint="The logger that this LogReader corresponds to.">
		<cfset variables.firewall = arguments.firewall>
		<cfset variables.logger = arguments.logger>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getLogger" returntype="BaseLogger" output="false" hint="Return the logger that corresponds to this LogReader">
		<cfreturn variables.logger>
	</cffunction>
	
	
	<cffunction name="getAllThreatCategories" returntype="query" output="false" hint="Returns a query with column threat_category">
		<cfreturn QueryNew("threat_category")>
	</cffunction>
	
	<cffunction name="getAllHostNames" returntype="query" output="false" hint="Returns a query with column request_host">
		<cfreturn QueryNew("request_host")>
	</cffunction>
	
	<cffunction name="getLogEntries" returntype="query" output="false" hint="Returns a query with several columns">
		<cfargument name="year" type="numeric" default="0" hint="Pass in a year to filter by year, or 0 for any year">
		<cfargument name="month" type="numeric" default="0" hint="Pass in a month to filter by month, or 0 for any month">
		<cfargument name="day" type="numeric" default="0" hint="Pass in a day or 0 to filter by any day">
		<cfargument name="threat_category" type="string" default="" hint="Pass in a threat category to filter by, or an empty string for any category.">
		<cfargument name="script_name" type="string" default="" hint="Pass in a URI to filter by, supports wildcards eg /admin/* will match anything under the admin uri.">
		<cfargument name="ip" type="string" default="" hint="Pass in an IP address to filter by.">
		<cfargument name="host" type="string" default="" hint="Pass in a hostname to filter by.">
		<cfargument name="threat_level" type="numeric" default="0" hint="Threat Level from 1-10">
		<cfargument name="blocked" type="string" default="" hint="Pass boolean to filter by blocked or not blocked">
		<cfargument name="limit" type="numeric" default="0" hint="Limit the number of records returned to this many">
		<cfargument name="page" type="numeric" default="1" hint="Page number when used with limit">
		<cfthrow message="The getLogEntries method is not implemented in the LogReader implementation">
	</cffunction>
	
	<cffunction name="getLogDetail" returntype="query" output="false" hint="Returns all information about a particular log entry.">
		<cfargument name="id" type="string" default="0">
		<cfthrow message="The getLogDetail method is not implemented in the LogReader implementation">
	</cffunction>
	
	
	<cffunction name="getCountFor" returntype="query" output="false" hint="Returns a query with the num column and column passed into the field argument.">
		<cfargument name="field" type="variablename" required="true" hint="One of: ip_address,script_name,threat_level,threat_category,filter_component,filter_name,request_date,request_host">
		<cfargument name="minimum" type="numeric" default="0">
		<cfargument name="year" type="numeric" default="0" hint="Pass in a year to filter by year, or 0 for any year">
		<cfargument name="month" type="numeric" default="0" hint="Pass in a month to filter by month, or 0 for any month">
		<cfargument name="day" type="numeric" default="0" hint="Pass in a day or 0 to filter by any day">
		<cfargument name="threat_category" type="string" default="" hint="Pass in a threat category to filter by, or an empty string for any category.">
		<cfargument name="script_name" type="string" default="" hint="Pass in a URI to filter by, supports wildcards eg /admin/* will match anything under the admin uri.">
		<cfargument name="ip" type="string" default="" hint="Pass in an IP address to filter by.">
		<cfargument name="host" type="string" default="" hint="Pass in a hostname to filter by.">
		<cfargument name="threat_level" type="numeric" default="0" hint="Threat Level from 1-10">
		<cfargument name="blocked" type="string" default="" hint="Pass boolean to filter by blocked or not blocked">
		<cfargument name="maxrows" type="numeric" default="0">
		<cfthrow message="The getCountFor method has not been implemented in your LogReader implementation.">
	</cffunction>
	
</cfcomponent>