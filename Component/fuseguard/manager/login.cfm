<cfparam name="form.username" default="">
<cfparam name="form.password" default="">
<cftry>
	<cfif NOT StructKeyExists(request, "firewall")>
		<cfinclude template="common.cfm">
	</cfif>
 	<cfif NOT request.firewall.getWebManagerEnabled() OR NOT request.firewall.hasAuthenticator()> 
		<cfinclude template="views/header.cfm">
		<cfinclude template="views/disabled.cfm">
		<cfinclude template="views/footer.cfm">
		<cfabort>
	</cfif>

	<cfset auth = request.firewall.getAuthenticator()>
	
	<cfif auth.authenticate(form.username, form.password)>
		<cflocation url="#request.urlBuilder.createDynamicURL('index')#" addtoken="false">
	<cfelse>
		<cfthrow message="Invalid Username or Password" type="fuseguard">
	</cfif>
	<cfcatch type="fuseguard">
		<cfset request.loginMessage = cfcatch.message>
		<cfinclude template="views/header.cfm">
		<cfinclude template="views/login.cfm">
		<cfinclude template="views/footer.cfm">
		<cfabort>
	</cfcatch>
	<cfcatch type="any">
		<cfmodule template="views/catch.cfm" catch="#cfcatch#" /><cfabort>
	</cfcatch>
</cftry>