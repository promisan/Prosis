<cfoutput>

<table width="100%" align="center" cellspacing="0" cellpadding="0">
	<tr>
	<td height="20" width="8%" align="right"><b>WORKFLOW</b><td colspan="2"></td>
	</tr>
	<tr>
	<td height="10" align="right"><strong>ENTITY:</strong></td><td><strong>&nbsp;&nbsp;#Entity.EntityDescription# [#Entity.EntityCode#]</strong></td>
	</tr>
	<td height="10" align="right"><strong>CLASS:</strong></td><td><strong>&nbsp;&nbsp;#Class.EntityClassName# [#URL.EntityClass#]</strong></td>
	<td align="right">#DateFormat(NOW(),"dd/mm/yyyy")#</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr><td colspan="9" class="line"></td></tr>
	</tr>
</table>	

</cfoutput>