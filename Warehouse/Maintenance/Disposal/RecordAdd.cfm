
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="No" 
			  html="Yes" 
			  label="Add" 
			  layout="webapp" 
			  banner="gray"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxl">
    </TD>
	</TR>
	<tr><td colspan="2" class="line"></td></tr>
	<tr>
	<tr><td height="4"></td></tr>
	
	<tr>	
	<td align="center" colspan="2">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">	
	</td>		
	</tr>
	
</TABLE>

</CFFORM>
