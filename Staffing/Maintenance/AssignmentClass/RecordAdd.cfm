<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="yellow" 
			  line="No"
			  label="Assignment Class" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

    <tr><td height="5"></td></tr>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="AssignmentClass" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Label:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="20" maxlength="20" class="regularxl">
    </TD>
	</TR>
	
	<tr>
	<td class="labelmedium">Incumbency</td>
	<td class="labelmedium">
	<input type="radio" name="Incumbency" value="100" checked>100%
	<input type="radio" name="Incumbency" value="50">50%
	<input type="radio" name="Incumbency" value="0">0%	
	</td>	
	</tr>
	
	<TR>
    <TD class="labelmedium">Operational:</TD>
    <TD>
		<input type="checkbox" name="Operational" value="1">
  	 </TD>
	</TR>
	
	 <TR>
    <TD class="labelmedium">Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="1" message="Please enter an number" validate="integer" required="Yes" size="1" maxlength="2" class="regularxl">
    </TD>
	</TR>
	
	<tr><td colspan="2">	
		<cf_dialogBottom option="add">
	</td></tr>
				
</table>

</CFFORM>

<cf_screenbottom layout="innerbox">