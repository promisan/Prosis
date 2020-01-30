
<cfoutput>
<table width="100%" cellspacing="0" cellpadding="0" bgcolor="f8f8f8" style="border-bottom:1px solid silver">
<tr>
<td align="center" height="29">

	<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
			<td>
			<input type="text" name="searchme" id="searchme" style="background-color:transparent;border:0px;font-size:15px;width:100%" class="regularxl" onKeyUp="javascript:check()">
			</td>
			<td width="25" align="center" height="25" style="border-left:1px solid gray">
			<img src="#SESSION.root#/Images/locate3.gif" align="absmiddle" id="searchicon" alt="" border="0" onclick="find(searchme.value)">
			</td>
		</tr>	
		
		<tr><td>		
			<cfdiv id="findme"/>
		</td></tr>
		
	</table>
	
</td>
</tr>

</table>
</cfoutput>