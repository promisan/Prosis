
<!--- process field selection on the fly --->

<cfparam name="form.selfields" default="">

<cfset list = replace(form.selfields,",","|","ALL")>
<cfoutput>

<script>
    try {
	document.getElementById('selectedfields').value = '#list#'		
	applyfilter('','','content') } catch(e) {}
</script>

</cfoutput>