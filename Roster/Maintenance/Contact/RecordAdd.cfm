
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%"
			  title="Background Call Sign" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Call Sign" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->
<cfform action="RecordSubmit.cfm" method="POST" name="dialog"><br>

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="25" maxlength="20" class="regularxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelit">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	
	<TR>
    <TD class="labelit">Mask:</TD>
    <TD>
  	  	<cfinput type="Text" name="CallSignMask" message="Please enter a mask" required="No" size="20" maxlength="20" class="regularxl">
    </TD>
	</TR>
	
	<tr>
		<td></td>
		<td class="labelit"><i>Examples : A = [A-Za-z], A9 = [A-Za-z0-9], 9 = [0-9], ? = Any character</i></td>
	</tr>
	
	<TR>
    <TD class="labelit">Order:</TD>
    <TD>
  	  	<cfinput type="Text" name="ListingOrder" message="Please enter a numeric order" validate="integer" required="No" size="1" maxlength="3" class="regularxl" style="text-align:center;">
    </TD>
	</TR>
		

	<tr><td colspan="2" height="6"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" height="6"></td></tr>

	
	<tr>	
	<td align="center" colspan="2"  valign="bottom">
    <input class="button10g" type="submit" name="Insert" value=" Save ">
	</td>	
	</tr>
	
</table>

</cfform>


