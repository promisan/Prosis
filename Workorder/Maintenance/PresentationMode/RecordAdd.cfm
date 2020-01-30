<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Presentation Mode" 			
			  scroll="Yes" 
			  layout="webapp" 
			  banner="blue" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="95%" cellspacing="4" cellpadding="4" align="center">
	

	<tr><td height="6"></td></tr>
    <TR>
    <TD width="20%" class="labelit">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="30" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Order:</TD>
    <TD>
  	   <cfinput type="Text" name="listingOrder" value="" message="Please enter a numeric listing order" required="Yes" size="2" validate="integer" maxlength="3" class="regularxl">
    </TD>
	</TR>		
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="30">
    <input class="button10g" style="height:25;width:200" type="submit" name="Insert" id="Insert" value="Save">
	</td>	
	
	</tr>
		
</table>

</CFFORM>

<cf_screenbottom layout="innerbox">
