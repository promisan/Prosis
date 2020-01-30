<cf_screentop height="100%" 
		      scroll="Yes" 
			  layout="webapp" 
			  label="Add decision code" >

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="94%" align="center" cellspacing="0" cellpadding="0" class="formpadding formspacing">

    <tr><td></td></tr>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="2" maxlength="5" class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
		
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="35" maxlength="50"class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
		
	
	<TR valign="top">
    <TD class="labelmedium">Memo:</TD>
    <TD>
	   <textarea cols="44" rows="6" name="DescriptionMemo" class="regular"></textarea>
  	  
    </TD>
	</TR>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr>	
		
	<td align="center" colspan="2">
	<input type="button" name="Cancel" value=" Cancel " class="button10g" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	
	</td>	
	
	</tr>
	
</TABLE>

</CFFORM>
