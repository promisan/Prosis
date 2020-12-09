
<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<!---
<tr><td class="labelmedium" colspan="4" align="center">This page can be adjusted based on local requirements</td></tr>
--->

<tr><td class="labellarge" colspan="2" style="font-size:20px;padding-top:4px">Stock on hand</td></tr>
<tr><td colspan="2" class="line"></td></tr>

<tr><td class="labellarge" colspan="2">

<cfset link = "#session.root#/warehouse/maintenance/ItemMaster/Statistics/ItemMovement.cfm?mission=#url.mission#&itemno=#url.itemno#">

<cfoutput>
<table>
<tr>
<td style="font-size:22px;padding-top:4px"><cf_tl id="Movements"></td>
<td align="right" style="padding-right:10px">
	<table>
	<tr class="labelmedium">
	<td><input type="radio" class="radiol" name="Period" value="Week" checked onclick="javascript:ptoken.navigate('#link#&period=week','movement')"></td>
	<td style="padding-left:4px"><cf_tl id="week"></td>
	<td><input type="radio" class="radiol" name="Period" value="Month" onclick="javascript:ptoken.navigate('#link#&period=month','movement')"></td>
	<td style="padding-left:4px"><cf_tl id="month"></td>
	<td><input type="radio" class="radiol" name="Period" value="Year" onclick="javascript:ptoken.navigate('#link#&period=year','movement')"></td>
	<td style="padding-left:4px"><cf_tl id="year"></td>
	</tr>
	</table>
</td>
</tr>
</table>
</cfoutput>

</td></tr>

<tr><td colspan="2">

<cf_securediv id="movement" bind="url:#link#&period=week">

</td></tr>

<!---
<tr><td style="height:20px"></td></tr>
<tr><td class="labellarge" colspan="2" style="padding-top:4px">Average Time between receipt and distribution</td></tr>
<tr><td colspan="2" class="line">
</td></tr>

--->


</table>

