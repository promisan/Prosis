
<table width="95%" height="100%" align="center" class="formpadding">

<tr><td class="labellarge" colspan="2" style="font-size:20px;padding-top:4px"><cf_tl id="Stock"></td></tr>			
			
<cfoutput>

<tr><td>

	<cfinclude template="../Stock/ItemStock.cfm">		
	
	</td>
	
</tr>	

</cfoutput>

<tr><td class="labellarge">

<cfset link = "#session.root#/warehouse/maintenance/ItemMaster/Statistics/ItemMovement.cfm?mission=#url.mission#&itemno=#url.itemno#">
	
	<cfoutput>
	<table>
	<tr>
	<td style="font-size:22px;padding-top:4px"><cf_tl id="Movements"></td>
	<td align="right" style="padding-left:10px;padding-top:6px;padding-right:10px">
		<table>
		<tr style="padding-left:4px" class="labelmedium2">
		<td><input type="radio" class="radiol" name="Period" value="Week"  onclick="ptoken.navigate('#link#&period=week','movement')"></td>
		<td style="padding-left:4px"><cf_tl id="Recent weeks"></td>
		<td style="padding-left:4px"><input type="radio" class="radiol" name="Period" value="Month" onclick="ptoken.navigate('#link#&period=month','movement')"></td>
		<td style="padding-left:4px"><cf_tl id="month"></td>
		<td style="padding-left:4px"><input type="radio" class="radiol" name="Period" value="Year" checked onclick="ptoken.navigate('#link#&period=year','movement')"></td>
		<td style="padding-left:4px"><cf_tl id="year"></td>
		</tr>
		</table>
	</td>
	</tr>
	</table>
	</cfoutput>

</td></tr>

<tr>
    <td style="height:100%;border:0px solid silver">
    <cf_divscroll overflowx="auto">
	<cf_securediv id="movement" bind="url:#link#&period=year">
	</cf_divscroll>
</td>
</tr>

<!---
<tr><td style="height:20px"></td></tr>
<tr><td class="labellarge" colspan="2" style="padding-top:4px">Average Time between receipt and distribution</td></tr>
<tr><td colspan="2" class="line">
</td></tr>

--->

</table>

