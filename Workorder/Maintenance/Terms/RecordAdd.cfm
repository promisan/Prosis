<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Add Term" 
			  layout="webapp" 
			  user="No" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<table width="95%" cellspacing="4" cellpadding="4" align="center">
	
	<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

	<tr><td height="6"></td></tr>    
	
	 <TR>
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="20" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD>Payment days:</TD>
    <TD>
  	   <cfinput type="Text" name="paymentDays" value="" message="Please enter a number as payment day" required="Yes" validate="integer" size="10" maxlength="3" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD>Discount:</TD>
    <TD>
  	   <cfinput type="Text" name="discount" value="" message="Please enter a decimal number as discount" required="Yes" validate="float" size="10" maxlength="6" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD>Discount days:</TD>
    <TD>
  	   <cfinput type="Text" name="discountDays" value="" message="Please enter a number as discount day" required="Yes" validate="integer" size="10" maxlength="3" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD>Operational:</TD>
    <TD>
		<SELECT name="operational" id="operational">		
			<OPTION value="0">No</OPTION>
			<OPTION value="1" selected>Yes </OPTION>	
		</SELECT>
    </TD>
	</TR>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="30">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value="Insert">
	</td>	
	
	</tr>
		
	</CFFORM>
	
</table>

<cf_screenbottom layout="innerbox">
