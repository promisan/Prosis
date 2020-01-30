<cfcomponent name="CFMailLogger" extends="BaseLogger" hint="A Logger that sends log messages via email">
	<cfset variables.mailFrom = "firewall@" & ReplaceNoCase(cgi.server_name, "www.", "")>
	<cfset variables.recipients = "">
	<cfset variables.smtpServer = "">
	<cfset variables.smtpUsername = "">
	<cfset variables.smtpPassword = "">
	
	<cffunction name="logRequest" returntype="void" access="public">
		<cfargument name="level" type="numeric" required="true">
		<cfargument name="filter" type="any" hint="a Filter object">
		<cfargument name="type" default="inspectRequest" type="variablename">
		<cfargument name="message" type="string" default="">
		<cfargument name="detail" type="string" default="">
		<cfset var subject = "[#arguments.level#] #cgi.remote_addr# #filter.getName()# ">
		<cfset var body = "">
		
		<cfif filter.blockEnabled() AND arguments.level GTE filter.getBlockLevel()>
			<cfset subject = subject & "Blocked ">
		<cfelseif filter.filterEnabled() AND arguments.level GTE filter.getFilterLevel()>
			<cfset subject = subject & "Filtered ">
		</cfif>
		<cfset subject = subject & " [#Replace(LCase(cgi.server_name), "www.", "")#]">
		<cfoutput>
<cfsavecontent variable="body">#arguments.message#
=====================================================================
Threat Severity Level: [#arguments.level#/10]
Filter: #arguments.filter.getName()# (#arguments.filter.getFilterID()#)
Type: #arguments.type#
Remote IP: #cgi.remote_addr#
Date: #DateFormat(Now(), "full")# 
Time: #TimeFormat(Now(), "full")#
=====================================================================
Server Name: #cgi.server_name#
Server Port: #cgi.server_port#
Request Method: #cgi.request_method#
Script Name: #cgi.script_name#
<cfif isVerbose()>
Query String: #cgi.query_string#
User Agent: #cgi.user_agent#
HTTP Referrer: #cgi.HTTP_REFERER#

=====================================================================
Detail:

#arguments.detail#

=====================================================================
Filter Description:

#arguments.filter.getDescription()#

--
Foundeo Web Application Firewall For ColdFusion
http://foundeo.com/security/
</cfif>

</cfsavecontent>	
		</cfoutput>
		<cfif NOT Len(variables.smtpServer) AND NOT Len(variables.smtpUsername) AND NOT Len(variables.smtpPassword)>
			<cfmail to="#variables.recipients#" from="#variables.mailFrom#" subject="#subject#" type="text">#body#</cfmail>
		<cfelse>
			<cfmail to="#variables.recipients#" from="#variables.mailFrom#" subject="#subject#" type="text" server="#variables.smtpServer#" username="#variables.smtpUsername#" password="#variables.smtpPassword#">#body#</cfmail>
		</cfif>
	</cffunction>
	
	<cffunction name="addRecipient" returntype="void" output="false" hint="Add an email address to send to">
		<cfargument name="email" type="string">
		<cfset arguments.email = ReReplace(arguments.email, "[^a-zA-Z0-9@_.+-]", "", "ALL")>
		<cfset variables.recipients = ListAppend(variables.recipients, arguments.email)>
	</cffunction>
	
	<cffunction name="setFromAddress" returntype="void" output="false" hint="The email address mail will be from. You can use a value like: Firewall <firewall@example.com>">
		<cfargument name="email" type="string" required="true">
		<cfset arguments.email = ReReplace(arguments.email, "[^a-zA-Z0-9@_.+ <>-]", "", "ALL")>
		<cfset variables.mailFrom = arguments.email>
	</cffunction>
	
	<cffunction name="setSMTPServer" returntype="void" output="false" hint="Set the SMTP Server username, and password">
		<cfargument name="smtpServer" type="string" required="true" hint="Host Name or IP Address of SMTP Server">
		<cfargument name="smtpUsername" type="string" default="" hint="User Name for SMTP Server">
		<cfargument name="smtpPassword" type="string" default="" hint="Password for SMTP Server">
		<cfset variables.smtpServer = arguments.smtpServer>
		<cfset variables.smtpUsername = arguments.smtpUsername>
		<cfset variables.smtpPassword = arguments.smtpPassword>
	</cffunction>
	
	<cffunction name="isViewable" returntype="boolean" hint="If the log is viewable such as a file or DB return true, if not (email, or IM) return false.">
		<cfreturn false>
	</cffunction>
	
	<cffunction name="getStorageDescription" returntype="string" output="false" hint="Returns a description of where the data is stored, eg datasource name.">
		<cfset var r = "to=" & variables.recipients & ", from=" & variables.mailFrom>
		<cfif Len(variables.smtpServer)>
			<cfset r = r & ", smtp=" & variables.smtpServer>
		</cfif>
		<cfreturn r>
	</cffunction>
	
</cfcomponent>