<cfparam name="url.id" default="NED">

<cfset client.LanguageId = "#url.id#">

<script>
	window.location.reload();
</script>