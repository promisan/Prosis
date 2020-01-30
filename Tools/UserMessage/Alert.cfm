
<cfparam name="Attributes.Message"  default="Problem">
<cfparam name="Attributes.Mode"     default="alert">

<cfif attributes.mode eq "alert">

<cfoutput>

<script>
    try { Prosis.busy('no') } catch(e) {}
	try { parent.Prosis.busy('no') } catch(e) {}
	alert("#Attributes.Message#")
</script>

</cfoutput>

</cfif>