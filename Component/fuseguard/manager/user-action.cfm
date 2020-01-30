<cfinclude template="check-auth.cfm">
<cfparam name="form.user_id" default="0">
<cfset auth = request.firewall.getAuthenticator()>
<cftry>
	<cfif auth.getAuthenticatedUserID() IS NOT form.user_id AND NOT auth.isAuthenticatedUserAdmin()>
		<cfthrow message="Sorry you can't edit this user.">
	</cfif>
	<cfif NOT auth.canEditUsers()>
		<cfthrow message="Sorry your authenticator does not allow you to edit users.">
	</cfif>
	<cfset uid = auth.updateUser(form.user_id, form)>
	<cflocation url="#request.urlBuilder.createDynamicURL('user', 'user_id=#URLEncodedFormat(uid)#')#" addtoken="false">
	<cfcatch type="any">
		<cfmodule template="views/catch.cfm" catch="#cfcatch#" /><cfabort>
	</cfcatch>
</cftry>