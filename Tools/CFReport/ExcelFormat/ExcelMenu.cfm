<cfoutput>

<table cellspacing="0" cellpadding="0">
<tr>
	<td>
	<input type="button" name="mail" id="mail" value="eMail" class="button10s" style="font-size:15px;width:120px;height:53px" onclick="openexcel('mail','#url.id#','#url.table#')">
	</td>
	<td style="padding-left:3px">
	<input type="button" name="view" id="view" value="Open" class="button10s" style="font-size:15px;width:120px;height:53px" onclick="openexcel('open','#url.id#','#url.table#')">
	</td>
</tr>
</table>

</cfoutput>