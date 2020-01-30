
<cf_screentop height="100%" label="Release of funds edition NNNN" scroll="Yes" html="Yes" layout="webapp" banner="yellow" bannerheight="50">

<cfoutput>
<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td height="14"></td></tr>

<tr>
 <td>Fund</td>
 <td>OrgUnit</td>
  <cfloop index="resource" from="1" to="4">
  	<td>#resource#</td>
  </cfloop>
  <td>Total</td>
</tr>

<tr><td colspan="7" class="line"></td></tr>

<cfloop index="fund" from="1" to="4">
	<tr>
	<td><b>fund#Fund#</td>
	</tr>
<cfloop index="orgunit" from="1" to="6">
	<tr>
	<td></td>
	<td>service name</td>	
	<cfloop index="resource" from="1" to="4">
	<td><input type="text" name="amt_#fund#_#orgunit#_#resource#" style="width:100" class="amount"></td>
	</cfloop>
	<td>subtotal</td>
	</tr>
</cfloop>
<tr>
	<td></td>
	<td></td>	
	<cfloop index="resource" from="1" to="4">
	<td>total</td>
	</cfloop>
	<td>fund total</td>
	</tr>
</cfloop>

</table>

</cfoutput>