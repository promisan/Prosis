
<cfset client.programpivotfilter = "">

<cfoutput>

	<cfsavecontent variable="client.programpivotfilter">
	  <cfif url.xv neq "">
		AND #url.xf# = '#url.xv#' 
	  </cfif>	
	  <cfif url.yv neq "">
		AND #url.yf# = '#url.yv#'
	  </cfif>	
	</cfsavecontent>
	
	
	<script>
		list('drillbox')
	</script>	
	
</cfoutput>
	


