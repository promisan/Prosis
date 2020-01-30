
<!--- --- process selection ---- --->


<cfoutput>

<cfloop index="itm" list="#form.clrlist#">
	
	<script>  
		document.getElementById('#itm#').checked = true
	</script>

</cfloop>

</cfoutput>