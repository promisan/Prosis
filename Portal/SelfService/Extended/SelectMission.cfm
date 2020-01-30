
<cfparam name="URL.mission"  default="">
<cfparam name="client.mission"  default="">

<cfset client.mission = url.mission>

<cfoutput>
	<script>
		window.location =  "default.cfm?id=#url.id#";
	</script>
</cfoutput>