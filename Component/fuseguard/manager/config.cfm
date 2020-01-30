<cfinclude template="check-auth.cfm">
<cfset request.title = "FuseGuard: Configuration">
<cfinclude template="views/header.cfm">
<cftry>
	<cfoutput>
		<h2><img src="#request.urlBuilder.createStaticURL('views/images/gear.png')#" class="icon" /> Configuration</h2>
	</cfoutput>
	<cfif request.firewall.getAuthenticator().isAuthenticatedUserAdmin()>
		<cfif StructKeyExists(form, "reconfigure") AND form.reconfigure IS Hash(TimeFormat(request.firewall.getDateConfigured(), "full"))>
			<cfset request.firewall.reconfigure(request.firewall.getConfiguratorName())>
			<div class="message">Configuration Reloaded, and Reinitialized</div>
		</cfif>
		<cfoutput>
		<form action="#request.urlBuilder.createDynamicURL('config', 'fuseguard_reinit=#URLEncodedFormat(request.firewall.getReinitializeKey())#')#" method="post">
			<input type="hidden" name="reconfigure" value="#Hash(TimeFormat(request.firewall.getDateConfigured(), "full"))#" />
			<button type="submit" class="btn"><i class="icon-off"></i> Reinitialize &amp; Reconfigure FuseGuard</button>
		</form>
		</cfoutput>
	</cfif>
	<cfoutput>#request.firewall.dumpConfiguration()#</cfoutput>

	<cfcatch type="any">
		<cfmodule template="views/catch.cfm" catch="#cfcatch#" /><cfabort>
	</cfcatch>
</cftry>
<cfinclude template="views/footer.cfm">