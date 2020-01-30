<cfset isUserLoggedIn = false>
<cfif isDefined("session.authent")>
	<cfif session.authent eq "1">
		<cfset isUserLoggedIn = true>
	</cfif>
</cfif>