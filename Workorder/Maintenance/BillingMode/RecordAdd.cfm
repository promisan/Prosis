<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Add Billing Mode" 
			  layout="webapp" 
			  user="No" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="92%" align="center" class="formpadding formspacing">
	
	<tr><td height="6"></td></tr>
    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="10" class="regularxxl">
    </TD>
	</TR>
	
	 <TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
    </TD>
	</TR>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="30">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value="Insert">
	</td>	
	
	</tr>
		
</table>

</CFFORM>

<cf_screenbottom layout="innerbox">
