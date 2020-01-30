
<input type="hidden" name="_Summary"     id="_Summary"      value = "0">		
<input type="hidden" name="_ShowColumns" id="_ShowColumns"     value = "ShowAdmin|ShowGrade|ShowPosition|ShowFund|ShowPersonGrade|ShowFullName|">
			
<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<tr><td height="4"></td></tr>

<tr><td bgcolor="white">
	
	<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr>	
		<td>&nbsp;</td>
		<td class="labelit">Summary:</td>														
		<td><input type="checkbox" style="height:18;width:18" name="Summary" id="Summary" value="0" onClick="setSummary(this)" disabled></td>	
	</tr>
	

	<tr>	
		<td>&nbsp;</td>
		<td colspan ="2" align="center"><b> - Or - </b></td>														
	</tr>	
		
	<tr>
		<td>&nbsp;</td>
		<td class="labelit">Admin Unit:</td>														
		<td><input type="checkbox" style="height:18;width:18" name="ShowAdmin" id="ShowAdmin" value="ShowAdmin" onClick="setShowColumn(this)" checked></td>	
	</tr>

	<tr>
		<td>&nbsp;</td>
		<td class="labelit">Position No.:</td>														
		<td><input type="checkbox" style="height:18;width:18" name="ShowPosition" id="ShowPosition" value="ShowPosition" onClick="setShowColumn(this)" checked></td>	
	</tr>

	<tr>
		<td>&nbsp;</td>
		<td class="labelit">Fund:</td>														
		<td><input type="checkbox" style="height:18;width:18" name="ShowFund" id="ShowFund" value="ShowFund" onClick="setShowColumn(this)" checked></td>	
	</tr>
	
			
	<tr>
		<td>&nbsp;</td>
		<td class="labelit">Post Grade:</td>														
		<td><input type="checkbox" style="height:18;width:18" name="ShowGrade" id="ShowGrade" value="ShowGrade" onClick="setShowColumn(this)" checked></td>	
	</tr>


	<tr>
		<td>&nbsp;</td>
		<td class="labelit">Person's Grade:</td>														
		<td><input type="checkbox" style="height:18;width:18" name="ShowPersonGrade" id="ShowPersonGrade" value="ShowPersonGrade" onClick="setShowColumn(this)" checked></td>	
	</tr>


	<tr>
		<td>&nbsp;</td>
		<td class="labelit">Title:</td>														
		<td><input type="checkbox" style="height:18;width:18" name="ShowTitle" id="ShowTitle" value="ShowTitle" onClick="setShowColumn(this)"></td>	
	</tr>


	<tr>
		<td>&nbsp;</td>
		<td class="labelit">FullName:</td>														
		<td><input type="checkbox" style="height:18;width:18" name="ShowFullName" id="ShowFullName" value="ShowFullName" onClick="setShowColumn(this)" checked></td>	
	</tr>
		
	</table>	

</td>
</tr>

<tr><td height="4"></td></tr>

</table>		
