<cfparam name="thisTag.ExecutionMode" default="invalid">
<cfif thisTag.ExecutionMode IS "start" AND NOT FindNoCase("catch.cfm", cgi.script_name)>
	<cfcontent reset="true"><cfset request.title="Error"><cfinclude template="header.cfm">
	<cfparam name="attributes.catch" default="#StructNew()#">
	<cfset variables.message = "Unspecified Error">
	<cfset variables.detail = "">
	<cfif StructKeyExists(attributes.catch, "message")>
		<cfset variables.message = attributes.catch.message>
	</cfif>
	<cfif StructKeyExists(attributes.catch, "detail")>
		<cfset variables.detail = attributes.catch.detail>
	</cfif>
	<cfif StructKeyExists(attributes.catch, "type")>
		<cfif attributes.catch.type IS "fuseguard">
			<!--- message is safe to display to user --->
		<cfelseif LCase(attributes.catch.type) IS "database">
			<cfif variables.message contains "Datasource">
				<cfset variables.message = "Datasource Error - Please ensure that you have a datasource defined that matches the name specified in your Configurator.">
				<cfset variables.detail = variables.message & " " & variables.detail>
			<cfelse>
				<cfset variables.detail = variables.message & " " & variables.detail>
				<cfset variables.message = "Database Exception">
			</cfif>
		<cfelse>
			<!--- only show actual message if logged in --->
			<cfset variables.detail = variables.message & " " & variables.detail>
			<cfset variables.message = "Unspecified Exception">
		</cfif>
	</cfif>
	<cfoutput>
		<div class="error">#XmlFormat(variables.message)#</div>
		<cfif (StructKeyExists(request, "isAuthenticated") AND request.isAuthenticated)>
			<cfif StructKeyExists(request, "firewall")><div class="errorDetail">#request.firewall.stringCleaner(variables.detail, "escape")#</div></cfif>
		</cfif>
		<cfif StructKeyExists(request, "firewall") AND (request.firewall.getRequestIPAddress() IS "127.0.0.1" OR request.firewall.getRequestIPAddress() IS "::1")>
			<h3>Debugging Info</h3>
			<p>Additional debugging information is displayed because your IP address is <em>localhost</em></p>
			<br />
			#request.firewall.dumpConfiguration()#
			<cfdump var="#attributes.catch#">
		</cfif>
	</cfoutput>
	
	<cfinclude template="footer.cfm">
	<cfabort>
</cfif>