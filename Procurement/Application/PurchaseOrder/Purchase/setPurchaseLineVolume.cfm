
<!--- set volume --->

<cfoutput>
<cftry>

	<cfset val = form.OrderUoMHeight/100*form.OrderUoMWidth/100*Form.OrderUoMLength/100>

	<script>
	 document.getElementById('orderuomvolume').value = '#numberformat(val,'.__')#' 
	</script>

	<cfcatch>
	
	<script>
	 document.getElementById('orderuomvolume').value = '' 
	</script>
	
	</cfcatch>

</cftry>
</cfoutput>