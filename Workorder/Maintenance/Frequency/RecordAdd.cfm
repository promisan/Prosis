<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Add Frequency" 
			  layout="webapp" 
			  user="No" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST"  name="dialog">

<table width="90%" class="formpadding"  align="center">

	<tr><td height="6"></td></tr>
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
    </TD>
	</TR>
	
	 <TR>
    <TD class="labelmedium2">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
    </TD>
	</TR>
			
	<tr>
		
	<td align="center" colspan="2" style="padding-top:70px" height="30">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value="Insert">
	</td>	
	
	</tr>
			
</table>

</CFFORM>

<cf_screenbottom layout="innerbox">
