
<cfoutput>
<cf_tableround mode="solidcolor" color="#bgColor#">
	<table width="95%" height="100%">
		<tr>
			<td width="#iconTdWidth#" align="center" valign="middle">
				<img src    = "#SESSION.root#/Images/Logos/Warehouse/#iconName#"
					width  = "#iconWidth#"
				   	title   = "#elementName#" 
				   	border  = "0" 
				   	align   = "absmiddle">
			</td>
			<td valign="middle" style="padding-left:25px;">
			<cfdiv id="div#elementName#" bind="url:#link#">
			</td>
		</tr>
	</table>
</cf_tableround>
</cfoutput>