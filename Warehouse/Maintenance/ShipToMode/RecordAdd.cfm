
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Mode of Shipment" 
			  option="Add Mode of Shipment" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="blue" 
			  jQuery="yes"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" enablecab="Yes" name="dialog">

	<tr><td height="6"></td></tr>
    <TR>
    <TD class="labelit" width="20%">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	 <TR>
    <TD class="labelit">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Order:</TD>
    <TD>
  	   <cfinput type="Text" name="listingOrder" value="" message="Please enter a numeric listing order" required="Yes" size="1" validate="integer" maxlength="3" class="regularxl" style="text-align:center;">
    </TD>
	</TR>		
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="30">
    <input class="button10g" type="submit" name="Insert" id="Insert" value="Save">
	</td>	
	
	</tr>
		
	</CFFORM>
	
</table>

<cf_screenbottom layout="innerbox">
