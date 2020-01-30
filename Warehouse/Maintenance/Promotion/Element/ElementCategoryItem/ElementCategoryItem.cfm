<cf_compression>

<cfif url.serial neq "">
	<cfset vCols = 1>
	<table width="100%" align="center">
		<tr><td height="10"></td></tr>
		<tr>
			<td class="labelmedium" colspan="<cfoutput>#vCols#</cfoutput>"><cf_tl id="Sale items that classify for discount"></td>
		</tr>
		<tr>
			<td colspan="<cfoutput>#vCols#</cfoutput>" class="line">
				<cfdiv id="divElementCategoryItemListing" bind="url:ElementCategoryItem/ElementCategoryItemEdit.cfm?idmenu=#url.idmenu#&promotionid=#url.promotionid#&serial=#url.serial#&category=&categoryItem=">
			</td>
		</tr>
	</table>
</cfif>