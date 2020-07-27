
<cftry>
	
	<cfset ptot = "#numberformat(url.total,',__')#">
	<cfset pamt = "#numberformat(url.amount,',__')#">
	
	<cfoutput>
	<script>  
		document.getElementById("overalltotal").value  = '#ptot#'
		document.getElementById("overallamount").value = '#pamt#'
	</script>
	</cfoutput>

<cfcatch>
	
	<cfoutput>
	<script>  
		document.getElementById("overalltotal").value  = ''
		document.getElementById("overallamount").value = ''
	</script>
	</cfoutput>

</cfcatch>

</cftry>