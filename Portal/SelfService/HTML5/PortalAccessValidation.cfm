<cfset vPortalAccess = 0>
<cfif AccessToPortal.recordCount eq 1>
	<cfif AccessToPortal.Status neq '9'>
		<cfset vPortalAccess = 1>
	</cfif>
<cfelse>
	<cfif Main.EnableAnonymous eq 1>
		<cfset vPortalAccess = 1>
	</cfif>
</cfif>

<cfif getAdministrator("*") eq "1">
	<cfset vPortalAccess = 1>
</cfif>

<cfif vPortalAccess eq 0>
	<cfoutput>
		<script>
			parent.window.location = '#session.root#/Portal/SelfService/HTML5/AccessDenied.cfm?id=#url.id#&mission=#url.mission#';
		</script>
	</cfoutput>
</cfif>