
<cfparam name="client.graph" default= "PostGradeBudget">
<cfparam name="url.item"     default= "#client.graph#">
<cfset client.graph = url.item>

<cfparam name="URL.Print" default="0">
<cfif url.print eq "1">
	<cfset w = 660>
<cfelse>
	<cfset w =  client.width-340>
</cfif>

<cfoutput>
<script>
 function listener(val,series) {
	    parent.document.getElementById("graphitem").value   = '#url.item#'
		parent.document.getElementById("graphselect").value = val
		parent.document.getElementById("graphseries").value = series
		parent.reloadlisting()
	 }
</script>
</cfoutput>