<cf_screentop height="100%" html="no">

<cfoutput>
<table align="center" cellspacing="0" class="formpadding">
	<tr><td colspan="3"><b>#url.time# - #url.action#</b></td></tr>
	<tr>
		<td width="5"></td>
		<td width="20%">Performed from host:</td>
		<td>#ucase(url.host)#</td>
	</tr>
	<tr>
		<td width="5"></td>
		<td>From IP Address:</td>
		<td>#url.ip#</td>
	</tr>
	<tr>
		<td width="5"></td>
		<td>By the Account:</td>
		<td>[#url.acc#] #url.name#</td>
	</tr>
</table>
</cfoutput>