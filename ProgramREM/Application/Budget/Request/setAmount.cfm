
<cfset ptot = "#numberformat(url.total,',__')#">
<cfset pamt = "#numberformat(url.amount,',__')#">

<cfoutput>
<script>  
	document.getElementById("overalltotal").value  = '#ptot#'
	document.getElementById("overallamount").value = '#pamt#'
</script>

</cfoutput>