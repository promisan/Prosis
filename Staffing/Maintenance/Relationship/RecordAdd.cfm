<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Add Relationship" 
			  layout="webapp" 
			  user="No"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="95%" class="formpadding" align="center">
	
	<tr><td></td></tr>	
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Relationship" value="" message="Please enter a code" required="Yes" size="20" maxlength="20" class="regularxxl">
    </TD>
	</TR>
	
	 <TR>
    <TD class="labelmedium2">Descriptive:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a descriptive" required="Yes" size="30" maxlength="50" class="regularxxl">
    </TD>
	</TR>
		
	<tr>
		
	<td align="center" colspan="2" height="40">
	<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value="Insert">
	</td>	
	
	</tr>
			
</table>

</CFFORM>

<cf_screenbottom layout="webapp">
