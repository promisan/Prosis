<cf_compression>

<cfif url.id1 neq "">

	<cfset vCols = 1>
	<table width="100%" align="center">
		<tr>
			<td colspan="<cfoutput>#vCols#</cfoutput>" class="labelmedium" style="height:30"><cf_tl id="Topics to enter as part of the review cycle submission"></td>
		</tr>
		<tr>
			<td colspan="<cfoutput>#vCols#</cfoutput>" class="linedotted">
				<cfdiv id="divProfileListing" bind="url:Profile/ProfileListing.cfm?idmenu=#url.idmenu#&id1=#url.id1#">
			</td>
		</tr>
	</table>
	
</cfif>