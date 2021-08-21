
<cftry>
	
	<cfset ptot = "#numberformat(url.total,',__')#">
	<cfset pamt = "#numberformat(url.amount,',__')#">
	
	<cfoutput>
	<script>  
	    try {
		document.getElementById("overalltotal").value  = '#ptot#'
		document.getElementById("overallamount").value = '#pamt#'
		} catch(e) {}
	</script>
	</cfoutput>

<cfcatch>
	
	<cfoutput>
	<script>  
	    try {
		document.getElementById("overalltotal").value  = ''
		document.getElementById("overallamount").value = ''
		} catch(e) {}
	</script>
	</cfoutput>

</cfcatch>

</cftry>