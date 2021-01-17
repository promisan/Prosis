<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Object Usage" 			 
  			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">


<!--- Entry form --->

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

	<tr><td height="10"></td></tr>

    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Name:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="35" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="6"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr>
	<tr><td height="6"></td></tr>
	<tr>	
		
	<tr>
		
	<td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value="  Save  ">	
	</td>	
	
	</tr>
	
	</CFFORM>
	
</TABLE>

<cf_screenbottom layout="innerbox">