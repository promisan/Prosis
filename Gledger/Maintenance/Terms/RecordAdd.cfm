<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Add" 
			  scroll="Yes" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#"> 

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
  	
	<tr><td></td></tr>
	<TR class="labelmedium">
    <TD>Description:</TD>
    <TD>
  	    <cfinput type="Text" class="regularxl" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="50">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Net days:</TD>
    <TD>
  	    <cfinput type="Text" name="PaymentDays"  class="regularxl" value="1" message="Please enter net days" validate="integer" required="Yes" size="10" maxlength="10" style="text-align: right;">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Discount days:</TD>
    <TD>
  	    <cfinput type="Text" class="regularxl" name="DiscountDays" value="1" message="Please enter discount days" validate="integer" required="Yes" size="10" maxlength="10" style="text-align: right;">
	</TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Discount:</TD>
    <TD>
  	    <cfinput type="Text" name="Discount" class="regularxl" value="0" message="Please enter a percentage" validate="float" required="Yes" size="10" maxlength="10" style="text-align: right;">%
    </TD>
	</TR>
	
	
	<tr><td colspan="2" height="3"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" height="55" align="center">
    	
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	<input class="button10g" type="submit" name="Insert" value=" Submit ">
	
	</td>
	</tr>
	</table>
	
</CFFORM>


</BODY></HTML>