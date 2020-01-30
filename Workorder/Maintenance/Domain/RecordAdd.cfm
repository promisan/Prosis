<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Domain" 
			  option="Service Item Domain Maintenance" 
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
    <TD width="25%" class="labelmedium"><cf_tl id="Code">:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20" class="regularxl">
    </TD>
	</TR>
	
	 <TR>
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Display format">:</TD>
    <TD>
  	   <cfinput type="Text" name="displayFormat" value="" message="Please enter a display format" required="No" size="40" maxlength="30" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Order">:</TD>
    <TD>
  	   <cfinput type="Text" name="listingOrder" value="" message="Please enter a numeric listing order" required="Yes" size="2" validate="integer" maxlength="3" class="regularxl">
    </TD>
	</TR>		
	
	<tr>
		<td class="labelmedium"><cf_tl id="Allow Concurrency">:</td>
		<td class="labelmedium">
		<input type="radio" name="AllowConcurrent" id="AllowConcurrent" value="0" checked>No
		<input type="radio" name="AllowConcurrent" id="AllowConcurrent" value="1">Yes
		</td>
	</tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="30">
    <input class="button10g" type="submit" name="Insert" id="Insert" value="Save">
	</td>	
	
	</tr>
			
</table>

</CFFORM>

<cf_screenbottom layout="innerbox">
