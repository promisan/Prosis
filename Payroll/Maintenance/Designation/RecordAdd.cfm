<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Designation" 
			  option="Add" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- Entry form --->

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formspacing formpadding">

	<tr><td colspan="2" align="center" height="10"></tr>

    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="5" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="No" size="40" maxlength="50" class="regularxl">
    </TD>
	</TR>

	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="ListingOrder" value="" message="Please enter a listing order" required="Yes" validate="integer" size="1" maxlength="10" class="regularxl" style="text-align:center;">
    </TD>
	</TR>
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	
	<tr>
	<td align="center" colspan="2" height="40">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	</td>	
	</tr>
	
</TABLE>

</CFFORM>


