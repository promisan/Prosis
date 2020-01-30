<cfparam name="url.autoReload"	default="1">

<cfset url.autoRedirect = "false">
<cfinclude template="../../Tools/Control/LogoutExit.cfm">

<cfif url.autoReload eq 1>
	<cfoutput>
		<script>
			window.location.href = "default.cfm?appId=#url.appId#";
		</script>
	</cfoutput>
</cfif>