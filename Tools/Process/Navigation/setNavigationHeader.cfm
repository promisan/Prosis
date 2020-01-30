
<!--- toggle the header --->



<cfparam name="client.topicheader" default="1">

<cfif client.topicheader eq "1">

	<cfset client.topicheader = "0">
	
	<script>
	  try {
		document.getElementById('headerline').className = "hide" } catch(e) {}
	</script>
	Help
	
<cfelse>

	<cfset client.topicheader = "1">
	
	<script>
	   try {
		document.getElementById('headerline').className = "regular" } catch(e) {}
	</script>
	Hide

</cfif>	