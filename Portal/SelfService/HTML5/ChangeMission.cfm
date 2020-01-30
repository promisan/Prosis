<cfset CLIENT.mission = url.mission>

<cfif url.reload eq "true">
	<cfoutput>
		<script>
			parent.window.location = "default.cfm?id=#url.id#&mission=#url.mission#";
		</script>
	</cfoutput>
</cfif>