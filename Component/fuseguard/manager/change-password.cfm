<cfinclude template="check-auth.cfm">
<cfinclude template="views/header.cfm">
<cftry>
	<cfparam name="form.new_password" default="">
	<cfparam name="form.old_password" default="">
	<cfparam name="form.confirm_password" default="">
	<cfparam name="form.user_id" default="0">
	<cfset auth = request.firewall.getAuthenticator()>
	<cfif auth.getAuthenticatedUserID() IS NOT form.user_id AND NOT auth.isAuthenticatedUserAdmin()>
		<cfset form.user_id = auth.getAuthenticatedUserID()>
	</cfif>
	
	<cfset auth.changePassword(form.user_id, form.old_password, form.new_password, form.confirm_password)>
	
	<h1>Password Changed Successfully.</h1>
	<cfif auth.getAuthenticatedUserID() IS form.user_id>
		<cfset auth.logout()>
	</cfif>
	<cfcatch type="fuseguard">
		<h1>Change Password Failed</h1>
		<div class="message"><cfoutput>#request.firewall.stringCleaner(cfcatch.message)#</cfoutput></div>
		<cfimport prefix="vw" taglib="views/">
		<vw:change-password user_id="#form.user_id#" />
	</cfcatch>
	<cfcatch type="any">
		<cfmodule template="views/catch.cfm" catch="#cfcatch#" /><cfabort>
	</cfcatch>
</cftry>

<cfinclude template="views/footer.cfm">