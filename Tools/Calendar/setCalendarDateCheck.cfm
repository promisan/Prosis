
<!--- checking --->


<CF_DateConvert Value="#url.val#">
<cfset DTE = dateValue>

<cfif isValid("date",dte)>

<cfelse>

	<cfoutput>
	
	<script>
		document.getElementById('#url.name#_date').focus()
		alert('Invalid date')
	</script>
	
	</cfoutput>
	
</cfif>	