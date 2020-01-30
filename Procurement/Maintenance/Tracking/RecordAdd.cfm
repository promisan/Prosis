<cfparam name="url.idmenu" default="">

<cf_screentop title="Add" 
			  height="100%"  
			  layout="webapp" 
			  label="Add Tracking" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	
<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">
    <TR>
    <TD class="regular">Code:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="Code" value="" message="Please enter a code" required="Yes" size="2" maxlength="2" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="regular">Description:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regular">
    </TD>
	</TR>
			
	<TR>
    <TD class="regular">Order:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="ListingOrder" value="0" message="Please enter a valid number" validate="integer" required="Yes" size="1" maxlength="1" class="regular">
    </TD>
	</TR>
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6">

	
	<tr><td colspan="2" align="center">
	
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">
	
	</td>	
	
	</tr>
		
	</CFFORM>
	
</TABLE>

