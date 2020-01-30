<cfcomponent output="false" hint="Contains the default URL builder implementation, extend this component to create a new URL structure for FuseGuard Manager (eg for SES urls or Framework Specific URLs).">
	
	<cffunction name="init" returntype="BaseURLBuilder" output="false" hint="Initializes and returns an instance of this object.">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="createDynamicURL" returntype="string" output="false" access="public" hint="Constructs a URL for use within FuseGuard Manager">
		<cfargument name="action" type="string" hint="The path name, eg user">
		<cfargument name="queryString" type="string" default="" hint="This value should be URL Encoded already">
		<cfset arguments.action = ReReplaceNoCase(arguments.action, "[^a-z0-9/_-]", "", "ALL") & ".cfm">
		<cfif Len(arguments.queryString)>
			<cfreturn arguments.action & "?" & ReReplaceNoCase(arguments.queryString, "[^a-z0-9&%=_.-]", "", "ALL")>
		<cfelse>
			<cfreturn arguments.action>
		</cfif>
	</cffunction>
	
	<cffunction name="createStaticURL" returntype="string" output="false" access="public" hint="Constructs a URL for FuseGuard Manager static assets (js, css, img, etc)">
		<cfargument name="path" type="string" hint="The full path to the static css/js file, eg: views/style/style.css">
		<cfreturn ReReplaceNoCase(arguments.path, "[^a-z0-9/_.-]", "", "ALL")>
	</cffunction>
	
	<cffunction name="getDefaultContentSecurityPolicy" hint="Returns the content security policy header value to return. If the result of createStaticURL is of another domain (eg a CDN) then this value must be updated. See content-security-policy.com for more info.">
		<cfreturn "default-src 'self';">
	</cffunction>
	
	<cffunction name="isCurrentAction" returntype="boolean">
		<cfargument name="action" type="string">
		<cfreturn FindNoCase(arguments.action & ".cfm", cgi.script_name)>
	</cffunction>
	
</cfcomponent>