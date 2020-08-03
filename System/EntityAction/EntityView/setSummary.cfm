
<cfoutput>

	<cfif url.overall eq "0">
		<cfset cl = "##59C25B">
	<cfelse>
		<cfset cl = "##EF5555">   
	</cfif>
	
	<cfif url.overall eq "0"><cf_tl id="No"><cf_tl id="Pending"><cfelse><span style="color:#cl#">#url.overall#</span></cfif> 
	<cfif url.overall eq "1"><cf_tl id="batch clearance"><cfelse><cf_tl id="batch clearances"></cfif>

</cfoutput>