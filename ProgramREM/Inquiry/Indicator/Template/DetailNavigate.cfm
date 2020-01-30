
<cfoutput>
<cfif client.programDetail eq "Pivot">

	<script>
	  pivot()		  
	</script>

<cfelse>

	<script>
	  list('listing')			  
	</script>

</cfif>

</cfoutput>