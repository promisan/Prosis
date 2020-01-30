
<!--- The user must be authenticated --->
<cfif isDefined("session.authent")>
	<cfif session.authent eq "1">
		<cf_WebPrintScript 
			title="#session.welcome# - #session.first# #session.last#" 
			root="#session.root#"
			style="#client.style#">
	</cfif>
</cfif>