<cftry>
	
	<cfset request.isAuthenticated = false>
	
	<cfinclude template="common.cfm">
	
	<cfif NOT request.firewall.getAuthenticator().isUserAuthenticated()>
		<cfinclude template="views/header.cfm">
		<cfinclude template="views/login.cfm">
		<cfinclude template="views/footer.cfm">
		<cfabort>
	<cfelse>
		<cfset request.isAuthenticated = true>
	</cfif>
	<cfcatch type="any">
		<cfmodule template="views/catch.cfm" catch="#cfcatch#" /><cfabort>
	</cfcatch>
</cftry>