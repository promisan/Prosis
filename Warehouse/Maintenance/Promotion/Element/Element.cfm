<cf_compression>

<cfif url.id1 neq "">
	<cfset vCols = 1>
	<table width="95%" align="center">
		<tr>
			<td colspan="<cfoutput>#vCols#</cfoutput>" class="labellarge" style="height:30"><cf_tl id="Promotion Elements"></td>
		</tr>
		<tr>
			<td colspan="<cfoutput>#vCols#</cfoutput>" class="line">
				<cfdiv id="divElementListing" bind="url:Element/ElementListing.cfm?idmenu=#url.idmenu#&id1=#url.id1#">
			</td>
		</tr>
	</table>
</cfif>