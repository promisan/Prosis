
<cfoutput>
<table width="99%" cellspacing="0" cellpadding="0" id="tdata_memo">
	<tr height="20">
		<td colspan="2">&nbsp;</td>
	</tr>
  	<tr>
        <td valign="top" width="10%" class="serif_small" align="right">
			<cfif Attributes.Reference neq "">	
				REFERENCE:
			</cfif>	
		</td>
        <td valign="top" width="90%" class="memoheader" align="left">#Attributes.Reference#</td>
  	</tr>
  	<tr>
        <td valign="top" width="10%" class="serif_small" align="right"></td>
        <td valign="top" width="90%" class="memoheader" align="right">#Attributes.DocumentDate#</td>
  	</tr>	
	
</table>	
</cfoutput>