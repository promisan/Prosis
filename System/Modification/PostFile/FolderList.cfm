
<cf_listingscript>

<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<table width="100%" height="100%">
	<tr><td valign="top" height="100%" style="padding-top:4px">
		<cf_securediv style="height:100%" 
		     bind="url:FolderListDetail.cfm?dir=#url.dir#&CFTREEITEMKEY=#url.CFTREEITEMKEY#&systemfunctionid=#url.systemfunctionid#" 
			 id="mylisting">
	</td></tr>
	
	<tr><td height="1" class="linedotted"></td></tr>
	<tr><td height="100" bgcolor="f4f4f4">
		<table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			<tr><td width="150">CM case No</td><td>
			<select></select>
			</td>
			<td>Open CM request</td>
			</tr>
			<tr><td>Reason:</td>
			     <td colspan="2"><input type="text" style="width:90%" name="Reason" id="Reason" value=""></td>
				 
			</tr>
			<tr><td>Comments</td>
			    <td colspan="2"><input type="text" style="width:90%" name="Comments" id="Comments" value=""></td>
			</tr>
			<tr><td colspan="3"><input type="button" class="button10g" name="Upload selected files" id="Upload selected files" value="Upload"></td></tr>
			
		</table>
	</td></tr>
</table>
