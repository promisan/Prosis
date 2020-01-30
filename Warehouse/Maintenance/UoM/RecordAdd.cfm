<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="UoM" 
			  option="Add UoM"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">


<cf_PreventCache>

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

    <TR>
    <TD class="regular">Code:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="code" id="code" value="" message="Please enter a code" required="Yes" size="10" maxlength="20" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="regular">Description:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="Description" id="Description" value="" message="Please enter a description" required="Yes" size="50" maxlength="50" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="regular">Order:</TD>
    <TD class="regular">
	   <cfinput type="Text" name="ListingOrder" id="ListingOrder" value="" message="Please enter a valid Listing Order" required="Yes" size="2" maxlength="3" range="0,999" class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="6"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr>
	<tr><td height="6"></td></tr>
	<tr>	
		
	<tr>
		
	<td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value="Save">	
	</td>	
	
	</tr>
	
</table>

</cfform>

<cf_screenbottom layout="innerbox">