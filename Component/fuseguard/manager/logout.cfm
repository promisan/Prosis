<cfinclude template="check-auth.cfm">
<cftry>
	<cfset request.firewall.getAuthenticator().logout()>
	<cfcatch type="any">
		<cfmodule template="views/catch.cfm" catch="#cfcatch#" /><cfabort>
	</cfcatch>
</cftry>
<cflocation url="#request.urlBuilder.createDynamicURL('index')#" addtoken="false">