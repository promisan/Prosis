<cfoutput>
<table width="99%" cellspacing="0" cellpadding="0" id="tdata_memo" >
	<tr><td colspan="6" style="height:10"></td></tr>
  	<tr>
        <td valign="top" width="10%" class="memoheader" align="right">
			<cfif Attributes.To neq "">
			TO:&nbsp;&nbsp;<br> A:&nbsp;&nbsp;
			</cfif>
		</td>
        <td valign="top" width="47%" class="memoheader"> 
				#Attributes.To#
		</td>

        <td width="17%" valign="top" class="memoheader" align="right">
			<cfif Attributes.DocumentDate neq "">
			DATE:&nbsp;&nbsp;
			</cfif>
		</td>
		<td width="26%" valign="top" colspan="3" class="memoheader">
			<cfif Attributes.DocumentDate neq "">
				#Attributes.DocumentDate#
			</cfif>	
		</td>
  	</tr>
	<tr>
		<td width="10%"></td>
		<td width="47%"></td>
        <td width="17%" valign="top" class="serif_small" align="right">
			<cfif Attributes.Reference neq "">
				REFERENCE:&nbsp;&nbsp;
			</cfif>	
		</td>
		<td width="26%" valign="top" colspan="3" class="memoheader">
			#Attributes.Reference#
		</td>
	</tr>
	<tr><td colspan="6" style="height:10"></td></tr>
	<tr>
		<td valign="top" class="memoheader" align="right">
			<cfif Attributes.From neq "">
				FROM:&nbsp;&nbsp;<br> DE:&nbsp;&nbsp;
			</cfif>	
		</td>
		<td valign="top" colspan="5" class="memoheader">
			#Attributes.From#
		</td>
	</tr>
	<tr><td colspan="6" style="height:10"></td></tr>
    <tr>
        <td valign="top" class="memoheader" align="right">SUBJECT:&nbsp;&nbsp;</td>
    	<td valign="top" colspan="5" class="memoheader">
			<b>#Attributes.Subject#</b>
		</td>
    </tr>
	<tr height="20"><td colspan="6"></td></tr>
	
</table>	
</cfoutput>