<cftry>
	<cfsetting enablecfoutputonly="no">
	<cfif IsDefined("application.fuseguard") AND StructKeyExists(application, "fuseguard")>
		<cfset request.firewall = application.fuseguard>
	<cfelseif StructKeyExists(server, "fuseguard")>	
		<cfset request.firewall = server.fuseguard>
	<cfelseif StructKeyExists(request, "fuseguard")>
		<cfset request.firewall = request.fuseguard>
	<cfelse>
		<cfset request.title = "Not Defined">
		<cfinclude template="views/header.cfm">
		<cfinclude template="views/not-defined.cfm">
		<cfinclude template="views/footer.cfm">
		<cfabort>
	</cfif>
	<cfset request.urlBuilder = request.firewall.getURLBuilder()>
	<cfif NOT request.firewall.getWebManagerEnabled() OR NOT request.firewall.hasAuthenticator()>
		<cfset request.title = "Disabled">
		<cfinclude template="views/header.cfm">
		<cfinclude template="views/disabled.cfm">
		<cfinclude template="views/footer.cfm">
		<cfabort>
	</cfif>
	<cfcatch type="any">
		<cfmodule template="views/catch.cfm" catch="#cfcatch#" /><cfabort>
	</cfcatch>
</cftry>